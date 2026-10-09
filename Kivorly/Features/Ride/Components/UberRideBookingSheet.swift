//
//  UberRideBookingSheet.swift
//  Kivorly
//
//  Uber-style interactive bottom sheet supporting:
//  - Interactive gesture & toggle between Compact View and Full View (when user moves to top).
//  - Fully rounded Capsule action buttons throughout.
//  - Clean, organized "Finding Driver" panel with solid-colored progress bar.
//  - StrokeBorder on vehicle cards for 100% visible 4-sided selection borders.
//  - High-contrast size badges (SM, STD, MD, XL, XXL, VIP) and payment badges (COD, etc.).
//

import SwiftUI

public struct UberRideBookingSheet: View {
    @Binding var stage: RideStage
    @Binding var selectedTier: RideTier
    @Binding var selectedPaymentMethod: RidePaymentMethod
    let tiers: [RideTier]
    let driver: RideDriver
    let onConfirmRide: () -> Void
    let onCancelRide: () -> Void

    @State private var selectedCategory: VehicleCategory = .all
    @State private var showPaymentMethodPicker: Bool = false
    @State private var requestProgress: Double = 0.20
    @State private var isExpanded: Bool = false

    private var filteredTiers: [RideTier] {
        if selectedCategory == .all {
            return tiers
        }
        return tiers.filter { $0.category == selectedCategory }
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Interactive Drag Handle & Toggle between Full and Compact View
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                    isExpanded.toggle()
                }
            }) {
                Capsule()
                    .fill(Color(uiColor: .systemGray4))
                    .frame(width: 38, height: 4.5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
                    .padding(.bottom, 8)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 15)
                    .onEnded { value in
                        if value.translation.height < -30 {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                                isExpanded = true
                            }
                        } else if value.translation.height > 30 {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                                isExpanded = false
                            }
                        }
                    }
            )

            switch stage {
            case .choosingTier:
                tallerTiersSelectionView

            case .findingDriver:
                cleanFindingDriverPanel

            case .driverEnRoute, .tripInProgress:
                compactActiveTripDriverView

            case .tripCompleted:
                compactTripCompletedView

            default:
                EmptyView()
            }
        }
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.top, 4)
        .padding(.bottom, 24)
        .frame(maxWidth: .infinity)
        .background(
            Color(uiColor: .secondarySystemGroupedBackground)
                .clipShape(CustomCornerShape(radius: 28, corners: [.topLeft, .topRight]))
                .ignoresSafeArea(edges: .bottom)
        )
        .shadow(color: Color.black.opacity(0.12), radius: 14, y: -4)
        .sheet(isPresented: $showPaymentMethodPicker) {
            compactPaymentPickerSheet
        }
        .onChange(of: stage) { _, newStage in
            if newStage != .choosingTier {
                isExpanded = false
            }
        }
    }

    // MARK: - Taller & Organized Tiers Selection View (Compact & Full View Modes)
    private var tallerTiersSelectionView: some View {
        VStack(spacing: 10) {


            // Category Filter Pills with Full Border Visibility
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(VehicleCategory.allCases) { category in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedCategory = category
                            }
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: category.icon)
                                    .font(.system(size: 12, weight: .semibold))
                                Text(category.rawValue)
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                selectedCategory == category ?
                                Color(uiColor: .systemFill) :
                                Color(uiColor: .tertiarySystemFill)
                            )
                            .foregroundColor(
                                selectedCategory == category ?
                                Color(uiColor: .label) :
                                Color(uiColor: .secondaryLabel)
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(
                                        selectedCategory == category ?
                                        Color(uiColor: .tintColor) :
                                        Color(uiColor: .separator).opacity(0.3),
                                        lineWidth: selectedCategory == category ? 2 : 0.6
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 2)
            }

            // Vehicle List with Interactive Compact (240pt) vs Full View (500pt)
            ScrollView(.vertical, showsIndicators: isExpanded) {
                VStack(spacing: 8) {
                    ForEach(filteredTiers) { tier in
                        Button(action: {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                selectedTier = tier
                            }
                        }) {
                            HStack(spacing: 12) {
                                // Vehicle Icon badge
                                ZStack {
                                    Circle()
                                        .fill(ServiceType.rideSharing.softBackgroundColor)
                                        .frame(width: 48, height: 48)

                                    Image(systemName: tier.iconName)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(KivorlyColors.primary)
                                }

                                // Vehicle Title, Size Badge, Passenger Count & ETA
                                VStack(alignment: .leading, spacing: 3) {
                                    HStack(spacing: 6) {
                                        Text(tier.title)
                                            .font(.system(size: 15, weight: .bold))
                                            .foregroundColor(Color(uiColor: .label))

                                        // Distinct Sizing Badge (SM, STD, MD, XL, XXL, VIP)
                                        Text(tier.size.rawValue)
                                            .font(.system(size: 10, weight: .black))
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2.5)
                                            .background(tier.size.badgeColor)
                                            .clipShape(Capsule())

                                        // Passenger Capacity
                                        HStack(spacing: 2) {
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 9))
                                            Text("\(tier.capacity)")
                                                .font(.system(size: 11, weight: .bold))
                                        }
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                    }

                                    HStack(spacing: 4) {
                                        Text(tier.etaText)
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(KivorlyColors.primary)

                                        Text("•")
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(uiColor: .tertiaryLabel))

                                        Text(tier.vehicleDescription)
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(uiColor: .secondaryLabel))
                                            .lineLimit(1)
                                    }
                                }

                                Spacer()

                                // Price in Taka
                                Text(tier.priceText)
                                    .font(.system(size: 17, weight: .heavy, design: .rounded))
                                    .foregroundColor(Color(uiColor: .label))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(
                                        selectedTier.id == tier.id ?
                                        Color(uiColor: .tintColor).opacity(0.08) :
                                        Color(uiColor: .tertiarySystemGroupedBackground)
                                    )
                            )
                            // StrokeBorder ensures all 4 sides are drawn cleanly inside bounds
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(
                                        selectedTier.id == tier.id ?
                                        Color(uiColor: .tintColor) :
                                        Color(uiColor: .separator).opacity(0.35),
                                        lineWidth: selectedTier.id == tier.id ? 2 : 0.8
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 3)
            }
            .frame(maxHeight: isExpanded ? 540 : 200) // Smoothly adjusts between compact and full view

            Divider()
                .padding(.vertical, 2)

            // Payment Pill & Default-Sized Rounded Action Button
            HStack(spacing: 12) {
                // Payment Method Selector Pill (Rounded, default height)
                Button(action: {
                    showPaymentMethodPicker = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: selectedPaymentMethod.iconName)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(selectedPaymentMethod.badgeColor)

                        Text(selectedPaymentMethod.badgeText)
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(selectedPaymentMethod.badgeColor)
                            .clipShape(Capsule())

                        Image(systemName: "chevron.up.chevron.down")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Color(uiColor: .tertiaryLabel))
                    }
                    .padding(.horizontal, 12)
                    .frame(height: 50)
                    .background(Color(uiColor: .tertiarySystemGroupedBackground))
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .strokeBorder(Color(uiColor: .separator).opacity(0.4), lineWidth: 1)
                    )
                }
                .buttonStyle(PlainButtonStyle())

                // Confirm Button: Fully Rounded Capsule, just Confirm text
                Button(action: {
                    requestProgress = 0.20
                    isExpanded = false
                    onConfirmRide()
                }) {
                    HStack {
                        Text("Confirm")
                            .font(.system(size: 15, weight: .bold))

                        Spacer()

                        Text(selectedTier.priceText)
                            .font(.system(size: 16, weight: .heavy, design: .rounded))

                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .frame(height: 50)
                    .background(KivorlyColors.primary)
                    .clipShape(Capsule())
                    .shadow(color: KivorlyColors.primary.opacity(0.25), radius: 6, y: 3)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    // MARK: - Clean & Organized Finding Driver Panel (Solid Progress Bar, No Gradient)
    private var cleanFindingDriverPanel: some View {
        VStack(spacing: 14) {
            // Header: Status + Live Spinner + Fare
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(KivorlyColors.primary.opacity(0.10))
                        .frame(width: 44, height: 44)

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: KivorlyColors.primary))
                        .scaleEffect(1.0)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Finding your driver...")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(uiColor: .label))

                    Text("Contacting nearest \(selectedTier.title)s")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(selectedTier.priceText)
                        .font(.system(size: 17, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(uiColor: .label))

                    Text(selectedPaymentMethod.badgeText)
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(selectedPaymentMethod.badgeColor)
                        .clipShape(Capsule())
                }
            }

            // Solid-Colored Progress Bar (No Gradient)
            VStack(spacing: 6) {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(uiColor: .systemGray5))
                            .frame(height: 5)

                        // Pure solid color bar, NO gradient
                        Capsule()
                            .fill(KivorlyColors.primary)
                            .frame(width: max(geo.size.width * requestProgress, 20), height: 5)
                            .animation(.easeInOut(duration: 0.5), value: requestProgress)
                    }
                }
                .frame(height: 5)

                HStack {
                    Text("Searching Gulshan & Banani")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(uiColor: .secondaryLabel))

                    Spacer()

                    Text("\(Int(requestProgress * 100))%")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(KivorlyColors.primary)
                }
            }
            .onAppear {
                requestProgress = 0.20
                withAnimation(.easeInOut(duration: 2.2)) {
                    requestProgress = 0.95
                }
            }

            // Clean Organized Vehicle Details Card
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(ServiceType.rideSharing.softBackgroundColor)
                        .frame(width: 36, height: 36)

                    Image(systemName: selectedTier.iconName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(KivorlyColors.primary)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(selectedTier.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(uiColor: .label))

                        Text(selectedTier.size.rawValue)
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(selectedTier.size.badgeColor)
                            .clipShape(Capsule())
                    }

                    Text("\(selectedTier.capacity) Seats • \(selectedTier.vehicleDescription)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }

                Spacer()

                HStack(spacing: 3) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 10))
                        .foregroundColor(KivorlyColors.primary)

                    Text(selectedTier.etaText)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(KivorlyColors.primary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(uiColor: .tertiarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color(uiColor: .separator).opacity(0.35), lineWidth: 0.8)
            )

            // Fully Rounded Cancel Request Button (Capsule, 50pt height)
            Button(role: .destructive, action: onCancelRide) {
                HStack(spacing: 6) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15, weight: .semibold))

                    Text("Cancel Request")
                        .font(.system(size: 15, weight: .bold))
                }
                .foregroundColor(KivorlyColors.error)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(KivorlyColors.error.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 6)
    }

    // MARK: - Compact Payment Picker Sheet (With StrokeBorder)
    private var compactPaymentPickerSheet: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("Select Payment Method")
                    .font(KivorlyTypography.titleSmall)
                    .padding(.top, 14)

                VStack(spacing: 8) {
                    ForEach(RidePaymentMethod.availableMethods) { method in
                        Button(action: {
                            selectedPaymentMethod = method
                            showPaymentMethodPicker = false
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: method.iconName)
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(method.badgeColor)
                                    .frame(width: 28)

                                Text(method.title)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(Color(uiColor: .label))

                                Spacer()

                                Text(method.badgeText)
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(method.badgeColor)
                                    .clipShape(Capsule())

                                if selectedPaymentMethod.id == method.id {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(uiColor: .tintColor))
                                        .padding(.leading, 4)
                                }
                            }
                            .padding(.horizontal, 14)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .fill(
                                        selectedPaymentMethod.id == method.id ?
                                        Color(uiColor: .tintColor).opacity(0.08) :
                                        Color(uiColor: .secondarySystemGroupedBackground)
                                    )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .strokeBorder(
                                        selectedPaymentMethod.id == method.id ?
                                        Color(uiColor: .tintColor) :
                                        Color(uiColor: .separator).opacity(0.35),
                                        lineWidth: selectedPaymentMethod.id == method.id ? 2 : 0.8
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, KivorlySpacing.md)

                Spacer()
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        showPaymentMethodPicker = false
                    }
                    .font(KivorlyTypography.bodySemibold)
                    .foregroundColor(Color(uiColor: .tintColor))
                }
            }
        }
        .presentationDetents([.fraction(0.48)])
    }

    // MARK: - Active Trip Driver
    private var compactActiveTripDriverView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 42))
                    .foregroundColor(Color(uiColor: .tintColor))

                VStack(alignment: .leading, spacing: 2) {
                    Text(driver.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(uiColor: .label))

                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 11))
                            .foregroundColor(.yellow)
                        Text(String(format: "%.2f", driver.rating))
                            .font(.system(size: 12, weight: .bold))

                        Text("• \(driver.carModel)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .lineLimit(1)
                    }
                }

                Spacer()

                HStack(spacing: 10) {
                    Button(action: {}) {
                        Circle()
                            .fill(Color(uiColor: .tertiarySystemFill))
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "phone.fill").font(.system(size: 15)).foregroundColor(Color(uiColor: .tintColor)))
                    }

                    Button(action: {}) {
                        Circle()
                            .fill(Color(uiColor: .tertiarySystemFill))
                            .frame(width: 40, height: 40)
                            .overlay(Image(systemName: "message.fill").font(.system(size: 15)).foregroundColor(Color(uiColor: .tintColor)))
                    }
                }
            }

            Divider()

            HStack {
                HStack(spacing: 6) {
                    Text(selectedTier.size.rawValue)
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2.5)
                        .background(selectedTier.size.badgeColor)
                        .clipShape(Capsule())

                    Text(selectedPaymentMethod.badgeText)
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2.5)
                        .background(selectedPaymentMethod.badgeColor)
                        .clipShape(Capsule())

                    Text("Arriving in 3m")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(uiColor: .tintColor))
                }

                Spacer()

                Text(driver.licensePlate)
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(uiColor: .tertiarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }

            // Fully Rounded Cancel Ride Button
            Button(role: .destructive, action: onCancelRide) {
                Text("Cancel Ride")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(KivorlyColors.error)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(Capsule())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 6)
    }

    // MARK: - Trip Completed
    private var compactTripCompletedView: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(KivorlyColors.success)

            Text("Arrived at Destination")
                .font(.system(size: 17, weight: .bold))

            HStack(spacing: 8) {
                Text(selectedTier.priceText)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))

                Text(selectedPaymentMethod.badgeText)
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 3)
                    .background(selectedPaymentMethod.badgeColor)
                    .clipShape(Capsule())
            }

            // Fully Rounded Done Button
            Button(action: onCancelRide) {
                Text("Done")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(KivorlyColors.primary)
                    .clipShape(Capsule())
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}
