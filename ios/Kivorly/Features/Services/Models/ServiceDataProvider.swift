//
//  ServiceDataProvider.swift
//  Kivorly
//
//  Central provider delivering dynamic mock data & configurations across all Kivorly verticals in Bangladeshi Taka (৳).
//

import SwiftUI

public enum ServiceDataProvider {
    public static func items(for type: ServiceType) -> [ServiceItemModel] {
        switch type {
        case .rideSharing:
            return [
                ServiceItemModel(
                    title: "Kivorly Eco (Sedan)",
                    category: "City Ride",
                    priceText: "৳350",
                    numericPrice: 350.0,
                    rating: 4.9,
                    reviewCount: 1420,
                    etaOrDuration: "3 min away",
                    icon: "car.fill",
                    serviceType: .rideSharing,
                    badges: ["Popular", "Quick Pickup"]
                ),
                ServiceItemModel(
                    title: "Kivorly Comfort (SUV)",
                    category: "Spacious",
                    priceText: "৳650",
                    numericPrice: 650.0,
                    rating: 4.95,
                    reviewCount: 880,
                    etaOrDuration: "5 min away",
                    icon: "car.side.fill",
                    serviceType: .rideSharing,
                    badges: ["Top Rated", "Extra Legroom"]
                ),
                ServiceItemModel(
                    title: "Kivorly Bike (Express)",
                    category: "Fastest Commute",
                    priceText: "৳150",
                    numericPrice: 150.0,
                    rating: 4.8,
                    reviewCount: 3200,
                    etaOrDuration: "2 min away",
                    icon: "bicycle",
                    serviceType: .rideSharing,
                    badges: ["Beat Traffic", "Budget"]
                ),
                ServiceItemModel(
                    title: "Kivorly Premier (Luxury)",
                    category: "Executive",
                    priceText: "৳1,200",
                    numericPrice: 1200.0,
                    rating: 5.0,
                    reviewCount: 410,
                    etaOrDuration: "7 min away",
                    icon: "car.2.fill",
                    serviceType: .rideSharing,
                    badges: ["VIP Driver", "Premium"]
                )
            ]

        case .foodDelivery:
            return [
                ServiceItemModel(
                    title: "Dhaka Shahi Kacchi Biryani",
                    category: "Biryani • Traditional",
                    priceText: "৳380",
                    numericPrice: 380.0,
                    rating: 4.95,
                    reviewCount: 2840,
                    etaOrDuration: "20-30 min",
                    icon: "fork.knife",
                    serviceType: .foodDelivery,
                    badges: ["Heritage", "Best Seller"],
                    imageEmoji: nil,
                    imageAssetName: "food_kacchi_biryani"
                ),
                ServiceItemModel(
                    title: "Gourmet Angus Smash Burger",
                    category: "American • Burgers",
                    priceText: "৳450",
                    numericPrice: 450.0,
                    rating: 4.9,
                    reviewCount: 1540,
                    etaOrDuration: "15-25 min",
                    icon: "takeoutbag.and.cup.and.straw.fill",
                    serviceType: .foodDelivery,
                    badges: ["Top Rated", "Juicy Beef"],
                    imageEmoji: nil,
                    imageAssetName: "food_smash_burger"
                ),
                ServiceItemModel(
                    title: "Artisan Woodfired Pizza",
                    category: "Italian • Pizza",
                    priceText: "৳820",
                    numericPrice: 820.0,
                    rating: 4.88,
                    reviewCount: 920,
                    etaOrDuration: "25-35 min",
                    icon: "fork.knife",
                    serviceType: .foodDelivery,
                    badges: ["Chef's Pick", "Crispy Crust"],
                    imageEmoji: nil,
                    imageAssetName: "food_woodfired_pizza"
                ),
                ServiceItemModel(
                    title: "Crispy Naga Wings Platter",
                    category: "Fast Food • Chicken",
                    priceText: "৳320",
                    numericPrice: 320.0,
                    rating: 4.82,
                    reviewCount: 1120,
                    etaOrDuration: "15-20 min",
                    icon: "takeoutbag.and.cup.and.straw.fill",
                    serviceType: .foodDelivery,
                    badges: ["Hot & Spicy", "Popular"],
                    imageEmoji: nil,
                    imageAssetName: "food_naga_wings"
                ),
                ServiceItemModel(
                    title: "Tokyo Tonkotsu Ramen",
                    category: "Japanese • Asian",
                    priceText: "৳590",
                    numericPrice: 590.0,
                    rating: 4.92,
                    reviewCount: 780,
                    etaOrDuration: "25-35 min",
                    icon: "cup.and.saucer.fill",
                    serviceType: .foodDelivery,
                    badges: ["Authentic", "Rich Broth"],
                    imageEmoji: nil,
                    imageAssetName: "food_tonkotsu_ramen"
                ),
                ServiceItemModel(
                    title: "Fresh Superfood Salad Bowl",
                    category: "Healthy • Vegan",
                    priceText: "৳460",
                    numericPrice: 460.0,
                    rating: 4.75,
                    reviewCount: 430,
                    etaOrDuration: "15-20 min",
                    icon: "leaf.fill",
                    serviceType: .foodDelivery,
                    badges: ["Gluten-Free", "Fresh"],
                    imageEmoji: nil,
                    imageAssetName: "food_salad_bowl"
                ),
                ServiceItemModel(
                    title: "Fresh Salmon Sushi Roll Set",
                    category: "Japanese • Asian",
                    priceText: "৳750",
                    numericPrice: 750.0,
                    rating: 4.91,
                    reviewCount: 520,
                    etaOrDuration: "25-30 min",
                    icon: "fork.knife",
                    serviceType: .foodDelivery,
                    badges: ["Premium", "Fresh Catch"],
                    imageEmoji: nil,
                    imageAssetName: "food_sushi_rolls"
                ),
                ServiceItemModel(
                    title: "Royal Mango Falooda & Kulfi",
                    category: "Dessert • Sweets",
                    priceText: "৳240",
                    numericPrice: 240.0,
                    rating: 4.88,
                    reviewCount: 650,
                    etaOrDuration: "10-15 min",
                    icon: "cup.and.saucer.fill",
                    serviceType: .foodDelivery,
                    badges: ["Chilled", "Sweet Tooth"],
                    imageEmoji: nil,
                    imageAssetName: "food_falooda_dessert"
                ),
                ServiceItemModel(
                    title: "Old Dhaka Mustard Beef Tehari",
                    category: "Biryani • Traditional",
                    priceText: "৳290",
                    numericPrice: 290.0,
                    rating: 4.90,
                    reviewCount: 1850,
                    etaOrDuration: "20-25 min",
                    icon: "fork.knife",
                    serviceType: .foodDelivery,
                    badges: ["Authentic Mustard", "Tender Beef"],
                    imageEmoji: nil,
                    imageAssetName: "food_beef_tehari"
                ),
                ServiceItemModel(
                    title: "Delhi Butter Chicken with Naan",
                    category: "Traditional • Curry",
                    priceText: "৳520",
                    numericPrice: 520.0,
                    rating: 4.89,
                    reviewCount: 1420,
                    etaOrDuration: "20-30 min",
                    icon: "fork.knife",
                    serviceType: .foodDelivery,
                    badges: ["Creamy Rich", "Chef's Pick"],
                    imageEmoji: nil,
                    imageAssetName: "food_butter_chicken"
                ),
                ServiceItemModel(
                    title: "Signature Cold Brew Iced Latte",
                    category: "Beverage • Coffee",
                    priceText: "৳280",
                    numericPrice: 280.0,
                    rating: 4.93,
                    reviewCount: 940,
                    etaOrDuration: "10-15 min",
                    icon: "cup.and.saucer.fill",
                    serviceType: .foodDelivery,
                    badges: ["Specialty Roast", "Chilled"],
                    imageEmoji: nil,
                    imageAssetName: "food_iced_coffee"
                ),
                ServiceItemModel(
                    title: "Molten Belgian Lava Cake",
                    category: "Dessert • Sweets",
                    priceText: "৳340",
                    numericPrice: 340.0,
                    rating: 4.94,
                    reviewCount: 880,
                    etaOrDuration: "15-20 min",
                    icon: "cup.and.saucer.fill",
                    serviceType: .foodDelivery,
                    badges: ["Warm Chocolate", "Indulgent"],
                    imageEmoji: nil,
                    imageAssetName: "food_chocolate_cake"
                )
            ]

        case .shopping:
            return [
                ServiceItemModel(
                    title: "Royal Silk Embroidered Panjabi",
                    category: "Aarong Heritage",
                    priceText: "\u{09F3}3,450",
                    numericPrice: 3450.0,
                    rating: 4.92,
                    reviewCount: 1420,
                    etaOrDuration: "Express 24h",
                    icon: "tshirt.fill",
                    serviceType: .shopping,
                    badges: ["Official Store", "Nakshi Work"],
                    imageEmoji: "✨"
                ),
                ServiceItemModel(
                    title: "Slim-Fit Egyptian Cotton Shirt",
                    category: "Yellow Lifestyle",
                    priceText: "\u{09F3}2,200",
                    numericPrice: 2200.0,
                    rating: 4.86,
                    reviewCount: 890,
                    etaOrDuration: "Next Day",
                    icon: "tshirt.fill",
                    serviceType: .shopping,
                    badges: ["100% Cotton", "Best Seller"],
                    imageEmoji: "👔"
                ),
                ServiceItemModel(
                    title: "Xiaomi Redmi Note 13 Pro 5G",
                    category: "Xiaomi BD Official",
                    priceText: "\u{09F3}29,999",
                    numericPrice: 29999.0,
                    rating: 4.95,
                    reviewCount: 2150,
                    etaOrDuration: "Express Same-Day",
                    icon: "iphone",
                    serviceType: .shopping,
                    badges: ["BTRC Approved", "Official Warranty"],
                    imageEmoji: "📱"
                ),
                ServiceItemModel(
                    title: "Genuine Full-Grain Leather Oxford",
                    category: "Apex Formal",
                    priceText: "\u{09F3}4,800",
                    numericPrice: 4800.0,
                    rating: 4.89,
                    reviewCount: 640,
                    etaOrDuration: "Next Day",
                    icon: "shoeprints.fill",
                    serviceType: .shopping,
                    badges: ["Full Grain", "Comfort Foam"],
                    imageEmoji: "👞"
                ),
                ServiceItemModel(
                    title: "Walton Primo 4K Smart TV 43\"",
                    category: "Walton Hi-Tech",
                    priceText: "\u{09F3}34,500",
                    numericPrice: 34500.0,
                    rating: 4.88,
                    reviewCount: 920,
                    etaOrDuration: "Scheduled 24h",
                    icon: "tv.fill",
                    serviceType: .shopping,
                    badges: ["4K HDR", "5-Yr Warranty"],
                    imageEmoji: "📺"
                )
            ]

        case .grocery:
            return [
                ServiceItemModel(
                    title: "Padma River Deshi Ilish Fish",
                    category: "Fresh Fish",
                    priceText: "\u{09F3}1650",
                    numericPrice: 1650.0,
                    rating: 4.98,
                    reviewCount: 3120,
                    etaOrDuration: "30 min",
                    icon: "fish.fill",
                    serviceType: .grocery,
                    badges: ["River Fresh", "Daily Catch"],
                    imageAssetName: "grocery_ilish_fish",
                    imageUrl: "https://images.unsplash.com/photo-1534482421-64566f976cfa?w=600&auto=format&fit=crop&q=80"
                ),
                ServiceItemModel(
                    title: "Farm Fresh Brown Layer Eggs",
                    category: "Daily Essentials",
                    priceText: "\u{09F3}165",
                    numericPrice: 165.0,
                    rating: 4.92,
                    reviewCount: 2200,
                    etaOrDuration: "15 min",
                    icon: "basket.fill",
                    serviceType: .grocery,
                    badges: ["Organic", "Farm Direct"],
                    imageAssetName: "grocery_brown_eggs",
                    imageUrl: "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=600&auto=format&fit=crop&q=80"
                ),
                ServiceItemModel(
                    title: "Fresh Deshi Chicken (Dressed)",
                    category: "Meat & Poultry",
                    priceText: "\u{09F3}380",
                    numericPrice: 380.0,
                    rating: 4.88,
                    reviewCount: 1540,
                    etaOrDuration: "20 min",
                    icon: "flame.fill",
                    serviceType: .grocery,
                    badges: ["Antibiotic Free"],
                    imageAssetName: "grocery_chicken_meat",
                    imageUrl: "https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=600&auto=format&fit=crop&q=80"
                ),
                ServiceItemModel(
                    title: "Halal Beef Curry Cut",
                    category: "Meat & Poultry",
                    priceText: "\u{09F3}780",
                    numericPrice: 780.0,
                    rating: 4.95,
                    reviewCount: 1820,
                    etaOrDuration: "25 min",
                    icon: "fork.knife",
                    serviceType: .grocery,
                    badges: ["Bengal Meat", "Halal"],
                    imageAssetName: "grocery_beef_cut",
                    imageUrl: "https://images.unsplash.com/photo-1603048588665-791ca8aea617?w=600&auto=format&fit=crop&q=80"
                ),
                ServiceItemModel(
                    title: "Premium Miniket Rice (5kg)",
                    category: "Rice & Oil",
                    priceText: "\u{09F3}410",
                    numericPrice: 410.0,
                    rating: 4.91,
                    reviewCount: 940,
                    etaOrDuration: "20 min",
                    icon: "takeoutbag.and.cup.and.straw.fill",
                    serviceType: .grocery,
                    badges: ["100% Sorted"],
                    imageAssetName: "grocery_miniket_rice",
                    imageUrl: "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&auto=format&fit=crop&q=80"
                ),
                ServiceItemModel(
                    title: "Farm Fresh Ripe Tomatoes (1kg)",
                    category: "Fresh Vegetables",
                    priceText: "\u{09F3}60",
                    numericPrice: 60.0,
                    rating: 4.85,
                    reviewCount: 810,
                    etaOrDuration: "15 min",
                    icon: "leaf.fill",
                    serviceType: .grocery,
                    badges: ["Vine Ripe"],
                    imageAssetName: "grocery_ripe_tomatoes",
                    imageUrl: "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80"
                )
            ]

        case .courier:
            return [
                ServiceItemModel(
                    title: "City Express Parcel",
                    category: "Instant Delivery",
                    priceText: "৳120",
                    numericPrice: 120.0,
                    rating: 4.91,
                    reviewCount: 1800,
                    etaOrDuration: "45 min guaranteed",
                    icon: "shippingbox.fill",
                    serviceType: .courier,
                    badges: ["Live GPS", "Insured"]
                ),
                ServiceItemModel(
                    title: "Confidential Document Courier",
                    category: "Secure Transit",
                    priceText: "৳200",
                    numericPrice: 200.0,
                    rating: 4.98,
                    reviewCount: 520,
                    etaOrDuration: "60 min",
                    icon: "doc.text.fill",
                    serviceType: .courier,
                    badges: ["OTP Delivery", "Waterproof"]
                ),
                ServiceItemModel(
                    title: "Heavy Cargo & Furniture Van",
                    category: "Large Haul",
                    priceText: "৳1,500",
                    numericPrice: 1500.0,
                    rating: 4.85,
                    reviewCount: 390,
                    etaOrDuration: "Scheduled",
                    icon: "box.truck.fill",
                    serviceType: .courier,
                    badges: ["Helpers Included"]
                )
            ]

        case .homeServices:
            return [
                ServiceItemModel(
                    title: "AC Deep Master Servicing",
                    category: "Appliances",
                    priceText: "৳1,200",
                    numericPrice: 1200.0,
                    rating: 4.89,
                    reviewCount: 1450,
                    etaOrDuration: "1.5 hours",
                    icon: "snowflake",
                    serviceType: .homeServices,
                    badges: ["Certified Tech", "30-Day Warranty"]
                ),
                ServiceItemModel(
                    title: "Professional Home Deep Clean",
                    category: "Housekeeping",
                    priceText: "৳2,500",
                    numericPrice: 2500.0,
                    rating: 4.92,
                    reviewCount: 880,
                    etaOrDuration: "3.0 hours",
                    icon: "sparkles",
                    serviceType: .homeServices,
                    badges: ["Eco Products", "Background Checked"]
                ),
                ServiceItemModel(
                    title: "Plumbing Inspection & Repair",
                    category: "Repairs",
                    priceText: "৳500",
                    numericPrice: 500.0,
                    rating: 4.83,
                    reviewCount: 670,
                    etaOrDuration: "45 min",
                    icon: "wrench.and.screwdriver.fill",
                    serviceType: .homeServices,
                    badges: ["Prompt Response"]
                )
            ]

        case .tickets:
            return [
                ServiceItemModel(
                    title: "VIP Cinema Premiere: Sci-Fi Odyssey",
                    category: "Movies",
                    priceText: "৳650",
                    numericPrice: 650.0,
                    rating: 4.9,
                    reviewCount: 810,
                    etaOrDuration: "Tonight, 8:00 PM",
                    icon: "film.fill",
                    serviceType: .tickets,
                    badges: ["IMAX 3D", "Recliner"]
                ),
                ServiceItemModel(
                    title: "Inter-City Express Luxury Coach",
                    category: "Travel",
                    priceText: "৳1,100",
                    numericPrice: 1100.0,
                    rating: 4.88,
                    reviewCount: 2400,
                    etaOrDuration: "Daily Departures",
                    icon: "bus.fill",
                    serviceType: .tickets,
                    badges: ["WiFi", "AC Sleeper"]
                ),
                ServiceItemModel(
                    title: "Live Symphony & Acoustic Concert",
                    category: "Live Events",
                    priceText: "৳1,800",
                    numericPrice: 1800.0,
                    rating: 4.96,
                    reviewCount: 350,
                    etaOrDuration: "Sat, 7:30 PM",
                    icon: "music.note",
                    serviceType: .tickets,
                    badges: ["Reserved Seating"]
                )
            ]

        case .hotels:
            return [
                ServiceItemModel(
                    title: "The Grand Waterfront Resort & Spa",
                    category: "5-Star Luxury",
                    priceText: "৳8,500 / night",
                    numericPrice: 8500.0,
                    rating: 4.94,
                    reviewCount: 1120,
                    etaOrDuration: "Instant Booking",
                    icon: "bed.double.fill",
                    serviceType: .hotels,
                    badges: ["Infinity Pool", "Free Breakfast"]
                ),
                ServiceItemModel(
                    title: "Urban Skyline Boutique Hotel",
                    category: "City Center",
                    priceText: "৳4,800 / night",
                    numericPrice: 4800.0,
                    rating: 4.85,
                    reviewCount: 680,
                    etaOrDuration: "Instant Booking",
                    icon: "building.2.fill",
                    serviceType: .hotels,
                    badges: ["Rooftop Lounge", "Metro Nearby"]
                ),
                ServiceItemModel(
                    title: "Highland Forest Eco Lodge",
                    category: "Nature Retreat",
                    priceText: "৳6,200 / night",
                    numericPrice: 6200.0,
                    rating: 4.97,
                    reviewCount: 430,
                    etaOrDuration: "Instant Booking",
                    icon: "tent.fill",
                    serviceType: .hotels,
                    badges: ["Mountain Views", "Organic Meals"]
                )
            ]
        }
    }
}
