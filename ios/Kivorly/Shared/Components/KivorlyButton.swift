//
//  KivorlyButton.swift
//  Kivorly
//
//  Default iPhone system styled button with variant support (filled/prominent, tinted/secondary,
//  bordered/outline, plain, destructive). Uses solid colors (no gradients), flat styling (no shadows),
//  and custom service tinting.
//

import SwiftUI

public enum KivorlyButtonStyle {
    case primary      // iOS Filled / Prominent
    case secondary    // iOS Tinted / Soft Fill
    case outline      // iOS Bordered / Outlined
    case plain        // iOS Borderless / Plain
    case destructive  // iOS Destructive
}

public enum KivorlyButtonSize {
    case compact
    case regular
    case large

    var height: CGFloat {
        switch self {
        case .compact: return 36
        case .regular: return 48
        case .large: return 54
        }
    }

    var font: Font {
        switch self {
        case .compact: return KivorlyTypography.captionBold
        case .regular: return KivorlyTypography.bodySemibold
        case .large: return KivorlyTypography.titleSmall
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .compact: return KivorlySpacing.md
        case .regular: return KivorlySpacing.lg
        case .large: return KivorlySpacing.xl
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .compact: return 8
        case .regular: return 12
        case .large: return 14
        }
    }
}

public struct KivorlyButton: View {
    private let title: String
    private let icon: String?
    private let style: KivorlyButtonStyle
    private let size: KivorlyButtonSize
    private let tint: Color?
    private let isLoading: Bool
    private let isFullWidth: Bool
    private let isSelected: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        icon: String? = nil,
        style: KivorlyButtonStyle = .primary,
        size: KivorlyButtonSize = .regular,
        tint: Color? = nil,
        isLoading: Bool = false,
        isFullWidth: Bool = true,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.tint = tint
        self.isLoading = isLoading
        self.isFullWidth = isFullWidth
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: {
            if !isLoading {
                action()
            }
        }) {
            HStack(spacing: KivorlySpacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
                        .scaleEffect(0.9)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(size.font)
                    }
                    Text(title)
                        .font(size.font)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: size.height)
            .padding(.horizontal, size.horizontalPadding)
            .background(backgroundView)
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(
                        isSelected ? effectiveTint : borderColor,
                        lineWidth: isSelected ? 2 : (style == .outline ? 1.2 : 0)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isLoading)
        .accessibilityLabel(title)
    }

    private var effectiveTint: Color {
        tint ?? KivorlyColors.primary
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            effectiveTint
        case .secondary:
            if let customTint = tint {
                customTint.opacity(0.12)
            } else {
                Color(uiColor: .secondarySystemFill)
            }
        case .outline, .plain:
            Color.clear
        case .destructive:
            KivorlyColors.error
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return Color.white
        case .secondary:
            return tint ?? KivorlyColors.textPrimary
        case .outline:
            return effectiveTint
        case .plain:
            return effectiveTint
        case .destructive:
            return Color.white
        }
    }

    private var borderColor: Color {
        switch style {
        case .outline:
            return effectiveTint
        default:
            return Color.clear
        }
    }
}
