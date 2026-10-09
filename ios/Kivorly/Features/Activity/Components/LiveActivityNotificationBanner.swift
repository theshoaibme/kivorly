//
//  LiveActivityNotificationBanner.swift
//  Kivorly
//
//  iOS Notification Center style Live Activity card pinned at the top of the Activity panel.
//

import SwiftUI

public struct LiveActivityNotificationBanner: View {
    let service: ServiceType
    let title: String
    let eta: String
    let progress: Double
    let referenceId: String
    let onTap: () -> Void

    public init(
        service: ServiceType = .rideSharing,
        title: String = "Toyota Prius • Driver 3m away",
        eta: String = "3 min",
        progress: Double = 0.75,
        referenceId: String = "KV-RIDE-902",
        onTap: @escaping () -> Void
    ) {
        self.service = service
        self.title = title
        self.eta = eta
        self.progress = progress
        self.referenceId = referenceId
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                // Header: Service Name + "Live Activity" Badge + ETA
                HStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(service.accentTint.opacity(0.15))
                            .frame(width: 26, height: 26)

                        Image(systemName: service.systemIcon)
                            .font(.system(size: 12, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(service.accentTint)
                    }

                    Text(service.title)
                        .font(KivorlyTypography.captionBold)
                        .foregroundColor(KivorlyColors.textPrimary)

                    Text("Live")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(KivorlyColors.primary)
                        .clipShape(Capsule())

                    Spacer()

                    // ETA Pill
                    HStack(spacing: 4) {
                        Circle()
                            .fill(KivorlyColors.primary)
                            .frame(width: 5, height: 5)
                        Text(eta)
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(KivorlyColors.primary)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(KivorlyColors.primary.opacity(0.12))
                    .clipShape(Capsule())
                }

                // Main Content
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(KivorlyTypography.bodySemibold)
                            .foregroundColor(KivorlyColors.textPrimary)
                            .lineLimit(1)

                        Text("Order ID: \(referenceId)")
                            .font(KivorlyTypography.caption)
                            .foregroundColor(KivorlyColors.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(KivorlyColors.textSecondary)
                }

                // Live Progress Bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(uiColor: .tertiarySystemFill))
                            .frame(height: 5)

                        Capsule()
                            .fill(service.accentTint)
                            .frame(width: geo.size.width * CGFloat(progress), height: 5)
                    }
                }
                .frame(height: 5)
            }
            .padding(KivorlySpacing.md)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(KivorlyRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
