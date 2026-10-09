//
//  ProfileToggleRow.swift
//  Kivorly
//
//  Toggle preference settings row.
//

import SwiftUI

public struct ProfileToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool

    public var body: some View {
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

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(KivorlyColors.primary)
        }
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.vertical, KivorlySpacing.sm)
    }
}
