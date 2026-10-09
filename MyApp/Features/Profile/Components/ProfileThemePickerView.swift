//
//  ProfileThemePickerView.swift
//  Kivorly
//
//  Dedicated theme preference row and picker supporting System (default), Light, and Dark.
//

import SwiftUI

public struct ProfileThemePickerView: View {
    @Bindable var themeManager = ThemeManager.shared

    public init() {}

    public var body: some View {
        HStack(spacing: KivorlySpacing.md) {
            ZStack {
                Circle()
                    .fill(KivorlyColors.primary.opacity(0.12))
                    .frame(width: 36, height: 36)

                Image(systemName: themeManager.currentTheme.icon)
                    .font(.system(size: 16, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(KivorlyColors.primary)
            }

            Text("Theme")
                .font(KivorlyTypography.bodyMedium)
                .foregroundColor(KivorlyColors.textPrimary)

            Spacer()

            Picker("Theme", selection: $themeManager.currentTheme) {
                ForEach(AppTheme.allCases) { theme in
                    Text(theme.rawValue).tag(theme)
                }
            }
            .pickerStyle(.menu)
            .tint(KivorlyColors.primary)
        }
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.vertical, KivorlySpacing.sm)
    }
}
