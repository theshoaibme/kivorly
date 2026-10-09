//
//  ServiceItemRowView.swift
//  Kivorly
//
//  Component rendering a service option or product item with price, rating, badges, and 3D icon.
//

import SwiftUI

public struct ServiceItemRowView: View {
    let item: ServiceItemModel
    let onSelect: () -> Void

    public init(item: ServiceItemModel, onSelect: @escaping () -> Void) {
        self.item = item
        self.onSelect = onSelect
    }

    public var body: some View {
        Button(action: onSelect) {
            KivorlyCard(padding: KivorlySpacing.md) {
                HStack(spacing: KivorlySpacing.md) {
                    // Food Image or Service Icon on Muted Rounded Container
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(item.serviceType.accentTint.opacity(0.12))
                            .frame(width: 54, height: 54)

                        if let emoji = item.imageEmoji, !emoji.isEmpty {
                            Text(emoji)
                                .font(.system(size: 30))
                        } else {
                            Image(systemName: item.icon)
                                .font(.system(size: 22, weight: .bold))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(item.serviceType.accentTint)
                        }
                    }

                    // Item Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.title)
                            .font(KivorlyTypography.titleSmall)
                            .foregroundColor(KivorlyColors.textPrimary)
                            .lineLimit(1)

                        HStack(spacing: 6) {
                            Text(item.category)
                                .font(KivorlyTypography.caption)
                                .foregroundColor(KivorlyColors.textSecondary)

                            Text("•")
                                .font(KivorlyTypography.caption)
                                .foregroundColor(KivorlyColors.textSecondary)

                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(Color(red: 0xF5 / 255.0, green: 0x9E / 255.0, blue: 0x0B / 255.0))
                                Text(String(format: "%.1f", item.rating))
                                    .font(KivorlyTypography.captionBold)
                                    .foregroundColor(KivorlyColors.textPrimary)
                            }

                            Text("•")
                                .font(KivorlyTypography.caption)
                                .foregroundColor(KivorlyColors.textSecondary)

                            Text(item.etaOrDuration)
                                .font(KivorlyTypography.caption)
                                .foregroundColor(item.serviceType.accentTint)
                        }

                        // Badges
                        if !item.badges.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 4) {
                                    ForEach(item.badges, id: \.self) { badge in
                                        Text(badge)
                                            .font(.system(size: 9, weight: .bold))
                                            .padding(.horizontal, 7)
                                            .padding(.vertical, 2.5)
                                            .background(Color(uiColor: .tertiarySystemFill))
                                            .foregroundColor(KivorlyColors.textSecondary)
                                            .clipShape(Capsule())
                                    }
                                }
                            }
                            .padding(.top, 2)
                        }
                    }

                    Spacer()

                    // Price & Action Indicator
                    VStack(alignment: .trailing, spacing: 6) {
                        Text(item.priceText)
                            .font(KivorlyTypography.priceDisplay)
                            .foregroundColor(item.serviceType.accentTint)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(KivorlyColors.textSecondary)
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
