# Developer Guide - Leads App

## 🚀 Quick Start Guide

### Prerequisites
- **Flutter SDK**: 3.0.0 or higher
- **Dart SDK**: 3.0.0 or higher (comes with Flutter)
- **IDE**: Android Studio, VS Code, or IntelliJ IDEA
- **Platform Tools**: 
  - Android: Android SDK, Android Emulator or Physical Device
  - iOS: Xcode (macOS only), iOS Simulator or Physical Device
  - Windows: Windows 10 SDK
  - Web: Chrome browser

---

## 📥 Installation & Setup

### 1. Clone or Navigate to Project
```bash
cd C:\Games\Leads\leads
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Verify Flutter Installation
```bash
flutter doctor
```

Expected output should show:
- ✓ Flutter (stable channel)
- ✓ Android toolchain
- ✓ Connected devices

### 4. Run the App
```bash
# Run on connected device/emulator
flutter run

# Run on specific device
flutter devices                    # List available devices
flutter run -d <device-id>         # Run on specific device

# Run with hot reload enabled (default)
flutter run --hot
```

---

## 🏗️ Project Structure Explained

```
leads/
├── lib/                           # Main source code
│   ├── main.dart                  # App entry point
│   │
│   ├── models/                    # Data models
│   │   ├── lead.dart              # Lead entity
│   │   ├── contact.dart           # Contact entity
│   │   └── notification.dart      # Notification entity
│   │
│   ├── data/                      # State management
│   │   ├── lead_store.dart        # Lead state store
│   │   └── notification_store.dart # Notification state store
│   │
│   ├── screens/                   # Feature screens
│   │   ├── splash/                # Splash screen
│   │   ├── login/                 # Authentication
│   │   ├── signup/                # Registration
│   │   ├── choose_role/           # Role selection
│   │   ├── home/                  # Main dashboard
│   │   ├── leads/                 # Lead management
│   │   ├── contacts/              # Contact management
│   │   ├── create_leads/          # Lead creation
│   │   ├── create_contact/        # Contact creation
│   │   ├── notifications/         # Notifications
│   │   ├── settings/              # Settings & profile
│   │   ├── team_manager_home/     # Manager dashboard
│   │   └── ...                    # Other screens
│   │
│   └── widgets/                   # Reusable components
│       ├── search/                # Search functionality
│       └── ...                    # Form inputs, buttons, etc.
│
├── assets/                        # Static assets
│   ├── images/                    # Image files
│   ├── icons/                     # SVG icons
│   └── ...
│
├── android/                       # Android platform code
├── ios/                          # iOS platform code
├── web/                          # Web platform code
├── windows/                      # Windows platform code
├── linux/                        # Linux platform code
├── macos/                        # macOS platform code
│
├── test/                         # Test files
│
├── pubspec.yaml                  # Dependencies & assets
├── pubspec.lock                  # Locked dependencies
├── analysis_options.yaml         # Linter rules
└── README.md                     # Project readme
```

---

## 🎨 Adding New Features

### Example: Adding a New Screen

#### 1. Create Screen File
```dart
// lib/screens/my_feature/my_feature_page.dart
import 'package:flutter/material.dart';

class MyFeaturePage extends StatefulWidget {
  const MyFeaturePage({super.key});

  @override
  State<MyFeaturePage> createState() => _MyFeaturePageState();
}

class _MyFeaturePageState extends State<MyFeaturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Feature'),
      ),
      body: Center(
        child: Text('My Feature Content'),
      ),
    );
  }
}
```

#### 2. Add Navigation
```dart
// In any screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const MyFeaturePage(),
  ),
);
```

---

### Example: Adding a New Model

#### 1. Create Model File
```dart
// lib/models/task.dart
class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final bool isCompleted;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isCompleted = false,
  });

  // Copy with method for immutability
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
```

#### 2. Create Store (if needed)
```dart
// lib/data/task_store.dart
import 'package:flutter/foundation.dart';
import 'package:leads/models/task.dart';

class TaskStore {
  // Singleton pattern
  static final TaskStore _instance = TaskStore._internal();
  factory TaskStore() => _instance;
  TaskStore._internal();

  // Observable task list
  final ValueNotifier<List<Task>> tasks = ValueNotifier([]);

