# Leads App - Project Documentation

## 📱 Project Overview

**Leads** is a Flutter-based mobile application designed for sales teams to manage leads, contacts, and team collaboration with role-based access control.

### Key Information
- **Platform**: Flutter (Cross-platform: iOS, Android, Web, Desktop)
- **Language**: Dart
- **Architecture**: Feature-based modular structure
- **State Management**: ValueNotifier with Singleton pattern
- **UI Framework**: Material Design 3

---

## 🎯 Application Purpose

The Leads app helps sales teams:
- Track and manage sales leads efficiently
- Store and organize customer/prospect contacts
- Schedule and calendar-based lead management
- Receive real-time notifications on lead activities
- Enable team managers to coordinate team members and distribute leads

---

## 👥 User Roles

### 1. **Regular User**
- Create and manage personal leads
- Add and manage contacts
- View calendar with scheduled leads
- Receive notifications
- Update lead statuses

### 2. **Team Manager**
- All regular user capabilities
- Add team members
- Transfer leads to team members
- View team statistics (Total Leads, Completed, Pending)
- Monitor team performance

---

## 🏗️ Technical Architecture

### Project Structure
```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
│   ├── lead.dart                      # Lead model with status enum
│   ├── contact.dart                   # Contact model
│   └── notification.dart              # Notification model with types
├── data/                              # Data layer (State Management)
│   ├── lead_store.dart                # Singleton lead store
│   └── notification_store.dart        # Singleton notification store
├── screens/                           # UI Screens (Feature-based)
│   ├── splash/                        # Splash screen
│   ├── login/                         # Login with email/password
│   ├── signup/                        # Registration
│   ├── choose_role/                   # Role selection
│   ├── home/                          # Regular user dashboard
│   ├── team_manager_home/             # Team manager dashboard
│   ├── leads/                         # Lead management
│   ├── contacts/                      # Contact management
│   ├── create_leads/                  # Lead creation
│   ├── create_contact/                # Contact creation
│   ├── notifications/                 # Notifications center
│   ├── settings/                      # User settings
│   ├── terms/                         # Terms & conditions
│   └── total_leads/                   # All leads view
└── widgets/                           # Reusable components
    └── search/                        # Global search functionality
```

---

## 📊 Data Models

### Lead Model
```dart
class Lead {
  final String id;
  final String title;
  final String contactName;
  final String contactId;
  final String details;
  final DateTime dateTime;
  final LeadStatus status;
}

enum LeadStatus {
  pending,      // New/unactioned leads
  rescheduled,  // Postponed leads
  completed     // Closed/finished leads
}
```

### Contact Model
```dart
class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String phoneCode;    // Country code
  final String email;
  final String note;
  
  // Computed properties
  String get fullName => ' ';
  String get formattedPhone => '+ ';
}
```

### Notification Model
```dart
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? leadId;      // Optional reference
  final String? contactId;   // Optional reference
}

enum NotificationType {
  newLead,          // Red icon
  leadRescheduled,  // Orange icon
  leadCompleted,    // Green icon
  leadAssigned      // Blue icon
}
```

---

## 🔄 State Management

### Data Stores (Singleton Pattern)

#### LeadStore
- **Purpose**: Centralized lead management
- **Type**: `ValueNotifier<List<Lead>>`
- **Methods**:
  - `addLead(Lead lead)` - Add new lead
  - `upsertLead(Lead lead)` - Add or update lead
  - `replaceAll(List<Lead> leads)` - Replace entire list

#### NotificationStore
- **Purpose**: Centralized notification management
- **Type**: `ValueNotifier<List<AppNotification>>`
- **Methods**:
  - `addNotification(AppNotification notification)`
  - `markAsRead(String id)`
  - `markAllAsRead()`
  - `deleteNotification(String id)`
  - Helper methods for specific notifications

---

## 📦 Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI Components
  cupertino_icons: ^1.0.8
  flutter_svg: ^2.0.10+1
  font_awesome_flutter: ^10.7.0
  
  # Country Selection
  country_picker: ^2.0.26
  
  # Calendar
  syncfusion_flutter_calendar: ^27.2.5
  
  # Utilities
  url_launcher: ^6.3.1
