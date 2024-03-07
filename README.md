# LocateMe

LocateMe is a Flutter application that allows users to view their current location on a Google Map and display a list of API data on another screen. This README provides an overview of the project and instructions on how to set it up.

## Table of Contents
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
- [Libraries Used](#libraries-used)


## Requirements

1. **Flutter App Development:**
   - **Setup:** Create a new Flutter project compatible with Android and iOS devices.
   - **Google Maps Integration:** Integrate the Google Maps API to display a map. Ensure you have a valid API key from the Google Cloud Platform.
   - **App Functionality:** Upon opening the app, the Google Maps screen displays the user's current location with a marker. The top view shows the current location's address details. There's a "Continue" button at the bottom, which, when clicked, passes the current address details (Address, Latitude, Longitude) to the next screen.
   - **Second Screen:** Display the passed address details at the top of the screen. Fetch data from the provided API (https://reqres.in/api/users?page=1) and display it in a list view. Optionally, implement pagination for the data.
   - **UI/UX:** Design a simple yet intuitive interface that looks and feels responsive. Ensure a seamless user experience across different device sizes.
   - **Back Press Handling:** On the home map screen, when the back button is pressed, a confirmation popup appears. Upon confirmation, the app closes.

2. **Libraries Used:**
   - Google Maps SDK
   - Riverpod for state management
   - Dio for network API calls
   - Freezed for JSON parsing

## Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/LocateMe.git
   ```
2. **Navigate to the project directory:**
   ```bash
   cd LocateMe
   ```
3. **Install dependencies && Run the app:**
   ```bash
   flutter pub get
   flutter run
   ```
## Usage
- Upon opening the app, you will see a Google Maps screen displaying your current location with a marker.
- The top view will show the current location's address details.
- Tap the "Continue" button at the bottom to navigate to the second screen. On the second screen, the passed address details will be displayed at the top.
- Below the address details, the API data fetched from https://reqres.in/api/users?page=1 will be displayed in a list view.
