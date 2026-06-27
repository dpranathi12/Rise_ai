# RiseAI: India's AI-Powered Smart Alarm & Personalized Wake-Up Coach

## Project Vision

RiseAI is a modern Android-first mobile application designed to revolutionize the morning routine. Unlike traditional alarm apps that are easily snoozed or dismissed, RiseAI leverages Artificial Intelligence to ensure users genuinely wake up and start their day energized. The AI personalizes wake-up challenges based on user habits, performance, and history, making every morning smarter and healthier. This application is built to be fully functional, visually stunning, and suitable for a live hackathon demonstration.

## Problem Statement

Millions of students, professionals, and shift workers in India struggle to wake up on time. Existing alarm systems often fail to provide the necessary motivation, leading to poor productivity, missed classes, unhealthy sleep habits, and reduced physical activity. RiseAI addresses this by transforming the morning routine through AI-powered exercise verification, adaptive challenges, and personalized motivation.

## Core AI Features

The alarm in RiseAI will not stop until the user successfully completes an AI-verified wake-up challenge. The AI intelligently adapts these challenges over time, moving beyond fixed rules to provide a truly personalized experience.

### AI Pose Estimation

Utilizing **MediaPipe Pose** or **TensorFlow Lite Pose Detection**, RiseAI tracks key body landmarks (shoulders, elbows, hips, knees, ankles) to recognize and count repetitions for various exercises such as squats, jumping jacks, push-ups, lunges, and stretching. The system ensures movements are performed correctly, rejecting half squats, incomplete movements, fake bending, or cheating attempts.

### AI Adaptive Wake-Up Engine

This engine learns from the user's history, considering factors like wake-up consistency, average completion time, failed alarms, skipped workouts, and exercise accuracy. Based on these insights, the AI automatically selects the appropriate exercise type, number of repetitions, motivational message, and overall wake-up difficulty, continuously improving recommendations daily.

### AI Wakefulness Detection

Before allowing exercise counting, RiseAI verifies the user's wakefulness by detecting open eyes, face visibility, head movement, blinking, and looking toward the camera. Counting is paused if the face disappears, the user leaves the camera view, or lighting becomes too dark.

### AI Motivation Engine

Personalized motivational messages are generated every morning, leveraging user data to provide encouraging feedback, such as streak achievements, improvements over previous weeks, and positive reinforcement for increased challenge difficulty.

### AI Habit Analytics

RiseAI provides insightful analytics, including average wake-up time, best wake-up day, longest streak, improvement over the previous week, completion percentage, estimated calories burned, and exercise history. These are displayed through intuitive charts and progress cards.

## Alarm Workflow

1.  **User creates an alarm.**
2.  **Alarm rings.**
3.  **Full-screen alarm activates.**
4.  **User presses "I'm Awake".**
5.  **Camera opens.**
6.  **AI verifies face and body.**
7.  **AI selects today's challenge.**
8.  **Live pose estimation starts.**
9.  **Real-time repetition counting (e.g., 0/15, 1/15, ...).**
10. **Challenge completed.**
11. **Alarm stops automatically.**
12. **Confetti animation.**
13. **Show today's statistics.**
14. **Display AI-generated motivational message.**

## Main Screens

*   **Splash Screen**: Animated logo, gradient background, Lottie animation.
*   **Onboarding**: Explains why traditional alarms fail, how AI helps, and benefits with beautiful illustrations.
*   **Login**: Options for Google, Email, or Guest login.
*   **Home**: Displays today's alarm, current streak, wake-up score, next alarm, quick set alarm, today's AI challenge, morning quote, and a beautiful dashboard.
*   **Create Alarm**: Allows users to choose time, days, sound, vibration, exercise preferences, and difficulty.
*   **Alarm Screen**: Full-screen, cannot be closed or swiped away, animated background, large countdown, alarm animation, and a prominent "I'm Awake" button.
*   **AI Camera Screen**: Front camera preview, skeleton overlay, joint tracking, live repetition counter, exercise instructions, voice guidance, accuracy score, and completion percentage.
*   **Dashboard**: Weekly and monthly charts, streak calendar, calories burned, wake-up quality, completion graph, and achievements.
*   **History**: Lists all alarms, completion times, exercises completed, and average performance with search and filter options.
*   **Settings**: Manages theme (dark mode), language, notification settings, voice, exercise customization, privacy, and permissions.

## Gamification

RiseAI incorporates gamification elements to enhance user engagement:

*   **Levels & XP**: Users gain experience points (XP) for completing challenges, leading to level progression.
*   **Coins**: Earned through consistent wake-ups and challenge completion.
*   **Achievements**: Unlock badges for milestones like "Early Bird," "7-Day Streak," "30-Day Champion," "500 Squats," and "100 Wake-Ups." Premium badges are also available.

## Notifications

*   **Bedtime reminder**
*   **Hydration reminder**
*   **Morning motivation**
*   **Weekly report**
*   **Streak warning**

## UI Design

Following **Material Design 3** principles, RiseAI features a premium appearance with rounded corners, glassmorphism effects, animated gradients, Lottie animations, smooth page transitions, modern typography, and dark mode support. The design is responsive and pixel-perfect.

## Tech Stack

*   **Flutter**: Cross-platform UI toolkit.
*   **Riverpod**: State management.
*   **Hive**: Fast and efficient local data storage.
*   **Firebase Authentication**: User authentication.
*   **Cloud Firestore**: Cloud database (for future integration).
*   **MediaPipe Pose / TensorFlow Lite**: On-device AI pose estimation.
*   **ML Kit Face Detection**: On-device AI wakefulness detection.
*   **Flutter Local Notifications**: Local notification scheduling.
*   **Android AlarmManager**: Android-specific alarm scheduling.
*   **Foreground Service**: For persistent alarm functionality.
*   **Lottie**: For animations.
*   **Google Fonts**: For custom typography.
*   **FL Chart**: For data visualization.
*   **Shared Preferences**: For simple key-value storage.
*   **Path Provider**: For accessing device file system paths.
*   **UUID**: For generating unique IDs.
*   **Confetti**: For celebratory animations.

## Performance & Security

*   **On-device AI**: AI runs completely on the device, requiring no internet for core alarm functionality.
*   **Optimized Performance**: 30 FPS pose estimation, fast camera startup, and battery optimization.
*   **Security**: Encrypted local storage, secure authentication, minimal permissions, and privacy-first design.

## Installation Guide

To set up and run the RiseAI project locally, follow these steps:

### Prerequisites

*   **Flutter SDK**: Ensure Flutter is installed and configured. Follow the official guide: [Flutter Installation Guide](https://flutter.dev/docs/get-started/install)
*   **Android SDK**: Command-line tools and platform-tools are required. These were installed during the setup process.
*   **Java Development Kit (JDK)**: OpenJDK 17 or higher.

### Steps

1.  **Clone the repository:**
    ```bash
    git clone [repository_url] rise_ai
    cd rise_ai
    ```

2.  **Get Flutter dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate Hive adapters:**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Configure Firebase (Optional but Recommended for full functionality):**
    *   Create a Firebase project on the [Firebase Console](https://console.firebase.google.com/).
    *   Add an Android app to your Firebase project and follow the instructions to download `google-services.json`.
    *   Place `google-services.json` in `android/app/` directory.
    *   Uncomment `await Firebase.initializeApp();` in `lib/main.dart`.

5.  **Run the application:**
    ```bash
    flutter run
    ```

    *Note: For AI features requiring camera access, run on a physical Android device or an emulator with camera support.*
