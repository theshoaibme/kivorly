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
                    placeCard(title: "Artisan Bistro", rating: 4.9, imageName: "food_artisan_bistro", fallbackIcon: "fork.knife")
                    placeCard(title: "Kivorly Fresh Mart", rating: 4.8, imageName: "food_fresh_mart", fallbackIcon: "basket.fill")
                    placeCard(title: "Tokyo Ramen Bar", rating: 4.7, imageName: "food_ramen_bar", fallbackIcon: "flame.fill")
                }
                .padding(.horizontal, KivorlySpacing.md)
            }
        }
    }

    private func placeCard(title: String, rating: Double, imageName: String, fallbackIcon: String) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: 10) {
                if let uiImage = UIImage(named: imageName) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 160, height: 96)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: KivorlyRadius.medium, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: KivorlyRadius.medium, style: .continuous)
                                .stroke(Color(uiColor: .separator).opacity(0.2), lineWidth: 0.8)
                        )
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: KivorlyRadius.medium)
                            .fill(Color(uiColor: .tertiarySystemFill))
                            .frame(width: 160, height: 96)

                        Circle()
                            .fill(KivorlyColors.primary.opacity(0.12))
                            .frame(width: 48, height: 48)

                        Image(systemName: fallbackIcon)
                            .font(.system(size: 24, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(KivorlyColors.primary)
                    }
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
