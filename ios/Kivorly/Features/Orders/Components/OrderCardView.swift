//
//  OrderCardView.swift
//  Kivorly
//
//  Single order list card component with service-specific branding,
//  live progress indicator, and end-to-end action shortcuts.
//

import SwiftUI

public struct OrderCardView: View {
    let order: SuperAppOrder
    let onTap: () -> Void
    let onQuickAction: () -> Void

    public init(
        order: SuperAppOrder,
        onTap: @escaping () -> Void = {},
        onQuickAction: @escaping () -> Void = {}
    ) {
        self.order = order
        self.onTap = onTap
        self.onQuickAction = onQuickAction
    }

    public var body: some View {
        Button(action: onTap) {
            KivorlyCard(padding: KivorlySpacing.md) {
                VStack(alignment: .leading, spacing: KivorlySpacing.sm) {
                    // Header: Service Icon, Title, ID, Status
                    HStack(spacing: KivorlySpacing.sm) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(order.service.accentTint.opacity(0.14))
                                .frame(width: 44, height: 44)

                            Image(systemName: order.service.systemIcon)
                                .font(.system(size: 20, weight: .bold))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(order.service.accentTint)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            Text(order.title)
                                .font(KivorlyTypography.titleSmall)
                                .foregroundColor(Color(uiColor: .label))
                                .lineLimit(1)

                            HStack(spacing: 6) {
                                Text(order.id)
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))

                                Text("\u{2022}")
                                    .foregroundColor(Color(uiColor: .tertiaryLabel))

                                Text(order.subtitle)
                                    .font(KivorlyTypography.caption)
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                    .lineLimit(1)
                            }
                        }

                        Spacer()

                        StatusBadge(order.status)
                    }

                    // Live Status or ETA Pill (for active/upcoming)
                    if order.status == .active || order.status == .inProgress {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 8, height: 8)
                                .overlay(
                                    Circle()
                                        .stroke(Color.green.opacity(0.4), lineWidth: 2)
                                        .scaleEffect(1.4)
                                )

                            Text(order.etaText)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(KivorlyColors.primary)

                            Spacer()

                            if let pin = order.securityPin {
                                Text("PIN: \(pin)")
                                    .font(.system(size: 11, weight: .black, design: .monospaced))
                                    .foregroundColor(KivorlyColors.primary)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(KivorlyColors.primary.opacity(0.1))
                                    .cornerRadius(6)
                            }
                        }
                        .padding(8)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .cornerRadius(8)
                    }

                    Divider()

                    // Footer: Timestamp, Amount & Quick Action Button
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 11))
                            Text(order.timestamp)
                                .font(KivorlyTypography.caption)
                        }
                        .foregroundColor(Color(uiColor: .secondaryLabel))

                        Spacer()

                        Text(order.amount)
                            .font(KivorlyTypography.priceDisplay)
                            .foregroundColor(Color(uiColor: .label))

                        // Quick Action Button
                        Button(action: onQuickAction) {
                            HStack(spacing: 4) {
                                if order.status == .active || order.status == .inProgress {
                                    Text("Track")
                                    Image(systemName: "location.fill")
                                } else if order.status == .confirmed {
                                    Text("View Pass")
                                    Image(systemName: "ticket.fill")
                                } else if order.status == .completed {
                                    Text("Details")
                                    Image(systemName: "chevron.right")
                                } else {
                                    Text("View")
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(order.service.accentTint)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(order.service.accentTint.opacity(0.12))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(.top, 2)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
