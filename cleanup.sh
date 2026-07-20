#!/bin/bash
# Exam App — Post-Refactor Cleanup Script
# Run from: exam_app/ directory
# Usage: bash cleanup.sh

set -e

echo "=== Step 1: Delete dead files ==="

# Old presentation layer (replaced by features/)
rm -rf lib/presentation/
echo "  Deleted lib/presentation/"

# Old mock data (distributed to feature data sources)
rm -rf lib/data/mock/
echo "  Deleted lib/data/mock/"

# Old injectable DI files (replaced by manual registration in di.dart)
rm -f lib/core/di/di.config.dart
rm -f lib/core/di/network_module.dart
rm -f lib/core/di/asset_bundle_module.dart
echo "  Deleted old DI files"

echo ""
echo "=== Step 2: Get dependencies ==="
flutter pub get

echo ""
echo "=== Step 3: Run flutter analyze ==="
flutter analyze

echo ""
echo "=== Done! ==="
