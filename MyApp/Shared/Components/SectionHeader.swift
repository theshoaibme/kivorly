//
//  SectionHeader.swift
//  Kivorly
//
//  Clean section header displaying title and optional action.
//

import SwiftUI

public struct SectionHeader: View {
    private let title: String
    private let actionTitle: String?
    private let action: (() -> Void)?

    public init(
        title: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .font(KivorlyTypography.titleMedium)
                .foregroundColor(KivorlyColors.textPrimary)

            Spacer()

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    HStack(spacing: 2) {
                        Text(actionTitle)
                            .font(KivorlyTypography.bodySemibold)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(KivorlyColors.midnightNavy)
                }
                .accessibilityLabel(actionTitle)
            }
        }
        .padding(.horizontal, KivorlySpacing.md)
    }
}
