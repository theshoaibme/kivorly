//
//  RideModels.swift
//  Kivorly
//
//  Streamlined models for Uber-style ride sharing: compact vehicle sizes (SM, STD, MD, XL, XXL, VIP),
//  categories (Bikes, Cars, XL/XXL, Premier), COD & MFS payment badges, drivers, and routes.
//

import SwiftUI
import CoreLocation

public enum RideStage: String {
    case selectingDestination
    case choosingTier
    case findingDriver
    case driverEnRoute
    case tripInProgress
    case tripCompleted
}

public enum VehicleCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case bike = "Bikes"
    case car = "Cars"
    case large = "XL & XXL"
    case premier = "Premier"

    public var id: String { rawValue }

    public var icon: String {
        switch self {
        case .all: return "sparkles"
        case .bike: return "bicycle"
        case .car: return "car.fill"
        case .large: return "car.2.fill"
        case .premier: return "crown.fill"
        }
    }
}

public enum VehicleSize: String, CaseIterable {
    case sm = "SM"
    case std = "STD"
    case md = "MD"
    case xl = "XL"
    case xxl = "XXL"
    case vip = "VIP"

    public var badgeColor: Color {
        switch self {
        case .sm: return Color(red: 0x10 / 255.0, green: 0xB9 / 255.0, blue: 0x81 / 255.0) // Emerald
        case .std: return Color(red: 0x25 / 255.0, green: 0x63 / 255.0, blue: 0xEB / 255.0) // Royal Blue
        case .md: return Color(red: 0x06 / 255.0, green: 0xB6 / 255.0, blue: 0xD4 / 255.0)  // Cyan
        case .xl: return Color(red: 0xF9 / 255.0, green: 0x73 / 255.0, blue: 0x16 / 255.0) // Coral Orange
        case .xxl: return Color(red: 0x8B / 255.0, green: 0x5C / 255.0, blue: 0xF6 / 255.0)// Purple
        case .vip: return Color(red: 0xE1 / 255.0, green: 0x1D / 255.0, blue: 0x48 / 255.0)// Crimson
        }
    }
}

public struct RideTier: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let price: Double
    public let priceText: String
    public let etaText: String
    public let capacity: Int
    public let luggageCapacity: Int
    public let size: VehicleSize
    public let category: VehicleCategory
    public let iconName: String
    public let vehicleDescription: String

    public init(
        id: String,
        title: String,
        subtitle: String,
        price: Double,
        priceText: String,
        etaText: String,
        capacity: Int,
        luggageCapacity: Int,
        size: VehicleSize,
        category: VehicleCategory,
        iconName: String,
        vehicleDescription: String
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.priceText = priceText
        self.etaText = etaText
        self.capacity = capacity
        self.luggageCapacity = luggageCapacity
        self.size = size
        self.category = category
        self.iconName = iconName
        self.vehicleDescription = vehicleDescription
    }

    public static let sampleTiers: [RideTier] = [
        // Bikes
        RideTier(
            id: "bike_sm",
            title: "Kivorly Bike",
            subtitle: "Solo scooty",
            price: 110,
            priceText: "৳110",
            etaText: "2 min",
            capacity: 1,
            luggageCapacity: 1,
            size: .sm,
            category: .bike,
            iconName: "bicycle",
            vehicleDescription: "125cc Scooty"
        ),
        RideTier(
            id: "bike_std",
            title: "Kivorly Moto",
            subtitle: "Fast commuter",
            price: 150,
            priceText: "৳150",
            etaText: "3 min",
            capacity: 1,
            luggageCapacity: 1,
            size: .std,
            category: .bike,
            iconName: "motorcycle",
            vehicleDescription: "150cc Commuter"
        ),

        // Cars - SM, STD, MD
        RideTier(
            id: "car_sm",
            title: "Kivorly Mini",
            subtitle: "Compact AC",
            price: 290,
            priceText: "৳290",
            etaText: "3 min",
            capacity: 3,
            luggageCapacity: 1,
            size: .sm,
            category: .car,
            iconName: "car.fill",
            vehicleDescription: "Alto / Spacia AC"
        ),
        RideTier(
            id: "car_std",
            title: "Kivorly Sedan",
            subtitle: "Standard AC",
            price: 390,
            priceText: "৳390",
            etaText: "4 min",
            capacity: 4,
            luggageCapacity: 2,
            size: .std,
            category: .car,
            iconName: "car.side.fill",
            vehicleDescription: "Axio / Corolla AC"
        ),
        RideTier(
            id: "car_md",
            title: "Kivorly Comfort",
            subtitle: "Extra legroom",
            price: 560,
            priceText: "৳560",
            etaText: "5 min",
            capacity: 4,
            luggageCapacity: 3,
            size: .md,
            category: .car,
            iconName: "car.side.rear.open.fill",
            vehicleDescription: "Premio / Allion AC"
        ),

        // Large - XL & XXL
        RideTier(
            id: "car_xl",
            title: "Kivorly Car XL",
            subtitle: "6-Seater SUV",
            price: 780,
            priceText: "৳780",
            etaText: "5 min",
            capacity: 6,
            luggageCapacity: 4,
            size: .xl,
            category: .large,
            iconName: "suv.side.fill",
            vehicleDescription: "Honda BR-V • 6 Seats"
        ),
        RideTier(
            id: "car_xxl",
            title: "Kivorly Car XXL",
            subtitle: "8-Seater Van",
            price: 1150,
            priceText: "৳1,150",
            etaText: "7 min",
            capacity: 8,
            luggageCapacity: 6,
            size: .xxl,
            category: .large,
            iconName: "car.2.fill",
            vehicleDescription: "Toyota HiAce • 8 Seats"
        ),

        // Premier
        RideTier(
            id: "car_vip",
            title: "Kivorly Premier",
            subtitle: "Luxury Sedan",
            price: 1450,
            priceText: "৳1,450",
            etaText: "6 min",
            capacity: 4,
            luggageCapacity: 3,
            size: .vip,
            category: .premier,
            iconName: "crown.fill",
            vehicleDescription: "Crown / Camry VIP"
        )
    ]
}

