# EasyTrack - BAC Monitoring App

EasyTrack is a Flutter app that allows users track their Blood Alcohol Concentration (BAC) during drinking sessions. It features real-time BAC calculations, intuitive graphs, drink session management, and live notifications to promote safer drinking habits.

---

## Current Features

- Start and stop tracking drink sessions
- Add a standard drink with a single tap
- Live BAC tracking and max BAC calculation
- BAC graphs for visual analysis
- Local session storage with Hive
- Clean navigation and UI

---

## Pending Features
- Push notifications with:
  - Current BAC
  - Max BAC from now on, assuming no additional drinks
  - Color-coded icons based on BAC
  - Button to quickly add a drink
- Bluetooth sync with external hardware to:
    - Track drinks with a buttons
    - Display BAC color on through lights

---

## Development

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- VS Code or Android Studio 
- Device/emulator for testing such as XCode

### Installation

```bash
git clone https://github.com/your-username/easytrack.git
cd easytrack
flutter pub get
flutter run