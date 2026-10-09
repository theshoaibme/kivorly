//
//  ProfileMenuRow.swift
//  Kivorly
//
//  Clickable settings row component.
//

import SwiftUI

public struct ProfileMenuRow: View {
    let icon: String
    let title: String
    let action: (() -> Void)?

    public init(
        icon: String,
        title: String,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: KivorlySpacing.md) {
                ZStack {
                    Circle()
                        .fill(KivorlyColors.primary.opacity(0.12))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(KivorlyColors.primary)
                }

                Text(title)
                    .font(KivorlyTypography.bodyMedium)
                    .foregroundColor(KivorlyColors.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(KivorlyColors.textSecondary)
            }
            .padding(.horizontal, KivorlySpacing.md)
            .padding(.vertical, KivorlySpacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
