//
//  ServicesSolarOrbitView.swift
//  Kivorly
//
//  Solar system orbit animation featuring Kivorly app logo as the radiant sun
//  and all 8 core services orbiting smoothly with custom tint glows and orbital tracks.
//

import SwiftUI

public struct ServicesSolarOrbitView: View {
    // Continuous rotation angles for outer and inner orbital rings
    @State private var innerOrbitAngle: Double = 0
    @State private var outerOrbitAngle: Double = 0
    @State private var isCoronaPulsing: Bool = false
    @State private var selectedService: ServiceType? = nil
    @State private var isRotating: Bool = false

    // Inner orbit: 4 services (radius: 76)
    private let innerServices: [ServiceType] = [
        .rideSharing,
        .foodDelivery,
        .grocery,
        .courier
    ]

    // Outer orbit: 4 services offset by 45° (radius: 124)
    private let outerServices: [ServiceType] = [
        .shopping,
        .homeServices,
        .tickets,
        .hotels
    ]

    private let innerRadius: CGFloat = 74
    private let outerRadius: CGFloat = 122

    public init() {}

    public var body: some View {
        ZStack {
            // Background ambient celestial glow
            RadialGradient(
                gradient: Gradient(colors: [
                    KivorlyColors.primary.opacity(0.12),
                    Color.orange.opacity(0.06),
                    Color.clear
                ]),
                center: .center,
                startRadius: 20,
                endRadius: 150
            )
            .frame(width: 300, height: 300)

            // 1. Orbital Track Rings
            orbitalRings

            // 2. Faint Solar Rays (Sun-like light beams)
            solarRays

            // 3. Center Sun: Official Kivorly Brand Logo
            centerSunLogo

            // 4. Inner Orbit Services
            innerOrbitLayer

            // 5. Outer Orbit Services
            outerOrbitLayer
        }
        .frame(width: 290, height: 290)
        .contentShape(Rectangle())
        .onAppear {
            startContinuousAnimation()
        }
    }

    // MARK: - 1. Orbital Guide Rings
    private var orbitalRings: some View {
        ZStack {
            // Outermost faint celestial boundary
            Circle()
                .stroke(KivorlyColors.primary.opacity(0.06), lineWidth: 1)
                .frame(width: outerRadius * 2 + 36, height: outerRadius * 2 + 36)

            // Outer Orbit Track (Dashed)
            Circle()
                .stroke(
                    KivorlyColors.primary.opacity(0.18),
                    style: StrokeStyle(lineWidth: 1.2, lineCap: .round, dash: [4, 6])
                )
                .frame(width: outerRadius * 2, height: outerRadius * 2)

            // Inner Orbit Track (Dashed)
            Circle()
                .stroke(
                    KivorlyColors.primary.opacity(0.22),
                    style: StrokeStyle(lineWidth: 1.2, lineCap: .round, dash: [3, 5])
                )
                .frame(width: innerRadius * 2, height: innerRadius * 2)

            // Subtle celestial star dots on orbit tracks
            ForEach([30.0, 110.0, 210.0, 300.0], id: \.self) { deg in
                Circle()
                    .fill(KivorlyColors.primary.opacity(0.35))
                    .frame(width: 3, height: 3)
                    .offset(
                        x: outerRadius * cos(deg * .pi / 180),
                        y: outerRadius * sin(deg * .pi / 180)
                    )
            }
        }
    }

