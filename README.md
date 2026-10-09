<div align="center">

# Kivorly 🇧🇩
### The Everything Super App for Bangladesh

[![iOS Platform](https://img.shields.io/badge/Platform-iOS%2017%2B-007AFF?style=for-the-badge&logo=apple&logoColor=white)](https://github.com/theshoaibme/kivorly)
[![Android](https://img.shields.io/badge/Android-Jetpack%20Compose-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://github.com/theshoaibme/kivorly)
[![Web Platform](https://img.shields.io/badge/Web-Next.js%2016-000000?style=for-the-badge&logo=nextdotjs&logoColor=white)](https://github.com/theshoaibme/kivorly)
[![Country](https://img.shields.io/badge/Country-Bangladesh%20%F0%9F%87%A7%F0%9F%87%A9-006A4E?style=for-the-badge)](https://github.com/theshoaibme/kivorly)
[![Currency](https://img.shields.io/badge/Currency-%E0%A7%B3%20BDT-F42A41?style=for-the-badge)](https://github.com/theshoaibme/kivorly)
[![Build Status](https://img.shields.io/badge/CI%2FCD-Passing-34C759?style=for-the-badge&logo=github-actions&logoColor=white)](https://github.com/theshoaibme/kivorly/actions)

<p align="center">
  <b>One unified app for everything you need daily across Dhaka and all 64 districts.</b><br>
  Rides, Inter-city Travel, Express Parcels, Brand Shopping, Daily Groceries, Luxury Resort Packages, Food, and Home Services.
</p>

</div>

---

## 📱 App Highlights & Interface

### Core Experience

| Home Dashboard | Explore Hub | Orders & History |
| :---: | :---: | :---: |
| <img src="docs/screenshots/01_home_dashboard.png" width="260"/> | <img src="docs/screenshots/02_explore_directory.png" width="260"/> | <img src="docs/screenshots/03_orders_history.png" width="260"/> |

| Live Activity & Tracking | User Profile & Settings |
| :---: | :---: |
| <img src="docs/screenshots/04_activity_live.png" width="260"/> | <img src="docs/screenshots/05_profile_settings.png" width="260"/> |

---

## 🚀 8 Dedicated Service Verticals

### 1. 🚗 Ride Sharing & 2. 🎫 Tickets & Travel

| Ride Sharing (Dhaka Map) | Inter-City Tickets (Bus, Air, Train, Launch) |
| :---: | :---: |
| <img src="docs/screenshots/06_service_ride_sharing.png" width="360"/> | <img src="docs/screenshots/07_service_tickets.png" width="360"/> |
| Instant rides across Gulshan, Banani, Dhanmondi, Uttara with live vehicle tracking and fair pricing. | Multi-modal travel booking covering domestic flights, AC sleeper buses, trains, and river launches. |

### 3. 📦 Parcel Delivery & 4. 🛍️ Online Shopping Mall

| Express Parcel Courier | Kivorly Shopping Mall |
| :---: | :---: |
| <img src="docs/screenshots/08_service_parcel_delivery.png" width="360"/> | <img src="docs/screenshots/09_service_online_shopping.png" width="360"/> |
| Same-day city courier and nationwide delivery across all 64 districts with Cash on Delivery (COD). | Official brand stores featuring Aarong, Yellow, Apex, Walton, and Xiaomi with size & color pickers. |

### 5. 🥬 Daily Fresh Grocery Bazaar & 6. 🏖️ Hotels & Resort Packages

| Daily Fresh Grocery Bazaar | Hotel & Staycation Packages |
| :---: | :---: |
| <img src="docs/screenshots/10_service_grocery.png" width="360"/> | <img src="docs/screenshots/11_service_hotel_packages.png" width="360"/> |
| 1-hour express delivery for Padma River Ilish, fresh vegetables, farm eggs, pantry essentials, and meat. | Flexible stays: 1-Day Day-cation, 1-3 Nights, 1 Week, 1 Month, and VIP Luxury across Cox's Bazar & Sajek. |

### 7. 🍔 Food Delivery & 8. 🛠️ Home Services

| Authentic Food Delivery | Verified Home Services |
| :---: | :---: |
| <img src="docs/screenshots/12_service_food_delivery.png" width="360"/> | <img src="docs/screenshots/13_service_home_services.png" width="360"/> |
| Craving Sultan's Dine, Kacchi Bhai, or Chillox? Fast doorstep delivery with hot packaging. | Certified AC servicing, electrical masters, plumbing, and deep home sanitization with 30-day warranty. |

---

## ✨ What Makes Kivorly Special

- **Made for Bangladesh**: Custom-tailored for Dhaka and all 64 districts nationwide.
- **Transparent Pricing in Taka (`৳`)**: No hidden fees, instant currency breakdown on every transaction.
- **Local Payment Gateways**: Seamless integration with **bKash**, **Nagad**, and **Cash on Delivery**.
- **Live Order Tracking**: Dynamic Island notifications and real-time status updates from dispatch to doorstep.
- **Clean & Elegant Design**: Thoughtful typography, smooth transitions, and delightful user experience.

---

## 🏗️ Multi-Platform Monorepo Architecture

```
kivorly/
├── ios/                    # 🍏 Native Apple iOS Application (iOS 17+)
│   ├── Kivorly.xcodeproj   # Xcode Project (Target & Scheme: Kivorly)
│   └── Kivorly/            # Core, Features, Shared Components, and Assets.xcassets
├── android/                # 🤖 Native Android Application (Kotlin & Jetpack Compose)
│   ├── app/                # Application module (Clean Architecture & Compose UI)
│   ├── gradle/             # Gradle wrapper & Version Catalog (libs.versions.toml)
│   └── build.gradle.kts    # Gradle build configuration
├── web/                    # 🌐 Web Portal & Responsive Landing (Next.js 16 + React 19)
│   ├── src/app/            # App Router with live interactive vertical showcase
│   └── public/             # Static brand assets & service screenshots
├── docs/                   # 📸 App screenshots & UI documentation
└── .github/workflows/      # ⚙️ Multi-platform automated CI/CD pipelines
```

---

## 🛠️ Getting Started

### 1. 🍏 iOS Application

- **Requirements**: macOS Sonoma/Sequoia, Xcode 16+, iOS 17.0+
- **Open Project**:
  ```bash
  open ios/Kivorly.xcodeproj
  ```
- **CLI Build**:
  ```bash
  xcodebuild build \
    -project ios/Kivorly.xcodeproj \
    -scheme Kivorly \
    -destination "generic/platform=iOS Simulator" \
    CODE_SIGNING_ALLOWED=NO
  ```

### 2. 🤖 Android Application

- **Requirements**: Android Studio Ladybug+, Java 17, Android SDK 35
- **Build Debug APK**:
  ```bash
  cd android
  ./gradlew assembleDebug
  ```

### 3. 🌐 Web Portal (Next.js)

- **Requirements**: Node.js 20+, pnpm 10+
- **Development Server**:
  ```bash
  cd web
  pnpm install
  pnpm dev
  ```
- **Production Build**:
  ```bash
  pnpm --dir web build
  ```

---

<div align="center">
  <sub>Copyright © 2026 Kivorly Technologies. All rights reserved.</sub>
</div>