  // Add task
  void addTask(Task task) {
    tasks.value = [...tasks.value, task];
  }

  // Update task
  void updateTask(Task task) {
    final index = tasks.value.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      final updatedList = List<Task>.from(tasks.value);
      updatedList[index] = task;
      tasks.value = updatedList;
    }
  }

  // Delete task
  void deleteTask(String id) {
    tasks.value = tasks.value.where((t) => t.id != id).toList();
  }
}
```

#### 3. Use in UI
```dart
// In your widget
ValueListenableBuilder<List<Task>>(
  valueListenable: TaskStore().tasks,
  builder: (context, tasks, child) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
        );
      },
    );
  },
)
```

---

## 🔧 Common Development Tasks

### Add a New Dependency
```bash
# Edit pubspec.yaml, then run:
flutter pub get

# Or add directly via command:
flutter pub add package_name
```

### Update Dependencies
```bash
flutter pub upgrade
```

### Generate Assets
After adding images/icons to `assets/` folder:

1. Update `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/
    - assets/icons/
```

2. Run:
```bash
flutter pub get
```

### Clean Build
```bash
flutter clean
flutter pub get
flutter run
```

---

## 🐛 Debugging

### Enable Debug Mode
```bash
flutter run --debug
```

### View Logs
```bash
flutter logs
```

### Debug in VS Code
1. Set breakpoints in code
2. Press F5 or Run > Start Debugging
3. Use debug console

### Common Issues & Solutions

#### Issue: "Gradle build failed"
**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

#### Issue: "Pod install failed" (iOS)
**Solution**:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run
```

#### Issue: "Hot reload not working"
**Solution**:
- Stop app
- Run `flutter clean`
- Restart app

---

## 🧪 Testing

### Run Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Writing Tests

#### Unit Test Example
```dart
// test/models/lead_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:leads/models/lead.dart';

void main() {
  group('Lead Model Tests', () {
    test('Lead should be created with all properties', () {
      final lead = Lead(
        id: '1',
        title: 'Test Lead',
        contactName: 'John Doe',
        contactId: 'c1',
        details: 'Test details',
        dateTime: DateTime.now(),
        status: LeadStatus.pending,
      );

      expect(lead.id, '1');
      expect(lead.title, 'Test Lead');
      expect(lead.status, LeadStatus.pending);
    });

    test('copyWith should create new instance with updated values', () {
      final lead = Lead(
        id: '1',
        title: 'Original',
        contactName: 'John Doe',
        contactId: 'c1',
        details: 'Details',
        dateTime: DateTime.now(),
        status: LeadStatus.pending,
      );

      final updated = lead.copyWith(title: 'Updated');

      expect(updated.title, 'Updated');
      expect(updated.id, lead.id);
    });
  });
}
```

#### Widget Test Example
```dart
// test/widgets/lead_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leads/models/lead.dart';

void main() {
  testWidgets('LeadCard displays lead information', (tester) async {
    final lead = Lead(
      id: '1',
      title: 'Test Lead',
      contactName: 'John Doe',
      contactId: 'c1',
      details: 'Details',
      dateTime: DateTime.now(),
      status: LeadStatus.pending,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LeadCard(lead: lead),
        ),
      ),
    );

    expect(find.text('Test Lead'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);
  });
}
```

---

## 📦 Building for Production

### Android APK
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### iOS (macOS only)
```bash
flutter build ios --release
# Then open Xcode and archive
```

### Web
```bash
flutter build web --release
# Output: build/web/
```

### Windows
```bash
flutter build windows --release
# Output: build/windows/runner/Release/
```

---

## 🎯 Code Style & Best Practices

### Naming Conventions
- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `camelCase` or `SCREAMING_SNAKE_CASE`
- **Private members**: `_underscorePrefix`

### Example
```dart
// Good
class LeadDetailPage extends StatelessWidget {}
final String userName = 'John';
const int maxLeads = 100;
final _privateHelper = Helper();

// Bad
class lead_detail_page extends StatelessWidget {}
final String UserName = 'John';
```

