//
//  ProfileView.swift
//  Kivorly
//
//  Fully functional Profile screen with navigation to all settings sub-flows including Notification Preferences.
//

import SwiftUI

public struct ProfileView: View {
    private let onLogout: () -> Void

    private var localization = KivorlyLocalization.shared
    private var themeManager = ThemeManager.shared

    @State private var userName: String = "MD Shoaib Khan"
    @State private var userPhone: String = "+880 1712-345678"

    @State private var isBiometricsEnabled: Bool = true
    @State private var showLanguagePicker: Bool = false
    @State private var showEditProfileSheet: Bool = false
    @State private var showHotlineSheet: Bool = false

    public init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: KivorlySpacing.lg) {
                    // Profile Header Card (Tapping opens Edit Profile)
                    ProfileHeaderView(
                        name: userName,
                        phone: userPhone,
                        onEditTap: { showEditProfileSheet = true }
                    )

                    // Preferences Group
                    VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                        SectionHeader(title: "Preferences")

                        KivorlyCard(padding: 0) {
                            VStack(spacing: 0) {
                                ProfileThemePickerView()

                                Divider().padding(.leading, 56)

                                ProfileMenuRow(icon: "globe", title: "Language: \(localization.currentLanguage.displayName)") {
                                    showLanguagePicker = true
                                }
                            }
                        }
                        .padding(.horizontal, KivorlySpacing.md)
                    }

                    // Account Settings Group
                    VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                        SectionHeader(title: "Account Settings")

                        KivorlyCard(padding: 0) {
                            VStack(spacing: 0) {
                                NavigationLink(destination: SavedAddressesView()) {
                                    ProfileMenuRow(icon: "mappin.circle.fill", title: "Saved Addresses")
                                }

                                Divider().padding(.leading, 56)

                                NavigationLink(destination: PaymentMethodsView()) {
                                    ProfileMenuRow(icon: "creditcard.fill", title: "Payment Methods")
                                }
                            }
                        }
                        .padding(.horizontal, KivorlySpacing.md)
                    }

                    // Notifications & Notch / Dynamic Island Group
                    VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                        SectionHeader(title: "Notifications & Alerts")

                        KivorlyCard(padding: 0) {
                            VStack(spacing: 0) {
                                NavigationLink(destination: NotificationPreferencesView()) {
                                    ProfileMenuRow(icon: "bell.badge.fill", title: "Notification Preferences")
                                }
                            }
                        }
                        .padding(.horizontal, KivorlySpacing.md)
                    }

                    // Security & Permissions Group
                    VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                        SectionHeader(title: "Security & Permissions")

                        KivorlyCard(padding: 0) {
                            VStack(spacing: 0) {
                                ProfileToggleRow(icon: "faceid", title: "Face ID", isOn: $isBiometricsEnabled)
                                Divider().padding(.leading, 56)
                                NavigationLink(destination: PrivacySecurityView()) {
                                    ProfileMenuRow(icon: "shield.lefthalf.filled", title: "Privacy & Permissions")
                                }
                            }
                        }
                        .padding(.horizontal, KivorlySpacing.md)
                    }

                    // Help & Support Group
                    VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                        SectionHeader(title: "Help & Support")

                        KivorlyCard(padding: 0) {
                            VStack(spacing: 0) {
                                NavigationLink(destination: HelpCenterView()) {
                                    ProfileMenuRow(icon: "questionmark.circle.fill", title: "Help Center")
                                }

                                Divider().padding(.leading, 56)

                                NavigationLink(destination: TermsPrivacyView()) {
                                    ProfileMenuRow(icon: "doc.text.fill", title: "Terms & Privacy")
                                }

                                Divider().padding(.leading, 56)

                                ProfileMenuRow(icon: "phone.bubble.left.fill", title: "Call 24/7 Hotline") {
                                    showHotlineSheet = true
                                }
                            }
                        }
                        .padding(.horizontal, KivorlySpacing.md)
                    }

                    // Sign Out Button
                    KivorlyButton("Sign Out", icon: "rectangle.portrait.and.arrow.right", style: .destructive) {
                        onLogout()
                    }
                    .padding(.horizontal, KivorlySpacing.md)
                    .padding(.top, KivorlySpacing.sm)

                    // App Version Footer
                    Text("Kivorly • v1.0.0 (Build 2026.10)")
                        .font(KivorlyTypography.caption)
                        .foregroundColor(KivorlyColors.textSecondary)
                        .padding(.bottom, KivorlySpacing.xl)
                }
                .padding(.vertical, KivorlySpacing.md)
            }
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showEditProfileSheet) {
                EditProfileView(name: $userName, phone: $userPhone)
            }
            .confirmationDialog("Choose Language", isPresented: $showLanguagePicker, titleVisibility: .visible) {
                Button("English") {
                    localization.currentLanguage = .english
                }
                Button("বাংলা (Bangla)") {
                    localization.currentLanguage = .bangla
                }
                Button("Cancel", role: .cancel) {}
            }
            .confirmationDialog("24/7 Hotline", isPresented: $showHotlineSheet, titleVisibility: .visible) {
                Button("Call +880 9612 000 888") {
                    print("Calling Kivorly Hotline")
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}
