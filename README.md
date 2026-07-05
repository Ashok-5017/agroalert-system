# 🌾 AgroAlert – AI-Powered Smart Farmer Alert System

AgroAlert is an AI-powered smart farming solution that delivers real-time weather alerts, crop advisories, and market information to farmers through a Flutter mobile application. The system helps farmers protect their crops from floods, droughts, pest attacks, and other extreme weather conditions by providing timely notifications in Tamil via WhatsApp.

---

# 🎯 Problem Statement

Every year, farmers in Tamil Nadu experience significant crop losses due to unpredictable weather and delayed information.

Major challenges include:

- 🌧️ No early warning for floods and heavy rainfall
- ☀️ Delayed drought and heatwave notifications
- 🐛 Lack of pest attack predictions
- 🌾 Weather information not available in Tamil
- 🏪 Limited access to live market (Mandi) prices
- 📢 Delayed communication resulting in crop damage

---

# 💡 Solution

AgroAlert provides an intelligent alert system that combines weather forecasting, AI-based crop advisory, and WhatsApp notifications.

### Key Features

- 📱 Phone number-based farmer login
- 🌦️ Real-time weather monitoring
- 📅 7-day weather forecast
- 🌱 AI-based crop advisory
- ⚠️ Automatic weather risk detection
- 💬 WhatsApp alerts in Tamil
- 🏪 Live Mandi market prices
- 👨‍🌾 Farmer registration and profile management
- ⚙️ Notification preferences

---

# 🏗️ System Architecture

```text
                   OpenWeather API
                          │
                          ▼
                 FastAPI Backend (Python)
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
 PostgreSQL         Alert Engine      Twilio WhatsApp
 Database          (Weather Rules)        Sandbox
        ▲                 │                 │
        └─────────────────┼─────────────────┘
                          ▼
                Flutter Mobile Application
                          │
                          ▼
                       Farmers
```

---

# 🛠️ Tech Stack

| Layer | Technology |
|--------|------------|
| Mobile Application | Flutter (Dart) |
| Backend | FastAPI (Python) |
| Database | PostgreSQL |
| Admin Dashboard | React.js |
| Weather Service | OpenWeatherMap API |
| WhatsApp Alerts | Twilio WhatsApp Sandbox |
| Deployment | Render.com |

---

# 📱 Mobile Application Features

- 🔑 Phone Number Login
- 🏠 Home Dashboard with Live Weather
- 🌦️ Current Weather Information
- 🌱 Crop Advisory
- 📅 7-Day Weather Forecast
- ⚠️ Weather Alert Notifications
- 🏪 Live Mandi Prices
- 📝 Farmer Registration
- ⚙️ Notification Settings

---

# 🚀 Getting Started

## Backend

```bash
cd backend

python -m venv venv

# Windows
.\venv\Scripts\Activate.ps1

pip install -r requirements.txt

uvicorn main:app --reload --host 0.0.0.0
```

## React Admin Dashboard

```bash
cd admin

npm install

npm run dev
```

## Flutter Mobile App

```bash
cd mobile_app/farmer_app

flutter pub get

flutter run -d chrome --web-browser-flag "--disable-web-security"
```

---

# 🌐 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/farmers/register` | Register a new farmer |
| POST | `/farmers/login` | Farmer login |
| GET | `/farmers/all` | Get all farmers |
| GET | `/weather/forecast` | Fetch weather forecast |
| POST | `/alerts/check` | Generate weather alerts |
| GET | `/alerts/active` | Get active alerts |
| POST | `/alerts/send-sms` | Send WhatsApp alert |
| POST | `/whatsapp/webhook` | WhatsApp chatbot webhook |

---

# 🔧 Environment Variables

Create a `.env` file inside the **backend** folder.

```env
DATABASE_URL=postgresql://user:password@localhost/agroalert_db

SECRET_KEY=your_secret_key

WEATHER_API_KEY=your_openweathermap_api_key

TWILIO_ACCOUNT_SID=your_twilio_sid

TWILIO_AUTH_TOKEN=your_twilio_token

TWILIO_WHATSAPP_FROM=whatsapp:+14155238886

TO_WHATSAPP_NUMBER=whatsapp:+91XXXXXXXXXX
```

---

# 📊 Smart Alert System

AgroAlert automatically generates alerts based on weather conditions.

| Weather Condition | Alert Type | Severity |
|-------------------|------------|----------|
| Rainfall > 100 mm | Flood | 🔴 Critical |
| Rainfall < 2 mm & Humidity < 30% | Drought | 🟠 High |
| Humidity > 85% & Temperature > 28°C | Pest Attack | 🟡 Medium |
| Temperature > 40°C | Heatwave | 🟠 High |

---

# 🌾 Project Impact

AgroAlert helps farmers by:

- ✅ Delivering early disaster warnings
- ✅ Reducing crop losses by up to **40%**
- ✅ Providing alerts in Tamil
- ✅ Supporting affordable Android devices
- ✅ Delivering notifications through WhatsApp
- ✅ Reaching hundreds of farmers simultaneously

---

# 👥 Project Information

**Project Name:** AgroAlert

**Domain:** Smart Agriculture / Industry 4.0

**Theme:** Agricultural Technology

**Target Users:** Small and Medium Farmers in Tamil Nadu
