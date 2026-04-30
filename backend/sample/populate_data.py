import os
import sys
import django

# Add the backend directory to Python path
BACKEND_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(BACKEND_DIR)
if PROJECT_ROOT not in sys.path:
    sys.path.insert(0, PROJECT_ROOT)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'ramani.settings')
django.setup()

from django.contrib.auth import get_user_model
from apps.departments.models import Department
from apps.venues.models import Venue
from apps.courses.models import Course, StudentCourse
from apps.timetables.models import Timetable
from apps.notifications.models import Notification
from apps.devices.models import Device
from apps.sync_logs.models import SyncLog

User = get_user_model()


def create_departments():
    departments = [
        {'name': 'Computer Science', 'code': 'CSE', 'head_of_department': 'Dr. A. Kumar'},
        {'name': 'Mechanical Engineering', 'code': 'ME', 'head_of_department': 'Dr. B. Sharma'},
        {'name': 'Electrical Engineering', 'code': 'EE', 'head_of_department': 'Dr. C. Gupta'},
        {'name': 'Administration', 'code': 'ADM', 'head_of_department': 'Mrs. D. Patel'},
    ]
    objs = []
    for data in departments:
        obj, _ = Department.objects.update_or_create(code=data['code'], defaults=data)
        objs.append(obj)
    return objs


def create_users(departments):
    users = [
        {
            'email': 'admin@nit.edu',
            'password': 'AdminPass123',
            'first_name': 'Campus',
            'last_name': 'Admin',
            'role': 'admin',
            'department': departments.get('ADM'),
            'is_staff': True,
            'is_superuser': True,
        },
        {
            'email': 'lecturer1@nit.edu',
            'password': 'Lecturer123',
            'first_name': 'Ravi',
            'last_name': 'Sharma',
            'role': 'lecturer',
            'department': departments.get('CSE'),
            'registration_number': 'LCT1001',
        },
        {
            'email': 'student1@nit.edu',
            'password': 'Student123',
            'first_name': 'Priya',
            'last_name': 'Mehta',
            'role': 'student',
            'department': departments.get('CSE'),
            'registration_number': 'STU2001',
        },
    ]

    created = {}
    for data in users:
        password = data.pop('password')
        defaults = {k: v for k, v in data.items() if k != 'email'}
        user, created_flag = User.objects.update_or_create(email=data['email'], defaults=defaults)
        if created_flag or not user.check_password(password):
            user.set_password(password)
            user.save()
        created[data['email']] = user
    return created


def create_venues(users):
    venues = [
        {
            'name': 'Block 23 - Room 101',
            'building': 'Block 23',
            'venue_type': 'lecture_hall',
            'latitude': 12.9715987,
            'longitude': 77.594566,
            'capacity': 80,
            'assigned_user': users.get('lecturer1@nit.edu'),
            'amenities': 'Projector, Whiteboard, AC',
            'description': 'Large lecture hall with smart board',
            'floor_number': 1,
            'is_accessible': True,
        },
        {
            'name': 'Main Library',
            'building': 'Central Campus',
            'venue_type': 'library',
            'latitude': 12.9720000,
            'longitude': 77.5950000,
            'capacity': 200,
            'assigned_user': None,
            'amenities': 'Books, Study rooms, Wi-Fi',
            'description': 'Campus main library with reading halls',
            'floor_number': 0,
            'is_accessible': True,
        },
    ]
    created = []
    for data in venues:
        assigned = data.pop('assigned_user')
        venue, _ = Venue.objects.update_or_create(
            name=data['name'], building=data['building'], defaults=data
        )
        if assigned:
            venue.assigned_user = assigned
            venue.save()
        created.append(venue)
    return created


def create_courses(departments, users):
    courses = [
        {
            'code': 'CSE101',
            'name': 'Introduction to Computer Science',
            'department': departments.get('CSE'),
            'lecturer': users.get('lecturer1@nit.edu'),
            'credit_hours': 3,
            'description': 'Fundamentals of computing and programming',
        },
    ]
    created = []
    for data in courses:
        course, _ = Course.objects.update_or_create(code=data['code'], defaults=data)
        created.append(course)
    StudentCourse.objects.update_or_create(
        student=users.get('student1@nit.edu'), course=created[0]
    )
    return created


def create_timetables(courses, venues):
    timetable_data = [
        {
            'course': courses[0],
            'venue': venues[0],
            'day_of_week': 'Monday',
            'start_time': '09:00',
            'end_time': '10:30',
            'semester': 1,
            'academic_year': '2026-2027',
            'capacity': 80,
        },
    ]
    created = []
    for data in timetable_data:
        timetable, _ = Timetable.objects.update_or_create(
            course=data['course'], venue=data['venue'], day_of_week=data['day_of_week'],
            start_time=data['start_time'], end_time=data['end_time'], defaults=data
        )
        created.append(timetable)
    return created


def create_notifications(users, courses, timetables):
    notifications = [
        {
            'user': users.get('student1@nit.edu'),
            'type': 'class_reminder',
            'title': 'Your next class starts soon',
            'message': 'Remember to attend CSE101 in Block 23 - Room 101 at 09:00 on Monday.',
            'related_course': courses[0],
            'related_timetable': timetables[0],
            'is_read': False,
        },
    ]
    created = []
    for data in notifications:
        notification, _ = Notification.objects.update_or_create(
            user=data['user'], title=data['title'], defaults=data
        )
        created.append(notification)
    return created


def create_devices(users):
    devices = [
        {
            'user': users.get('student1@nit.edu'),
            'device_token': 'token-student-0001',
            'device_type': 'Android',
            'device_name': 'Priya Phone',
            'is_active': True,
        },
    ]
    created = []
    for data in devices:
        device, _ = Device.objects.update_or_create(
            device_token=data['device_token'], defaults=data
        )
        created.append(device)
    return created


def create_sync_logs(users, devices):
    sync_entries = [
        {
            'user': users.get('student1@nit.edu'),
            'device': devices[0],
            'sync_type': 'full',
            'status': 'success',
            'synced_records': 45,
        },
    ]
    created = []
    for data in sync_entries:
        log, _ = SyncLog.objects.update_or_create(
            user=data['user'], device=data['device'], sync_type=data['sync_type'], defaults=data
        )
        created.append(log)
    return created


def main():
    print('Populating sample data...')

    departments = {dept.code: dept for dept in create_departments()}
    users = create_users(departments)
    venues = create_venues(users)
    courses = create_courses(departments, users)
    timetables = create_timetables(courses, venues)
    create_notifications(users, courses, timetables)
    devices = create_devices(users)
    create_sync_logs(users, devices)

    print('Sample data population completed successfully.')
    print('Departments:', Department.objects.count())
    print('Users:', User.objects.count())
    print('Venues:', Venue.objects.count())
    print('Courses:', Course.objects.count())
    print('Timetables:', Timetable.objects.count())
    print('Notifications:', Notification.objects.count())
    print('Devices:', Device.objects.count())
    print('Sync logs:', SyncLog.objects.count())


if __name__ == '__main__':
    main()
