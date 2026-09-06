# 🏋️ Workout App

A modern **Workout App** built with **Flutter & Dart**, designed to help users discover and explore different exercises based on targeted muscle groups.

The application integrates a **REST API** to provide dynamic exercise data, uses **Provider** for efficient state management, and **SharedPreferences** for storing user data and preferences locally.

---

## 📱 Screenshots

### 🏠 Home Screen

<p align="center">
  <img width="350" height="600" alt="workout_home" src="https://github.com/user-attachments/assets/072f697b-202e-4ef5-b78d-f8c5919d6505" />

</p>

---

### 💪 Exercises Screen

<p align="center">
  <img width="350" height="600" alt="workout_home2" src="https://github.com/user-attachments/assets/85f9bffd-db02-48fc-8fc7-54e3a1d94bff" />

</p>

---

---

### 📄 Exercise Details

<p align="center">
  <img width="350" height="600" alt="workput_details" src="https://github.com/user-attachments/assets/7613a8a7-5e02-47b0-be0c-99955ac6432a" />

</p>

---

### ⭐ Favorites Screen

<p align="center">
  <img width="350" height="600" alt="workout_favorites" src="https://github.com/user-attachments/assets/b697bfa7-e66d-4ec3-bfd1-eba7105cab32" />

</p>

---

### 🔍 Search Screen

<p align="center">
  <img width="350" height="600" alt="workout_search" src="https://github.com/user-attachments/assets/771b44ca-be80-483d-b2eb-9cba5224c778" />

</p>

---

## ✨ Features

* 🏋️ Browse different exercises
* 💪 Explore exercises by targeted muscle
* 🎯 Filter exercises based on muscle groups
* 📄 View detailed exercise information
* ⭐ Add and manage favorite exercises
* 🌐 Fetch dynamic exercise data using REST API
* 💾 Store data and user preferences locally using SharedPreferences
* 🔄 Efficient state management using Provider
* 🎨 Clean and responsive user interface
* ⚡ Smooth navigation and user experience

---

## 🛠️ Technologies & Tools

* **Flutter**
* **Dart**
* **REST API**
* **Provider**
* **SharedPreferences**
* **HTTP**
* **Material Design**

---

## 🏗️ Project Structure

```text
lib/
│
├── models/
│   └── exercise_model.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── exercises_screen.dart
│   ├── details_screen.dart
│   ├── favorites_screen.dart
│   └── search_screen.dart
│
├── providers/
│   └── workout_provider.dart
│
├── services/
│   └── api_service.dart
│
├── widgets/
│   ├── exercise_card.dart
│   └── muscle_filter.dart
│
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Android Studio or VS Code
* Android Emulator or a physical device

### Installation

1. Clone the repository:

```bash
git clone YOUR_REPOSITORY_URL
```

2. Navigate to the project:

```bash
cd workout
```

3. Install dependencies:

```bash
flutter pub get
```

4. Run the application:

```bash
flutter run
```

---

## 🌐 API Integration

The application uses a **REST API** to retrieve exercise data dynamically.

The API is responsible for providing information such as:

* Exercise names
* Target muscles
* Equipment
* Exercise instructions
* Exercise categories

> **Note:** If the API requires an API key, make sure to configure it properly and avoid committing private credentials to the repository.

---

## 🔄 State Management

**Provider** is used to manage the application's state.

It helps handle:

* Exercise data
* Favorites
* Filtering
* UI updates
* User interactions

This makes the application easier to maintain and keeps the UI synchronized with the underlying data.

---

## 💾 Local Storage

**SharedPreferences** is used for local data persistence.

It allows the application to store user-related preferences and selected data locally, so important information can remain available even after restarting the application.

---

## 🎯 Project Goals

The main goal of this project was to gain practical experience in building a real-world Flutter application while working with:

* REST API integration
* State management using Provider
* Local storage using SharedPreferences
* Dynamic filtering
* Reusable Flutter widgets
* Asynchronous programming
* Clean and maintainable project structure
* Responsive UI development

---

## 👨‍💻 Developer

**Khaled Waleed**

Flutter Developer | Mobile Application Developer

---



---

⭐ If you find this project useful or interesting, feel free to give it a star!
