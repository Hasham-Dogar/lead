# Architecture Diagram - Leads App

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         LEADS APP                                │
│                      Flutter Application                         │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Splash     │→ │    Login     │→ │ Choose Role  │          │
│  │   Screen     │  │    Screen    │  │    Screen    │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                              ↓                   │
│                    ┌─────────────────────────┴──────────┐       │
│                    ↓                                     ↓       │
│         ┌──────────────────┐                ┌──────────────────┐│
│         │   Regular User   │                │  Team Manager    ││
│         │    Home Page     │                │    Home Page     ││
│         └──────────────────┘                └──────────────────┘│
│                    ↓                                     ↓       │
│    ┌───────────────┼─────────────────┐     ┌───────────┼──────┐│
│    ↓               ↓                 ↓     ↓           ↓      ↓│
│ ┌──────┐    ┌──────────┐    ┌──────────┐ ┌─────┐ ┌────────┐  ││
│ │Leads │    │Contacts  │    │Calendar  │ │Team │ │Transfer│  ││
│ │Pages │    │Pages     │    │Widget    │ │Page │ │Leads   │  ││
│ └──────┘    └──────────┘    └──────────┘ └─────┘ └────────┘  ││
│     ↓             ↓                                             │
│ ┌─────────┐  ┌─────────┐                                       │
│ │ Create  │  │ Create  │                                       │
│ │ Lead    │  │ Contact │                                       │
│ └─────────┘  └─────────┘                                       │
│                                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │Notifications │  │   Settings   │  │    Search    │          │
│  │    Page      │  │    Pages     │  │   Delegate   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                    STATE MANAGEMENT LAYER                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────┐      ┌────────────────────────┐    │
│  │      LeadStore         │      │   NotificationStore    │    │
│  │    (Singleton)         │      │     (Singleton)        │    │
│  ├────────────────────────┤      ├────────────────────────┤    │
│  │ ValueNotifier<         │      │ ValueNotifier<         │    │
│  │   List<Lead>>          │      │   List<Notification>>  │    │
│  ├────────────────────────┤      ├────────────────────────┤    │
│  │ • addLead()            │      │ • addNotification()    │    │
│  │ • upsertLead()         │      │ • markAsRead()         │    │
│  │ • replaceAll()         │      │ • markAllAsRead()      │    │
│  │                        │      │ • deleteNotification() │    │
│  │                        │      │ • notifyNewLead()      │    │
│  │                        │      │ • notifyLeadCompleted()│    │
│  └────────────────────────┘      └────────────────────────┘    │
│              ↑                              ↑                   │
│              └──────────────┬───────────────┘                   │
│                             ↓                                   │
│                    ┌─────────────────┐                          │
│                    │  UI Components  │                          │
│                    │ (Listening via  │                          │
│                    │ ValueNotifier)  │                          │
│                    └─────────────────┘                          │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                        DATA MODEL LAYER                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────┐  │
│  │      Lead        │  │     Contact      │  │ Notification │  │
│  ├──────────────────┤  ├──────────────────┤  ├──────────────┤  │
│  │ • id             │  │ • id             │  │ • id         │  │
│  │ • title          │  │ • firstName      │  │ • title      │  │
│  │ • contactName    │  │ • lastName       │  │ • message    │  │
│  │ • contactId      │  │ • phoneNumber    │  │ • type       │  │
│  │ • details        │  │ • phoneCode      │  │ • timestamp  │  │
│  │ • dateTime       │  │ • email          │  │ • isRead     │  │
│  │ • status         │  │ • note           │  │ • leadId     │  │
│  └──────────────────┘  └──────────────────┘  │ • contactId  │  │
│          ↓                      ↓             └──────────────┘  │
│  ┌──────────────────┐  ┌──────────────────┐         ↓          │
│  │   LeadStatus     │  │ fullName (get)   │  ┌──────────────┐  │
│  │   (enum)         │  │ formattedPhone   │  │Notification  │  │
│  ├──────────────────┤  │ (get)            │  │Type (enum)   │  │
│  │ • pending        │  └──────────────────┘  ├──────────────┤  │
│  │ • rescheduled    │                        │ • newLead    │  │
│  │ • completed      │                        │ • rescheduled│  │
│  └──────────────────┘                        │ • completed  │  │
│                                               │ • assigned   │  │
│                                               └──────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      STORAGE LAYER                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│              ┌──────────────────────────────┐                   │
│              │      IN-MEMORY STORAGE       │                   │
│              │    (No Persistence Yet)      │                   │
│              │                              │                   │
│              │  Data stored in:             │                   │
│              │  • ValueNotifier lists       │                   │
│              │  • Widget state variables    │                   │
│              │  • Hardcoded test data       │                   │
│              │                              │                   │
│              │  ⚠️  Lost on app restart     │                   │
│              └──────────────────────────────┘                   │
│                                                                  │
│              ┌──────────────────────────────┐                   │
│              │   FUTURE: Database Layer     │                   │
│              │                              │                   │
│              │  Options:                    │                   │
│              │  • SQLite (local)            │                   │
│              │  • Hive (NoSQL local)        │                   │
│              │  • SharedPreferences         │                   │
│              │  • Firebase/Backend API      │                   │
│              └──────────────────────────────┘                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📊 Data Flow Diagram

