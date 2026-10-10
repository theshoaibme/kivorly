//
//  HomeHeroCarouselView.swift
//  Kivorly
//
//  Infinite looped hero carousel featuring ACTUAL high-resolution stock photography
//  (no icon images), flat styling (no shadows, no gradients), and continuous auto-scroll.
//

import SwiftUI
import Combine

public struct HeroBannerItem: Identifiable {
    public let id = UUID()
    public let tag: String
    public let title: String
    public let actionTitle: String
    public let service: ServiceType
    public let backgroundImage: String
    public let tintColor: Color
}

public struct HomeHeroCarouselView: View {
    let onSelectBanner: (HeroBannerItem) -> Void

    @State private var virtualIndex: Int = 1000
    private let timer = Timer.publish(every: 3.8, on: .main, in: .common).autoconnect()

    private let banners: [HeroBannerItem] = [
        HeroBannerItem(
            tag: "Fast Commute",
            title: "Instant City Rides with Live GPS",
            actionTitle: "Book Ride",
            service: .rideSharing,
            backgroundImage: "hero_ride_banner",
            tintColor: Color(red: 0x25 / 255.0, green: 0x63 / 255.0, blue: 0xEB / 255.0)
        ),
        HeroBannerItem(
            tag: "Fresh Flavors",
            title: "Hot Meals Delivered to Doorstep",
            actionTitle: "Order Food",
            service: .foodDelivery,
            backgroundImage: "hero_food_banner",
            tintColor: Color(red: 0xF9 / 255.0, green: 0x73 / 255.0, blue: 0x16 / 255.0)
        ),
        HeroBannerItem(
            tag: "Organic Daily",
            title: "Fresh Groceries & Dairy in 15m",
            actionTitle: "Shop Fresh",
            service: .grocery,
            backgroundImage: "hero_grocery_banner",
            tintColor: Color(red: 0x10 / 255.0, green: 0xB9 / 255.0, blue: 0x81 / 255.0)
        ),
        HeroBannerItem(
            tag: "Festival Mall",
            title: "Official Brand Stores Mega Offers",
            actionTitle: "Shop Now",
            service: .shopping,
            backgroundImage: "hero_shopping_banner",
            tintColor: Color(red: 0x8B / 255.0, green: 0x5C / 255.0, blue: 0xF6 / 255.0)
        ),
        HeroBannerItem(
            tag: "Top Stays",
            title: "Verified Hotels & Weekend Resorts",
            actionTitle: "Explore",
            service: .hotels,
            backgroundImage: "hero_hotels_banner",
            tintColor: Color(red: 0x63 / 255.0, green: 0x66 / 255.0, blue: 0xF1 / 255.0)
        ),
        HeroBannerItem(
            tag: "Express Travel",
            title: "Intercity AC Coach & Train Tickets",
            actionTitle: "Book Tickets",
            service: .tickets,
            backgroundImage: "hero_tickets_banner",
            tintColor: Color(red: 0xF4 / 255.0, green: 0x3F / 255.0, blue: 0x5E / 255.0)
        ),
        HeroBannerItem(
            tag: "Nationwide Express",
            title: "30-Min Doorstep Parcel Pickup",
            actionTitle: "Send Parcel",
            service: .courier,
            backgroundImage: "hero_courier_banner",
            tintColor: Color(red: 0xF5 / 255.0, green: 0x9E / 255.0, blue: 0x0B / 255.0)
        ),
        HeroBannerItem(
            tag: "Home Master",
            title: "AC Servicing & Deep Cleaning",
            actionTitle: "Book Service",
            service: .homeServices,
            backgroundImage: "hero_home_services_banner",
            tintColor: Color(red: 0x06 / 255.0, green: 0xB6 / 255.0, blue: 0xD4 / 255.0)
        )
    ]

    public init(onSelectBanner: @escaping (HeroBannerItem) -> Void) {
        self.onSelectBanner = onSelectBanner
    }

    private var activeBannerIndex: Int {
        let count = banners.count
        guard count > 0 else { return 0 }
        return (virtualIndex % count + count) % count
    }

    public var body: some View {
        VStack(spacing: KivorlySpacing.xs) {
            // Truly Infinite Paging TabView
            TabView(selection: $virtualIndex) {
                ForEach(0..<2000, id: \.self) { index in
                    let banner = banners[index % banners.count]
                    bannerCard(banner)
                        .tag(index)
                }
            }
            .frame(height: 154)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 0.55)) {
                    virtualIndex += 1
                }
            }

            // Synchronized Continuous Loop Indicators
            HStack(spacing: 6) {
                ForEach(0..<banners.count, id: \.self) { index in
                    Capsule()
                        .fill(activeBannerIndex == index ? banners[activeBannerIndex].tintColor : Color(uiColor: .tertiarySystemFill))
                        .frame(width: activeBannerIndex == index ? 20 : 6, height: 6)
                        .animation(.easeInOut(duration: 0.25), value: activeBannerIndex)
                }
            }
            .padding(.top, 4)
        }
    }

    private func bannerCard(_ item: HeroBannerItem) -> some View {
        Button(action: {
            onSelectBanner(item)
        }) {
            ZStack(alignment: .leading) {
                // Background: Actual Real Stock Photography with Solid Contrast Overlay (No Gradient)
                Image(item.backgroundImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 154)
                    .overlay(
                        Color.black.opacity(0.46)
                    )
                    .clipped()

                // Foreground Content (Actual images only, No icon images)
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.tag)
                        .font(.system(size: 10, weight: .bold))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(item.tintColor)
                        .foregroundColor(.white)
                        .clipShape(Capsule())

                    Text(item.title)
                        .font(KivorlyTypography.titleMedium)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: 4)

                    // Default iPhone Action Button (No shadow, no gradient)
                    HStack(spacing: 5) {
                        Text(item.actionTitle)
                            .font(.system(size: 12, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 10, weight: .bold))
                    }
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.white)
                    .clipShape(Capsule())
                }
                .padding(16)
            }
            .frame(maxWidth: .infinity, maxHeight: 154)
            .cornerRadius(18)
            .padding(.horizontal, KivorlySpacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
