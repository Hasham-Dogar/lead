# API Reference - Leads App

## 📚 Complete API Documentation

This document provides detailed API reference for all models, stores, and key methods in the Leads application.

---

## 🎯 Models

### Lead Class

**Location**: `lib/models/lead.dart`

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
```

#### Properties
| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique identifier for the lead |
| `title` | String | Lead title/name |
| `contactName` | String | Associated contact's full name |
| `contactId` | String | Reference to Contact model |
| `details` | String | Lead description/notes |
| `dateTime` | DateTime | Scheduled date and time |
| `status` | LeadStatus | Current status (enum) |

#### Constructors
```dart
const Lead({
  required this.id,
  required this.title,
  required this.contactName,
  required this.contactId,
  required this.details,
  required this.dateTime,
  required this.status,
})
```

#### Methods
```dart
Lead copyWith({
  String? id,
  String? title,
  String? contactName,
  String? contactId,
  String? details,
  DateTime? dateTime,
  LeadStatus? status,
}) // Returns new Lead instance with updated fields
```

---

### LeadStatus Enum

```dart
enum LeadStatus {
  pending,      // New, not yet actioned
  rescheduled,  // Postponed to another time
  completed     // Finished/closed
}
```

#### Extension Methods
```dart
extension LeadStatusExtension on LeadStatus {
  String get displayName // Returns user-friendly name
  Color get color        // Returns status color
}
```

**Color Mapping**:
- `pending` → Orange
- `rescheduled` → Blue
- `completed` → Green

---

### Contact Class

**Location**: `lib/models/contact.dart`

```dart
class Contact {
  final String id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String phoneCode;
  final String email;
  final String note;
}
```

#### Properties
| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique identifier |
| `firstName` | String | Contact's first name |
| `lastName` | String | Contact's last name |
| `phoneNumber` | String | Phone number (without country code) |
| `phoneCode` | String | Country dialing code |
| `email` | String | Email address |
| `note` | String | Additional notes/details |

#### Computed Properties
```dart
String get fullName => ' '
String get formattedPhone => '+ '
```

#### Constructors
```dart
const Contact({
  required this.id,
  required this.firstName,
  required this.lastName,
  required this.phoneNumber,
  required this.phoneCode,
  required this.email,
  required this.note,
})
```

#### Methods
```dart
Contact copyWith({
  String? id,
  String? firstName,
  String? lastName,
  String? phoneNumber,
  String? phoneCode,
  String? email,
  String? note,
}) // Returns new Contact instance with updated fields
```

---

### AppNotification Class

**Location**: `lib/models/notification.dart`

```dart
class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? leadId;
  final String? contactId;
}
```

#### Properties
| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique identifier |
| `title` | String | Notification title |
| `message` | String | Notification content |
| `type` | NotificationType | Type enum |
| `timestamp` | DateTime | When created |
| `isRead` | bool | Read status |
| `leadId` | String? | Optional lead reference |
| `contactId` | String? | Optional contact reference |

#### Constructors
```dart
const AppNotification({
  required this.id,
  required this.title,
  required this.message,
  required this.type,
  required this.timestamp,
  this.isRead = false,
  this.leadId,
  this.contactId,
})
```

#### Methods
```dart
AppNotification copyWith({
  String? id,
  String? title,
  String? message,
  NotificationType? type,
  DateTime? timestamp,
  bool? isRead,
  String? leadId,
  String? contactId,
}) // Returns new AppNotification with updated fields
```

---

### NotificationType Enum

```dart
enum NotificationType {
  newLead,          // New lead created
  leadRescheduled,  // Lead rescheduled
  leadCompleted,    // Lead completed
  leadAssigned      // Lead assigned to team member
}
```

#### Extension Methods
```dart
extension NotificationTypeExtension on NotificationType {
  Color get color      // Returns type-specific color
  IconData get icon    // Returns type-specific icon
}
```

**Color/Icon Mapping**:
| Type | Color | Icon |
|------|-------|------|
| `newLead` | Red | Add Circle |
| `leadRescheduled` | Orange | Schedule |
| `leadCompleted` | Green | Check Circle |
| `leadAssigned` | Blue | Person Add |

---

## 🗄️ Data Stores

### LeadStore (Singleton)

**Location**: `lib/data/lead_store.dart`

```dart
class LeadStore {
  static final LeadStore _instance = LeadStore._internal();
  factory LeadStore() => _instance;
  
  final ValueNotifier<List<Lead>> leads = ValueNotifier([]);
}
```

#### Properties
| Property | Type | Description |
|----------|------|-------------|
| `leads` | ValueNotifier<List<Lead>> | Observable lead list |

#### Methods

##### addLead
```dart
void addLead(Lead lead)
```
**Purpose**: Add a new lead to the store  
**Parameters**:
- `lead`: Lead instance to add  
**Returns**: void  
**Side Effects**: Notifies all listeners

##### upsertLead
```dart
void upsertLead(Lead lead)
```
**Purpose**: Add or update a lead (based on ID)  
**Parameters**:
- `lead`: Lead instance to add/update  
**Returns**: void  
**Behavior**: 
- If lead with same ID exists, updates it
- Otherwise, adds new lead
**Side Effects**: Notifies all listeners

##### replaceAll
```dart
void replaceAll(List<Lead> newLeads)
```
**Purpose**: Replace entire lead list  
**Parameters**:
- `newLeads`: New list of leads  
**Returns**: void  
**Side Effects**: Notifies all listeners

#### Usage Example
```dart
// Get instance
final leadStore = LeadStore();

// Add lead
leadStore.addLead(newLead);

