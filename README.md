# NIT Venue Location

## Project Overview

This project aims to develop a comprehensive mobile application for the National Institute of Transport (NIT) to automate student timetable management and provide location-based guidance to lecture venues. The system addresses the challenges of navigating a large campus, managing dynamic schedules, and ensuring timely access to accurate information.

## Features

- **Timetable Management**: Centralized database for storing and retrieving student schedules, including course details, timings, and venue assignments.
- **Venue Location Display**: Interactive map showing all lecture venues on the NIT campus.
- **Location-Based Navigation**: Provides real-time, step-by-step directions from the user's current location directly to the assigned lecture venue, ensuring an efficient path without requiring users to navigate the entire campus or ask for directions.
- **Real-Time Notifications**: Push notifications for schedule changes, venue updates, and reminders for upcoming classes.
- **Offline Support**: Access to timetables and venue information without internet connectivity.
- **User Roles**: Support for students, lecturers, administrators, and class representatives with role-based access.
- **Search and Filter**: Advanced search for timetables by course, lecturer, or time.
- **Venue Booking (Future)**: Optional feature for booking venues (inspired by literature review).

## Tech Stack

### Mobile Application
- **Framework**: Flutter (Dart) for cross-platform development (iOS and Android).
- **State Management**: Provider or Riverpod for managing app state.
- **Maps Integration**: Google Maps SDK for location services and navigation.
- **Local Storage**: SQLite for offline data persistence.
- **Notifications**: Firebase Cloud Messaging (FCM) for push notifications.

### Backend
- **Framework**: Node.js with Express.js for RESTful API development.
- **Authentication**: JWT (JSON Web Tokens) for secure user authentication.
- **Database**: PostgreSQL for online data storage, with synchronization to mobile SQLite.
- **Real-Time Features**: Socket.io for real-time updates (optional for notifications).

### Additional Tools
- **Version Control**: Git
- **CI/CD**: GitHub Actions for automated testing and deployment.
- **Testing**: Flutter Test for unit tests, Integration tests for UI, and Postman for API testing.
- **Documentation**: Swagger for API documentation.

## Architecture

The system follows a client-server architecture with offline capabilities.

```mermaid
graph TD
    A[Mobile App (Flutter)] --> B[Backend API (Node.js)]
    A --> C[Local SQLite DB]
    B --> D[PostgreSQL DB]
    A --> E[Google Maps API]
    A --> F[Firebase Cloud Messaging]
    B --> F
```

### Component Descriptions
- **Mobile App**: Handles UI, user interactions, offline data, and integrates with maps and notifications.
- **Backend API**: Manages data synchronization, authentication, and business logic.
- **Database**: PostgreSQL for centralized data; SQLite for local caching on device.
- **External Services**: Google Maps for navigation, Firebase for notifications.

## Dynamic Campus Map Data

The campus map data is designed to be **dynamic and data-driven** so that adding new buildings or paths does not require an app update.

### 1) Store locations in the database
- Keep all buildings/venues in the `VENUES` table (or a dedicated `BUILDINGS` table).
- Each row includes `name`, `description`, `latitude`, `longitude`, and any other metadata.
- When a new building is added, the admin inserts a new record and the app automatically shows it on the map.

### 2) Load markers dynamically (Database → API → App → Map)
- The mobile app loads venue data from the backend API (`GET /api/venues`).
- The app displays each venue as a map marker in Mapbox (or Google Maps).
- No hard-coded buildings in the app; new venues appear instantly after the database is updated.

### 3) Admin panel for managing campus data
- Build an admin interface to:
  - Add / edit / delete buildings
  - Update coordinates
  - Maintain walk paths between locations
- This makes the system future-proof: new buildings and paths only require database updates.

### 4) Support for campus routing and paths
- Store walkable paths as edges in a graph (e.g., a `PATHS` table linking buildings).
- Update the graph whenever new buildings or walkways are added.
- A routing algorithm (Dijkstra/A*) can compute the best route between buildings.

### 5) Use GeoJSON for exporting or importing map data (Mapbox-friendly)
- Optionally export/build GeoJSON for buildings and paths:

```json
{
  "type": "Feature",
  "properties": { "name": "Block 15" },
  "geometry": {
    "type": "Point",
    "coordinates": [39.2034, -6.8799]
  }
}
```

- Mapbox can load GeoJSON layers, making it easy to display custom campus data and keep it updated.

### System Flow (Recommended)
Admin Panel → Database (Buildings + Paths) → Backend API → Mobile App → Mapbox Map

This design supports future expansion: adding new buildings or paths does not require rebuilding the app.

## Database Schema

