//
//  RatingView.swift
//  Kivorly
//
//  Compact star rating badge with review count formatting.
//

import SwiftUI

public struct RatingView: View {
    private let rating: Double
    private let reviewCount: Int?

    public init(rating: Double, reviewCount: Int? = nil) {
        self.rating = rating
        self.reviewCount = reviewCount
    }

    public var body: some View {
        HStack(spacing: 3) {
            Image(systemName: "star.fill")
                .font(.system(size: 11))
                .foregroundColor(Color(red: 0xF5 / 255.0, green: 0x9E / 255.0, blue: 0x0B / 255.0))

            Text(String(format: "%.1f", rating))
                .font(KivorlyTypography.captionBold)
                .foregroundColor(KivorlyColors.textPrimary)

            if let count = reviewCount {
                Text("(\(count))")
                    .font(KivorlyTypography.caption)
                    .foregroundColor(KivorlyColors.textSecondary)
            }
        }
    }
}
