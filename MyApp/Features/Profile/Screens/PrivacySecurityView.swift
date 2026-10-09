//
//  PrivacySecurityView.swift
//  Kivorly
//
//  Security & privacy preferences, data permissions, and biometrics.
//

import SwiftUI

public struct PrivacySecurityView: View {
    @State private var locationAlways: Bool = true
    @State private var personalizedAds: Bool = false
    @State private var activityHistory: Bool = true
    @State private var twoFactorAuth: Bool = true
    @State private var showDataClearedAlert: Bool = false

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: KivorlySpacing.lg) {
                // Security Section
                VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                    SectionHeader(title: "Account Security")

                    KivorlyCard(padding: 0) {
                        VStack(spacing: 0) {
                            ProfileToggleRow(icon: "shield.checkmark.fill", title: "Two-Factor Authentication", isOn: $twoFactorAuth)
                            Divider().padding(.leading, 56)
                            ProfileMenuRow(icon: "key.fill", title: "Change Password")
                        }
                    }
                }

                // Privacy Permissions Section
                VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                    SectionHeader(title: "Data & Privacy")

                    KivorlyCard(padding: 0) {
                        VStack(spacing: 0) {
                            ProfileToggleRow(icon: "location.fill", title: "Precise Location", isOn: $locationAlways)
                            Divider().padding(.leading, 56)
                            ProfileToggleRow(icon: "clock.arrow.circlepath", title: "Save Order History", isOn: $activityHistory)
                            Divider().padding(.leading, 56)
                            ProfileToggleRow(icon: "chart.bar.xaxis", title: "Personalized Offers", isOn: $personalizedAds)
                        }
                    }
                }

                // Data Management
                VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                    SectionHeader(title: "Data Management")

                    KivorlyCard(padding: 0) {
                        VStack(spacing: 0) {
                            ProfileMenuRow(icon: "arrow.down.doc.fill", title: "Download Personal Data")
                            Divider().padding(.leading, 56)
                            ProfileMenuRow(icon: "trash.fill", title: "Clear Search History") {
                                showDataClearedAlert = true
                            }
                        }
                    }
                }
            }
            .padding(KivorlySpacing.md)
        }
        .background(KivorlyColors.background.ignoresSafeArea())
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
        .alert("History Cleared", isPresented: $showDataClearedAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your local search and browse history has been cleared.")
        }
    }
}
