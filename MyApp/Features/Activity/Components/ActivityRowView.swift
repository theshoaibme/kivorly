//
//  ActivityRowView.swift
//  Kivorly
//
//  Single interactive activity item row with distinct service tint and swipe actions.
//

import SwiftUI

public struct ActivityRowView: View {
    let item: ActivityItem
    let onTap: () -> Void

    public init(item: ActivityItem, onTap: @escaping () -> Void) {
        self.item = item
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            KivorlyCard(padding: KivorlySpacing.md) {
                HStack(spacing: KivorlySpacing.md) {
                    // 3D Hierarchical Icon in Muted Tint Circle
                    ZStack {
                        Circle()
                            .fill(tintColor.opacity(0.12))
                            .frame(width: 44, height: 44)

                        Image(systemName: item.icon)
                            .font(.system(size: 20, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(tintColor)
                    }

                    // Title
                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.title)
                            .font(KivorlyTypography.bodySemibold)
                            .foregroundColor(KivorlyColors.textPrimary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)

                        Text(item.timeAgo)
                            .font(KivorlyTypography.caption)
                            .foregroundColor(KivorlyColors.textSecondary)
                    }

                    Spacer()

                    // Unread Pill Indicator
                    if item.isUnread {
                        Circle()
                            .fill(KivorlyColors.primary)
                            .frame(width: 8, height: 8)
                    }

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(KivorlyColors.textSecondary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var tintColor: Color {
        if let service = item.serviceType {
            return service.accentTint
        }
        switch item.category {
        case .orders: return KivorlyColors.primary
        case .offers: return Color(red: 0xF9 / 255.0, green: 0x73 / 255.0, blue: 0x16 / 255.0)
        case .security: return Color(red: 0x10 / 255.0, green: 0xB9 / 255.0, blue: 0x81 / 255.0)
        case .all: return KivorlyColors.primary
        }
    }
}
