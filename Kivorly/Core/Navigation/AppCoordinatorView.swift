//
//  AppCoordinatorView.swift
//  Kivorly
//
//  Root state machine managing Splash, Onboarding, Authentication, Main Shell, and Service Flows.
//

import SwiftUI

public enum AppFlowState {
    case splash
    case onboarding
    case authentication
    case main
}

public struct AppCoordinatorView: View {
    @State private var flowState: AppFlowState = .splash
    @State private var activeServiceSheet: ServiceType? = nil

    public init() {}

    public var body: some View {
        ZStack {
            switch flowState {
            case .splash:
                SplashScreenView {
                    withAnimation {
                        flowState = .onboarding
                    }
                }
            case .onboarding:
                OnboardingView {
                    withAnimation {
                        flowState = .authentication
                    }
                }
            case .authentication:
                AuthenticationView {
                    withAnimation {
                        flowState = .main
                    }
                }
            case .main:
                MainTabView(
                    onSelectService: { service in
                        activeServiceSheet = service
                    },
                    onLogout: {
                        withAnimation {
                            flowState = .authentication
                        }
                    }
                )
            }
        }
        .sheet(item: $activeServiceSheet) { service in
            ServiceFlowPlaceholderView(service: service) {
                activeServiceSheet = nil
            }
        }
    }
}

public struct ServiceFlowPlaceholderView: View {
    let service: ServiceType
    let onDismiss: () -> Void

    public var body: some View {
        NavigationStack {
            VStack(spacing: KivorlySpacing.lg) {
                // 3D icon with fully rounded muted circle background
                ZStack {
                    Circle()
                        .fill(service.accentTint.opacity(0.12))
                        .frame(width: 88, height: 88)

                    Image(systemName: service.systemIcon)
                        .font(.system(size: 38, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(service.accentTint)
                }
                .padding(.top, KivorlySpacing.xxl)

                // Title only (no descriptions)
                Text(service.title)
                    .font(KivorlyTypography.titleLarge)
                    .foregroundColor(KivorlyColors.textPrimary)

                Spacer()

                KivorlyButton("Close", style: .outline) {
                    onDismiss()
                }
                .padding(.horizontal, KivorlySpacing.xl)
                .padding(.bottom, KivorlySpacing.xl)
            }
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle(service.shortTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onDismiss()
                    }
                    .font(KivorlyTypography.bodySemibold)
                    .foregroundColor(KivorlyColors.midnightNavy)
                }
            }
        }
    }
}
