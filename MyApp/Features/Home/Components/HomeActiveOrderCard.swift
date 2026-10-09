//
//  HomeActiveOrderCard.swift
//  Kivorly
//
//  Live activity order status card.
//

import SwiftUI

public struct HomeActiveOrderCard: View {
    let title: String
    let onDetailsTap: () -> Void

    public var body: some View {
        VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
            SectionHeader(
                title: "Live Activity",
                actionTitle: "Details",
                action: onDetailsTap
            )

            KivorlyCard(padding: KivorlySpacing.md) {
                HStack(spacing: KivorlySpacing.md) {
                    ZStack {
                        Circle()
                            .fill(KivorlyColors.primary.opacity(0.12))
                            .frame(width: 48, height: 48)

                        Image(systemName: "fork.knife")
                            .font(.system(size: 20, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(KivorlyColors.primary)
                    }

                    Text(title)
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(KivorlyColors.textPrimary)

                    Spacer()

                    StatusBadge(.inProgress)
                }
            }
            .padding(.horizontal, KivorlySpacing.md)
        }
    }
}