### Widget Organization
```dart
class MyWidget extends StatefulWidget {
  // 1. Constructor
  const MyWidget({super.key});

  // 2. State creation
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  // 1. Variables
  int _counter = 0;

  // 2. Lifecycle methods
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 3. Custom methods
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // 4. Build method (last)
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

### Use Const Constructors
```dart
// Good - improves performance
const Text('Hello');
const SizedBox(height: 16);

// Avoid when possible
Text('Hello');
SizedBox(height: 16);
```

### Extract Widgets
```dart
// Instead of this:
Column(
  children: [
    Container(
      child: Text('Header'),
    ),
    // ... 100 lines of code
  ],
)

// Do this:
Column(
  children: [
    _HeaderWidget(),
    // ... rest
  ],
)

Widget _HeaderWidget() {
  return Container(
    child: const Text('Header'),
  );
}
```

---

## 🔐 Adding Database Persistence

### Option 1: Hive (Recommended for this app)

#### 1. Add Dependencies
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.6
```

#### 2. Initialize Hive
```dart
// lib/main.dart
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  await Hive.openBox<Lead>('leads');
  await Hive.openBox<Contact>('contacts');
  
  runApp(const MyApp());
}
```

#### 3. Update Lead Store
```dart
// lib/data/lead_store.dart
import 'package:hive/hive.dart';

class LeadStore {
  static final LeadStore _instance = LeadStore._internal();
  factory LeadStore() => _instance;
  LeadStore._internal();

  final ValueNotifier<List<Lead>> leads = ValueNotifier([]);
  late Box<Lead> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Lead>('leads');
    leads.value = _box.values.toList();
  }

  void addLead(Lead lead) {
    _box.put(lead.id, lead);
    leads.value = [...leads.value, lead];
  }

  void deleteLead(String id) {
    _box.delete(id);
    leads.value = leads.value.where((l) => l.id != id).toList();
  }
}
```

---

### Option 2: SQLite

#### 1. Add Dependencies
```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3
```

#### 2. Create Database Helper
```dart
// lib/data/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('leads.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leads(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        contactName TEXT NOT NULL,
        contactId TEXT NOT NULL,
        details TEXT,
        dateTime TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
  }
}
```

---

## 🚀 Performance Optimization Tips

### 1. Use const Constructors
```dart
const Text('Hello')  // Better
Text('Hello')        // Rebuilds unnecessarily
```

### 2. Avoid Rebuilding Entire Widget Tree
```dart
// Use ValueListenableBuilder for specific parts
ValueListenableBuilder<int>(
  valueListenable: counter,
  builder: (context, value, child) {
    return Text('');  // Only this rebuilds
  },
)
```

### 3. Use Keys for Lists
```dart
ListView.builder(
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(items[index].id),  // Important!
      title: Text(items[index].name),
    );
  },
)
```

### 4. Lazy Loading Images
```dart
Image.network(
  url,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return CircularProgressIndicator();
  },
)
```

---

## 📚 Useful Commands Reference

```bash
# Development
flutter run                          # Run app
flutter run -d chrome                # Run on web
flutter run --release                # Release mode
flutter hot-reload                   # Hot reload (r in terminal)
flutter hot-restart                  # Hot restart (R in terminal)

# Analysis
flutter analyze                      # Check for issues
flutter test                         # Run tests
flutter doctor                       # Check setup

# Build
flutter build apk                    # Android APK
flutter build appbundle              # Android Bundle
flutter build ios                    # iOS build
flutter build web                    # Web build

# Clean
flutter clean                        # Clean build files
flutter pub get                      # Get dependencies
flutter pub upgrade                  # Update dependencies

# Devices
flutter devices                      # List devices
flutter emulators                    # List emulators
flutter emulators --launch <id>      # Start emulator
```

---

## 🔗 Helpful Resources

### Official Documentation
- Flutter: https://flutter.dev/docs
- Dart: https://dart.dev/guides
- Material Design: https://material.io

### Package Documentation
- Syncfusion Calendar: https://help.syncfusion.com/flutter/calendar/overview
- Country Picker: https://pub.dev/packages/country_picker
- Flutter SVG: https://pub.dev/packages/flutter_svg

### Community
- Flutter Discord: https://discord.gg/flutter
- Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
- Reddit: https://reddit.com/r/FlutterDev

---

**Last Updated**: January 1, 2026
