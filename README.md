# NextCheck - Real-Time Location Check-in App

NextCheck is a **Flutter-based mobile application** that allows hosts to create check-in points with a defined radius and participants to check in and automatically check out based on their distance. The app supports real-time tracking, Firebase backend integration, and role-based functionality for hosts and participants.

---

## Features

### Host
- Create a **check-in point** with location and radius.
- See all **active participants** within the check-in area.
- View participants' real-time location relative to the check-in point.
- Auto-checkout participants when they leave the radius.
- Marker and radius boundary visualization on Google Maps.

### Participant
- Check-in to the active point using GPS location.
- Auto-checkout when moving out of the designated radius.
- Distance display showing meters/kilometers from the check-in point.

### Authentication
- **Sign up** and **Login** using email/password.
- Role selection: **Host** or **Participant**.
- Password visibility toggle.
- Forgot password placeholder for future implementation.

### UI/UX
- Modern **gradient-based design** with MNC standards.
- Smooth animations using **AnimatedTextKit** and **ZoomTapAnimation**.
- Loading indicators for async operations.
- Responsive layout for different screen sizes.

### Backend
- Firebase Firestore for storing:
  - Active check-in point.
  - Participants’ check-in status.
- Firebase Authentication for user accounts.

---

## Screens

1. **Signup Screen**
   - Email, password, role selection.
   - Gradient background with animated title.

2. **Login Screen**
   - Email, password, forgot password.
   - Login button with gradient and shadow.

3. **Host Dashboard**
   - Create check-in point.
   - Google Maps marker + boundary visualization.
   - List of active participants.

4. **Participant Dashboard**
   - View check-in point on map.
   - Auto check-in and checkout based on location.
   - Distance display from check-in point.

---

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/nextcheck.git
   cd nextcheck
