# Ashley's Treats - Production Deployment Guide

## 🚀 Overview

Ashley's Treats is a fully integrated Flutter application for a bakery business, featuring:
- **Frontend**: Flutter mobile app with beautiful UI
- **Backend**: Firebase Authentication & Firestore
- **Local Storage**: Isar database for offline functionality
- **File Storage**: Appwrite for image management
- **State Management**: Riverpod for reactive programming

## 📋 Prerequisites

### Development Environment
- Flutter SDK 3.22.3 or higher
- Dart SDK 3.4.4 or higher
- Android Studio / VS Code
- Git

### Production Services
- Firebase project with Authentication & Firestore
- Appwrite instance for file storage
- Google Play Console account (for Android)
- Apple Developer account (for iOS)

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │    Firebase     │    │    Appwrite     │
│                 │    │                 │    │                 │
│ • Authentication│◄──►│ • Auth          │    │ • File Storage  │
│ • Product List  │    │ • Firestore     │    │ • Image Upload  │
│ • Cart          │    │ • Functions     │    │                 │
│ • Orders        │    │ • Messaging     │    │                 │
│ • Profile       │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │
         ▼
┌─────────────────┐
│  Isar Database  │
│                 │
│ • Local Cache   │
│ • Offline Data  │
│ • Cart Items    │
│ • User Prefs    │
└─────────────────┘
```

## 🔧 Setup Instructions

### 1. Clone and Install Dependencies

```bash
git clone <repository-url>
cd ashleystreats
flutter pub get
```

### 2. Configure Firebase

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication with Email/Password
3. Enable Firestore Database
4. Download configuration files:
   - `google-services.json` for Android → `android/app/`
   - `GoogleService-Info.plist` for iOS → `ios/Runner/`

### 3. Configure Appwrite

1. Set up Appwrite instance
2. Create a project
3. Configure storage bucket for images
4. Update configuration in `lib/core/config/app_config.dart`

### 4. Generate Required Files

```bash
# Generate Isar models
flutter packages pub run build_runner build --delete-conflicting-outputs

# Generate app icons (optional)
flutter packages pub run flutter_launcher_icons:main
```

## 🚀 Production Build

### Automated Build Script

```bash
./scripts/build_production.sh
```

### Manual Build Commands

#### Android
```bash
# APK for testing
flutter build apk --release

# App Bundle for Play Store
flutter build appbundle --release
```

#### iOS
```bash
# iOS build (macOS only)
flutter build ios --release
```

#### Web
```bash
# Web build
flutter build web --release
```

## 🔐 Security Configuration

### Firebase Security Rules

#### Firestore Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Orders - users can read/write their own orders, admins can read all
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.userId || 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
    }
    
    // Products - read for all authenticated users, write for admins only
    match /products/{productId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

#### Storage Rules
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /products/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

### App Configuration

Update `lib/core/config/app_config.dart` for production:

```dart
// Debug Settings
static const bool isDebugMode = false; // Set to false in production
static const bool showDetailedErrors = false; // Set to false in production
static const bool enableAnalytics = true; // Set to true in production
```

## 📱 App Store Deployment

### Google Play Store

1. **Prepare App Bundle**
   ```bash
   flutter build appbundle --release
   ```

2. **Upload to Play Console**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create new app or update existing
   - Upload the AAB file from `build/app/outputs/bundle/release/`

3. **Store Listing Requirements**
   - App icon (512x512 PNG)
   - Screenshots (phone, tablet, 10-inch tablet)
   - Feature graphic (1024x500)
   - Short description (80 chars)
   - Full description (4000 chars)
   - Privacy policy URL

### Apple App Store

1. **Prepare iOS Build**
   ```bash
   flutter build ios --release
   ```

2. **Xcode Configuration**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Configure signing & capabilities
   - Archive and upload to App Store Connect

3. **App Store Requirements**
   - App icon (1024x1024 PNG)
   - Screenshots for all device sizes
   - App description
   - Keywords
   - Privacy policy

## 🌐 Web Deployment

### Firebase Hosting

1. **Install Firebase CLI**
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

2. **Initialize Hosting**
   ```bash
   firebase init hosting
   # Select build/web as public directory
   # Configure as single-page app: Yes
   # Overwrite index.html: No
   ```

3. **Deploy**
   ```bash
   firebase deploy --only hosting
   ```

### Alternative Hosting Options
- **Netlify**: Drag and drop `build/web` folder
- **Vercel**: Connect GitHub repository
- **GitHub Pages**: Push `build/web` to gh-pages branch

## 🔍 Testing & Quality Assurance

### Automated Testing
```bash
# Run all tests
flutter test

# Run integration tests
flutter test integration_test/

# Code analysis
flutter analyze
```

### Manual Testing Checklist

#### Authentication Flow
- [ ] User registration
- [ ] Email verification
- [ ] Login/logout
- [ ] Password reset
- [ ] Role-based access (admin/customer)

#### Product Management
- [ ] View product list
- [ ] Search products
- [ ] Filter by category
- [ ] Product details
- [ ] Admin: Add/edit/delete products

#### Cart & Orders
- [ ] Add to cart
- [ ] Update quantities
- [ ] Remove items
- [ ] Checkout process
- [ ] Order history
- [ ] Order status updates

#### Performance
- [ ] App startup time < 3 seconds
- [ ] Smooth scrolling
- [ ] Image loading
- [ ] Offline functionality
- [ ] Background sync

## 📊 Monitoring & Analytics

### Firebase Analytics
- User engagement
- Screen views
- Custom events
- Conversion tracking

### Crashlytics
- Real-time crash reporting
- Performance monitoring
- User session data

### Performance Monitoring
```dart
// Add to main.dart
import 'package:firebase_performance/firebase_performance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  runApp(MyApp());
}
```

## 🔄 CI/CD Pipeline

### GitHub Actions Example

```yaml
name: Build and Deploy
on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.22.3'
    - run: flutter pub get
    - run: flutter test
    - run: flutter build apk --release
    - run: flutter build web --release
```

## 🚨 Troubleshooting

### Common Issues

1. **Build Failures**
   - Clean project: `flutter clean && flutter pub get`
   - Update dependencies: `flutter pub upgrade`
   - Clear build cache: `flutter clean`

2. **Firebase Connection Issues**
   - Verify configuration files are in correct locations
   - Check Firebase project settings
   - Ensure services are enabled

3. **Isar Database Issues**
   - Regenerate models: `flutter packages pub run build_runner build --delete-conflicting-outputs`
   - Clear app data on device

4. **Performance Issues**
   - Enable Flutter Inspector
   - Use `flutter run --profile` for profiling
   - Optimize images and assets

## 📞 Support

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Riverpod Documentation](https://riverpod.dev/)

### Community
- [Flutter Discord](https://discord.gg/flutter)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [GitHub Issues](https://github.com/flutter/flutter/issues)

---

## 🎉 Congratulations!

Your Ashley's Treats app is now production-ready! 🧁

Remember to:
- Monitor app performance and user feedback
- Keep dependencies updated
- Implement new features based on user needs
- Maintain regular backups of your data
- Follow app store guidelines for updates

Good luck with your bakery business! 🚀