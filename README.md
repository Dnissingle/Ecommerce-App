# Grocery App

A responsive grocery shopping app built with Flutter and GetX. Product and category
catalogs, guest carts, customer accounts, stock, and orders are stored in Supabase.

## Features

- Responsive layouts, light/dark themes, and English/Arabic translations
- Supabase-backed catalog with search and category filters
- Persistent, per-customer carts and stock-aware checkout
- Email/password customer accounts and order history
- Atomic order creation with delivery address, phone, and cash-on-delivery status

## Tech stack

- Flutter and GetX
- Supabase Auth and Postgres with row-level security
- `flutter_screenutil`, `flutter_svg`, `carousel_slider`, and `flutter_animate`
- `shared_preferences` for local theme and language preferences

## Project structure

```text
lib/
├── app/
│   ├── components/       # Reusable UI widgets
│   ├── data/
│   │   ├── models/       # Category and product data models
│   │   ├── repositories/ # Supabase catalog, cart, order, and auth access
│   │   └── services/     # Supabase client initialization
│   ├── modules/          # Feature screens, controllers, and bindings
│   └── routes/           # App routing configuration
├── config/               # Themes and translations
└── main.dart             # Entry point
supabase/
└── migrations/           # Store schema, RLS policies, checkout RPC, seed data
```

## Supabase setup

1. Create a Supabase project and open its SQL Editor.
2. Run `supabase/migrations/20261119134500_store_schema.sql`.
3. In Supabase Authentication settings, enable **Anonymous Sign-Ins** and
   email/password authentication. Anonymous sessions support guest carts; customers
   can create an email/password account from the Profile tab.
4. Install dependencies:

   ```bash
   flutter pub get
   ```

5. Run the app with your project URL and public anon/publishable key:

   ```bash
   flutter run --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLIC_PUBLISHABLE_KEY
   ```

Use only the project URL and public anon/publishable key. Never put a Supabase
`service_role` key in a Flutter app. If either compile-time value is missing, the app
shows a setup error rather than silently using demo data.

The migration seeds the sample products and categories. Their `image_path` values
refer to bundled assets; public HTTPS image URLs are also supported.

## Assets

- Images: `assets/images/`
- SVG vectors: `assets/vectors/`
- Fonts: `assets/fonts/`
