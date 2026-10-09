//
//  ServiceType.swift
//  Kivorly
//
//  The 8 core services using harmonized palette tokens, authentic transparent 3D illustrations, and soft background colors.
//

import SwiftUI

public enum ServiceType: String, CaseIterable, Identifiable, Codable {
    case rideSharing = "ride_sharing"
    case foodDelivery = "food_delivery"
    case shopping = "shopping"
    case grocery = "grocery"
    case courier = "courier"
    case homeServices = "home_services"
    case tickets = "tickets"
    case hotels = "hotels"

    public var id: String { rawValue }

    public var title: String {
        switch self {
        case .rideSharing: return "Ride Sharing"
        case .foodDelivery: return "Food Delivery"
        case .shopping: return "Online Shopping"
        case .grocery: return "Grocery"
        case .courier: return "Parcel"
        case .homeServices: return "Home Services"
        case .tickets: return "Tickets"
        case .hotels: return "Hotels"
        }
    }

    public var shortTitle: String {
        switch self {
        case .rideSharing: return "Rides"
        case .foodDelivery: return "Food"
        case .shopping: return "Shopping"
        case .grocery: return "Grocery"
        case .courier: return "Parcel"
        case .homeServices: return "Services"
        case .tickets: return "Tickets"
        case .hotels: return "Hotels"
        }
    }

    public var systemIcon: String {
        switch self {
        case .rideSharing: return "car.fill"
        case .foodDelivery: return "fork.knife"
        case .shopping: return "bag.fill"
        case .grocery: return "basket.fill"
        case .courier: return "shippingbox.fill"
        case .homeServices: return "wrench.and.screwdriver.fill"
        case .tickets: return "ticket.fill"
        case .hotels: return "bed.double.fill"
        }
    }

    /// Real 3D rendered graphic asset name in xcassets (transparent background, centered)
    public var assetImageName: String {
        switch self {
        case .rideSharing: return "service_ride_sharing"
        case .foodDelivery: return "service_food_delivery"
        case .shopping: return "service_online_shopping"
        case .grocery: return "service_grocery"
        case .courier: return "service_courier"
        case .homeServices: return "service_home_services"
        case .tickets: return "service_tickets"
        case .hotels: return "service_hotels"
        }
    }

    /// Harmonized, curated premium accent palette for each service
    public var accentTint: Color {
        switch self {
        case .rideSharing:
            // Royal Electric Blue
            return Color(red: 0x25 / 255.0, green: 0x63 / 255.0, blue: 0xEB / 255.0)
        case .foodDelivery:
            // Sunset Coral Orange
            return Color(red: 0xF9 / 255.0, green: 0x73 / 255.0, blue: 0x16 / 255.0)
        case .shopping:
            // Deep Iris Purple
            return Color(red: 0x8B / 255.0, green: 0x5C / 255.0, blue: 0xF6 / 255.0)
        case .grocery:
            // Fresh Jade Emerald
            return Color(red: 0x10 / 255.0, green: 0xB9 / 255.0, blue: 0x81 / 255.0)
        case .courier:
            // Warm Amber Ochre
            return Color(red: 0xF5 / 255.0, green: 0x9E / 255.0, blue: 0x0B / 255.0)
        case .homeServices:
            // Clean Cyan / Lagoon Teal
            return Color(red: 0x06 / 255.0, green: 0xB6 / 255.0, blue: 0xD4 / 255.0)
        case .tickets:
            // Rose Pink
            return Color(red: 0xF4 / 255.0, green: 0x3F / 255.0, blue: 0x5E / 255.0)
        case .hotels:
            // Twilight Indigo
            return Color(red: 0x63 / 255.0, green: 0x66 / 255.0, blue: 0xF1 / 255.0)
        }
    }

    /// Soft pastel background color matching the design mockup with native dynamic dark/light support
    public var softBackgroundColor: Color {
        Color(uiColor: UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                switch self {
                case .rideSharing:
                    return UIColor(red: 0x1E / 255.0, green: 0x2A / 255.0, blue: 0x4A / 255.0, alpha: 0.85)
                case .foodDelivery:
                    return UIColor(red: 0x42 / 255.0, green: 0x24 / 255.0, blue: 0x1A / 255.0, alpha: 0.85)
                case .shopping:
                    return UIColor(red: 0x32 / 255.0, green: 0x20 / 255.0, blue: 0x48 / 255.0, alpha: 0.85)
                case .grocery:
                    return UIColor(red: 0x1A / 255.0, green: 0x36 / 255.0, blue: 0x28 / 255.0, alpha: 0.85)
                case .courier:
                    return UIColor(red: 0x1E / 255.0, green: 0x2E / 255.0, blue: 0x42 / 255.0, alpha: 0.85)
                case .homeServices:
                    return UIColor(red: 0x3E / 255.0, green: 0x34 / 255.0, blue: 0x18 / 255.0, alpha: 0.85)
                case .tickets:
                    return UIColor(red: 0x34 / 255.0, green: 0x22 / 255.0, blue: 0x4A / 255.0, alpha: 0.85)
                case .hotels:
                    return UIColor(red: 0x1A / 255.0, green: 0x34 / 255.0, blue: 0x3C / 255.0, alpha: 0.85)
                }
            } else {
                switch self {
                case .rideSharing:
                    return UIColor(red: 229 / 255.0, green: 239 / 255.0, blue: 253 / 255.0, alpha: 1.0)
                case .foodDelivery:
                    return UIColor(red: 254 / 255.0, green: 231 / 255.0, blue: 218 / 255.0, alpha: 1.0)
                case .shopping:
                    return UIColor(red: 237 / 255.0, green: 230 / 255.0, blue: 253 / 255.0, alpha: 1.0)
                case .grocery:
                    return UIColor(red: 223 / 255.0, green: 246 / 255.0, blue: 237 / 255.0, alpha: 1.0)
                case .courier:
                    return UIColor(red: 226 / 255.0, green: 239 / 255.0, blue: 253 / 255.0, alpha: 1.0)
                case .homeServices:
                    return UIColor(red: 255 / 255.0, green: 243 / 255.0, blue: 211 / 255.0, alpha: 1.0)
                case .tickets:
                    return UIColor(red: 239 / 255.0, green: 236 / 255.0, blue: 254 / 255.0, alpha: 1.0)
                case .hotels:
                    return UIColor(red: 223 / 255.0, green: 245 / 255.0, blue: 248 / 255.0, alpha: 1.0)
                }
            }
        })
    }
}
