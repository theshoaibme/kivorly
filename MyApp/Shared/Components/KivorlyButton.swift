//
//  KivorlyButton.swift
//  Kivorly
//
//  Native iOS default system styled button using standard continuous corner radius (12pt),
//  native system colors, and default system selection borders.
//

import SwiftUI

public enum KivorlyButtonStyle {
    case primary
    case secondary
    case outline
    case destructive
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
    private let isLoading: Bool
    private let isFullWidth: Bool
    private let isSelected: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        icon: String? = nil,
        style: KivorlyButtonStyle = .primary,
        size: KivorlyButtonSize = .regular,
        isLoading: Bool = false,
        isFullWidth: Bool = true,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
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
                        isSelected ? Color(uiColor: .tintColor) : borderColor,
                        lineWidth: isSelected ? 2 : (style == .outline ? 1 : 0)
                    )
            )
        }
        .disabled(isLoading)
        .accessibilityLabel(title)
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            KivorlyColors.primary
        case .secondary:
            Color(uiColor: .secondarySystemFill)
        case .outline:
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
            return KivorlyColors.textPrimary
        case .outline:
            return KivorlyColors.primary
        case .destructive:
            return Color.white
        }
    }

    private var borderColor: Color {
        switch style {
        case .outline:
            return Color(uiColor: .tintColor)
        default:
            return Color.clear
        }
    }
}
