# NIT Venue Location

A comprehensive campus navigation and timetable management system for the National Institute of Transport (NIT).

## Project Overview

This project develops a mobile application that serves as a comprehensive campus navigation system for the National Institute of Transport (NIT). The core functionality allows users to navigate to any campus location they don't know, with timetables providing additional reminders and one-click access to scheduled venues.

### Problem Statement
Students and staff at large campuses like NIT face challenges:
- Finding unfamiliar locations across campus
- Navigating between buildings efficiently
- Missing scheduled classes due to poor navigation
- Managing time-sensitive academic schedules

This application solves these issues with an interactive campus map for general navigation, plus integrated timetable reminders for academic scheduling.

## Features

### Core Navigation (Always Available)
- **Campus Map Navigation**: Interactive Mapbox map showing all campus venues and buildings
- **Location Search & Discovery**: Find any venue by name, type, or category (lecture halls, offices, labs, shops, cafes, libraries, etc.)
- **Real-Time Directions**: Step-by-step navigation from current location to any selected venue
- **Offline Venue Data**: Access to venue information and basic maps without internet

### Timetable Integration (When Available)
- **Schedule Reminders**: Push notifications as class times approach
- **One-Click Navigation**: Tap timetable entry to instantly navigate to the venue
- **Timetable Management**: View and sync academic schedules with venue locations
- **Role-Based Access**: Support for students, lecturers, and administrators

#### Phase 2 (Future)
- **Advanced Search**: Filter venues by type, building, or amenities
- **Admin Panel**: Interface for managing venues, users, and timetables
- **Campus Routing**: Optimal pathfinding between multiple locations
- **Real-Time Notifications**: Schedule changes and venue updates

## Tech Stack

