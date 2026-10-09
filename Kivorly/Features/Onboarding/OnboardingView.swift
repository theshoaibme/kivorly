//
//  OnboardingView.swift
//  Kivorly
//
//  Clean title-only onboarding flow built with modular components.
//

import SwiftUI

public struct OnboardingPage: Identifiable {
    public let id = UUID()
    public let icon: String
    public let title: String
    public let badge: String
}

public struct OnboardingView: View {
    private let onComplete: () -> Void

    @State private var currentPage: Int = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "square.grid.3x3.topleft.filled",
            title: "8 Services in One App",
            badge: "All-in-one"
        ),
        OnboardingPage(
            icon: "map.fill",
            title: "Real-Time Tracking",
            badge: "Real-time"
        ),
        OnboardingPage(
            icon: "shield.checkerboard",
            title: "Secure Payments",
            badge: "Trusted"
        )
    ]

    public init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }

    public var body: some View {
        ZStack {
            KivorlyColors.background.ignoresSafeArea()

            VStack(spacing: 0) {
                // Skip Button
                HStack {
                    Spacer()
                    Button(action: onComplete) {
                        Text("Skip")
                            .font(KivorlyTypography.bodySemibold)
                            .foregroundColor(KivorlyColors.textSecondary)
                            .padding(.horizontal, KivorlySpacing.md)
                            .padding(.vertical, KivorlySpacing.xs)
                    }
                }
                .padding(.top, KivorlySpacing.sm)
                .padding(.trailing, KivorlySpacing.sm)

                // Page TabView with modular OnboardingCardView
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingCardView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                // Bottom Indicator and Actions
                VStack(spacing: KivorlySpacing.lg) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(currentPage == index ? KivorlyColors.primary : Color(uiColor: .tertiarySystemFill))
                                .frame(width: currentPage == index ? 24 : 8, height: 8)
                                .animation(.easeInOut(duration: 0.25), value: currentPage)
                        }
                    }

                    if currentPage == pages.count - 1 {
                        KivorlyButton("Get Started", icon: "arrow.right", style: .primary) {
                            onComplete()
                        }
                    } else {
                        HStack(spacing: KivorlySpacing.md) {
                            if currentPage > 0 {
                                KivorlyButton("Back", style: .outline, isFullWidth: false) {
                                    withAnimation {
                                        currentPage -= 1
                                    }
                                }
                                .frame(width: 100)
                            }

                            KivorlyButton("Continue", icon: "chevron.right", style: .primary) {
                                withAnimation {
                                    currentPage += 1
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, KivorlySpacing.xl)
                .padding(.bottom, KivorlySpacing.xl)
            }
        }
    }
}
