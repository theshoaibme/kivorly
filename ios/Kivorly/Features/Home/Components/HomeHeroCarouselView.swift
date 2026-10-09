//
//  HomeHeroCarouselView.swift
//  Kivorly
//
//  Infinite looped hero carousel featuring real high-resolution images, real service illustrations, and continuous auto-scroll.
//

import SwiftUI
import Combine

public struct HeroBannerItem: Identifiable {
    public let id = UUID()
    public let tag: String
    public let title: String
    public let actionTitle: String
    public let service: ServiceType
    public let backgroundImage: String?
    public let assetGraphic: String
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
            assetGraphic: "service_ride_sharing",
            tintColor: Color(red: 0x25 / 255.0, green: 0x63 / 255.0, blue: 0xEB / 255.0)
        ),
        HeroBannerItem(
            tag: "Fresh Flavors",
            title: "Hot Meals Delivered to Doorstep",
            actionTitle: "Order Food",
            service: .foodDelivery,
            backgroundImage: nil,
            assetGraphic: "service_food_delivery",
            tintColor: Color(red: 0xF9 / 255.0, green: 0x73 / 255.0, blue: 0x16 / 255.0)
        ),
        HeroBannerItem(
            tag: "Organic Daily",
            title: "Fresh Groceries & Dairy in 15m",
            actionTitle: "Shop Fresh",
            service: .grocery,
            backgroundImage: nil,
            assetGraphic: "service_grocery",
            tintColor: Color(red: 0x10 / 255.0, green: 0xB9 / 255.0, blue: 0x81 / 255.0)
        ),
        HeroBannerItem(
            tag: "Top Stays",
            title: "Verified Hotels & Weekend Resorts",
            actionTitle: "Explore",
            service: .hotels,
            backgroundImage: nil,
            assetGraphic: "service_hotels",
            tintColor: Color(red: 0x63 / 255.0, green: 0x66 / 255.0, blue: 0xF1 / 255.0)
        ),
        HeroBannerItem(
            tag: "Home Master",
            title: "AC Servicing & Deep Cleaning",
            actionTitle: "Book Service",
            service: .homeServices,
            backgroundImage: nil,
            assetGraphic: "service_home_services",
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
            .frame(height: 146)
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
                // Background: Real Photo with Gradient or Solid Tint
                if let bg = item.backgroundImage {
                    Image(bg)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 146)
                        .overlay(
                            LinearGradient(
                                colors: [
                                    Color.black.opacity(0.78),
                                    Color.black.opacity(0.40),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipped()
                } else {
                    RoundedRectangle(cornerRadius: KivorlyRadius.medium)
                        .fill(item.tintColor)
                }

                // Foreground Content
                HStack(spacing: KivorlySpacing.md) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(item.tag)
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 9)
                            .padding(.vertical, 3)
                            .background(Color.white.opacity(0.25))
                            .foregroundColor(.white)
                            .clipShape(Capsule())

                        Text(item.title)
                            .font(KivorlyTypography.titleMedium)
                            .foregroundColor(.white)
                            .lineLimit(2)

                        HStack(spacing: 4) {
                            Text(item.actionTitle)
                                .font(KivorlyTypography.captionBold)
                            Image(systemName: "arrow.right")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(item.backgroundImage != nil ? KivorlyColors.primary : item.tintColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white)
                        .clipShape(Capsule())
                    }

                    Spacer()

                    // Real 3D Rendered Service Graphic
                    ZStack {
                        Circle()
                            .fill(item.service.softBackgroundColor.opacity(0.92))
                            .frame(width: 72, height: 72)

                        Image(item.assetGraphic)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 54, height: 54)
                    }
                    .shadow(color: Color.black.opacity(0.15), radius: 6)
                    .padding(.trailing, KivorlySpacing.sm)
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.vertical, KivorlySpacing.sm)
            }
            .cornerRadius(KivorlyRadius.medium)
            .padding(.horizontal, KivorlySpacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
