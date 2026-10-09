package com.kivorly.app.core.navigation

sealed class Screen(val route: String, val title: String, val icon: String) {
    object Home : Screen("home", "Home", "🏠")
    object Explore : Screen("explore", "Explore", "🧭")
    object Activity : Screen("activity", "Activity", "⚡")
    object Orders : Screen("orders", "Orders", "🧾")
    object Profile : Screen("profile", "Profile", "👤")
    object RideBooking : Screen("ride_booking", "Ride Booking", "🚗")
}
