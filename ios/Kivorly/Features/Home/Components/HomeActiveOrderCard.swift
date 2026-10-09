//
//  HomeActiveOrderCard.swift
//  Kivorly
//
//  Live activity order status card bound to OrdersManager.
//

import SwiftUI

public struct HomeActiveOrderCard: View {
    @ObservedObject private var ordersManager: OrdersManager = OrdersManager.shared
    let onDetailsTap: () -> Void

    public init(onDetailsTap: @escaping () -> Void = {}) {
        self.onDetailsTap = onDetailsTap
    }

    public var body: some View {
        if let activeOrder = ordersManager.activeOrders.first {
            VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                SectionHeader(
                    title: "Live Activity",
                    actionTitle: "Track",
                    action: onDetailsTap
                )

                Button(action: onDetailsTap) {
                    KivorlyCard(padding: KivorlySpacing.md) {
                        HStack(spacing: KivorlySpacing.md) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(activeOrder.service.accentTint.opacity(0.14))
                                    .frame(width: 48, height: 48)

                                Image(systemName: activeOrder.service.systemIcon)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(activeOrder.service.accentTint)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(activeOrder.title)
                                    .font(KivorlyTypography.titleSmall)
                                    .foregroundColor(Color(uiColor: .label))
                                    .lineLimit(1)

                                HStack(spacing: 6) {
                                    Circle()
                                        .fill(Color.green)
                                        .frame(width: 6, height: 6)
                                    Text(activeOrder.etaText)
                                        .font(KivorlyTypography.caption)
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                }
                            }

                            Spacer()

                            StatusBadge(activeOrder.status)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, KivorlySpacing.md)
            }
        }
    }
}