### User Creates a Lead

```
┌──────────────┐
│    User      │
└──────┬───────┘
       │ 1. Taps "Create Lead"
       ↓
┌────────────────────┐
│ CreateLeadsPage    │
└────────┬───────────┘
         │ 2. Fills form
         │    - Select contact
         │    - Enter title
         │    - Add details
         │    - Set date/time
         │    - Choose status
         ↓
┌────────────────────┐
│  Submit Button     │
└────────┬───────────┘
         │ 3. Creates Lead object
         ↓
┌────────────────────┐      4. Adds lead
│    LeadStore       │◄─────────────────
└────────┬───────────┘
         │ 5. Notifies listeners
         ↓
┌────────────────────┐      6. Triggers notification
│ NotificationStore  │◄─────────────────
└────────┬───────────┘
         │ 7. Creates AppNotification
         ↓
┌────────────────────┐
│  UI Auto-Updates   │
│  (ValueNotifier)   │
└────────┬───────────┘
         │ 8. Shows updated:
         │    - Lead list
         │    - Calendar
         │    - Notification badge
         ↓
┌────────────────────┐
│  User sees changes │
└────────────────────┘
```

---

## 🔄 Navigation Flow

```
                    App Launch
                        ↓
                ┌───────────────┐
                │ Splash Screen │
                └───────┬───────┘
                        ↓
                ┌───────────────┐
                │  Login Page   │
                └───────┬───────┘
                        │
          ┌─────────────┴─────────────┐
          │                           │
     New User?                   Has Account?
          │                           │
          ↓                           ↓
    ┌──────────┐              ┌──────────────┐
    │  Signup  │              │ Authenticate │
    └────┬─────┘              └──────┬───────┘
         │                           │
         └────────────┬──────────────┘
                      ↓
              ┌──────────────┐
              │ Choose Role  │
              └──────┬───────┘
                     │
        ┌────────────┴────────────┐
        ↓                         ↓
┌─────────────────┐      ┌─────────────────┐
│  Regular User   │      │  Team Manager   │
│   Home Page     │      │   Home Page     │
└────────┬────────┘      └────────┬────────┘
         │                        │
    ┌────┴────┐             ┌─────┴─────┐
    ↓         ↓             ↓           ↓
 Leads    Contacts       Team      Transfer
 Pages    Pages          Page       Leads
    │         │             │           │
    └────┬────┘             └─────┬─────┘
         ↓                        ↓
    Settings                 Settings
    (Common)                 (Common)
```

---

## 🎯 Feature Module Structure

```
┌─────────────────────────────────────────────────┐
│              AUTHENTICATION MODULE               │
├─────────────────────────────────────────────────┤
│  • Login (Email/Password)                       │
│  • Signup (Full Name, Email, Phone, Password)  │
│  • Forgot Password                              │
│  • Choose Role (User/Manager)                   │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│                 LEADS MODULE                     │
├─────────────────────────────────────────────────┤
│  • Create Lead                                  │
│  • View Lead List                               │
│  • View Lead Details                            │
│  • Edit Lead                                    │
│  • Update Lead Status                           │
│  • Calendar View                                │
│  • Search Leads                                 │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│               CONTACTS MODULE                    │
├─────────────────────────────────────────────────┤
│  • Create Contact                               │
│  • View Contact List                            │
│  • View Contact Details                         │
│  • Edit Contact                                 │
│  • Search Contacts                              │
│  • Country Code Picker                          │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│            NOTIFICATIONS MODULE                  │
├─────────────────────────────────────────────────┤
│  • View Notifications                           │
│  • Mark as Read (Single/All)                    │
│  • Delete Notification                          │
│  • Notification Badge                           │
│  • Type-based Icons & Colors                    │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│            TEAM MANAGEMENT MODULE                │
│            (Manager Role Only)                   │
├─────────────────────────────────────────────────┤
│  • Add Team Members                             │
│  • View Team List                               │
│  • Transfer Leads                               │
│  • View Statistics                              │
│    - Total Leads                                │
│    - Completed Leads                            │
│    - Pending Leads                              │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│               SETTINGS MODULE                    │
├─────────────────────────────────────────────────┤
│  • View Profile                                 │
│  • Edit Profile                                 │
│  • Change Password                              │
│  • Privacy Settings                             │
│  • Terms & Conditions                           │
│  • Logout                                       │
└─────────────────────────────────────────────────┘
```

