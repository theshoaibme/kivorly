//
//  DynamicIslandLiveActivityBanner.swift
//  Kivorly
//
//  Simulated iPhone Dynamic Island / Notch Live Activity pill for real-time tracking.
//

import SwiftUI

public struct DynamicIslandLiveActivityBanner: View {
    let service: ServiceType
    let title: String
    let eta: String
    let progress: Double // 0.0 to 1.0
    let onTap: () -> Void

    @State private var isExpanded: Bool = false

    public init(
        service: ServiceType = .rideSharing,
        title: String = "Toyota Prius • 3 mins away",
        eta: String = "3 min",
        progress: Double = 0.65,
        onTap: @escaping () -> Void
    ) {
        self.service = service
        self.title = title
        self.eta = eta
        self.progress = progress
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                isExpanded.toggle()
            }
            onTap()
        }) {
            VStack(spacing: 8) {
                HStack(spacing: KivorlySpacing.sm) {
                    // 3D Hierarchical icon
                    ZStack {
                        Circle()
                            .fill(service.accentTint.opacity(0.2))
                            .frame(width: 32, height: 32)

                        Image(systemName: service.systemIcon)
                            .font(.system(size: 14, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(service.accentTint)
                    }

                    // Title
                    Text(title)
                        .font(KivorlyTypography.captionBold)
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Spacer()

                    // ETA Pill
                    HStack(spacing: 4) {
                        Circle()
                            .fill(service.accentTint)
                            .frame(width: 6, height: 6)

                        Text(eta)
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Capsule())
                }

                // Live Progress Track
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 4)

                        Capsule()
                            .fill(service.accentTint)
                            .frame(width: geo.size.width * CGFloat(progress), height: 4)
                    }
                }
                .frame(height: 4)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color.black)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, KivorlySpacing.md)
    }
}
