# EyeCon Mobile App - Setup Instructions

## Overview
EyeCon is a comprehensive eye care mobile application built with Flutter that provides vision testing, daily exercises, and AI-powered chatbot assistance for eye health.

## Features Implemented

### ✅ Core Features
- **Home Dashboard**: Overview of daily progress, quick actions, and recent activity
- **Daily Exercises**: Interactive exercise tracker with progress monitoring
- **AI Chatbot (Dr. Aisha)**: Voice-enabled conversational assistant for eye health
- **Profile Management**: User profile with statistics and settings
- **Vision Testing**: Basic vision test functionality (enhanced version in progress)

### ✅ Technical Implementation
- **Frontend**: Flutter with Material Design 3
- **State Management**: Provider pattern
- **Backend**: Firebase (Firestore, Auth, Storage)
- **AI Integration**: OpenRouter API for chatbot, fal.ai for voice features
- **Data Models**: Comprehensive models for users, exercises, tests, and chat
- **UI Components**: Custom widgets with animations and micro-interactions

## Setup Instructions

### 1. Prerequisites
- Flutter SDK (3.9.2 or higher)
- Android Studio / VS Code
- Firebase project
- OpenRouter API key
- fal.ai API key

### 2. Firebase Setup
1. Create a new Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Enable Authentication, Firestore Database, and Storage
3. Download `google-services.json` for Android and `GoogleService-Info.plist` for iOS
4. Place them in the appropriate directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

### 3. API Keys Configuration
Update the API keys in `lib/services/ai_service.dart`:
```dart
static const String _openRouterApiKey = 'YOUR_OPENROUTER_API_KEY';
static const String _falApiKey = 'YOUR_FAL_API_KEY';
```

### 4. Firebase Configuration
Update `lib/firebase_options.dart` with your Firebase project details:
```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'your-android-api-key',
  appId: 'your-android-app-id',
  messagingSenderId: 'your-sender-id',
  projectId: 'your-project-id',
  storageBucket: 'your-project-id.appspot.com',
);
```

### 5. Install Dependencies
```bash
flutter pub get
```

### 6. Run the App
```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios
```

## Project Structure

```
lib/
├── models/                 # Data models
│   ├── user_model.dart
│   ├── vision_test_model.dart
│   ├── exercise_model.dart
│   └── chat_model.dart
├── providers/              # State management
│   ├── user_provider.dart
│   ├── exercise_provider.dart
│   └── chat_provider.dart
├── services/               # Backend services
│   ├── firebase_service.dart
│   └── ai_service.dart
├── screens/                # UI screens
│   ├── home_screen.dart
│   ├── exercises_screen_new.dart
│   ├── vision_test_screen.dart
│   ├── eye_doctor_screen.dart
│   └── profile_screen.dart
├── widgets/                # Reusable widgets
│   ├── exercise_card.dart
│   ├── progress_indicator.dart
│   └── daily_plan_card.dart
└── main.dart
```

## Key Features Explained

### 1. Home Screen
- Displays daily progress with statistics
- Quick access to main features
- Recent activity feed
- Motivational messaging

### 2. Daily Exercises
- Tabbed interface (Today, Exercises, History)
- Progress tracking with visual indicators
- Exercise library with filtering
- AI-generated recommendations

### 3. AI Chatbot (Dr. Aisha)
- Conversational interface with voice support
- Context-aware responses
- Quick action buttons
- Real-time messaging

### 4. Profile Management
- User statistics and progress
- Settings and preferences
- Support and help options

## Customization

### Colors
The app uses a consistent color scheme:
- Primary: `#10B2D0` (Teal)
- Secondary: `#4ECDC4` (Light Teal)
- Accent: `#FF6B6B` (Coral)
- Background: White with subtle grays

### Typography
- Primary font: Inter (clean, modern)
- Consistent sizing and weights throughout

## Next Steps

### Immediate Improvements
1. **Enhanced Vision Test**: Add calibration, adaptive testing, and prescription calculation
2. **Exercise Animations**: Add Lottie animations for exercise guidance
3. **Push Notifications**: Implement reminder notifications
4. **Offline Support**: Add offline functionality for exercises

### Future Features
1. **Teleconsultation**: Connect with real eye doctors
2. **Glasses Shop**: Order prescription glasses
3. **Wearable Integration**: Connect with smart devices
4. **Community Features**: User challenges and social features

## Troubleshooting

### Common Issues
1. **Firebase Connection**: Ensure proper configuration and internet connection
2. **API Keys**: Verify all API keys are correctly set
3. **Dependencies**: Run `flutter clean` and `flutter pub get` if build fails
4. **Permissions**: Ensure camera and microphone permissions for voice features

### Debug Mode
Run in debug mode to see detailed error messages:
```bash
flutter run --debug
```

## Support
For technical support or feature requests, please refer to the project documentation or contact the development team.

---

**Note**: This is a development version. For production deployment, ensure all API keys are properly secured and Firebase security rules are configured.