    // MARK: - 2. Sun-like Rays
    private var solarRays: some View {
        ZStack {
            ForEach(0..<8) { index in
                let angle = Double(index) * 45.0
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.orange.opacity(0.28),
                                KivorlyColors.primary.opacity(0.12),
                                Color.clear
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 1.5, height: 24)
                    .offset(y: -46)
                    .rotationEffect(.degrees(angle))
            }
        }
    }

    // MARK: - 3. Center Sun: App Logo with Corona
    private var centerSunLogo: some View {
        ZStack {
            // Pulsing Corona Glow Layer 2
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.orange.opacity(0.35),
                            KivorlyColors.primary.opacity(0.2),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 10,
                        endRadius: 52
                    )
                )
                .frame(width: 104, height: 104)
                .scaleEffect(isCoronaPulsing ? 1.12 : 0.94)
                .opacity(isCoronaPulsing ? 0.75 : 0.45)

            // Pulsing Corona Border Ring
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [Color.orange.opacity(0.4), KivorlyColors.primary.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
                .frame(width: 78, height: 78)
                .scaleEffect(isCoronaPulsing ? 1.08 : 0.96)

            // Inner warm sun backplate
            Circle()
                .fill(Color(uiColor: .systemBackground))
                .frame(width: 62, height: 62)
                .shadow(color: Color.orange.opacity(0.3), radius: 10, x: 0, y: 0)

            // Official Kivorly Brand Logo
            Image("AppLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                selectedService = nil
            }
        }
    }

    // MARK: - 4. Inner Orbit Layer (4 Services)
    private var innerOrbitLayer: some View {
        ZStack {
            ForEach(innerServices.indices, id: \.self) { index in
                let baseAngle = Double(index) * 90.0
                let service = innerServices[index]
                let isSelected = selectedService == service

                ServiceOrbView(
                    service: service,
                    size: 36,
                    isSelected: isSelected,
                    onTap: {
                        toggleSelection(service)
                    }
                )
                .offset(
                    x: innerRadius * cos(baseAngle * .pi / 180),
                    y: innerRadius * sin(baseAngle * .pi / 180)
                )
                // Counter-rotate each icon so it stays upright while orbiting
                .rotationEffect(.degrees(-innerOrbitAngle))
            }
        }
        .rotationEffect(.degrees(innerOrbitAngle))
    }

    // MARK: - 5. Outer Orbit Layer (4 Services Offset by 45°)
    private var outerOrbitLayer: some View {
        ZStack {
            ForEach(outerServices.indices, id: \.self) { index in
                let baseAngle = Double(index) * 90.0 + 45.0
                let service = outerServices[index]
                let isSelected = selectedService == service

                ServiceOrbView(
                    service: service,
                    size: 38,
                    isSelected: isSelected,
                    onTap: {
                        toggleSelection(service)
                    }
                )
                .offset(
                    x: outerRadius * cos(baseAngle * .pi / 180),
                    y: outerRadius * sin(baseAngle * .pi / 180)
                )
                // Counter-rotate each icon so it stays upright while orbiting
                .rotationEffect(.degrees(-outerOrbitAngle))
            }
        }
        .rotationEffect(.degrees(outerOrbitAngle))
    }

    // MARK: - Helper Methods
    private func toggleSelection(_ service: ServiceType) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            if selectedService == service {
                selectedService = nil
            } else {
                selectedService = service
            }
        }
    }

    private func startContinuousAnimation() {
        guard !isRotating else { return }
        isRotating = true

        // Smooth continuous 360-degree rotation of inner orbit (clockwise, 20s)
        withAnimation(
            .linear(duration: 20)
            .repeatForever(autoreverses: false)
        ) {
            innerOrbitAngle = 360
        }

        // Smooth continuous 360-degree rotation of outer orbit (clockwise, 32s)
        withAnimation(
            .linear(duration: 32)
            .repeatForever(autoreverses: false)
        ) {
            outerOrbitAngle = 360
        }

        // Breathing solar corona pulse
        withAnimation(
            .easeInOut(duration: 2.0)
            .repeatForever(autoreverses: true)
        ) {
            isCoronaPulsing = true
        }
    }
}

// MARK: - Individual Service Orb Component
private struct ServiceOrbView: View {
    let service: ServiceType
    let size: CGFloat
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Sun-like radiating halo around service orb
                Circle()
                    .fill(service.accentTint.opacity(isSelected ? 0.35 : 0.16))
                    .frame(width: size + 10, height: size + 10)
                    .blur(radius: isSelected ? 4 : 2)

                // Background container orb
                Circle()
                    .fill(service.softBackgroundColor)
                    .frame(width: size, height: size)
                    .shadow(
                        color: service.accentTint.opacity(isSelected ? 0.45 : 0.22),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: 2
                    )

                // Crisp border ring
                Circle()
                    .stroke(
                        service.accentTint.opacity(isSelected ? 0.9 : 0.45),
                        lineWidth: isSelected ? 2.0 : 1.2
                    )
                    .frame(width: size, height: size)

                // Sharp SF Symbol Icon
                Image(systemName: service.systemIcon)
                    .font(.system(size: size * 0.42, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(service.accentTint)
            }
            .scaleEffect(isSelected ? 1.18 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ZStack {
        Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
        ServicesSolarOrbitView()
    }
}