```

---

## 🚀 Features

### 1. Authentication
- Email/password login
- User registration
- Password recovery
- Role selection (User/Manager)

### 2. Lead Management
- Create leads with contact association
- Schedule leads with date/time picker
- Update lead status (Pending/Rescheduled/Completed)
- View lead details
- Calendar view of scheduled leads
- Search leads globally

### 3. Contact Management
- Add contacts with full details
- Country code picker for phone numbers
- View contact details
- Add notes to contacts
- Search contacts

### 4. Notifications
- Real-time notification system
- Color-coded notification types
- Mark as read functionality
- Delete notifications
- Badge showing unread count

### 5. Team Management (Manager Only)
- Add team members
- View team statistics
- Transfer leads to team members
- Monitor team performance

### 6. Calendar Integration
- Syncfusion calendar widget
- Monthly view with lead indicators
- Color-coded lead status
- Click to view lead details

### 7. Settings
- User profile management
- Change password
- Privacy settings
- Terms & conditions
- App information

---

## 🎨 Design System

### Color Scheme
- **Primary**: Blue tones for main actions
- **Success**: Green for completed items
- **Warning**: Orange for rescheduled items
- **Danger**: Red for pending/urgent items
- **Neutral**: Grays for backgrounds and text

### Typography
- Default Material Design font system
- Font Awesome icons for visual elements

### UI Components
- Material Design 3 components
- Custom bottom navigation bar
- Animated calendar expansion
- Gradient backgrounds
- Custom clock picker

---

## ⚠️ Known Limitations

### Current Implementation
1. **No Data Persistence**: All data is in-memory and lost on app restart
2. **No Backend Integration**: Authentication is UI-only, no real API
3. **Hardcoded Test Data**: Some screens use hardcoded contacts
4. **No User Sessions**: No user state management across app restarts
5. **Local State in HomePage**: HomePage maintains its own leads list instead of using LeadStore

### Deprecation Warnings (11 total)
- 5× `Color.withOpacity()` → Should use `.withValues()`
- 3× SVG `color` parameter → Should use `ColorFilter`
- 1× `dialogBackgroundColor` → Should use `DialogThemeData`
- 2× Private type in public API

**Note**: These are warnings only and do not affect functionality.

---

## 🔧 Setup Instructions

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK (comes with Flutter)
- Android Studio / VS Code
- iOS/Android Simulator or physical device

### Installation
```bash
# Clone or navigate to project
cd C:\Games\Leads\leads

# Get dependencies
flutter pub get

# Check Flutter installation
flutter doctor

# Run the app
flutter run

# Build for specific platform
flutter build apk          # Android
flutter build ios          # iOS
flutter build web          # Web
flutter build windows      # Windows desktop
```

---

## 🧪 Testing

### Current Status
- Test folder exists: `lib/test/`
- No tests currently implemented

### Recommended Testing Strategy
1. Unit tests for data models
2. Widget tests for UI components
3. Integration tests for user flows
4. State management tests for stores

---

## 🔮 Future Enhancements

### High Priority
1. **Database Integration** (SQLite, Hive, or Firebase)
2. **Backend API Integration** (Authentication, data sync)
3. **Push Notifications** (Firebase Cloud Messaging)
4. **Offline Support** with sync capability

### Medium Priority
5. **Export/Import Data** (CSV, Excel)
6. **Advanced Search & Filters**
7. **Lead Analytics & Reports**
8. **Attachment Support** (Documents, images)
9. **Email Integration**
10. **Activity Logging**

### Low Priority
11. **Dark Mode Support**
12. **Multi-language Support**
13. **Custom Themes**
14. **Widgets for Home Screen**

---

## 📁 File Statistics

- **Total Dart Files**: 73
- **Screens**: 31 screen files
- **Widgets**: 25+ reusable widgets
- **Models**: 3 data models
- **Data Stores**: 2 state managers

---

## 📄 License & Credits

- **Framework**: Flutter (Google)
- **Calendar**: Syncfusion Flutter Calendar
- **Icons**: Font Awesome, Custom SVGs

---

## 📞 Contact & Support

For questions or support regarding this project:
- Review code documentation in source files
- Check Flutter documentation: https://flutter.dev/docs
- Syncfusion Calendar docs: https://help.syncfusion.com/flutter/calendar/overview

---

**Last Updated**: January 1, 2026
**Version**: 1.0.0
**Status**: Development - Functional with noted limitations
