import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/streaming_server.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../providers/player_providers.dart';

/// Full‑screen streaming player powered by [InAppWebView].
///
/// Behaviour:
///  • Forces landscape orientation and immersive system UI on enter.
///  • Reverts to portrait and edge‑to‑edge system UI on exit.
///  • Loads the embed URL for the currently selected [StreamingServer].
///  • Blocks popup windows (ad mitigation).
///  • JavaScript enabled + inline media playback allowed.
///  • Glassmorphic server‑switcher chips overlaid at the top‑right
///    allow the user to hot‑swap between servers if one fails.
class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({
    super.key,
    required this.mediaType,
    required this.id,
    this.season,
    this.episode,
  });

  final String mediaType;
  final int id;
  final int? season;
  final int? episode;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  double _progress = 0;

  /// Whether the server‑switcher panel is expanded.
  bool _showServerPanel = false;

  // ── Lifecycle ────────────────────────────────────────────

  @override
  void initState() {
    super.initState();

    // Force landscape + immersive mode.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Revert to portrait and restore system UI.
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────

  /// Resolves the embed URL for the given [server] using the
  /// current media parameters.
  String _urlForServer(StreamingServer server) {
    return server.resolveUrl(
      mediaType: widget.mediaType,
      tmdbId: widget.id,
      season: widget.season ?? 1,
      episode: widget.episode ?? 1,
    );
  }

  void _exit() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/home');
    }
  }

  /// Triggers a URL load on the active [InAppWebViewController].
  void _switchServer(StreamingServer server) {
    final current = ref.read(selectedServerProvider);
    if (server == current) return;

    ref.read(selectedServerProvider.notifier).state = server;
    setState(() {
      _isLoading = true;
      _progress = 0;
    });

    _webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(_urlForServer(server))),
    );
  }

  /// Whether the current server failed to load.
  bool _hasError = false;

  /// Chrome‑like user‑agent so embed sites don't block us.
  static const _userAgent =
      'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36';

  /// Injects CSS to hide common ad overlays.
  void _injectAdBlockCss(InAppWebViewController controller) {
    controller.evaluateJavascript(source: '''
      (function() {
        var style = document.createElement('style');
        style.textContent =
          '.ad-overlay, .popup, [class*="adsbygoogle"],' +
          '[id*="ad-"], iframe[src*="ads"],' +
          'div[class*="overlay"]:not(video):not(.player) {' +
          '  display: none !important;' +
          '}';
        document.head.appendChild(style);
      })();
    ''');
  }

  /// Reloads the current server URL in the web view.
  void _retry() {
    final server = ref.read(selectedServerProvider);
    setState(() {
      _isLoading = true;
      _hasError = false;
      _progress = 0;
    });
    _webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(_urlForServer(server))),
    );
  }

  // ── Build ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final selectedServer = ref.watch(selectedServerProvider);
    final initialUrl = _urlForServer(selectedServer);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── WebView ──────────────────────────────────────
          InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
            initialSettings: InAppWebViewSettings(
              // ── JavaScript & media ─────────────────────
              javaScriptEnabled: true,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              domStorageEnabled: true,

              // ── Emulator Video Decode Crash Fix ────────
              hardwareAcceleration: false,

              // ── Viewport / rendering ───────────────────
              useWideViewPort: true,
              loadWithOverviewMode: true,
              transparentBackground: true,

              // ── Popup / ad blocking ────────────────────
              javaScriptCanOpenWindowsAutomatically: false,
              supportMultipleWindows: false,

              // ── Navigation ─────────────────────────────
              allowsBackForwardNavigationGestures: false,
              useShouldOverrideUrlLoading: true,

              // ── User‑Agent — critical for embed sites ──
              userAgent: _userAgent,

              // ── Mixed content (HTTP subresources) ──────
              mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,

              // ── Allow autoplay ─────────────────────────
              allowContentAccess: true,
              allowFileAccess: true,
            ),

            onWebViewCreated: (controller) {
              _webViewController = controller;
            },

            // Block new‑window (popup) requests — primary ad mitigation.
            onCreateWindow: (controller, createWindowAction) async {
              return false;
            },

            // Intercept navigations to block ad redirects.
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              final url = navigationAction.request.url?.toString() ?? '';
              final currentServer = ref.read(selectedServerProvider);
              final expectedHost =
                  Uri.tryParse(_urlForServer(currentServer))?.host ?? '';

              // Allow navigations within the embed's own domain and
              // common CDN / video hosts.
              final allowed = url.contains(expectedHost) ||
                  url.contains('vidking.net') ||
                  url.contains('vidsrc') ||
                  url.contains('embed.su') ||
                  url.contains('googleapis.com') ||
                  url.contains('gstatic.com') ||
                  url.contains('google.com') ||
                  url.contains('cloudflare') ||
                  url.contains('cdn') ||
                  url.contains('.mp4') ||
                  url.contains('.m3u8') ||
                  url.contains('hls') ||
                  url.contains('stream');

              return allowed
                  ? NavigationActionPolicy.ALLOW
                  : NavigationActionPolicy.CANCEL;
            },

            // Track loading progress.
            onProgressChanged: (controller, progress) {
              if (mounted) {
                setState(() {
                  _progress = progress / 100;
                  if (progress >= 100) _isLoading = false;
                });
              }
            },

            onLoadStop: (controller, url) {
              if (mounted) setState(() => _isLoading = false);
              _injectAdBlockCss(controller);
            },

            onReceivedError: (controller, request, error) {
              // Only flag main frame errors, not sub-resource failures.
              if (request.isForMainFrame ?? false) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _hasError = true;
                  });
                }
              }
            },

            onReceivedHttpError: (controller, request, response) {
              final code = response.statusCode ?? 0;
              if ((request.isForMainFrame ?? false) && code >= 400) {
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                    _hasError = true;
                  });
                }
              }
            },
          ),

          // ── Loading indicator ────────────────────────────
          if (_isLoading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

          // ── Error overlay ────────────────────────────────
          if (_hasError)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.error, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'Failed to load stream',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Try switching to another server',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: _retry,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: AppColors.accentGradient,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusXl),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Top‑left: Back button ────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            child: _GlassIconButton(
              icon: Icons.arrow_back_rounded,
              onTap: _exit,
            ),
          ),

          // ── Top‑right: Server switcher toggle ────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 8,
            child: _GlassIconButton(
              icon: _showServerPanel
                  ? Icons.close_rounded
                  : Icons.dns_rounded,
              onTap: () =>
                  setState(() => _showServerPanel = !_showServerPanel),
            ),
          ),

          // ── Server switcher panel ────────────────────────
          if (_showServerPanel)
            Positioned(
              top: MediaQuery.of(context).padding.top + 56,
              right: 8,
              child: _ServerSwitcherPanel(
                selected: selectedServer,
                onSelected: _switchServer,
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Server Switcher Panel
// ═══════════════════════════════════════════════════════════

/// A small glassmorphic column of server choice chips.
///
/// Positioned as a floating overlay at the top‑right of the
/// player. Each chip maps to a [StreamingServer] enum value.
class _ServerSwitcherPanel extends StatelessWidget {
  const _ServerSwitcherPanel({
    required this.selected,
    required this.onSelected,
  });

  final StreamingServer selected;
  final ValueChanged<StreamingServer> onSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: StreamingServer.values.map((server) {
              final isActive = server == selected;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: _ServerChip(
                  label: server.label,
                  isActive: isActive,
                  onTap: () => onSelected(server),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// A single glassmorphic choice chip for a streaming server.
class _ServerChip extends StatelessWidget {
  const _ServerChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive ? AppColors.accentGradient : null,
          color: isActive ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive
                  ? Icons.check_circle_rounded
                  : Icons.circle_outlined,
              color: isActive ? Colors.white : AppColors.textSecondary,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Shared glass icon button
// ═══════════════════════════════════════════════════════════

/// Frosted‑glass circular icon button used for overlay controls.
class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
        ),
      ),
    );
  }
}
