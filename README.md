# E-Commerce_app

Demo Login Credentials
- Username / Email: demo@gmail.com
- Password: 123456

This project is a mobile e-commerce application developed using Flutter and Dart. It provides users with a simple and modern shopping experience where they can browse products, explore fashion categories, view product information, and manage their shopping cart.
1. Technologies Used
    - Flutter: Used to build the mobile application's user interface.
    - Dart: Main programming language used for application development.
    - REST API: Used to fetch product information from the DummyJSON API.
    - HTTP Package: Handles API requests and receives product data in JSON format.
    - Provider: Used for state management, especially for managing cart items across different screens.
    - Lottie: Used to display smooth animations on the splash and login screens.
    - Material Design: Used to create a modern and responsive user interface.
2. Application Architecture
    The application follows a modular structure by separating screens, models, services, providers, and reusable widgets.
    - Screens: Contains different pages such as Splash, Login, Home, Explore, Cart, and Profile.
    - Models: Defines the product data structure and handles JSON data conversion.
    - Services: Manages API communication and fetches product information.
    - Providers: Manages application state, such as adding and removing products from the cart.
    - Widgets: Contains reusable UI components such as product cards, category sections, and trending product sections.
3. API Integration
    The application uses the DummyJSON REST API to retrieve product information.
    - Sends HTTP GET requests to the API.
    - Receives product data in JSON format.
    - Converts JSON responses into Dart model objects.
    - Displays product images, names, prices, ratings, and categories.
    - Supports category-based product filtering, including fashion products.
4. State Management
    The Provider package is used to manage the shopping cart.
    - Users can add products from Home or Explore screens.
    - Cart data is shared across different screens.
    - Users can increase or decrease product quantities.
    - Users can remove products from the cart.
    - Cart totals are updated when the cart changes.
5. User Interface and Navigation
    The application includes:
    - Animated splash screen.
    - Login screen with form validation.
    - Home screen with product sections.
    - Explore screen for browsing and searching products.
    - Fashion product collections.
    - Product cards with images, ratings, and prices.
    - Shopping cart screen.
    - Profile screen with user-related options.
    - Bottom navigation for easy movement between main screens.
6. Main Objective
The main objective of this project is to develop a user-friendly and responsive e-commerce mobile application while implementing   practical Flutter development concepts such as REST API integration, state management, reusable widgets, navigation, asynchronous         programming, and clean code organization.

Note: The current application uses DummyJSON for product data and demonstrates the shopping workflow. It does not yet represent a complete production e-commerce system with real payments, order processing, or backend authentication.
