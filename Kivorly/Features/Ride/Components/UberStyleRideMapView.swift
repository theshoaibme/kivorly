//
//  UberStyleRideMapView.swift
//  Kivorly
//
//  Uber-style interactive MapKit map with authentic pickup & drop-off pins,
//  clean dark polyline, realistic nearby vehicle markers, and GPS tracking.
//

import SwiftUI
import MapKit

public struct UberStyleRideMapView: View {
    @Bindable var locationManager: LocationManager
    let pickupCoord: CLLocationCoordinate2D
    let destinationCoord: CLLocationCoordinate2D?
    let nearbyCarCoordinates: [CLLocationCoordinate2D]
    let driverCoord: CLLocationCoordinate2D?

    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .camera(
        MapCamera(
            centerCoordinate: LocationManager.defaultCoordinate,
            distance: 3500,
            heading: 0,
            pitch: 30
        )
    ))

    public init(
        locationManager: LocationManager,
        pickupCoord: CLLocationCoordinate2D,
        destinationCoord: CLLocationCoordinate2D?,
        nearbyCarCoordinates: [CLLocationCoordinate2D],
        driverCoord: CLLocationCoordinate2D?
    ) {
        self.locationManager = locationManager
        self.pickupCoord = pickupCoord
        self.destinationCoord = destinationCoord
        self.nearbyCarCoordinates = nearbyCarCoordinates
        self.driverCoord = driverCoord
    }

    public var body: some View {
        ZStack {
            Map(position: $cameraPosition) {
                // Uber-style Pickup Pin with Badge Pill & Pulse Dot
                Annotation("Pickup", coordinate: pickupCoord) {
                    VStack(spacing: 2) {
                        Text("Pickup")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(.white)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 3)
                            .background(Color.black)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.25), radius: 3)

                        ZStack {
                            Circle()
                                .fill(Color.black.opacity(0.18))
                                .frame(width: 26, height: 26)

                            Circle()
                                .fill(Color.black)
                                .frame(width: 14, height: 14)

                            Circle()
                                .fill(Color.white)
                                .frame(width: 5, height: 5)
                        }
                    }
                }

                // Uber-style Destination Pin with White Drop Pill & Square Dot
                if let dest = destinationCoord {
                    Annotation("Destination", coordinate: dest) {
                        VStack(spacing: 2) {
                            Text("Drop-off")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(.black)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color.white)
                                .clipShape(Capsule())
                                .shadow(color: Color.black.opacity(0.25), radius: 3)

                            ZStack {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(Color.black)
                                    .frame(width: 16, height: 16)

                                RoundedRectangle(cornerRadius: 2, style: .continuous)
                                    .fill(Color.white)
                                    .frame(width: 6, height: 6)
                            }
                        }
                    }

                    // Uber-style Dark Polyline Route connecting Pickup to Destination
                    MapPolyline(coordinates: [
                        pickupCoord,
                        CLLocationCoordinate2D(
                            latitude: (pickupCoord.latitude * 2 + dest.latitude) / 3,
                            longitude: (pickupCoord.longitude + dest.longitude * 2) / 3
                        ),
                        dest
                    ])
                    .stroke(Color.black, lineWidth: 5)
                }

                // Uber-style Nearby Vehicles (Clean White Discs with Car Silhouettes)
                ForEach(0..<nearbyCarCoordinates.count, id: \.self) { idx in
                    Annotation("Nearby Ride", coordinate: nearbyCarCoordinates[idx]) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 28, height: 28)
                                .shadow(color: Color.black.opacity(0.22), radius: 3, y: 1)

                            Image(systemName: "car.side.fill")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color.black)
                        }
                    }
                }

                // Active Assigned Driver Pin
                if let driver = driverCoord {
                    Annotation("Driver", coordinate: driver) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.25))
                                .frame(width: 40, height: 40)

                            Circle()
                                .fill(Color.black)
                                .frame(width: 26, height: 26)

                            Image(systemName: "car.fill")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .mapControls {
                MapCompass()
                MapScaleView()
            }

            // Location Permission Request Pill
            if locationManager.authorizationStatus == .notDetermined {
                VStack {
                    HStack(spacing: KivorlySpacing.sm) {
                        Image(systemName: "location.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(KivorlyColors.primary)

                        Text("Enable GPS for exact pickup")
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(Color(uiColor: .label))

                        Spacer()

                        Button("Allow") {
                            locationManager.requestPermission()
                        }
                        .font(KivorlyTypography.captionBold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(KivorlyColors.primary)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, KivorlySpacing.md)
                    .padding(.vertical, 10)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(KivorlyRadius.medium)
                    .shadow(color: Color.black.opacity(0.1), radius: 6)
                    .padding(.horizontal, KivorlySpacing.md)
                    .padding(.top, 110)

                    Spacer()
                }
            }
        }
    }
}
