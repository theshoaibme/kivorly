//
//  ThemeManager.swift
//  Kivorly
//
//  Centralized theme manager supporting System (default), Light, and Dark modes.
//

import SwiftUI

public enum AppTheme: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    public var id: String { rawValue }

    public var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }

    public var icon: String {
        switch self {
        case .system: return "circle.lefthalf.filled"
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        }
    }
}

@Observable
public final class ThemeManager {
    public static let shared = ThemeManager()

    public var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "kivorly_app_theme")
        }
    }

    private init() {
        if let saved = UserDefaults.standard.string(forKey: "kivorly_app_theme"),
           let theme = AppTheme(rawValue: saved) {
            self.currentTheme = theme
        } else {
            // Default to System theme
            self.currentTheme = .system
        }
    }
}
