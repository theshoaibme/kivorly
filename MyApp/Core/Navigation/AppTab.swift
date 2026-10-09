//
//  AppTab.swift
//  Kivorly
//
//  Defines the 5 core bottom navigation destinations.
//

import SwiftUI

public enum AppTab: Int, CaseIterable, Identifiable {
    case home = 0
    case explore = 1
    case orders = 2
    case activity = 3
    case profile = 4

    public var id: Int { rawValue }

    public var title: String {
        switch self {
        case .home: return "Home"
        case .explore: return "Explore"
        case .orders: return "Orders"
        case .activity: return "Activity"
        case .profile: return "Profile"
        }
    }

    public var icon: String {
        switch self {
        case .home: return "house.fill"
        case .explore: return "safari.fill"
        case .orders: return "doc.text.fill"
        case .activity: return "bell.fill"
        case .profile: return "person.crop.circle.fill"
        }
    }
}
