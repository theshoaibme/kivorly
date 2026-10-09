//
//  NotificationPreferencesView.swift
//  Kivorly
//
//  Granular notification preference controls per service and alert category.
//

import SwiftUI

public struct NotificationPreferencesView: View {
    @State private var allowAllNotifications: Bool = true
    @State private var rideAlerts: Bool = true
    @State private var foodDeliveryAlerts: Bool = true
    @State private var shoppingDiscounts: Bool = false
    @State private var groceryUpdates: Bool = true
    @State private var courierTracking: Bool = true
    @State private var promotionalOffers: Bool = false
    @State private var soundAndVibration: Bool = true
    @State private var liveActivityLockScreen: Bool = true

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: KivorlySpacing.lg) {
                // Master Toggle
                VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                    SectionHeader(title: "Master Control")

                    KivorlyCard(padding: 0) {
                        ProfileToggleRow(
                            icon: "bell.badge.fill",
                            title: "Allow Notifications",
                            isOn: $allowAllNotifications
                        )
                    }
                }

                if allowAllNotifications {
                    // iPhone Notch & Lock Screen
                    VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                        SectionHeader(title: "iPhone Dynamic Island & Lock Screen")

                        KivorlyCard(padding: 0) {
                            VStack(spacing: 0) {
                                ProfileToggleRow(
                                    icon: "capsule.fill",
                                    title: "Dynamic Island Live Activities",
                                    isOn: $liveActivityLockScreen
                                )
                                Divider().padding(.leading, 56)
                                ProfileToggleRow(
                                    icon: "speaker.wave.2.fill",
                                    title: "Sound & Haptics",
                                    isOn: $soundAndVibration
                                )
                            }
                        }
                    }

                    // Per-Service Preferences
                    VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                        SectionHeader(title: "Service Notifications")

                        KivorlyCard(padding: 0) {
                            VStack(spacing: 0) {
                                ProfileToggleRow(icon: "car.fill", title: "Ride Sharing ETA", isOn: $rideAlerts)
                                Divider().padding(.leading, 56)
                                ProfileToggleRow(icon: "fork.knife", title: "Food Preparation & Delivery", isOn: $foodDeliveryAlerts)
                                Divider().padding(.leading, 56)
                                ProfileToggleRow(icon: "shippingbox.fill", title: "Courier Status", isOn: $courierTracking)
                                Divider().padding(.leading, 56)
                                ProfileToggleRow(icon: "basket.fill", title: "Grocery Dispatched", isOn: $groceryUpdates)
                                Divider().padding(.leading, 56)
                                ProfileToggleRow(icon: "tag.fill", title: "Shopping Deals & Offers", isOn: $shoppingDiscounts)
                                Divider().padding(.leading, 56)
                                ProfileToggleRow(icon: "sparkles", title: "Promotions & Vouchers", isOn: $promotionalOffers)
                            }
                        }
                    }
                }
            }
            .padding(KivorlySpacing.md)
        }
        .background(KivorlyColors.background.ignoresSafeArea())
        .navigationTitle("Notification Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
}