### PostgreSQL Schema

```mermaid
erDiagram
    USERS ||--o{ TIMETABLES : has
    USERS ||--o{ VENUES : manages
    TIMETABLES ||--o{ COURSES : includes
    VENUES ||--o{ TIMETABLES : assigned_to
    COURSES ||--o{ LECTURERS : taught_by

    USERS {
        int id PK
        string name
        string email
        string role
        string password_hash
    }

    TIMETABLES {
        int id PK
        int user_id FK
        int course_id FK
        int venue_id FK
        datetime start_time
        datetime end_time
        date date
    }

    VENUES {
        int id PK
        string name
        string location
        float latitude
        float longitude
        string description
    }

    COURSES {
        int id PK
        string name
        string code
        int lecturer_id FK
    }

    LECTURERS {
        int id PK
        string name
        string department
    }
```

### SQLite Schema (Mobile)
Mirrors the PostgreSQL schema for offline access, with additional sync flags.

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration (admin only)
- `POST /api/auth/logout` - User logout

### Timetables
- `GET /api/timetables` - Get user's timetable
- `POST /api/timetables` - Create/update timetable entry (admin/lecturer)
- `PUT /api/timetables/:id` - Update specific timetable entry
- `DELETE /api/timetables/:id` - Delete timetable entry

### Venues
- `GET /api/venues` - Get all venues
- `POST /api/venues` - Add new venue (admin)
- `PUT /api/venues/:id` - Update venue details
- `GET /api/venues/:id/directions` - Get directions to venue

### Notifications
- `POST /api/notifications/send` - Send notification (admin)

## Installation and Setup

### Prerequisites
- Flutter SDK (version 3.0+)
- Node.js (version 16+)
- PostgreSQL (version 13+)
- Google Maps API Key
- Firebase Project Setup

### Backend Setup
1. Clone the repository: `git clone <repo-url>`
2. Navigate to backend directory: `cd backend`
3. Install dependencies: `npm install`
4. Set up environment variables (create `.env` file):
   ```
   DATABASE_URL=postgresql://user:password@localhost:5432/nit_timetable
   JWT_SECRET=your-secret-key
   GOOGLE_MAPS_API_KEY=your-api-key
   FIREBASE_SERVER_KEY=your-firebase-key
   ```
5. Run database migrations: `npm run migrate`
6. Start the server: `npm start`

### Mobile App Setup
1. Navigate to mobile directory: `cd mobile`
2. Install dependencies: `flutter pub get`
3. Configure API endpoints in `lib/config.dart`
4. Add Google Maps API key to `android/app/src/main/AndroidManifest.xml` and `ios/Runner/AppDelegate.swift`
5. Set up Firebase: Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
6. Run the app: `flutter run`

### Database Setup
- Create PostgreSQL database: `createdb nit_timetable`
- Run initial seed data if available.

## Usage

### For Students
1. Login with student credentials.
2. View personal timetable on the dashboard.
3. Tap on a class to view venue details and get directions.
4. Receive notifications for schedule changes.

### For Lecturers
1. Login and view assigned courses.
2. Update timetable if changes occur.
3. Access venue information.

### For Administrators
1. Manage users, venues, and timetables.
2. Send bulk notifications.
3. Monitor system usage.

## Testing

### Unit Tests
- Run Flutter tests: `flutter test`
- Run backend tests: `npm test`

### Integration Tests
- Use Flutter integration tests for UI flows.
- Test API endpoints with Postman collections.

### Manual Testing
- Test offline functionality by disabling internet.
- Verify navigation accuracy on campus.
- Check notification delivery.

## Deployment

### Mobile App
- Build for Android: `flutter build apk`
- Build for iOS: `flutter build ios`
- Distribute via Google Play Store and Apple App Store.

### Backend
- Deploy to cloud platforms like Heroku, AWS, or DigitalOcean.
- Use Docker for containerization.

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -m 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Create a Pull Request.

### Code Style
- Follow Flutter/Dart style guide.
- Use ESLint for JavaScript/Node.js.
- Write descriptive commit messages.

## Future Enhancements

- Implement AI-based schedule optimization.
- Add AR navigation for indoor venues.
- Integrate with NIT's existing systems (e.g., student portal).
- Expand to web version using Flutter Web.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## References

- Arinaitwe, M. (2011). Automated management systems. Kampala International University.
- Vijayalakshmi, B., Arthi, D., Pragna, B., Deekshitha, D. S., & Pooja Sree, B. V. S. (2024). Campus Venue and Equipment Booking System. International Journal of Research in Engineering, IT and Social Sciences, 14(06), 97–104.