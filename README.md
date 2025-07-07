````markdown
# 📱 SalesApp

A mobile sales and inventory management app built with **Flutter** and **SQLite** — made with ❤️ for managing customers, phones, partners, sales, transactions, and installment payments, all offline!

---

## 🚀 Features

- 📦 **Phone Inventory** – Add and track phones with cost prices.
- 👤 **Customers & Partners** – Manage customer details and partner investments.
- 💰 **Sales Tracking** – Record sales with down payments and installments.
- 📆 **Installments** – Track and update installment payments.
- 📊 **Transaction Summary** – View incoming/outgoing funds and profit sharing.
- 📂 **CSV Report Export** – Export all tables (customers, phones, sales, etc.) to downloadable CSVs.
- 📱 **Offline First** – Works without internet using local SQLite.



## 🛠️ Tech Stack

- **Flutter** (Stateful Widgets, Material Design)
- **SQLite (sqflite)** – Local database
- **permission_handler** – Storage permissions
- **csv** – Export data
- **path_provider** – Access device file paths

---

## 📁 Folder Structure (Simplified)

```bash
lib/
├── models/              # Data Models (Customer, Phone, Sale, etc.)
├── services/            # SQLite DB service
├── screens/             # UI Screens for listing and adding data
├── widgets/             # Shared widgets like custom drawer
├── main.dart            # App Entry Point
````

---

## 🧪 Setup Instructions

1. **Clone the repo**

```bash
git clone https://github.com/malakafaqahmad/salesapp.git
cd salesapp
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

> 💡 Make sure you have an Android emulator or physical device connected.

---


## 📤 Export CSV Feature

From the **Report Screen**, you can export all tables as CSV files to the device's **Downloads** folder. Make sure to allow storage permission when asked.

---

## 👨‍💻 Author

**Malak Afaq Ahmad**
📧 [u2022672@giki.edu.pk](mailto:u2022672@giki.edu.pk)

---

Apk-File: https://drive.google.com/file/d/1vCUqE4Ci-GHABPvf-B8mqhH6SozuKEGo/view?usp=drive_link
