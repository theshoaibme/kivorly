//
//  PromotionalBannerCard.swift
//  Kivorly
//
//  Clean title-focused banner card with fully rounded muted icon background and action button.
//

import SwiftUI

public struct PromotionalBannerCard: View {
    private let tag: String
    private let title: String
    private let actionTitle: String
    private let icon: String
    private let onAction: () -> Void
    private let onDismiss: (() -> Void)?

    public init(
        tag: String = "Exclusive Launch",
        title: String,
        description: String = "",
        actionTitle: String = "Explore",
        icon: String = "sparkles",
        onAction: @escaping () -> Void,
        onDismiss: (() -> Void)? = nil
    ) {
        self.tag = tag
        self.title = title
        self.actionTitle = actionTitle
        self.icon = icon
        self.onAction = onAction
        self.onDismiss = onDismiss
    }

    public var body: some View {
        ZStack(alignment: .topTrailing) {
            HStack(spacing: KivorlySpacing.md) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(tag)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.2))
                        .foregroundColor(.white)
                        .clipShape(Capsule())

                    Text(title)
                        .font(KivorlyTypography.titleMedium)
                        .foregroundColor(.white)
                        .lineLimit(2)

                    Button(action: onAction) {
                        HStack(spacing: 4) {
                            Text(actionTitle)
                                .font(KivorlyTypography.captionBold)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(KivorlyColors.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 68, height: 68)

                    Image(systemName: icon)
                        .font(.system(size: 30, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.white)
                }
            }
            .padding(KivorlySpacing.lg)
            .background(KivorlyColors.primary)
            .cornerRadius(KivorlyRadius.medium)

            if let onDismiss = onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color.white.opacity(0.7))
                        .padding(KivorlySpacing.sm)
                }
                .accessibilityLabel("Dismiss promotion")
            }
        }
        .padding(.horizontal, KivorlySpacing.md)
    }
}
