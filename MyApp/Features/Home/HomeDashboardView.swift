//
//  HomeDashboardView.swift
//  Kivorly
//
//  Clean title-focused Home Dashboard with real service illustrations, infinite hero carousel, and deep links into Uber-style ride sharing & other services.
//

import SwiftUI

public struct HomeDashboardView: View {
    private let onSelectService: (ServiceType) -> Void

    @State private var searchText: String = ""
    @State private var activeLocation: String = "Gulshan-2, Dhaka"
    @State private var showNotificationsSheet: Bool = false
    @State private var activeModalService: ServiceType? = nil
    @State private var showUberRideBooking: Bool = false

    public init(onSelectService: @escaping (ServiceType) -> Void) {
        self.onSelectService = onSelectService
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: KivorlySpacing.md) {
                    // 1. Top Header with App Name "Kivorly", Location & Notification Bell
                    HomeHeaderView(
                        location: activeLocation,
                        unreadNotificationCount: 2,
                        onLocationTap: { print("Location change") },
                        onNotificationTap: { showNotificationsSheet = true }
                    )

                    // 2. Search Bar
                    KivorlySearchBar(
                        text: $searchText,
                        placeholder: "Search services or items"
                    )
                    .padding(.horizontal, KivorlySpacing.md)

                    // 3. Hero Carousel (Infinite auto-scrolling loop with real images)
                    HomeHeroCarouselView { bannerItem in
                        if bannerItem.service == .rideSharing {
                            showUberRideBooking = true
                        } else {
                            activeModalService = bannerItem.service
                        }
                    }

                    // 4. 8 Services Grid (Featuring exact 3D illustration assets)
                    HomeServicesGridView { service in
                        if service == .rideSharing {
                            showUberRideBooking = true
                        } else {
                            activeModalService = service
                        }
                    }

                    // 5. Active Order Card
                    HomeActiveOrderCard(
                        title: "Burger & Co. • KV-8921",
                        onDetailsTap: { showNotificationsSheet = true }
                    )

                    // 6. Popular Places
                    HomeRecommendedSection(
                        onViewAll: { activeModalService = .foodDelivery }
                    )
                }
                .padding(.vertical, KivorlySpacing.sm)
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $showNotificationsSheet) {
                NavigationStack {
                    ActivityView()
                }
            }
            .sheet(item: $activeModalService) { service in
                ServiceDetailView(service: service)
            }
            .fullScreenCover(isPresented: $showUberRideBooking) {
                UberRideBookingView()
            }
        }
    }
}
