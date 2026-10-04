#!/bin/bash
set -e

# Create core Clean Architecture directories for the media feature
mkdir -p lib/features/media/domain/entities
mkdir -p lib/features/media/domain/repositories
mkdir -p lib/features/media/domain/usecases
mkdir -p lib/features/media/data/models
mkdir -p lib/features/media/data/datasources
mkdir -p lib/features/media/data/repositories

# Move models
mv lib/shared/data/models/* lib/features/media/data/models/

# Move repository
mv lib/shared/data/repositories/tmdb_repository.dart lib/features/media/data/repositories/tmdb_repository_impl.dart

# Create provider directories for each feature
mkdir -p lib/features/home/presentation/providers
mkdir -p lib/features/search/presentation/providers
mkdir -p lib/features/details/presentation/providers
mkdir -p lib/features/player/presentation/providers
mkdir -p lib/features/media/presentation/providers

# Clean up empty shared directories
rm -rf lib/shared/data/models
rm -rf lib/shared/data/repositories
rm -rf lib/shared/data

echo "Project structure updated successfully."
