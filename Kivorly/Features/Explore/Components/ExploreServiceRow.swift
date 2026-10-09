//
//  ExploreServiceRow.swift
//  Kivorly
//
//  Single service discovery card row with service-specific accent color.
//

import SwiftUI

public struct ExploreServiceRow: View {
    let service: ServiceType
    let onSelect: () -> Void

    public var body: some View {
        Button(action: onSelect) {
            KivorlyCard(padding: KivorlySpacing.md) {
                HStack(spacing: KivorlySpacing.md) {
                    ZStack {
                        Circle()
                            .fill(service.accentTint.opacity(0.12))
                            .frame(width: 44, height: 44)

                        Image(systemName: service.systemIcon)
                            .foregroundColor(service.accentTint)
                            .font(.system(size: 20, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                    }

                    Text(service.title)
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(KivorlyColors.textPrimary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(KivorlyColors.textSecondary)
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, KivorlySpacing.md)
    }
}
