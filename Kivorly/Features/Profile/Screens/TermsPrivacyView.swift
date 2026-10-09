//
//  TermsPrivacyView.swift
//  Kivorly
//
//  Terms of Service and Privacy Policy viewer.
//

import SwiftUI

public struct TermsPrivacyView: View {
    @State private var selectedTab: Int = 0

    public init() {}

    public var body: some View {
        VStack(spacing: 0) {
            Picker("Document", selection: $selectedTab) {
                Text("Terms of Service").tag(0)
                Text("Privacy Policy").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(KivorlySpacing.md)

            ScrollView {
                VStack(alignment: .leading, spacing: KivorlySpacing.md) {
                    if selectedTab == 0 {
                        termsContent
                    } else {
                        privacyContent
                    }
                }
                .padding(KivorlySpacing.md)
            }
        }
        .background(KivorlyColors.background.ignoresSafeArea())
        .navigationTitle("Legal & Policies")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var termsContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("1. Acceptance of Terms")
                .font(KivorlyTypography.titleSmall)
                .foregroundColor(KivorlyColors.textPrimary)
            Text("By using the Kivorly application, you agree to comply with and be bound by these Terms of Service. Kivorly aggregates multiple on-demand services under a unified platform.")
                .font(KivorlyTypography.bodyMedium)
                .foregroundColor(KivorlyColors.textSecondary)

            Text("2. Booking & Cancellation")
                .font(KivorlyTypography.titleSmall)
                .foregroundColor(KivorlyColors.textPrimary)
            Text("Cancellation policies vary depending on the service category (Ride, Food, Tickets, or Hotel Booking). Detailed cancellation terms are displayed prior to finalizing checkout.")
                .font(KivorlyTypography.bodyMedium)
                .foregroundColor(KivorlyColors.textSecondary)

            Text("3. Payment Terms")
                .font(KivorlyTypography.titleSmall)
                .foregroundColor(KivorlyColors.textPrimary)
            Text("All transactions are securely routed through certified payment gateways including bKash, Nagad, Visa, Mastercard, and Apple Pay.")
                .font(KivorlyTypography.bodyMedium)
                .foregroundColor(KivorlyColors.textSecondary)
        }
    }

    private var privacyContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("1. Information Collection")
                .font(KivorlyTypography.titleSmall)
                .foregroundColor(KivorlyColors.textPrimary)
            Text("We collect location data only when needed to match you with nearby drivers, deliver food to your address, or verify hotel check-in coordinates.")
                .font(KivorlyTypography.bodyMedium)
                .foregroundColor(KivorlyColors.textSecondary)

            Text("2. Data Protection")
                .font(KivorlyTypography.titleSmall)
                .foregroundColor(KivorlyColors.textPrimary)
            Text("Your biometric authentication data (Face ID) remains exclusively on your device's Secure Enclave and is never transmitted to our servers.")
                .font(KivorlyTypography.bodyMedium)
                .foregroundColor(KivorlyColors.textSecondary)
        }
    }
}