public struct RidePaymentMethod: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let badgeText: String
    public let badgeColor: Color
    public let iconName: String
    public let isCashOnDelivery: Bool

    public init(
        id: String,
        title: String,
        subtitle: String,
        badgeText: String,
        badgeColor: Color,
        iconName: String,
        isCashOnDelivery: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.badgeText = badgeText
        self.badgeColor = badgeColor
        self.iconName = iconName
        self.isCashOnDelivery = isCashOnDelivery
    }

    public static let availableMethods: [RidePaymentMethod] = [
        RidePaymentMethod(
            id: "cod",
            title: "Cash (COD)",
            subtitle: "Pay cash to driver",
            badgeText: "COD",
            badgeColor: Color(red: 0x10 / 255.0, green: 0xB9 / 255.0, blue: 0x81 / 255.0),
            iconName: "banknote.fill",
            isCashOnDelivery: true
        ),
        RidePaymentMethod(
            id: "bkash",
            title: "bKash Digital",
            subtitle: "Auto-debit MFS",
            badgeText: "bKash",
            badgeColor: Color(red: 0xE2 / 255.0, green: 0x13 / 255.0, blue: 0x6E / 255.0),
            iconName: "iphone.radiowaves.left.and.right"
        ),
        RidePaymentMethod(
            id: "nagad",
            title: "Nagad Wallet",
            subtitle: "Mobile banking",
            badgeText: "Nagad",
            badgeColor: Color(red: 0xF7 / 255.0, green: 0x93 / 255.0, blue: 0x1E / 255.0),
            iconName: "creditcard.circle.fill"
        ),
        RidePaymentMethod(
            id: "wallet",
            title: "Kivorly Balance",
            subtitle: "৳2,450 balance",
            badgeText: "৳2,450",
            badgeColor: Color(red: 0x25 / 255.0, green: 0x63 / 255.0, blue: 0xEB / 255.0),
            iconName: "wallet.pass.fill"
        ),
        RidePaymentMethod(
            id: "card",
            title: "Card",
            subtitle: "Visa ending in 4119",
            badgeText: "Visa",
            badgeColor: Color(red: 0x7C / 255.0, green: 0x3A / 255.0, blue: 0xED / 255.0),
            iconName: "creditcard.fill"
        )
    ]
}

public struct RideDriver {
    public let name: String
    public let rating: Double
    public let totalTrips: Int
    public let carModel: String
    public let licensePlate: String
    public let phone: String

    public static let sample = RideDriver(
        name: "Rashidul Hasan",
        rating: 4.95,
        totalTrips: 1840,
        carModel: "Premio Hybrid",
        licensePlate: "DHK METRO-GA-34-8921",
        phone: "+880 1711-234567"
    )
}

public struct RideLocationPoint: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let subtitle: String
    public let coordinate: CLLocationCoordinate2D

    public static func == (lhs: RideLocationPoint, rhs: RideLocationPoint) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static let sampleDestinations: [RideLocationPoint] = [
        RideLocationPoint(
            title: "Banani 11",
            subtitle: "Road 11, Block D, Banani",
            coordinate: CLLocationCoordinate2D(latitude: 23.7937, longitude: 90.4043)
        ),
        RideLocationPoint(
            title: "Airport Terminal 2",
            subtitle: "Airport Road, Dhaka",
            coordinate: CLLocationCoordinate2D(latitude: 23.8433, longitude: 90.4034)
        ),
        RideLocationPoint(
            title: "Dhanmondi Lake",
            subtitle: "Road 32, Dhanmondi",
            coordinate: CLLocationCoordinate2D(latitude: 23.7516, longitude: 90.3770)
        ),
        RideLocationPoint(
            title: "Bashundhara City",
            subtitle: "Panthapath, Dhaka",
            coordinate: CLLocationCoordinate2D(latitude: 23.7510, longitude: 90.3908)
        )
    ]
}
