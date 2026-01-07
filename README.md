# 🌊 CityToCoast App – Baby & Pet Sitting Platform

CityToCoast is a Flutter-powered mobile app designed to connect families across the Sunshine Coast, Gold Coast, and Brisbane with trusted babysitters and pet sitters.  
Built with ❤️ using Flutter, Firebase, and Stripe.

---

## 📱 Features

- 👶 Browse & book trusted babysitters and childcare helpers  
- 🐶 Book pet sitters for cats, dogs, and more  
- ⭐ Sitter profiles with images, reviews & ratings  
- 📅 Real-time availability (calendar slots)  
- 💬 Messaging system (upcoming)
- 💳 Secure payments powered by Stripe  
- 🔐 Firebase Authentication & Firestore  
- 🌐 Fully cross-platform (Android/iOS/Web ready)

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/20031144-afk/Citytocoast_app.git
cd Citytocoast_app

###Install Flutter Dependencies
flutter pub get

🔧 Environment Configuration (Required)

This project does not commit secrets.
Every developer must create their own .env.

Create .env in project root:
# Stripe Keys
STRIPE_SECRET_KEY=your_stripe_secret_key
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key

🛠 Troubleshooting

❌ App won’t build

Run flutter pub get

Make sure you have Firebase config files

❌ Payment errors

Check .env exists

Confirm Stripe test keys added

❌ Firestore permission issues

Verify rules in Firebase console

❌ Functions failing

cd functions
npm install
firebase functions:config:get


---

### Bonus Files You Should Add

#### `.env.example`
```env
STRIPE_SECRET_KEY=
STRIPE_PUBLISHABLE_KEY=