### Frontend (Mobile)
- **Framework**: [Flutter](https://flutter.dev) (Dart) for cross-platform development (iOS & Android)
- **State Management**: [Riverpod](https://riverpod.dev) for predictable and testable state management
- **Maps**: [Mapbox SDK](https://www.mapbox.com) for location services and campus navigation
- **Local Storage**: SQLite for offline data persistence and sync flags
- **Notifications**: [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) (FCM) for push notifications

### Backend
- **Framework**: [Django](https://www.djangoproject.com) (Python) with [Django REST Framework](https://www.django-rest-framework.org)
- **Authentication**: JWT (JSON Web Tokens) or Django's built-in authentication
- **Database**: [PostgreSQL](https://www.postgresql.org) (v13+) for persistent data storage
- **Real-Time** (Optional): [Django Channels](https://channels.readthedocs.io) for future real-time features

### DevOps & Tooling
- **Version Control**: Git / GitHub
- **CI/CD**: GitHub Actions for automated testing and deployment
- **Testing**: 
  - Flutter Test for unit & widget tests
  - Django Test Framework for backend unit & integration tests
  - Postman for API integration testing
- **API Documentation**: Swagger/OpenAPI
- **Container**: Docker for consistent development environments

## Repository Structure

```
ramani/
├── README.md                    # Project documentation
├── .gitignore                   # Git ignore rules
├── .env                         # Environment variables (database, secrets)
├── LICENSE                      # MIT License
│
├── docs/                        # Project documentation
│   ├── API.md                  # REST API specification
│   ├── DATABASE.md             # Database schema & queries
│   └── ARCHITECTURE.md         # Design decisions & patterns
│
├── backend/                     # Django REST API
│   ├── ramani/                 # Django project settings
│   │   ├── __init__.py
│   │   ├── asgi.py
│   │   ├── settings.py         # Django settings and configuration
│   │   ├── urls.py             # Main URL configuration
│   │   └── wsgi.py
│   ├── apps/                   # Django apps
│   │   ├── users/              # User management & authentication
│   │   ├── departments/        # Department management
│   │   ├── venues/             # Venue/location management
│   │   ├── courses/            # Course management
│   │   ├── timetables/         # Timetable management
│   │   ├── notifications/      # Notification system
│   │   ├── devices/            # Device management
│   │   └── sync_logs/          # Synchronization logs
│   ├── sample/                 # Sample data scripts
│   │   └── populate_data.py    # Database seeding script
│   ├── manage.py               # Django management script
│   ├── requirements.txt        # Python dependencies
│   └── README.md               # Backend-specific setup
│
├── mobile/                      # Flutter mobile application (planned)
│   └── README.md               # Mobile-specific setup (planned)
│
└── vee/                        # Python virtual environment
    └── ...                     # Virtual environment files
```
│   ├── Dockerfile              # Container image
│   └── README.md               # Backend-specific setup
│
├── mobile/                      # Flutter mobile application
│   ├── lib/
│   │   ├── features/           # Feature modules (feature-based architecture)
│   │   │   ├── auth/
│   │   │   │   ├── data/
│   │   │   │   ├── domain/
│   │   │   │   └── presentation/
│   │   │   ├── timetable/
│   │   │   │   ├── data/
│   │   │   │   ├── domain/
│   │   │   │   └── presentation/
│   │   │   ├── venues/
│   │   │   │   ├── data/
│   │   │   │   ├── domain/
│   │   │   │   └── presentation/
│   │   │   ├── notifications/
│   │   │   │   ├── data/
│   │   │   │   ├── domain/
│   │   │   │   └── presentation/
│   │   │   └── navigation/
│   │   │       └── presentation/
│   │   ├── core/               # Shared code
│   │   │   ├── models/         # Shared data models
│   │   │   ├── services/       # API client, storage, notifications
│   │   │   ├── utils/          # Utilities & constants
│   │   │   ├── theme/          # App theme & colors
│   │   │   └── errors/         # Error handling
│   │   ├── widgets/            # Reusable UI components
│   │   ├── main.dart
│   │   └── config.dart         # Configuration (API endpoints, Mapbox token)
│   ├── test/
│   │   ├── features/           # Feature-specific tests
│   │   └── unit/               # Unit tests
│   ├── android/
│   ├── ios/
│   ├── pubspec.yaml
│   ├── analysis_options.yaml   # Lint rules
│   └── README.md               # Mobile-specific setup
│
├── admin/                       # Admin panel (web-based, optional)
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── README.md               # Admin-specific setup
│
└── .github/
    ├── workflows/
    │   ├── backend-ci.yml      # Backend tests & deployment
    │   ├── mobile-ci.yml       # Flutter builds
    │   └── deploy.yml          # Production deployment
    └── ISSUE_TEMPLATE/
        ├── bug_report.md
        └── feature_request.md
```

### Directory Explanations

**Backend (`src/` organization)**
- `config/`: Database connections, JWT secrets, environment variables
- `controllers/`: HTTP request handlers (auth, timetables, venues, notifications)
- `models/`: Database models (User, Timetable, Venue, Course, Lecturer)
- `services/`: Business logic (timetable sync, venue queries, notification dispatch)
- `middleware/`: Authentication (verifyToken), input validation, error handling
- `routes/`: Route definitions (auth routes, admin routes, user routes)

**Mobile (Feature-based architecture)**
- Each feature has `data/`, `domain/`, `presentation/` (Clean Architecture)
- `data/`: Local storage (Hive/SQLite), API calls
- `domain/`: Business logic, entities, repositories
- `presentation/`: UI screens, state management (Riverpod), widgets

**Migrations & Seeds**
- `backend/migrations/`: SQL scripts for schema versioning
- `backend/seeds/`: Sample course, venue, and user data for testing

**CI/CD**
- `.github/workflows/`: GitHub Actions for testing and deployment
- Includes linting, unit tests, integration tests, and build steps

### Key Files to Create at Project Start

1. **Root level**: `.gitignore`, `.env.example`, `docker-compose.yml`, `LICENSE`
2. **Backend**: `backend/src/app.js`, `backend/.env.example`, `backend/Dockerfile`
3. **Mobile**: `mobile/lib/main.dart`, `mobile/lib/config.dart`, `mobile/pubspec.yaml`
4. **Docs**: `docs/API.md`, `docs/DATABASE.md`, `docs/ARCHITECTURE.md`

## Quick Start

### Prerequisites
- Python 3.8+
- PostgreSQL 13+
- Flutter SDK (for mobile development)

### Backend Setup

1. **Clone and navigate to backend**:
   ```bash
   git clone https://github.com/[org]/ramani.git
   cd ramani/backend
   ```

2. **Create virtual environment**:
   ```bash
   python -m venv ../vee
   source ../vee/bin/activate  # On Windows: ../vee/Scripts/activate
   ```

3. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up environment variables**:
   ```bash
   cp .env.example .env  # Copy template
   # Edit .env with your database credentials
   ```

5. **Run migrations**:
   ```bash
   python manage.py migrate
   ```

6. **Create superuser**:
   ```bash
   python manage.py createsuperuser
   ```

7. **Populate sample data** (optional):
   ```bash
   python sample/populate_data.py
   ```

8. **Start development server**:
   ```bash
   python manage.py runserver
   ```

The backend will be available at `http://localhost:8000`.

### Mobile Setup (Coming Soon)

Flutter mobile app setup instructions will be added once development begins.

## Architecture

The system follows a client-server architecture with offline capabilities.

```mermaid
graph TD
    A[Mobile App (Flutter)] --> B[Backend API (Django REST Framework)]
    A --> C[Local SQLite DB]
    B --> D[PostgreSQL DB]
    A --> E[Mapbox API]
    A --> F[Firebase Cloud Messaging]
    B --> F
```

### Component Descriptions
- **Mobile App**: Handles UI, user interactions, offline data, and integrates with maps and notifications.
- **Backend API**: Django REST Framework manages data synchronization, authentication, and business logic.
- **Database**: PostgreSQL for centralized data; SQLite for local caching on device.
- **External Services**: Mapbox for navigation, Firebase for notifications.

## Dynamic Campus Map Data

The campus map data is designed to be **dynamic and data-driven** so that adding new buildings or paths does not require an app update.

### 1) Store locations in the database
- Keep all buildings/venues in the `VENUES` table (or a dedicated `BUILDINGS` table).
- Each row includes `name`, `description`, `latitude`, `longitude`, and any other metadata.
- When a new building is added, the admin inserts a new record and the app automatically shows it on the map.

### 2) Load markers dynamically (Database → API → App → Map)
- The mobile app loads venue data from the backend API (`GET /api/venues`).
- The app displays each venue as a map marker in Mapbox.
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

The database schema is fully documented in [docs/DATABASE.md](docs/DATABASE.md), which includes detailed table definitions, relationships, constraints, and sample data.

### Core Entities

The system uses PostgreSQL with the following main entities:

- **USERS**: Students, lecturers, and administrators with role-based access
- **DEPARTMENTS**: Organizational units at NIT
- **COURSES**: Academic courses with lecturer assignments
- **VENUES**: All campus locations (lecture halls, offices, labs, shops, cafes, libraries, etc.) with GPS coordinates
- **TIMETABLES**: Links users to courses and venues with scheduling details
- **NOTIFICATIONS**: System notifications for schedule changes and updates
- **DEVICES**: Mobile device tracking for push notifications
- **SYNC_LOGS**: Tracks mobile app data synchronization

### Key Features

- **Unified Venues Table**: Represents the entire campus hierarchy (buildings, rooms, facilities)
- **Role-Based Users**: Lecturer-specific fields like specialization (optional)
- **GPS Integration**: Latitude/longitude for Mapbox navigation
- **Offline Support**: Sync logs for mobile app synchronization
- **Flexible Venue Types**: Lecture halls, offices, labs, shops, cafes, libraries, auditoriums, facilities, admin offices, and other campus locations

### Entity-Relationship Overview

```mermaid
erDiagram
    USERS ||--o{ TIMETABLES : has
    USERS ||--o{ DEVICES : registers
    COURSES ||--o{ TIMETABLES : scheduled_to
    COURSES ||--o{ USERS : taught_by
    VENUES ||--o{ TIMETABLES : assigned_to
    VENUES ||--o{ USERS : has_office
    USERS ||--o{ NOTIFICATIONS : receives
    USERS ||--o{ SYNC_LOGS : tracks

    USERS {
        int id PK
        string email UK
        string password_hash
        string full_name
        enum role "student|lecturer|admin"
        string phone
        int department_id FK
        string office_location
        string specialization
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    COURSES {
        int id PK
        string code UK
        string name
        text description
        int credit_hours
        int lecturer_id FK
        int department_id FK
        int capacity
        timestamp created_at
        timestamp updated_at
    }

    VENUES {
        int id PK
        string name UK
        string building
        string room_number
        float latitude
        float longitude
        enum venue_type
        int capacity
        string description
        int assigned_user_id FK
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    TIMETABLES {
        int id PK
        int user_id FK
        int course_id FK
        int venue_id FK
        string day_of_week
        time start_time
        time end_time
        date date_from
        date date_to
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }

    NOTIFICATIONS {
        int id PK
        int user_id FK
        string title
        text message
        string type
        boolean is_read
        timestamp created_at
    }

    DEVICES {
        int id PK
        int user_id FK
        string device_name
        string device_id UK
        enum platform "iOS|Android"
        string fcm_token
        boolean is_active
        timestamp created_at
    }

    SYNC_LOGS {
        int id PK
        int user_id FK
        timestamp last_sync
        int synced_records
        string status
        text error_message
        timestamp created_at
    }
```

For complete table definitions, indexes, constraints, and sample data, see [docs/DATABASE.md](docs/DATABASE.md).

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

> **Note**: This project is in the design phase. Setup instructions below are for when development begins. For now, focus on reviewing the architecture and design documents.

### Prerequisites (Once Development Begins)
- **Flutter SDK** v3.0+ (for mobile development)
- **Python** 3.8+ with **Django** 4.0+ (for backend)
- **PostgreSQL** v13+ (for database)
- **Mapbox Access Token** (create at [mapbox.com](https://www.mapbox.com))
- **Firebase Project** (create at [firebase.google.com](https://firebase.google.com))
- **Git** for version control

### Environment Setup

#### Backend Setup
```bash
git clone https://github.com/[org]/ramani.git
cd ramani/backend

# Install dependencies
npm install

# Create .env file with required variables
cp .env.example .env

# Edit .env with your credentials:
# DATABASE_URL=postgresql://user:password@localhost:5432/nit_timetable
# JWT_SECRET=your-secret-key
# MAPBOX_ACCESS_TOKEN=your-token
# FIREBASE_SERVER_KEY=your-key

# Run migrations
npm run migrate

# Start development server
npm run dev
```

#### Mobile App Setup
```bash
cd ramani/mobile

# Get dependencies
flutter pub get

# Create lib/config.dart with API endpoint configuration
# See docs/SETUP.md for detailed configuration

# Configure Firebase
# - Download google-services.json (Android)
# - Download GoogleService-Info.plist (iOS)

# Run on emulator/device
flutter run
```

#### Database Setup
```bash
# Create PostgreSQL database
createdb nit_timetable

# Apply initial schema (migrations)
cd ../backend && npm run migrate
```

### Configuration Files

Key configuration templates:
- `backend/.env.example` - Backend environment variables
- `mobile/lib/config.dart` - API endpoints and Mapbox token
- Database migrations in `backend/migrations/`
- Firebase configuration in `mobile/ios/` and `mobile/android/`

## User Workflows (Planned)

### Student Workflow
1. Download app from Google Play / App Store
2. Login with NIT credentials
3. View personal timetable on dashboard
4. Tap on a class to see:
   - Venue details (building, room, capacity)
   - Distance from current location
   - Weather at venue
5. Tap "Get Directions" to launch campus navigation
6. Receive push notifications for schedule changes

### Lecturer Workflow
1. Login with lecturer credentials
2. View assigned courses and timetable
3. Edit or update timetable (if authorized)
4. Access venue information and student roster

### Administrator Workflow
1. Access admin panel (web-based)
2. Manage user accounts and roles
3. Add/edit/delete venues and buildings
4. Update timetables in bulk
5. Send notifications to students/lecturers
6. View usage analytics and reports

## Development Workflow

### Setting Up for Contribution

```bash
# Clone the repository
git clone https://github.com/[org]/ramani.git
cd ramani

# Create a feature branch
git checkout -b feature/your-feature-name

# Backend development
cd backend
npm install
npm run dev

# Mobile development (separate terminal)
cd mobile
flutter pub get
flutter run
```

### Code Management

- **Main branch**: Production-ready code
- **Develop branch**: Integration branch for features
- **Feature branches**: `feature/feature-name`
- **Bugfix branches**: `bugfix/issue-name`

### Testing Strategy

Once code is available:

#### Backend Tests
```bash
cd backend
npm test                    # Run unit tests
npm run test:integration   # Run integration tests
npm run test:coverage      # Generate coverage report
```

#### Mobile Tests
```bash
cd mobile
flutter test                           # Unit tests
flutter drive --target=test_driver/app.dart  # Integration tests
```

#### Manual Testing Checklist
- [ ] Offline data sync after reconnection
- [ ] Navigation accuracy from various campus locations
- [ ] Firebase notification delivery
- [ ] Role-based access control
- [ ] API response time under load

## Deployment Pipeline

> **Status**: To be implemented with GitHub Actions

### Staged Deployment

1. **Develop** → Run tests → Deploy to staging
2. **Staging** → Approval required → Deploy to production
3. **Production** → Available on Play Store / App Store

### Build Commands

```bash
# Backend (Docker)
cd backend
docker build -t ramani-api:latest .
docker tag ramani-api:latest gcr.io/[project]/ramani-api:latest
docker push gcr.io/[project]/ramani-api:latest

# Mobile - Android
cd mobile
flutter build apk --split-per-abi

# Mobile - iOS
cd mobile
flutter build ios --release
```

## Contributing

Thank you for your interest in contributing! Here's how to get involved:

### Getting Started

1. **Review the documentation**:
   - Understand the architecture from diagrams/
   - Read the API specification
   - Check existing issues/PRs

2. **Set up your development environment**:
   - Follow the [Installation and Setup](#installation-and-setup) section
   - Verify all tests pass locally

3. **Pick an issue**:
   - Look for issues tagged `good-first-issue`
   - Check project board for priority items
   - Comment on the issue to express interest

### Development Process

1. **Create a feature branch**:
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/descriptive-name
   ```

2. **Code with best practices**:
   - Follow language/framework conventions
   - Write tests for new functionality
   - Keep commits atomic and well-described
   - Reference issue numbers in commit messages: `git commit -m "Fix auth flow (closes #42)"`

3. **Push and create Pull Request**:
   ```bash
   git push origin feature/descriptive-name
   ```

4. **Code Review**:
   - Address feedback from maintainers
   - Participate in discussion
   - Update PR based on reviewer comments

5. **Merge**:
   - Squash commits if requested
   - Merge to `develop` branch
   - Delete feature branch after merge

### Code Style

- **Backend**: Use ESLint configuration in `backend/.eslintrc`
- **Mobile**: Use Dart lint rules defined in `mobile/analysis_options.yaml`
- **Commits**: Use conventional commits format (`feat:`, `fix:`, `docs:`, `refactor:`)

### Reporting Issues

Please include:
- Clear description of the bug/feature
- Steps to reproduce (for bugs)
- Expected vs actual behavior
- Environment details (OS, DevTools versions, etc.)
- Screenshots/logs if applicable

## Project Roadmap

### Q2 2026 (Current)
- ✅ Architecture & design phase
- ⏳ Backend API development
- ⏳ Database schema implementation

### Q3 2026
- Flutter mobile app scaffolding
- API integration
- Offline data sync implementation
- Firebase setup

### Q4 2026
- MVP testing
- Beta release to NIT
- Feedback collection

### Q1 2027
- Admin panel development
- Advanced routing features
- Performance optimization
- App Store release

## License

This project is licensed under the [MIT License](LICENSE) - see file for details.

## Contact & Support

- **Project Lead**: [Your Name] ([email](mailto:your-email@example.com))
- **Issues & Discussions**: [GitHub Issues](https://github.com/[org]/ramani/issues)
- **Documentation**: Check `/docs` folder for detailed guides
- **Slack/Chat**: [Link to project chat]

## Acknowledgments

- NIT administration for project support
- Flutter and Dart communities
- Mapbox for location services
- Firebase for backend services

---

**Last Updated**: April 2026  
**Repository**: https://github.com/[org]/ramani

### Code Style
- Follow Flutter/Dart style guide.
- Use Black and Flake8 for Python/Django code formatting and linting.
- Write descriptive commit messages.

## Future Enhancements

- Implement AI-based schedule optimization.
- Add AR navigation for indoor venues.
- Integrate with NIT's existing systems (e.g., student portal).
- Expand to web version using Flutter Web.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

