# 🧠 CalmConnect - Mental Health Support Platform

[![Watch Demo](https://img.shields.io/badge/🎥%20Watch%20Demo-YouTube%20Shorts-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://youtube.com/shorts/Uuan3-ANRl0?si=_uJG7Pkmz3SzC7E9)
[![Download APK](https://img.shields.io/badge/📱%20Download%20APK-Latest%20Release-00C851?style=for-the-badge&logo=android&logoColor=white)](https://github.com/Rohanvish4/CalmConnect/releases/latest)
[![Source Code](https://img.shields.io/badge/💻%20Source%20Code-GitHub-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Rohanvish4/CalmConnect)

CalmConnect is a comprehensive mental health support Flutter application that facilitates peer-to-peer communication, professional resource discovery, and daily wellness tips. It’s built to create a safe, judgment-free environment for mental health support and community building.

---

## 🏆 Hackathon Achievement

### Hack O'Gravity – 3-Day Hackathon
- Organizer: Career Development Cell, KNIT Sultanpur  
- Collaboration Partner: Tata Consultancy Services (TCS)  
- Duration: 3 Days  
- Theme: Innovation, Creativity, and Problem-Solving  
- Recognition: Presented CalmConnect as a solution for mental health support in digital communities  

---

## 📱 App Demo & Tour

### 🎥 Video Walkthrough
Watch our comprehensive app tour showcasing key features and functionality:

[![CalmConnect App Tour](https://img.shields.io/badge/▶%20Watch%20Demo-YouTube%20Shorts-red?style=for-the-badge&logo=youtube)](https://youtube.com/shorts/Uuan3-ANRl0?si=_uJG7Pkmz3SzC7E9)

YouTube Short Highlights (≈2.5 minutes):
- Complete app navigation and user interface
- Authentication system for both peers and counselors
- Real-time chat functionality demonstration
- Professional resource discovery features
- Self-care tips and wellness content
- Mobile responsiveness and user experience

### 📥 Download APK
Get the latest release of CalmConnect for Android:

[![Download APK](https://img.shields.io/badge/📱%20Download%20APK-Latest%20Release-green?style=for-the-badge&logo=android)](https://github.com/Rohanvish4/CalmConnect/releases/latest)

App Details:
- Size: ~30MB (optimized for smaller downloads)
- Compatibility: Android 5.0+ (API 21+)
- Architectures: ARM64, ARM32
- Installation: Enable “Unknown Sources” in Android settings

---

## ✨ Features

### 🔐 Authentication System
- Dual User Types: Peer users and Professional counselors
- Secure Registration: Email/password with Firebase
- Real-time validation and user-friendly errors
- Counselor Verification: Fields for professional credentials

### 🏠 Home Dashboard
- Personalized greetings (time-based)
- Clear feature categories
- Material Design 3 with gradient backgrounds
- Quick access to professional resources

### 💬 Real-time Chat
- Peer-to-peer messaging
- Chat with verified counselors
- Firebase real-time sync
- Moderated, supportive environment

### 📚 Resource Discovery
- Professional directory with profiles
- Categorized by specialization and expertise
- Enhanced search by need
- Detailed counselor information

### 🌱 Self-Care & Wellness
- Daily curated wellness tips
- Community-contributed tips
- Interactive cards
- Progress tracking

### 🤝 Peer Support Network
- Discover and connect with peers
- Support groups
- Privacy-first, judgment-free interactions
- Optional anonymity

---

## 🛠 Technical Stack

- Frontend: Flutter (Dart), Material Design 3
- State Management: GetX (reactive + DI), Controllers
- Backend & Data: Firebase Authentication, Cloud Firestore, Firebase Storage, real-time sync
- Architecture: MVC, Repository pattern, reusable components, responsive design

---

## 📱 App Architecture

```
lib/
├── component/              # Reusable UI components
│   ├── calm_connect_logo.dart
│   ├── ktext_form_field.dart
│   └── user_card.dart
├── controller/             # Business logic controllers
│   └── auth_controller.dart
├── model/                  # Data models
│   ├── chat_item.dart
│   ├── professional_resource.dart
│   ├── tip.dart
│   └── user_model.dart
├── routes/                 # Navigation management
│   ├── route_generator.dart
│   └── routes.dart
├── screens/                # UI screens
│   ├── auth/               # Authentication
│   ├── chat/               # Messaging system
│   ├── home/               # Main dashboard
│   ├── resources/          # Professional resources
│   ├── self_care/          # Wellness features
│   └── support/            # Support system
├── service/                # External integrations
│   └── firebase_service.dart
└── shared/                 # Shared utilities
    └── shared_controller.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>= 3.9.2)
- Dart SDK
- Android Studio or VS Code
- Firebase account
- Android/iOS development setup

### Installation

1) Clone the repository
```bash
git clone https://github.com/Rohanvish4/CalmConnect.git
cd CalmConnect
```

2) Install dependencies
```bash
flutter pub get
```

3) Firebase setup
- Create a Firebase project
- Add Android/iOS apps to the project
- Download and add configuration files:
  - android/app/google-services.json (Android)
  - ios/Runner/GoogleService-Info.plist (iOS)

4) Run the application
```bash
flutter run
```

---

## 📊 App Size Optimization

| Build Type     | Size   | Best For                        |
|----------------|--------|---------------------------------|
| ARM64 APK      | ~20MB  | Modern Android devices          |
| ARM32 APK      | ~18MB  | Older Android devices           |
| Universal APK  | ~52MB  | Maximum compatibility           |

Techniques Used:
- Architecture-specific builds (`--split-per-abi`)
- Tree-shaking for unused code
- Icon font optimization (≈99.4% reduction)
- ProGuard/R8 minification
- Resource shrinking for unused assets

---

## 🎨 UI/UX Highlights48

### Design Philosophy
- Calming color palette (soothing blues/greens)
- Intuitive bottom navigation and meaningful icons
- Accessibility: high contrast, readable typography
- Responsive across screen sizes

### Key UI Features
- Custom logo with fallbacks
- Gradient backgrounds
- Elevated cards with rounded corners
- Smooth loading states and transitions
- Clear error handling and validation

---

## 🔥 Key Innovations

### Mental Health Focus
- Peer support with shared experiences
- Professional integration for guidance
- Safe, moderated communication
- Easy access to trusted resources

### Technical Innovations
- Dual user system (peers and professionals)
- Real-time synchronization
- Context-aware validation
- Scalable, maintainable architecture

---


## 🌍 Impact & Vision

### Problem Statement
Mental health support is often inaccessible, stigmatized, or expensive. Many people struggle without guidance or community support—especially digital-native generations.

### Our Solution
CalmConnect provides:
- Accessible peer-to-peer conversations
- Easy access to verified professionals
- Safe community spaces for sharing
- Curated wellness tips and self-care practices

### Target Impact
- Reduce stigma through peer support
- Increase accessibility to professional help
- Foster supportive digital communities
- Promote daily wellness and self-care

---

## 🧭 Roadmap

### Phase 1 – Enhanced Features
- [ ] Advanced chat (voice messages, media)
- [ ] Group therapy sessions
- [ ] Crisis support (emergency resources)
- [ ] Mobile notifications

### Phase 2 – AI Integration
- [ ] AI chat support (initial screening)
- [ ] Mood tracking and insights
- [ ] Smart matching (peers/counselors)
- [ ] Personalized wellness content

### Phase 3 – Platform Expansion
- [ ] Web application
- [ ] Integration APIs (providers)
- [ ] Analytics dashboard
- [ ] Multi-language support

---

## 🏅 Achievements

### Technical Accomplishments
- Fully functional cross-platform Flutter app
- Firebase real-time database and authentication
- Modern UI/UX with Material Design 3
- Clean, scalable architecture

### Innovation Recognition
- Addressed real-world mental health challenges
- User-centric design with accessibility focus
- Robust implementation within tight timelines
- Positive potential for community impact

---



---

## 📞 Contact

- Email: rohannic111@gmail.com  




## 🌟 Screenshots & Demo

Screenshots coming soon — watch the YouTube demo in the meantime.

Key Screens:
1. Authentication Flow — secure login/registration  
2. Home Dashboard — personalized mental health hub  
3. Chat Interface — real-time peer and professional communication  
4. Resource Directory — professional services  
5. Self-Care Section — daily wellness tips and community sharing

---

## 🔗 Repository & Links

[![GitHub Repository](https://img.shields.io/badge/GitHub-Repository-181717?style=for-the-badge&logo=github)](https://github.com/Rohanvish4/CalmConnect)
[![YouTube Demo](https://img.shields.io/badge/YouTube-Demo-FF0000?style=for-the-badge&logo=youtube)](https://youtube.com/shorts/Uuan3-ANRl0?si=_uJG7Pkmz3SzC7E9)
[![Download APK](https://img.shields.io/badge/Download-APK-00C851?style=for-the-badge&logo=android)](https://github.com/Rohanvish4/CalmConnect/releases/latest)

If you found this project helpful, please ⭐ star the repo!

---

Built with ❤️ during Hack O'Gravity Hackathon 2025  
Empowering mental health support through technology
