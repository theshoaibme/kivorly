//
//  UberRideBookingView.swift
//  Kivorly
//
//  Full Uber-like ride booking interface with real-time interactive MapKit map, GPS pickup,
//  destination search, live vehicle pins, vehicle size categorization (SM, STD, MD, XL, XXL, VIP),
//  proper Kivorly logos, and interactive payment selector with COD & MFS badges.
//

import SwiftUI
import CoreLocation

public struct UberRideBookingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var locationManager = LocationManager.shared

    @State private var stage: RideStage = .choosingTier
    @State private var selectedTier: RideTier = RideTier.sampleTiers[0]
    @State private var selectedPaymentMethod: RidePaymentMethod = RidePaymentMethod.availableMethods[0] // Defaults to Cash to Driver (COD)
    @State private var pickupLocation: String = "Gulshan 2, Circle (Current Location)"
    @State private var destinationLocation: String = "Banani 11, Road 11, Block D"
    @State private var showSearchSheet: Bool = false

    private let pickupCoordinate = LocationManager.defaultCoordinate
    @State private var destinationCoordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 23.7937, longitude: 90.4043)

    // Simulated nearby live vehicles (Gulshan/Banani area)
    private let nearbyVehicles: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 23.7940, longitude: 90.4060),
        CLLocationCoordinate2D(latitude: 23.7915, longitude: 90.4090),
        CLLocationCoordinate2D(latitude: 23.7930, longitude: 90.4030),
        CLLocationCoordinate2D(latitude: 23.7900, longitude: 90.4055)
    ]

    @State private var driverCoordinate: CLLocationCoordinate2D? = nil

    public init() {}

    public var body: some View {
        ZStack(alignment: .bottom) {
            // Background MapKit Real Map View
            UberStyleRideMapView(
                locationManager: locationManager,
                pickupCoord: locationManager.userLocation ?? pickupCoordinate,
                destinationCoord: destinationCoordinate,
                nearbyCarCoordinates: stage == .choosingTier ? nearbyVehicles : [],
                driverCoord: driverCoordinate
            )
            .ignoresSafeArea()

            // Top Floating Header & Location Pill
            VStack(spacing: 8) {
                topControlBar
                destinationSummaryBar
                Spacer()
            }

            // Floating Location Re-Center & Bottom Uber Sheet
            VStack(spacing: 8) {
                HStack {
                    Spacer()
                    Button(action: {
                        locationManager.requestPermission()
                    }) {
                        Circle()
                            .fill(Color(uiColor: .systemBackground))
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "location.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(uiColor: .label))
                            )
                            .shadow(color: Color.black.opacity(0.15), radius: 6, y: 2)
                    }
                    .padding(.trailing, KivorlySpacing.md)
                }

                UberRideBookingSheet(
                    stage: $stage,
                    selectedTier: $selectedTier,
                    selectedPaymentMethod: $selectedPaymentMethod,
                    tiers: RideTier.sampleTiers,
                    driver: RideDriver.sample,
                    onConfirmRide: startDriverDispatch,
                    onCancelRide: resetRide
                )
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSearchSheet) {
            destinationPickerSheet
        }
        .onAppear {
            locationManager.requestPermission()
        }
    }

    private var topControlBar: some View {
        HStack {
            // Left: Back Button
            Button(action: {
                dismiss()
            }) {
                Circle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 6)
            }

            Spacer()

            // Center: Service Logo and Service Name (No green dot)
            HStack(spacing: 8) {
                Image(ServiceType.rideSharing.assetImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)

                Text(ServiceType.rideSharing.title)
                    .font(KivorlyTypography.titleSmall)
                    .foregroundColor(Color(uiColor: .label))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(uiColor: .systemBackground))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.1), radius: 4)

            Spacer()

            // Right: Search Button (only has icon)
            Button(action: {
                showSearchSheet = true
            }) {
                Circle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                    )
                    .shadow(color: Color.black.opacity(0.12), radius: 6)
            }
        }
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.top, 6)
    }

    private var destinationSummaryBar: some View {
        Button(action: {
            showSearchSheet = true
        }) {
            HStack(spacing: KivorlySpacing.sm) {
                VStack(spacing: 4) {
                    Circle()
                        .fill(KivorlyColors.primary)
                        .frame(width: 8, height: 8)
                    Rectangle()
                        .fill(Color(uiColor: .separator))
                        .frame(width: 2, height: 16)
                    Square()
                        .fill(Color.black)
                        .frame(width: 8, height: 8)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(pickupLocation)
                        .font(KivorlyTypography.captionBold)
                        .foregroundColor(Color(uiColor: .label))
                        .lineLimit(1)

                    Divider()

                    Text(destinationLocation)
                        .font(KivorlyTypography.captionBold)
                        .foregroundColor(KivorlyColors.primary)
                        .lineLimit(1)
                }

                Spacer()

                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
            .padding(12)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(KivorlyRadius.medium)
            .shadow(color: Color.black.opacity(0.12), radius: 8)
            .padding(.horizontal, KivorlySpacing.md)
            }
        .buttonStyle(PlainButtonStyle())
    }

    private var destinationPickerSheet: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: KivorlySpacing.md) {
                // Search Input
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                    TextField("Where to?", text: $destinationLocation)
                        .font(KivorlyTypography.bodyMedium)
                }
                .padding()
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(Capsule())
                .padding(.horizontal, KivorlySpacing.md)

                // Quick Destinations
                List {
                    Section("Saved & Recent Places") {
                        ForEach(RideLocationPoint.sampleDestinations) { place in
                            Button(action: {
                                destinationLocation = "\(place.title), \(place.subtitle)"
                                destinationCoordinate = place.coordinate
                                showSearchSheet = false
                            }) {
                                HStack(spacing: KivorlySpacing.md) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(place.title)
                                            .font(KivorlyTypography.bodySemibold)
                                            .foregroundColor(Color(uiColor: .label))
                                        Text(place.subtitle)
                                            .font(KivorlyTypography.caption)
                                            .foregroundColor(Color(uiColor: .secondaryLabel))
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Set Destination")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { showSearchSheet = false }
                }
            }
        }
    }

    private func startDriverDispatch() {
        stage = .findingDriver

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.spring()) {
                driverCoordinate = CLLocationCoordinate2D(latitude: 23.7930, longitude: 90.4065)
                stage = .driverEnRoute
            }
        }
    }

    private func resetRide() {
        withAnimation {
            stage = .choosingTier
            driverCoordinate = nil
        }
    }
}

// Helper Shape for square destination icon
struct Square: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(rect)
        return path
    }
}
