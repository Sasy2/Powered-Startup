# EyeCon - AI-Powered Eye Care App

A comprehensive Flutter application for eye health monitoring and vision testing, featuring AI-powered assistance and professional-grade vision tests.

## Features

### 🔍 **Snellen Visual Acuity Test**
- **Calibration System**: Credit card-based screen calibration for accurate measurements
- **Scientific Formula**: Implements proper Snellen formula with 5 arcminutes angle
- **Responsive Design**: Adapts to different screen sizes and orientations
- **Dual Eye Testing**: Tests both left and right eyes separately
- **Real-time Results**: Instant visual acuity assessment

### 🤖 **AI Eye Doctor Assistant**
- **Intelligent Chatbot**: AI-powered responses for eye health questions
- **Quick Actions**: Pre-defined responses for common eye issues
- **Voice Integration**: Text-to-speech for accessibility (coming soon)
- **Personalized Advice**: Tailored recommendations based on symptoms

### 💪 **Eye Exercise Programs**
- **Guided Exercises**: Step-by-step eye strengthening routines
- **Progress Tracking**: Monitor your eye health journey
- **Customizable Plans**: Personalized exercise schedules
- **Real-time Feedback**: Track your improvement over time

### 📊 **Health Dashboard**
- **Daily Statistics**: Screen time, exercise completion, break reminders
- **Progress Visualization**: Charts and graphs showing your improvement
- **Goal Setting**: Set and track personal eye health goals
- **Activity History**: Complete log of your eye care activities

## Technical Features

- **Flutter Framework**: Cross-platform mobile development
- **Firebase Integration**: Real-time data synchronization and user management
- **Responsive UI**: Material Design 3 with custom theming
- **State Management**: Provider pattern for efficient state handling
- **Scientific Accuracy**: Medically accurate vision testing algorithms

## Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Firebase project (for full functionality)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Sasy2/Powered-Startup.git
   cd Powered-Startup
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (Optional)
   - Add your `google-services.json` to `android/app/`
   - Update `lib/firebase_options.dart` with your Firebase config

4. **Run the app**
   ```bash
   flutter run
   ```

## Vision Test Algorithm

The app implements the scientifically accurate Snellen formula:

```
LetterHeight = 2 × Distance × tan(θ/2)
```

Where:
- **Distance** = 3m (simulated) or 40cm (actual phone distance)
- **θ** = 5 arcminutes (Snellen standard letter angle)

## Project Structure

```
lib/
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
├── services/        # Business logic
├── widgets/         # Reusable components
└── main.dart        # App entry point
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Medical professionals for vision testing guidance
- Open source community for inspiration

---

**Built with ❤️ for better eye health**