---

## 🔐 Role-Based Access Control

```
┌──────────────────────────────────────────────────┐
│                  USER ROLES                       │
└──────────────────────────────────────────────────┘

┌─────────────────────┐        ┌─────────────────────┐
│   Regular User      │        │   Team Manager      │
├─────────────────────┤        ├─────────────────────┤
│ ✅ Create Leads     │        │ ✅ All User Rights  │
│ ✅ View Leads       │        │ ✅ Add Team Members │
│ ✅ Edit Leads       │        │ ✅ Transfer Leads   │
│ ✅ Delete Leads     │        │ ✅ View Statistics  │
│ ✅ Create Contacts  │        │ ✅ Manage Team      │
│ ✅ View Contacts    │        │                     │
│ ✅ Edit Contacts    │        │                     │
│ ✅ Calendar View    │        │                     │
│ ✅ Notifications    │        │                     │
│ ✅ Search           │        │                     │
│ ✅ Settings         │        │                     │
│                     │        │                     │
│ ❌ Team Management  │        │                     │
│ ❌ Transfer Leads   │        │                     │
│ ❌ Statistics       │        │                     │
└─────────────────────┘        └─────────────────────┘
```

---

## 🎨 Widget Hierarchy

### Home Page Structure

```
HomePage (StatefulWidget)
├── Scaffold
    ├── AppBar
    │   ├── HomeHeader (Custom)
    │   │   ├── Title
    │   │   ├── Search Icon
    │   │   └── Notification Icon (with badge)
    ├── Body
    │   ├── Column
    │       ├── AnimatedContainer (Calendar)
    │       │   └── CalendarWidget (Syncfusion)
    │       │       └── MonthView with Lead Appointments
    │       ├── Expanded
    │           └── ListView (Recent Leads)
    │               └── LeadCard (for each lead)
    │                   ├── Lead Title
    │                   ├── Contact Name
    │                   ├── DateTime
    │                   └── Status Badge
    └── BottomNavigationBar (Custom)
        ├── Home
        ├── Contacts
        ├── Add Lead (Floating)
        └── Settings
```

### Team Manager Home Structure

```
TeamManagerHomePage (StatefulWidget)
├── Scaffold
    ├── AppBar
    │   ├── Title
    │   └── Notification Icon
    ├── Body
    │   └── IndexedStack (based on nav selection)
    │       ├── [0] Dashboard
    │       │   ├── Statistics Row
    │       │   │   ├── StatsCard (Total Leads)
    │       │   │   ├── StatsCard (Completed)
    │       │   │   └── StatsCard (Pending)
    │       │   ├── Quick Actions
    │       │   │   ├── Add Team Member Button
    │       │   │   └── Transfer Leads Button
    │       │   └── Recent Leads List
    │       ├── [1] Team Page
    │       │   └── Team Member List
    │       ├── [2] Leads List Page
    │       └── [3] Settings
    └── BottomNavigationBar
```

---

## 📦 Dependency Graph

```
┌──────────────────────────────────────────────────┐
│              External Dependencies                │
└──────────────────────────────────────────────────┘

flutter (SDK)
├── Material Design Widgets
├── Cupertino Widgets (iOS style)
└── Platform Channels

flutter_svg (^2.0.10+1)
└── SVG image rendering

font_awesome_flutter (^10.7.0)
└── Icon library

country_picker (^2.0.26)
└── Country selection & phone codes

syncfusion_flutter_calendar (^27.2.5)
└── Calendar widget with appointments

url_launcher (^6.3.1)
└── Open external URLs/apps

cupertino_icons (^1.0.8)
└── iOS-style icons
```

---

## 🔄 State Update Flow

```
User Action
    ↓
Event Handler (Button tap, form submit, etc.)
    ↓
Create/Update Model Object (Lead, Contact, Notification)
    ↓
Call Store Method (addLead, upsertLead, etc.)
    ↓
Store Updates Internal ValueNotifier
    ↓
ValueNotifier.notifyListeners() triggered
    ↓
All listening widgets rebuild
    ↓
UI reflects new state
```

---

**Last Updated**: January 1, 2026
