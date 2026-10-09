//
//  OrderCardView.swift
//  Kivorly
//
//  Single order list card component with service-specific color.
//

import SwiftUI

public struct OrderCardView: View {
    let order: SuperAppOrder

    public var body: some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: KivorlySpacing.sm) {
                HStack(spacing: KivorlySpacing.sm) {
                    ZStack {
                        Circle()
                            .fill(order.service.accentTint.opacity(0.12))
                            .frame(width: 44, height: 44)

                        Image(systemName: order.service.systemIcon)
                            .font(.system(size: 20, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(order.service.accentTint)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(order.title)
                            .font(KivorlyTypography.titleSmall)
                            .foregroundColor(KivorlyColors.textPrimary)

                        Text(order.id)
                            .font(KivorlyTypography.caption)
                            .foregroundColor(KivorlyColors.textSecondary)
                    }

                    Spacer()

                    StatusBadge(order.status)
                }

                Divider()

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 11))
                        Text(order.timestamp)
                            .font(KivorlyTypography.caption)
                    }
                    .foregroundColor(KivorlyColors.textSecondary)

                    Spacer()

                    Text(order.amount)
                        .font(KivorlyTypography.priceDisplay)
                        .foregroundColor(KivorlyColors.textPrimary)
                }
                .padding(.top, 2)
            }
        }
    }
}