// Listen to changes
leadStore.leads.addListener(() {
  print('Leads updated: ');
});

// Access leads
List<Lead> allLeads = leadStore.leads.value;
```

---

### NotificationStore (Singleton)

**Location**: `lib/data/notification_store.dart`

```dart
class NotificationStore {
  static final NotificationStore _instance = NotificationStore._internal();
  factory NotificationStore() => _instance;
  
  final ValueNotifier<List<AppNotification>> notifications = ValueNotifier([]);
}
```

#### Properties
| Property | Type | Description |
|----------|------|-------------|
| `notifications` | ValueNotifier<List<AppNotification>> | Observable notification list |

#### Methods

##### addNotification
```dart
void addNotification(AppNotification notification)
```
**Purpose**: Add a notification  
**Parameters**:
- `notification`: AppNotification instance  
**Returns**: void

##### markAsRead
```dart
void markAsRead(String id)
```
**Purpose**: Mark single notification as read  
**Parameters**:
- `id`: Notification ID  
**Returns**: void

##### markAllAsRead
```dart
void markAllAsRead()
```
**Purpose**: Mark all notifications as read  
**Returns**: void

##### deleteNotification
```dart
void deleteNotification(String id)
```
**Purpose**: Remove a notification  
**Parameters**:
- `id`: Notification ID  
**Returns**: void

##### Helper Methods

```dart
void notifyNewLead(Lead lead)
void notifyLeadRescheduled(Lead lead)
void notifyLeadCompleted(Lead lead)
void notifyLeadAssigned(Lead lead, String memberName)
```

**Purpose**: Create type-specific notifications  
**Parameters**: Lead instance and optional additional data  
**Returns**: void  
**Behavior**: Creates and adds notification with appropriate type

#### Computed Properties
```dart
int get unreadCount // Returns count of unread notifications
List<AppNotification> get unreadNotifications // Returns only unread
```

#### Usage Example
```dart
// Get instance
final notificationStore = NotificationStore();

// Add notification
notificationStore.notifyNewLead(lead);

// Mark as read
notificationStore.markAsRead('notification-id');

// Get unread count
int count = notificationStore.unreadCount;

// Listen to changes
notificationStore.notifications.addListener(() {
  print('Notifications: ');
});
```

---

## 🎨 UI Components

### GlobalSearchDelegate

**Location**: `lib/widgets/search/global_search_delegate.dart`

```dart
class GlobalSearchDelegate extends SearchDelegate<void>
```

#### Constructor
```dart
GlobalSearchDelegate({
  required this.contacts,
  required this.leads,
  required this.onContactTap,
  required this.onLeadTap,
})
```

#### Properties
| Property | Type | Description |
|----------|------|-------------|
| `contacts` | List<Contact> | Searchable contacts |
| `leads` | List<Lead> | Searchable leads |
| `onContactTap` | Function(Contact) | Contact tap callback |
| `onLeadTap` | Function(Lead) | Lead tap callback |

#### Search Behavior
- Searches across contact names, emails, phone numbers
- Searches across lead titles, contact names, details
- Case-insensitive matching
- Real-time results as user types

---

## 🔧 Utility Functions

### ID Generation
```dart
String generateId() {
  return DateTime.now().millisecondsSinceEpoch.toString();
}
```
**Usage**: Generate unique IDs for models

---

## 📱 Screen Navigation

### Navigation Routes

```dart
// Login
Navigator.pushReplacementNamed(context, '/login');

// Choose Role
Navigator.pushNamed(context, '/choose-role');

// Home (Regular User)
Navigator.pushReplacementNamed(context, '/home');

// Team Manager Home
Navigator.pushReplacementNamed(context, '/team-manager-home');

// Create Lead
Navigator.push(context, MaterialPageRoute(
  builder: (context) => CreateLeadsPage(contacts: contacts),
));

// Lead Detail
Navigator.push(context, MaterialPageRoute(
  builder: (context) => LeadDetailPage(lead: lead),
));

// Contact Detail
Navigator.push(context, MaterialPageRoute(
  builder: (context) => ContactDetailPage(contact: contact),
));
```

---

## 🎯 State Management Patterns

### Listening to Store Changes

```dart
// In StatefulWidget
@override
void initState() {
  super.initState();
  LeadStore().leads.addListener(_onLeadsChanged);
}

@override
void dispose() {
  LeadStore().leads.removeListener(_onLeadsChanged);
  super.dispose();
}

void _onLeadsChanged() {
  setState(() {
    // Update UI
  });
}
```

### ValueListenableBuilder Pattern

```dart
ValueListenableBuilder<List<Lead>>(
  valueListenable: LeadStore().leads,
  builder: (context, leads, child) {
    return ListView.builder(
      itemCount: leads.length,
      itemBuilder: (context, index) {
        return LeadCard(lead: leads[index]);
      },
    );
  },
)
```

---

## 🔐 Constants & Configuration

### Status Colors
```dart
const Map<LeadStatus, Color> statusColors = {
  LeadStatus.pending: Color(0xFFFFA500),      // Orange
  LeadStatus.rescheduled: Color(0xFF2196F3),  // Blue
  LeadStatus.completed: Color(0xFF4CAF50),    // Green
};
```

### Notification Colors
```dart
const Map<NotificationType, Color> notificationColors = {
  NotificationType.newLead: Color(0xFFF44336),         // Red
  NotificationType.leadRescheduled: Color(0xFFFF9800), // Orange
  NotificationType.leadCompleted: Color(0xFF4CAF50),   // Green
  NotificationType.leadAssigned: Color(0xFF2196F3),    // Blue
};
```

---

**Last Updated**: January 1, 2026
