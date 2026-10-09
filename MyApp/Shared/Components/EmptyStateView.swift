//
//  EmptyStateView.swift
//  Kivorly
//
//  Minimal empty state presentation displaying icon, title, and action.
//

import SwiftUI

public struct EmptyStateView: View {
    private let icon: String
    private let title: String
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        icon: String,
        title: String,
        message: String = "",
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(spacing: KivorlySpacing.md) {
            ZStack {
                Circle()
                    .fill(Color(uiColor: .tertiarySystemFill))
                    .frame(width: 80, height: 80)

                Image(systemName: icon)
                    .font(.system(size: 34, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(KivorlyColors.textSecondary)
            }

            Text(title)
                .font(KivorlyTypography.titleMedium)
                .foregroundColor(KivorlyColors.textPrimary)
                .multilineTextAlignment(.center)

            if let actionTitle = actionTitle, let action = action {
                KivorlyButton(
                    actionTitle,
                    style: .primary,
                    size: .regular,
                    isFullWidth: false,
                    action: action
                )
                .padding(.top, KivorlySpacing.xs)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, KivorlySpacing.xxl)
    }
}
