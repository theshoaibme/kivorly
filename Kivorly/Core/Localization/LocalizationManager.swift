//
//  LocalizationManager.swift
//  Kivorly
//
//  Centralized localization manager supporting English and Bangla (বাংলা).
//

import SwiftUI

public enum KivorlyLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case bangla = "bn"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .english: return "English"
        case .bangla: return "বাংলা (Bangla)"
        }
    }
}

@Observable
public final class KivorlyLocalization {
    public static let shared = KivorlyLocalization()

    public var currentLanguage: KivorlyLanguage = .english

    private init() {}

    public func localized(_ key: String) -> String {
        guard let strings = KivorlyLocalization.localizedStrings[key] else {
            return key
        }
        return strings[currentLanguage] ?? key
    }

    private static let localizedStrings: [String: [KivorlyLanguage: String]] = [
        // Brand & Slogan
        "brand_name": [
            .english: "Kivorly",
            .bangla: "কিভোরলি"
        ],
        "tagline": [
            .english: "Everything you need. One journey.",
            .bangla: "আপনার প্রয়োজনীয় সবকিছু। এক ঠিকানায়।"
        ],
        // Tabs
        "tab_home": [
            .english: "Home",
            .bangla: "হোম"
        ],
        "tab_explore": [
            .english: "Explore",
            .bangla: "অনুসন্ধান"
        ],
        "tab_orders": [
            .english: "Orders",
            .bangla: "অর্ডার"
        ],
        "tab_activity": [
            .english: "Activity",
            .bangla: "কার্যকলাপ"
        ],
        "tab_profile": [
            .english: "Profile",
            .bangla: "প্রোফাইল"
        ],
        // Search & Greeting
        "search_placeholder": [
            .english: "What do you need today?",
            .bangla: "আজ আপনার কী প্রয়োজন?"
        ],
        "delivery_to": [
            .english: "Delivering to",
            .bangla: "ডেলিভারি ঠিকানা"
        ],
        "default_location": [
            .english: "Gulshan-2, Dhaka",
            .bangla: "গুলশান-২, ঢাকা"
        ],
        // Services
        "service_rides": [
            .english: "Ride Sharing",
            .bangla: "রাইড শেয়ারিং"
        ],
        "service_food": [
            .english: "Food Delivery",
            .bangla: "ফুড ডেলিভারি"
        ],
        "service_shopping": [
            .english: "Online Shopping",
            .bangla: "অনলাইন শপিং"
        ],
        "service_grocery": [
            .english: "Grocery",
            .bangla: "মুদিবাজার"
        ],
        "service_courier": [
            .english: "Courier",
            .bangla: "কুরিয়ার সার্ভিস"
        ],
        "service_home_services": [
            .english: "Home Services",
            .bangla: "হোম সার্ভিস"
        ],
        "service_tickets": [
            .english: "Tickets",
            .bangla: "টিকিট বুকিং"
        ],
        "service_hotels": [
            .english: "Hotels",
            .bangla: "হোটেল বুকিং"
        ],
        // Common Actions
        "skip": [
            .english: "Skip",
            .bangla: "এড়িয়ে যান"
        ],
        "continue": [
            .english: "Continue",
            .bangla: "পরবর্তী"
        ],
        "get_started": [
            .english: "Get Started",
            .bangla: "শুরু করুন"
        ],
        "sign_in": [
            .english: "Sign In",
            .bangla: "সাইন ইন"
        ],
        "verify_otp": [
            .english: "Verify Code",
            .bangla: "কোড নিশ্চিত করুন"
        ],
        "resend_otp": [
            .english: "Resend Code",
            .bangla: "পুনরায় কোড পাঠান"
        ],
        "apple_sign_in": [
            .english: "Continue with Apple",
            .bangla: "অ্যাপল দিয়ে সাইন ইন"
        ]
    ]
}

public extension String {
    var localized: String {
        KivorlyLocalization.shared.localized(self)
    }
}
