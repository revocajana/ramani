# NIT Venue Location

A comprehensive campus navigation and timetable management system for the National Institute of Transport (NIT).

## Project Overview

This project aims to develop a mobile application that helps NIT students efficiently navigate campus and manage their academic schedules. The system automates timetable distribution, provides location-based guidance to lecture venues, and integrates real-time notifications for schedule updates.

### Problem Statement
Students at large campuses like NIT face challenges:
- Locating lecture venues quickly, especially when new to campus
- Managing dynamic timetable updates
- Missing classes due to navigation delays

This application solves these issues with an interactive campus map, one-tap navigation, and offline timetable access.

## Features

### MVP (Core)
- **Timetable Management**: Centralized database for storing student schedules with course details and venue assignments
- **Venue Location Display**: Interactive Mapbox map showing all lecture venues on campus
- **Location-Based Navigation**: Real-time, step-by-step directions from current location to assigned lecture venue
- **Offline Support**: Access to timetables and venue information without internet connectivity
- **Role-based Access**: Support for students, lecturers, and administrators

#### Phase 2 (Future)
- **Real-Time Notifications**: Push notifications for schedule changes and venue updates
- **Advanced Search**: Filter timetables by course, lecturer, or time
- **Admin Panel**: Interface for managing venues, users, and timetables
- **Campus Routing**: Compute optimal routes using graph-based pathfinding

## Tech Stack

### Frontend (Mobile)
- **Framework**: [Flutter](https://flutter.dev) (Dart) for cross-platform development (iOS & Android)
- **State Management**: [Riverpod](https://riverpod.dev) for predictable and testable state management
- **Maps**: [Mapbox SDK](https://www.mapbox.com) for location services and campus navigation
- **Local Storage**: SQLite for offline data persistence and sync flags
- **Notifications**: [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging) (FCM) for push notifications

### Backend
- **Runtime**: [Node.js](https://nodejs.org) (v16+) with [Express.js](https://expressjs.com)
- **Authentication**: JWT (JSON Web Tokens) for stateless authentication
- **Database**: [PostgreSQL](https://www.postgresql.org) (v13+) for persistent data storage
- **Real-Time** (Optional): [Socket.io](https://socket.io) for future real-time features

### DevOps & Tooling
- **Version Control**: Git / GitHub
- **CI/CD**: GitHub Actions for automated testing and deployment
- **Testing**: 
  - Flutter Test for unit & widget tests
  - Jest for backend unit tests
  - Postman for API integration testing
- **API Documentation**: Swagger/OpenAPI
- **Container**: Docker for consistent development environments

## Repository Structure

```
ramani/                    
├── backend/                     # Node.js + Express REST API (to be created)
│   ├── src/
│   ├── tests/
│   ├── package.json
│   └── .env.example
├── mobile/                      # Flutter mobile application (to be created)
│   ├── lib/
│   ├── test/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
├── docs/                        # Additional documentation (optional)
|    ├── API.md                  # API specification details
|    └── SETUP.md                # Detailed setup instructions
└── README.md                    # Project documentation (this file)  

```

## Quick Start

This is a design-phase project. To contribute or understand the architecture:

1. **Read the documentation**:
   - Review [README.md](README.md) (this file) for overview
   - Check [diagrams/flowchart.md](diagrams/flowchart.md) for system flow
   - Check [diagrams/usecase.md](diagrams/usecase.md) for user scenarios

2. **Set up development environment** (once code is available):
   ```bash
   git clone https://github.com/[org]/ramani.git
   cd ramani
   
   # Backend
   cd backend && npm install && npm run dev
   
   # Mobile (separate terminal)
   cd mobile && flutter pub get && flutter run
   ```

3. **Contribute**: See [Contributing](#contributing) section below

## Architecture

The system follows a client-server architecture with offline capabilities.

```mermaid
graph TD
    A[Mobile App (Flutter)] --> B[Backend API (Node.js)]
    A --> C[Local SQLite DB]
    B --> D[PostgreSQL DB]
    A --> E[Mapbox API]
    A --> F[Firebase Cloud Messaging]
    B --> F
```

### Component Descriptions
- **Mobile App**: Handles UI, user interactions, offline data, and integrates with maps and notifications.
- **Backend API**: Manages data synchronization, authentication, and business logic.
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

> **Note**: This project is in the design phase. Setup instructions below are for when development begins. For now, focus on reviewing the architecture and design documents.

### Prerequisites (Once Development Begins)
- **Flutter SDK** v3.0+ (for mobile development)
- **Node.js** v16+ (for backend)
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