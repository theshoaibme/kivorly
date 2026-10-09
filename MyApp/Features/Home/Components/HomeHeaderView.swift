//
//  HomeHeaderView.swift
//  Kivorly
//
//  Native header with brand title, location selector, notification bell with unread badge, and user profile avatar.
//

import SwiftUI

public struct HomeHeaderView: View {
    let location: String
    let unreadNotificationCount: Int
    let onLocationTap: () -> Void
    let onNotificationTap: () -> Void

    public init(
        location: String,
        unreadNotificationCount: Int = 2,
        onLocationTap: @escaping () -> Void,
        onNotificationTap: @escaping () -> Void
    ) {
        self.location = location
        self.unreadNotificationCount = unreadNotificationCount
        self.onLocationTap = onLocationTap
        self.onNotificationTap = onNotificationTap
    }

    public var body: some View {
        HStack(spacing: KivorlySpacing.sm) {
            // Brand Title & Location Column
            VStack(alignment: .leading, spacing: 2) {
                // App Name Brand Header
                Text("Kivorly")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundColor(KivorlyColors.textPrimary)

                // Location Picker
                Button(action: onLocationTap) {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(KivorlyColors.primary)
                            .font(.system(size: 13, weight: .semibold))

                        Text(location)
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(KivorlyColors.textSecondary)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(KivorlyColors.textSecondary)
                    }
                }
            }

            Spacer()

            // Notification Bell & Profile Avatar of MD Shoaib Khan
            HStack(spacing: 10) {
                Button(action: onNotificationTap) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 17))
                            .foregroundColor(KivorlyColors.textPrimary)
                            .frame(width: 42, height: 42)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .clipShape(Circle())

                        if unreadNotificationCount > 0 {
                            Text("\(unreadNotificationCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(KivorlyColors.primary)
                                .clipShape(Capsule())
                                .offset(x: 4, y: -2)
                        }
                    }
                }
                .accessibilityLabel("Notifications")

                // MD Shoaib Khan Profile Image
                Image("profile_user")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 42, height: 42)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(KivorlyColors.primary.opacity(0.35), lineWidth: 1.5)
                    )
                    .shadow(color: Color.black.opacity(0.06), radius: 4, y: 1)
            }
        }
        .padding(.horizontal, KivorlySpacing.md)
    }
}
