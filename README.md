# Mehmani - مدیریت مهمانی

A Flutter application for managing party and event expenses, guest lists, and cost calculations.

## 📱 About

Mehmani (مهمانی) is a Persian/Farsi mobile application designed to help users efficiently manage party and event planning. The app provides tools for tracking guest lists, managing food items, calculating costs, and estimating expenses for events.

## ✨ Features

### 🏠 Guest Management

- Add and manage families/households
- Track number of members per family
- Select families for specific events
- Edit and delete guest information

### 🍽️ Food Management

- Add food items with quantities and units (grams, pieces, servings)
- Set prices per person for each food item
- Track food selections for events
- Manage food inventory

### 💰 Cost Calculator

- Automatic calculation of total food costs based on guest count
- Gift estimation per family
- Real-time cost updates
- Persian number formatting for better readability

### 💾 Data Management

- Local data storage using Hive database
- Backup and restore functionality
- Data persistence across app sessions
- Export/import capabilities

### 🎨 User Interface

- Persian/Farsi language support
- RTL (Right-to-Left) text direction
- Animated bottom navigation
- Modern Material Design
- Responsive layout for different screen sizes

## 🛠️ Technical Stack

- **Framework**: Flutter
- **State Management**: GetX
- **Local Database**: Hive
- **Navigation**: GetX Routing
- **UI Components**: Material Design
- **Number Formatting**: Persian Number Utility
- **Notifications**: Motion Toast
- **File Operations**: File Picker, Permission Handler

## 📋 Prerequisites

- Flutter SDK (>=2.16.2)
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

## 🚀 Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/mehmani.git
   cd mehmani
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**

   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Usage

### Adding Guests

1. Navigate to "تعداد خانوار" (Family Count) section
2. Tap the floating action button to add a new family
3. Enter family name and member count
4. Save the information

### Adding Food Items

1. Go to "اطلاعات غذا" (Food Information) section
2. Tap the floating action button to add food items
3. Enter food name, quantity, unit, and price per person
4. Save the food item

### Calculating Costs

1. Navigate to "محاسبه هزینه" (Cost Calculation) section
2. Select families for the event
3. Choose food items for the menu
4. View automatic cost calculations
5. Use the calculator button for detailed breakdown

### Backup & Restore

1. Open the drawer menu
2. Use "پشتیبان گیری" (Backup) to save data
3. Use "بازیابی اطلاعات" (Restore) to load saved data

## 📁 Project Structure

```
lib/
├── abzar/                    # Utility tools
│   ├── bacup_restor.dart    # Backup and restore functionality
│   └── seRagham.dart        # Number formatting utilities
├── bindings/                 # GetX bindings
├── controllers/              # GetX controllers
├── routes/                   # Application routes
├── screen/                   # UI screens
│   ├── calculat/            # Calculator screen
│   ├── food/                # Food management screens
│   ├── models/              # Data models
│   ├── persons/             # Person management screens
│   └── home_page.dart       # Main home screen
├── const.dart               # Constants and styles
└── main.dart                # Application entry point
```

## 🔧 Configuration

### Fonts

The app uses custom Persian fonts:

- Vazir (main font)
- Nunito (secondary font)
- NiseBusch (special font)

### Colors

- Primary: Amber/Orange theme
- Background: Gradient colors
- Text: Dark colors for readability

## 📊 Data Models

### PersonModel

- `id`: Unique identifier
- `title`: Family name
- `conter`: Member count
- `isChecked`: Selection status

### FoodModel

- `id`: Unique identifier
- `title`: Food name
- `amount`: Quantity
- `vahed`: Unit (grams, pieces, servings)
- `fi`: Price per person
- `isChecked`: Selection status

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**Mohsen Faraji**

- Flutter Developer
- Contact: Mohsen.faraji.dev
- Telegram: @M0h3nFrji

## 🆘 Support

If you encounter any issues or have questions:

1. Check the help section in the app
2. Open an issue on GitHub
3. Contact the developer through the provided channels

## 🔄 Version History

- **v1.0.0**: Initial release with core functionality
  - Guest management
  - Food tracking
  - Cost calculation
  - Backup/restore features

---

**Note**: This application is designed specifically for Persian/Farsi users and includes RTL support and Persian number formatting.
