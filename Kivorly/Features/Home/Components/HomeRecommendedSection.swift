//
//  HomeRecommendedSection.swift
//  Kivorly
//
//  Recommended places row component.
//

import SwiftUI

public struct HomeRecommendedSection: View {
    let onViewAll: () -> Void

    public var body: some View {
        VStack(alignment: .leading, spacing: KivorlySpacing.sm) {
            SectionHeader(
                title: "Popular Places",
                actionTitle: "View All",
                action: onViewAll
            )

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: KivorlySpacing.md) {
                    placeCard(title: "Artisan Bistro", rating: 4.9, icon: "fork.knife")
                    placeCard(title: "Kivorly Fresh Mart", rating: 4.8, icon: "basket.fill")
                    placeCard(title: "Tokyo Ramen Bar", rating: 4.7, icon: "flame.fill")
                }
                .padding(.horizontal, KivorlySpacing.md)
            }
        }
    }

    private func placeCard(title: String, rating: Double, icon: String) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: KivorlyRadius.medium)
                        .fill(Color(uiColor: .tertiarySystemFill))
                        .frame(width: 160, height: 86)

                    Circle()
                        .fill(KivorlyColors.primary.opacity(0.12))
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(KivorlyColors.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(KivorlyColors.textPrimary)
                        .lineLimit(1)

                    RatingView(rating: rating)
                }
            }
            .frame(width: 160)
        }
    }
}
