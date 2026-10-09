//
//  OnboardingCardView.swift
//  Kivorly
//
//  Single onboarding step presentation card with 3D icon and title.
//

import SwiftUI

public struct OnboardingCardView: View {
    let page: OnboardingPage

    public var body: some View {
        VStack(spacing: KivorlySpacing.md) {
            Spacer()

            if page.illustrationType == .servicesSolarOrbit {
                ServicesSolarOrbitView()
            } else {
                ZStack {
                    Circle()
                        .fill(KivorlyColors.primary.opacity(0.12))
                        .frame(width: 150, height: 150)

                    Image(systemName: page.icon)
                        .font(.system(size: 48, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(KivorlyColors.primary)
                }
            }

            VStack(spacing: KivorlySpacing.sm) {
                if !page.badge.isEmpty && page.illustrationType != .servicesSolarOrbit {
                    Text(page.badge)
                        .font(KivorlyTypography.captionBold)
                        .foregroundColor(KivorlyColors.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(KivorlyColors.primary.opacity(0.12))
                        .clipShape(Capsule())
                }

                Text(page.title)
                    .font(KivorlyTypography.displayMedium)
                    .foregroundColor(KivorlyColors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, KivorlySpacing.lg)
            }

            Spacer()
        }
    }
}
