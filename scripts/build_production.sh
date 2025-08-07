#!/bin/bash

echo "🚀 Building Ashley's Treats for Production"
echo "=========================================="

# Set environment variables for production
export FLUTTER_ENV=production

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev"
    exit 1
fi

echo "✅ Flutter detected: $(flutter --version | head -n 1)"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Generate code (for Isar models)
echo "🔄 Generating code..."
if command -v dart &> /dev/null; then
    dart run build_runner build --delete-conflicting-outputs
else
    flutter packages pub run build_runner build --delete-conflicting-outputs
fi

# Analyze code
echo "🔍 Analyzing code..."
flutter analyze
if [ $? -ne 0 ]; then
    echo "❌ Code analysis found issues. Please fix them before building for production."
    exit 1
fi

# Run tests (if any exist)
echo "🧪 Running tests..."
flutter test
if [ $? -ne 0 ]; then
    echo "⚠️  Some tests failed. Consider fixing them before deploying."
fi

# Build for Android (APK)
echo "🤖 Building Android APK..."
flutter build apk --release --split-per-abi
if [ $? -eq 0 ]; then
    echo "✅ Android APK built successfully"
    echo "📱 APK location: build/app/outputs/flutter-apk/"
else
    echo "❌ Android APK build failed"
fi

# Build for Android (App Bundle)
echo "🤖 Building Android App Bundle..."
flutter build appbundle --release
if [ $? -eq 0 ]; then
    echo "✅ Android App Bundle built successfully"
    echo "📱 App Bundle location: build/app/outputs/bundle/release/"
else
    echo "❌ Android App Bundle build failed"
fi

# Build for Web
echo "🌐 Building for Web..."
flutter build web --release
if [ $? -eq 0 ]; then
    echo "✅ Web build completed successfully"
    echo "🌐 Web build location: build/web/"
else
    echo "❌ Web build failed"
fi

# Build for iOS (only on macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building for iOS..."
    flutter build ios --release --no-codesign
    if [ $? -eq 0 ]; then
        echo "✅ iOS build completed successfully"
        echo "📱 iOS build location: build/ios/iphoneos/"
    else
        echo "❌ iOS build failed"
    fi
else
    echo "ℹ️  iOS build skipped (requires macOS)"
fi

echo ""
echo "🎉 Production build process completed!"
echo "================================================"
echo ""
echo "📋 Build Summary:"
echo "• Android APK: build/app/outputs/flutter-apk/"
echo "• Android App Bundle: build/app/outputs/bundle/release/"
echo "• Web: build/web/"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "• iOS: build/ios/iphoneos/"
fi
echo ""
echo "🚀 Your app is ready for production deployment!"
echo ""
echo "📝 Next Steps:"
echo "1. Test the built apps on various devices"
echo "2. Upload to respective app stores"
echo "3. Configure Firebase for production"
echo "4. Set up analytics and crash reporting"
echo "5. Configure CI/CD pipeline"