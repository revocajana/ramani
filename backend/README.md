# NIT Venue Location - Django Backend

This is the Django REST API backend for the NIT Venue Location system.

## Setup Instructions

### Prerequisites
- Python 3.8+
- PostgreSQL 13+
- Git

### Installation

1. **Create virtual environment:**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

4. **Set up PostgreSQL database:**
   ```sql
   CREATE DATABASE ramani;
   CREATE USER ramani_user WITH PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE ramani TO ramani_user;
   ```

5. **Run migrations:**
   ```bash
   python manage.py makemigrations
   python manage.py migrate
   ```

6. **Create superuser:**
   ```bash
   python manage.py createsuperuser
   ```

7. **Run development server:**
   ```bash
   python manage.py runserver
   ```

The API will be available at `http://localhost:8000/api/`

## API Endpoints

- `/api/users/` - User management
- `/api/departments/` - Department management
- `/api/venues/` - Venue management
- `/api/courses/` - Course management
- `/api/timetables/` - Timetable management
- `/api/notifications/` - Notification management
- `/api/devices/` - Device management
- `/api/sync/` - Synchronization logs

## Authentication

The API uses JWT (JSON Web Token) authentication. Include the token in the Authorization header:

```
Authorization: Bearer <your-jwt-token>
```

## Admin Panel

Access the Django admin panel at `http://localhost:8000/admin/` to manage data.