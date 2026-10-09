//
//  DesignTokens.swift
//  Kivorly
//
//  Apple Human Interface Guidelines modern color palette with dark/light mode balance.
//

import SwiftUI

// MARK: - Premium Color Palette
public enum KivorlyColors {
    // Primary Brand Signature: Deep Electric Indigo (#2563EB)
    public static let primary = Color(red: 0x25 / 255.0, green: 0x63 / 255.0, blue: 0xEB / 255.0)

    // Secondary Brand Accent: Vibrant Violet (#7C3AED)
    public static let accent = Color(red: 0x7C / 255.0, green: 0x3A / 255.0, blue: 0xED / 255.0)

    // Semantic Status Colors (Finely balanced tones)
    public static let success = Color(red: 0x10 / 255.0, green: 0xB9 / 255.0, blue: 0x81 / 255.0) // Emerald
    public static let warning = Color(red: 0xF5 / 255.0, green: 0x9E / 255.0, blue: 0x0B / 255.0) // Amber
    public static let error = Color(red: 0xEF / 255.0, green: 0x44 / 255.0, blue: 0x44 / 255.0)   // Coral Red
    public static let info = Color(red: 0x0E / 255.0, green: 0xA5 / 255.0, blue: 0xE9 / 255.0)    // Sky Blue

    // Native Dynamic Backgrounds (Adapts automatically to system light/dark mode)
    public static var background: Color {
        Color(uiColor: .systemGroupedBackground)
    }

    public static var surface: Color {
        Color(uiColor: .secondarySystemGroupedBackground)
    }

    public static var surfaceElevated: Color {
        Color(uiColor: .tertiarySystemGroupedBackground)
    }

    // Dynamic Typography Labels
    public static var textPrimary: Color {
        Color(uiColor: .label)
    }

    public static var textSecondary: Color {
        Color(uiColor: .secondaryLabel)
    }

    public static var textTertiary: Color {
        Color(uiColor: .tertiaryLabel)
    }

    // Dynamic Native Separators
    public static var border: Color {
        Color(uiColor: .separator)
    }

    public static var slateGray: Color {
        Color(uiColor: .systemGray)
    }

    public static let pureWhite = Color.white
    public static let midnightNavy = Color(uiColor: .label)
}

// MARK: - Spacing Grid
public enum KivorlySpacing {
    public static let xxs: CGFloat = 4
    public static let xs: CGFloat = 8
    public static let sm: CGFloat = 12
    public static let md: CGFloat = 16
    public static let lg: CGFloat = 20
    public static let xl: CGFloat = 24
    public static let xxl: CGFloat = 32
    public static let xxxl: CGFloat = 40
    public static let huge: CGFloat = 48
}

// MARK: - Corner Radii
public enum KivorlyRadius {
    public static let small: CGFloat = 10
    public static let medium: CGFloat = 16
    public static let large: CGFloat = 22
    public static let extraLarge: CGFloat = 30
    public static let pill: CGFloat = 999
}

// MARK: - Apple System Typography
public struct KivorlyTypography {
    public static let displayLarge = Font.system(.largeTitle, design: .default).weight(.bold)
    public static let displayMedium = Font.system(.title, design: .default).weight(.bold)
    public static let titleLarge = Font.system(.title2, design: .default).weight(.bold)
    public static let titleMedium = Font.system(.title3, design: .default).weight(.semibold)
    public static let titleSmall = Font.system(.headline, design: .default).weight(.semibold)
    public static let bodyLarge = Font.system(.body, design: .default)
    public static let bodyMedium = Font.system(.callout, design: .default)
    public static let bodySemibold = Font.system(.callout, design: .default).weight(.semibold)
    public static let callout = Font.system(.subheadline, design: .default)
    public static let caption = Font.system(.caption, design: .default)
    public static let captionBold = Font.system(.caption, design: .default).weight(.bold)
    public static let priceDisplay = Font.system(.headline, design: .rounded).weight(.bold)
}

// MARK: - Custom Rounded Corners Shape
public struct CustomCornerShape: Shape {
    public var radius: CGFloat
    public var corners: UIRectCorner

    public init(radius: CGFloat = 28, corners: UIRectCorner = [.topLeft, .topRight]) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
