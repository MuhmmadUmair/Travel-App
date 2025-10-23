# 🗺️ Flutter Travel Guide App

A modern and interactive **Travel Guide App** built with **Flutter**, designed to help tourists explore destinations, view maps (including **offline map support**), and manage favorite places easily.

The app provides **location-based recommendations**, allows adding destinations to **favorites**, and includes a **clean and intuitive UI** for the best travel experience.

---

## 🚀 Features

✅ Location-based recommendations
✅ View destinations on an interactive **offline map**
✅ Add or remove favorite places
✅ See favorite destinations list from the home screen
✅ Clean, responsive, and animated UI
✅ Modular architecture (Model–View–Provider pattern)

---

## 📂 Project Structure

```
lib/
├── main.dart                # App entry point
├── screens/
│   ├── home_screen.dart     # Main home screen with destinations & favorites
│   ├── map_screen.dart      # Offline map integration using flutter_map
├── models/
│   └── destination.dart     # Model for travel destinations
├── providers/
│   └── favorites_provider.dart # State management with Provider
├── widgets/
│   ├── destination_card.dart # Custom card for showing destination info
│   └── favorites_list.dart   # Widget for displaying favorite items
└── utils/
    └── constants.dart        # App constants (colors, padding, strings)
```

---

## 🛠️ Technologies Used

| Technology                      | Purpose                     |
| ------------------------------- | --------------------------- |
| **Flutter**                     | Cross-platform framework    |
| **Dart**                        | Programming language        |
| **Provider**                    | State management            |
| **flutter_map + OpenStreetMap** | Offline map integration     |
| **SharedPreferences**           | Local storage for favorites |

---

## 🗺️ Offline Map Support

The app integrates **OpenStreetMap** via the `flutter_map` package.
You can view maps and pins for each destination, even in **offline mode**, once the map tiles are cached locally.

---

## 📸 Screenshots

![Travel App](https://github.com/MuhmmadUmair/Travel-App/blob/3bd770fe9a2eaabe16462d14aa7094053d73b64f/assets/images/App_Screenshot.jpg?raw=true)
## ⚙️ Getting Started

### Prerequisites

* Install **Flutter SDK**
* Set up an emulator or real device (Android/iOS)
* Ensure you have an active internet connection for initial map caching

---

### Installation

1️⃣ **Clone the repository**

```bash
git clone https://github.com/your-username/flutter_travel_guide_app.git
cd flutter_travel_guide_app
```

2️⃣ **Install dependencies**

```bash
flutter pub get
```

3️⃣ **Run the app**

```bash
flutter run
```

---

## 🧰 How It Works

1. The app displays a list of **tourist destinations**.
2. Each card shows a name, image, and description.
3. Tap the **heart icon ❤️** to mark a place as favorite.
4. Tap the **map icon 🗺️** to view the destination on the **offline map**.
5. Favorites can be viewed directly from the **top-right corner** of the Home Screen.

---

## 🌟 Future Enhancements

✨ Add user authentication (login/signup)
✨ Add real-time weather updates for destinations
✨ Add trip planner and route tracking
✨ Integrate Google Maps for hybrid view
✨ Add support for multiple languages

---

## 👨‍💻 Author

**Muhammad Umair**

---

## 🌐 Connect with Me

💼 **LinkedIn:** [https://www.linkedin.com/in/merry032c](https://www.linkedin.com/in/merry032c)

