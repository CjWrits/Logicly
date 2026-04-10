# Logicly

A minimal Flutter app that explains any DSA problem or topic in the simplest way possible using AI.

## Features

- Explain any DSA problem or topic instantly
- Multiple solution approaches (Brute Force → Optimal)
- Step-by-step logic, intuition, Java code, time complexity
- Syntax highlighted code blocks
- Light & dark mode
- Powered by Groq (llama-3.3-70b)

## Setup

### 1. Clone the repo
```bash
git clone https://github.com/<your-username>/logicly.git
cd logicly
```

### 2. Get your free Groq API key
Go to https://console.groq.com → API Keys → Create API Key

### 3. Create your .env file
```bash
cp .env.example .env
```
Then open `.env` and replace `your_groq_api_key_here` with your actual key.

### 4. Install dependencies
```bash
flutter pub get
```

### 5. Generate app icons
```bash
flutter run -t tool/generate_icons.dart -d flutter-tester
```

### 6. Run the app
```bash
flutter run
```

### 7. Build release APK
```bash
flutter build apk --release --split-per-abi
```
APK will be at `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

## Tech Stack

- Flutter 3.x
- Groq API — `llama-3.3-70b-versatile`
- `http` — API calls
- `flutter_dotenv` — secure API key management

## Security

- API key is stored in `.env` which is git-ignored
- Never commit your `.env` file
- Use `.env.example` as a template

## Disclaimer

Explanations are AI-generated. Always verify before using in production or exams.
