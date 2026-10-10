//
//  ServicesSolarOrbitView.swift
//  Kivorly
//
//  Apple-inspired clean radial services showcase:
//  - All 8 core service icons bloom open one by one from the center logo with fluid spring motion.
//  - Prominent, large authentic 3D graphic assets from the app (service.assetImageName).
//  - Smooth continuous rotation around the central Kivorly logo.
//  - While rotating, icons smoothly zoom in / swell much bigger one by one in an organic sequence.
//  - Zero borders, zero shadows, zero background orbits/tracks.
//

import SwiftUI

public struct ServicesSolarOrbitView: View {
    @State private var orbVisible: [Bool] = Array(repeating: false, count: 8)
    @State private var selectedService: ServiceType? = nil
    @State private var centerLogoAppeared: Bool = false

    // All 8 core services
    private let allServices: [ServiceType] = ServiceType.allCases

    // Constellation radial distance & prominent orb sizes
    private let orbitRadius: CGFloat = 114
    private let orbSize: CGFloat = 52
    private let iconSize: CGFloat = 40

    // Frame dimensions
    private let canvasSize: CGFloat = 310
    private var centerPoint: CGFloat { canvasSize / 2.0 }

    // Rotation cycle speed (34 seconds for full 360° rotation)
    private let rotationDuration: Double = 34.0

    // Pseudo-random order for icons smoothly popping large one by one
    // (Jumping playfully across opposite quadrants: top, bottom, top-right, bottom-left, etc.)
    private let swellSequence: [Int] = [0, 4, 1, 6, 3, 7, 2, 5]
    private let swellStepDuration: Double = 1.45

    public init() {}

    public var body: some View {
        VStack(spacing: KivorlySpacing.md) {
            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let currentAngle = (time.truncatingRemainder(dividingBy: rotationDuration) / rotationDuration) * 360.0

                // Active progress through the one-by-one zoom in cycle
                let totalSwellTime = Double(swellSequence.count) * swellStepDuration
                let swellTimeNormalized = (time.truncatingRemainder(dividingBy: totalSwellTime)) / swellStepDuration

                ZStack {
                    // Center: Official Kivorly Brand Logo (Zero borders, zero background, zero shadows)
                    centerLogoView

                    // All 8 Services: Large 3D app icons, bloom open & zoom in significantly bigger one by one
                    ForEach(allServices.indices, id: \.self) { index in
                        let isBloomed = orbVisible[index]
                        let baseAngle = Double(index) * (360.0 / Double(allServices.count))
                        let angleDegrees = baseAngle + currentAngle
                        let angleRadians = angleDegrees * .pi / 180.0

                        let r = isBloomed ? orbitRadius : 0.0
                        let x = r * cos(angleRadians)
                        let y = r * sin(angleRadians)

                        let service = allServices[index]
                        let isSelected = selectedService == service

                        // Calculate organic Apple-style swell pulse for this specific icon
                        let orderInSequence = Double(swellSequence.firstIndex(of: index) ?? index)
                        let dist = abs(swellTimeNormalized - orderInSequence)
                        let wrappedDist = min(dist, Double(swellSequence.count) - dist)

                        // Smooth bell curve (peaks at 1.0, settles cleanly to 0.0)
                        let pulse: CGFloat = wrappedDist < 1.0 ? CGFloat(pow(cos(wrappedDist * .pi * 0.5), 2)) : 0.0
                        
                        // Large dynamic zoom-in scale (+55% bigger when pulsing, +65% when selected)
                        let dynamicScale: CGFloat = 1.0 + 0.55 * pulse
                        let finalScale: CGFloat = isBloomed ? (isSelected ? 1.65 : dynamicScale) : 0.01

                        ActualServiceOrbView(
                            service: service,
                            size: orbSize,
                            iconSize: iconSize,
                            isSelected: isSelected,
                            onTap: {
                                toggleSelection(service)
                            }
                        )
                        .scaleEffect(finalScale)
                        .opacity(isBloomed ? 1.0 : 0.0)
                        .position(x: centerPoint + x, y: centerPoint + y)
                        .zIndex(isSelected ? 20.0 : Double(pulse * 10.0))
                        .animation(
                            .spring(response: 0.58, dampingFraction: 0.72),
                            value: isBloomed
                        )
                    }
                }
                .frame(width: canvasSize, height: canvasSize)
            }

            // Interactive service name pill when tapped (Clean, zero borders, zero shadows)
            if let selected = selectedService {
                HStack(spacing: 8) {
                    Image(selected.assetImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    Text(selected.title)
                        .font(KivorlyTypography.captionBold)
                        .foregroundColor(selected.accentTint)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(selected.softBackgroundColor)
                .clipShape(Capsule())
                .transition(.scale.combined(with: .opacity))
            } else {
                Text(" ")
                    .font(KivorlyTypography.captionBold)
                    .padding(.vertical, 6)
                    .opacity(0)
            }
        }
        .contentShape(Rectangle())
        .onAppear {
            triggerAppleStyleEntrance()
        }
    }

    // MARK: - Center Sun: Kivorly Logo (Zero Borders, Zero Background, Zero Shadows)
    private var centerLogoView: some View {
        Image("AppLogo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
            .scaleEffect(centerLogoAppeared ? 1.0 : 0.6)
            .opacity(centerLogoAppeared ? 1.0 : 0.0)
            .onTapGesture {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                    selectedService = nil
                }
            }
    }

    // MARK: - Apple-like Staggered Bloom Entrance
    private func triggerAppleStyleEntrance() {
        centerLogoAppeared = false
        for i in 0..<orbVisible.count {
            orbVisible[i] = false
        }

        // Center logo appears first with smooth spring
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
            centerLogoAppeared = true
        }

        // Service icons bloom open one by one outward from center
        for i in 0..<allServices.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12 + Double(i) * 0.075) {
                withAnimation(.spring(response: 0.58, dampingFraction: 0.72)) {
                    if i < orbVisible.count {
                        orbVisible[i] = true
                    }
                }
            }
        }
    }

    // MARK: - Selection Helper
    private func toggleSelection(_ service: ServiceType) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            if selectedService == service {
                selectedService = nil
            } else {
                selectedService = service
            }
        }
    }
}

// MARK: - Actual 3D Service Orb Component (Zero Borders, Zero Shadows)
private struct ActualServiceOrbView: View {
    let service: ServiceType
    let size: CGFloat
    let iconSize: CGFloat
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Flat soft pastel container circle (Zero borders, zero shadows)
                Circle()
                    .fill(service.softBackgroundColor)
                    .frame(width: size, height: size)

                // Actual 3D rendered graphic asset used across the app
                Image(service.assetImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
            }
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
