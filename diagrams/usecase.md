# Use Case Diagram for NIT Venue Location System

```mermaid
usecaseDiagram
    actor Student
    actor Lecturer
    actor Administrator
    actor "Class Representative" as ClassRep
    
    Student --> (Login to System)
    Student --> (View Personal Timetable)
    Student --> (Search Timetables)
    Student --> (Navigate to Venue)
    Student --> (Receive Notifications)
    
    Lecturer --> (Login to System)
    Lecturer --> (View Personal Timetable)
    Lecturer --> (Update Timetable)
    
    Administrator --> (Login to System)
    Administrator --> (Manage Users)
    Administrator --> (Manage Venues)
    Administrator --> (Manage Campus Map Data)
    Administrator --> (Update Timetable)
    
    ClassRep --> (Login to System)
    ClassRep --> (Book Venue)
```