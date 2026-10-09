package com.kivorly.app.shared.models

data class ServiceVertical(
    val id: String,
    val title: String,
    val banglaTitle: String,
    val icon: String,
    val description: String,
    val badge: String
)

object ServiceDataProvider {
    val verticals = listOf(
        ServiceVertical(
            id = "rides",
            title = "Ride Sharing",
            banglaTitle = "রাইড শেয়ারিং",
            icon = "🚗",
            description = "Dhaka City Rides, Cars & Bikes",
            badge = "Live GPS"
        ),
        ServiceVertical(
            id = "tickets",
            title = "Tickets & Travel",
            banglaTitle = "টিকিট ও ভ্রমণ",
            icon = "🎫",
            description = "Air, Train, Bus & Launch",
            badge = "64 Districts"
        ),
        ServiceVertical(
            id = "courier",
            title = "Express Courier",
            banglaTitle = "পার্সেল ও কুরিয়ার",
            icon = "📦",
            description = "Same-Day Doorstep Delivery",
            badge = "Instant"
        ),
        ServiceVertical(
            id = "mall",
            title = "Shopping Mall",
            banglaTitle = "অনলাইন শপিং মল",
            icon = "🛍️",
            description = "Aarong, Apex, Yellow & Walton",
            badge = "Authentic"
        ),
        ServiceVertical(
            id = "grocery",
            title = "Daily Grocery",
            banglaTitle = "তাজা মুদি বাজার",
            icon = "🥬",
            description = "Fresh Fish, Veggies & Meat",
            badge = "1-Hour"
        ),
        ServiceVertical(
            id = "hotels",
            title = "Hotels & Stays",
            banglaTitle = "হোটেল ও রিসোর্ট",
            icon = "🏖️",
            description = "Cox's Bazar, Sajek & Sylhet",
            badge = "Best Rate"
        ),
        ServiceVertical(
            id = "food",
            title = "Food Delivery",
            banglaTitle = "খাবার ডেলিভারি",
            icon = "🍔",
            description = "Sultan's Dine & Top Restaurants",
            badge = "Hot & Fresh"
        ),
        ServiceVertical(
            id = "services",
            title = "Home Services",
            banglaTitle = "হোম সার্ভিস",
            icon = "🛠️",
            description = "AC Repair, Cleaning & Electrician",
            badge = "Warranty"
        )
    )
}
