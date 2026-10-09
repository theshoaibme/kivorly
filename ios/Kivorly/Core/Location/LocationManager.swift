//
//  LocationManager.swift
//  Kivorly
//
//  Real-time CoreLocation wrapper managing permission state and device coordinates.
//

import Foundation
import CoreLocation

@Observable
public final class LocationManager: NSObject, CLLocationManagerDelegate {
    public static let shared = LocationManager()

    private let manager = CLLocationManager()

    public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    public var userLocation: CLLocationCoordinate2D? = nil
    public var isLocating: Bool = false

    // Default fallback coordinate (Gulshan 2, Dhaka)
    public static let defaultCoordinate = CLLocationCoordinate2D(latitude: 23.7925, longitude: 90.4078)

    public override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = manager.authorizationStatus
    }

    public func requestPermission() {
        if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startUpdating()
        }
    }

    public func startUpdating() {
        isLocating = true
        manager.startUpdatingLocation()
    }

    public func stopUpdating() {
        isLocating = false
        manager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startUpdating()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        userLocation = latest.coordinate
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Silently preserve last location or fallback
    }
}
