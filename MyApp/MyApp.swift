//
//  MyApp.swift
//  Kivorly
//
//  Created for Kivorly Super App.
//

import SwiftUI

@main
struct KivorlyApp: App {
    private var themeManager = ThemeManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(themeManager.currentTheme.colorScheme)
        }
    }
}
