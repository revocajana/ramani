# Flowchart for Student Navigation Process

```mermaid
flowchart TD
    A[Start] --> B[Open NIT Venue Location App]
    B --> C[Login with Credentials]
    C --> D{Login Successful?}
    D -->|Yes| E[Load Campus Map Data from Server]
    D -->|No| F[Display Error Message]
    F --> C
    E --> G[Select Date/Time for Timetable]
    G --> H[View Timetable]
    H --> I[Choose Upcoming Class]
    I --> J[Get Current Location]
    I --> J[Calculate Route to Venue]
    J --> K[Display Step-by-Step Directions]
    K --> L[Navigate Using Map]
    L --> M{Arrived at Venue?}
    M -->|No| L
    M -->|Yes| N[Mark Class as Attended / End]
    N --> O[End]
```

## Diagram (textual view)

Start → Open App → Login

Login → (success) → Load Campus Map Data → Select Date/Time → View Timetable → Choose Class → Get Location → Calculate Route → Display Directions → Navigate → Arrive → End

Login → (failure) → Display Error → Login


