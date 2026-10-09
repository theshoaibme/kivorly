//
//  BangladeshHotelsBookingView.swift
//  Kivorly
//
//  End-to-End Bangladeshi Hotel & Resort Package Booking System
//  Features Day-cation (1 Day), 1 Night, 2 Nights Weekend, 3 Nights Holiday,
//  1 Week Vacation, 1 Month Long-Stay / Workcation, and VIP Premium Packages.
//  Strictly no uppercase strings, clean UI, all pricing in Bangladeshi Taka (৳).
//

import SwiftUI

public enum StayPackageType: String, CaseIterable, Identifiable {
    case all = "All Packages"
    case dayCation = "☀️ 1 Day Day-cation"
    case oneNight = "🌙 1 Night Stay"
    case twoNights = "🏖️ 2 Nights Weekend"
    case threeNights = "✨ 3 Nights Holiday"
    case oneWeek = "🌴 1 Week Vacation (7 Nights)"
    case oneMonth = "💼 1 Month Long-Stay (30 Nights)"
    case vipPremium = "👑 VIP Premium Luxury"

    public var id: String { rawValue }

    public var durationLabel: String {
        switch self {
        case .all: return "All Durations"
        case .dayCation: return "10 AM - 6 PM (8 Hours)"
        case .oneNight: return "1 Night (Overnight)"
        case .twoNights: return "2 Nights / 3 Days"
        case .threeNights: return "3 Nights / 4 Days"
        case .oneWeek: return "7 Nights (Weekly Special)"
        case .oneMonth: return "30 Nights (Extended Stay)"
        case .vipPremium: return "VIP Presidential Stay"
        }
    }
}

public struct HotelPackageItem: Identifiable {
    public let id: String
    public let resortName: String
    public let location: String
    public let destinationArea: String
    public let packageType: StayPackageType
    public let price: Double
    public let originalPrice: Double?
    public let rating: Double
    public let reviewCount: Int
    public let emoji: String
    public let includedPerks: [String]
    public let roomType: String
    public let description: String
    public let cancellationPolicy: String
}

public struct BangladeshHotelsBookingView: View {
    @Environment(\.dismiss) private var dismiss

    // Search & Filters
    @State private var searchQuery: String = ""
    @State private var isSearchActive: Bool = false
    @State private var selectedDestination: String = "All"
    @State private var selectedPackageType: StayPackageType = .all

    // Booking Flow State
    @State private var selectedPackageForBooking: HotelPackageItem? = nil
    @State private var checkInDate: Date = Date().addingTimeInterval(86400) // Tomorrow
    @State private var numberOfGuests: Int = 2
    @State private var numberOfRooms: Int = 1
    @State private var selectedRoomUpgrade: String = "Included Standard"
    @State private var guestName: String = "MD Shoaib Khan"
    @State private var guestPhone: String = "+880 1712-345678"
    @State private var specialRequests: String = "High floor, quiet corner room"
    @State private var selectedPaymentMethod: String = "bKash"

    // Confirmed Voucher State
    @State private var showConfirmationVoucher: Bool = false
    @State private var confirmedBookingId: String = ""

    private let destinations = [
        "All", "Cox's Bazar", "Sajek Valley", "Sreemangal", "Sylhet", "Saint Martin", "Dhaka 5-Star"
    ]

    private let packagesCatalog: [HotelPackageItem] = [
        // 1. Day-cation Package (1 Day)
        HotelPackageItem(
            id: "hp-1",
            resortName: "Sea Pearl Beach Resort & Spa",
            location: "Inani Beach, Cox's Bazar",
            destinationArea: "Cox's Bazar",
            packageType: .dayCation,
            price: 2800,
            originalPrice: 3500,
            rating: 4.93,
            reviewCount: 1420,
            emoji: "🏖️",
            includedPerks: ["Buffet Lunch Included", "Infinity Pool Access", "Private Beach Lounger", "Spa 20% Voucher"],
            roomType: "Day-use Ocean Cabana",
            description: "Check-in 10:00 AM, Check-out 6:00 PM. Enjoy full resort amenities, grand international buffet lunch, and pool access.",
            cancellationPolicy: "Free cancellation up to 6 hours before check-in"
        ),

        // 2. 1 Night Stay
        HotelPackageItem(
            id: "hp-2",
            resortName: "Sayeman Beach Resort",
            location: "Marine Drive, Kolatoli, Cox's Bazar",
            destinationArea: "Cox's Bazar",
            packageType: .oneNight,
            price: 7500,
            originalPrice: 8800,
            rating: 4.95,
            reviewCount: 2890,
            emoji: "🌊",
            includedPerks: ["Complimentary Buffet Breakfast", "Sunset Infinity Pool", "Gym & Sauna", "Airport Shuttle"],
            roomType: "Deluxe Sea Facing Room",
            description: "1 night luxury stay with private balcony overlooking the Bay of Bengal and complimentary chef's buffet breakfast.",
            cancellationPolicy: "Free cancellation 24h prior"
        ),

        // 3. 2 Nights Weekend Escape
        HotelPackageItem(
            id: "hp-3",
            resortName: "Grand Sultan Tea Resort & Golf",
            location: "Sreemangal, Moulvibazar",
            destinationArea: "Sreemangal",
            packageType: .twoNights,
            price: 18500,
            originalPrice: 22000,
            rating: 4.96,
            reviewCount: 1850,
            emoji: "🍵",
            includedPerks: ["2 Nights Deluxe Stay", "Daily Breakfast & BBQ Dinner", "Tea Garden Guided Tour", "Golf Access"],
            roomType: "King Tea View Suite",
            description: "2 nights weekend getaway amidst sprawling tea gardens. Includes evening live musical BBQ and guided nature walk.",
            cancellationPolicy: "Free cancellation 48h prior"
        ),

        // 4. 3 Nights Holiday
        HotelPackageItem(
            id: "hp-4",
            resortName: "Megh Kabbo Resort",
            location: "Ruilui Para, Sajek Valley",
            destinationArea: "Sajek Valley",
            packageType: .threeNights,
            price: 13500,
            originalPrice: 16000,
            rating: 4.91,
            reviewCount: 940,
            emoji: "☁️",
            includedPerks: ["3 Nights Wooden Cottage", "Cloud View Balcony", "Helipad Bonfire Night", "Indigenous Breakfast"],
            roomType: "Cliffside Cloud Cottage",
            description: "3 nights holiday immersed in the clouds of Sajek. Watch clouds flow into your private wooden balcony at sunrise.",
            cancellationPolicy: "Free cancellation 3 days prior"
        ),

        // 5. 1 Week Vacation Retreat (7 Nights)
        HotelPackageItem(
            id: "hp-5",
            resortName: "DuSai Hotel & Villas",
            location: "Gisbari, Moulvibazar, Sylhet",
            destinationArea: "Sylhet",
            packageType: .oneWeek,
            price: 49000,
            originalPrice: 65000,
            rating: 4.98,
            reviewCount: 760,
            emoji: "🏡",
            includedPerks: ["7 Nights Private Villa", "25% Weekly Discount", "Daily Gourmet Dining", "Private Jacuzzi", "Airport Transfer"],
            roomType: "Private Hilltop Villa",
            description: "7 nights comprehensive vacation retreat. Private villa with personal plunge pool, rainforest trek, and fine dining.",
            cancellationPolicy: "Free cancellation 5 days prior"
        ),

        // 6. 1 Month Long-Stay / Workcation (30 Nights)
        HotelPackageItem(
            id: "hp-6",
            resortName: "Long Beach Hotel & Suites",
            location: "Kalatoli Road, Cox's Bazar",
            destinationArea: "Cox's Bazar",
            packageType: .oneMonth,
            price: 78000,
            originalPrice: 130000,
            rating: 4.88,
            reviewCount: 520,
            emoji: "💼",
            includedPerks: ["30 Nights Extended Stay", "40% Workcation Discount", "High-speed 100Mbps WiFi", "Daily Laundry Included", "Kitchenette"],
            roomType: "Executive Residence Suite",
            description: "30 nights extended stay for professionals and families. Includes co-working lounge access, daily housekeeping, and laundry.",
            cancellationPolicy: "Flexible monthly renewal"
        ),

        // 7. VIP Premium Luxury Package
        HotelPackageItem(
            id: "hp-7",
            resortName: "InterContinental Dhaka 5-Star",
            location: "1 Minto Road, Ramna, Dhaka",
            destinationArea: "Dhaka 5-Star",
            packageType: .vipPremium,
            price: 36000,
            originalPrice: 45000,
            rating: 4.99,
            reviewCount: 3100,
            emoji: "👑",
            includedPerks: ["VIP Presidential Suite", "24/7 Dedicated Butler", "Club InterContinental Lounge", "Limousine Pickup", "Private Spa Session"],
            roomType: "Presidential Royal Suite",
            description: "The pinnacle of Bangladeshi hospitality. Dedicated personal butler, private luxury limousine transfer, and caviar breakfast.",
            cancellationPolicy: "Free cancellation 24h prior"
        ),

        // 8. 2 Nights Saint Martin Coral Escape
        HotelPackageItem(
            id: "hp-8",
            resortName: "Blue Marine Coral Resort",
            location: "West Beach, Saint Martin's Island",
            destinationArea: "Saint Martin",
            packageType: .twoNights,
            price: 11500,
            originalPrice: 14000,
            rating: 4.87,
            reviewCount: 820,
            emoji: "🏝️",
            includedPerks: ["2 Nights Beachfront Room", "Ship Ticket Assistance", "Fresh Coral Fish BBQ", "Snorkeling Equipment"],
            roomType: "Beachfront Eco Cottage",
            description: "2 nights island stay on Saint Martin with pristine blue waters and evening fresh seafood beach barbecue.",
            cancellationPolicy: "Weather dependent full refund"
        )
    ]

    private var filteredPackages: [HotelPackageItem] {
        packagesCatalog.filter { item in
            let matchesDestination = (selectedDestination == "All" || item.destinationArea == selectedDestination)
            let matchesPackage = (selectedPackageType == .all || item.packageType == selectedPackageType)
            let matchesSearch = searchQuery.isEmpty ||
                item.resortName.localizedCaseInsensitiveContains(searchQuery) ||
                item.location.localizedCaseInsensitiveContains(searchQuery) ||
                item.destinationArea.localizedCaseInsensitiveContains(searchQuery)
            return matchesDestination && matchesPackage && matchesSearch
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            topControlBar

            // Expandable Search Bar
            if isSearchActive {
                expandableSearchBar
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            ScrollView {
                VStack(spacing: 14) {
                    // Context Bar
                    stayContextBar

                    // Hero Package Highlight Banner
                    heroPackageBanner

                    // Destination Tabs Filter
                    destinationsFilterBar

                    // Stay Package Duration Filter Pills
                    packagesTypeFilterBar

                    // Package Cards List
                    packagesListSection
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.vertical, KivorlySpacing.md)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(item: $selectedPackageForBooking) { package in
            packageBookingModal(for: package)
        }
        .sheet(isPresented: $showConfirmationVoucher) {
            confirmedVoucherModal
        }
    }

    // MARK: - Top Navigation Bar
    private var topControlBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                Circle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)
            }

            Spacer()

            HStack(spacing: 8) {
                Image(ServiceType.hotels.assetImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)

                Text(ServiceType.hotels.title)
                    .font(KivorlyTypography.titleSmall)
                    .foregroundColor(Color(uiColor: .label))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(uiColor: .systemBackground))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)

            Spacer()

            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isSearchActive.toggle()
                    if !isSearchActive { searchQuery = "" }
                }
            }) {
                Circle()
                    .fill(isSearchActive ? ServiceType.hotels.accentTint : Color(uiColor: .systemBackground))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: isSearchActive ? "xmark" : "magnifyingglass")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(isSearchActive ? .white : Color(uiColor: .label))
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)
            }
        }
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.top, 10)
        .padding(.bottom, 6)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }

    // MARK: - Expandable Search Bar
    private var expandableSearchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(uiColor: .secondaryLabel))
            TextField("Search resorts in Cox's Bazar, Sajek, Sylhet...", text: $searchQuery)
                .font(KivorlyTypography.bodyMedium)
            if !searchQuery.isEmpty {
                Button(action: { searchQuery = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(uiColor: .tertiarySystemFill))
        .clipShape(Capsule())
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.vertical, 8)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }

    // MARK: - Context Bar
    private var stayContextBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 14))
                .foregroundColor(ServiceType.hotels.accentTint)

            Text("Best Price Guarantee • Free Cancellation on Packages")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(uiColor: .label))

            Spacer()

            Text("Verified")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(ServiceType.hotels.accentTint)
                .padding(.horizontal, 8)
                .padding(.vertical, 3.5)
                .background(ServiceType.hotels.accentTint.opacity(0.12))
                .clipShape(Capsule())
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 4, y: 1)
    }

    // MARK: - Hero Package Highlight Banner
    private var heroPackageBanner: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("Summer Staycation Deals")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.25))
                        .clipShape(Capsule())

                    Text("Up to 40% Off")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                }

                Text("From 1 Day-cation to 1 Month Long-Stay")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)

                Text("Flexible packages across Bangladesh's top luxury resorts")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
            }

            Spacer()

            Text("🏨")
                .font(.system(size: 42))
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [Color(red: 0x0D / 255.0, green: 0x94 / 255.0, blue: 0x88 / 255.0), Color(red: 0x05 / 255.0, green: 0x96 / 255.0, blue: 0x69 / 255.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.teal.opacity(0.25), radius: 8, y: 3)
    }

    // MARK: - Destinations Filter Bar
    private var destinationsFilterBar: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Destinations in Bangladesh")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(uiColor: .secondaryLabel))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(destinations, id: \.self) { dest in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedDestination = dest
                            }
                        }) {
                            Text(dest)
                                .font(.system(size: 12, weight: .bold))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(
                                    selectedDestination == dest ?
                                    ServiceType.hotels.accentTint :
                                    Color(uiColor: .secondarySystemGroupedBackground)
                                )
                                .foregroundColor(
                                    selectedDestination == dest ? .white : Color(uiColor: .label)
                                )
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(
                                            selectedDestination == dest ? Color.clear : Color(uiColor: .separator).opacity(0.4),
                                            lineWidth: 0.8
                                        )
                                    )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }

    // MARK: - Stay Package Duration Filter Bar
    private var packagesTypeFilterBar: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Stay Packages & Durations")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(uiColor: .secondaryLabel))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(StayPackageType.allCases) { pkg in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedPackageType = pkg
                            }
                        }) {
                            Text(pkg.rawValue)
                                .font(.system(size: 12, weight: .bold))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 7)
                                .background(
                                    selectedPackageType == pkg ?
                                    Color(uiColor: .systemFill) :
                                    Color(uiColor: .tertiarySystemFill)
                                )
                                .foregroundColor(
                                    selectedPackageType == pkg ? Color(uiColor: .label) : Color(uiColor: .secondaryLabel)
                                )
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(
                                            selectedPackageType == pkg ? ServiceType.hotels.accentTint : Color.clear,
                                            lineWidth: 1.5
                                        )
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }

    // MARK: - Package Cards List
    private var packagesListSection: some View {
        VStack(spacing: 12) {
            ForEach(filteredPackages) { item in
                hotelPackageCard(for: item)
            }
        }
    }

    private func hotelPackageCard(for item: HotelPackageItem) -> some View {
        Button(action: {
            selectedPackageForBooking = item
        }) {
            VStack(alignment: .leading, spacing: 10) {
                // Header: Emoji & Name & Rating
                HStack(alignment: .top, spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(ServiceType.hotels.accentTint.opacity(0.12))
                            .frame(width: 52, height: 52)
                        Text(item.emoji)
                            .font(.system(size: 28))
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.resortName)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))

                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.red)
                            Text(item.location)
                                .font(.system(size: 11))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    // Rating Badge
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", item.rating))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.12))
                    .clipShape(Capsule())
                }

                // Package Duration Pill
                HStack(spacing: 6) {
                    Text(item.packageType.rawValue)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(ServiceType.hotels.accentTint)
                        .padding(.horizontal, 9)
                        .padding(.vertical, 4)
                        .background(ServiceType.hotels.accentTint.opacity(0.12))
                        .clipShape(Capsule())

                    Text(item.packageType.durationLabel)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(uiColor: .secondaryLabel))

                    Spacer()

                    Text(item.roomType)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(uiColor: .label))
                }

                // Single-line Perks Scroll
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(item.includedPerks, id: \.self) { perk in
                            HStack(spacing: 3) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.green)
                                Text(perk)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3.5)
                            .background(Color(uiColor: .tertiarySystemFill).opacity(0.6))
                            .clipShape(Capsule())
                        }
                    }
                }

                Divider()

                // Pricing & Booking Action
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(alignment: .firstTextBaseline, spacing: 4) {
                            Text("৳\(Int(item.price))")
                                .font(.system(size: 19, weight: .black))
                                .foregroundColor(ServiceType.hotels.accentTint)

                            if let orig = item.originalPrice {
                                Text("৳\(Int(orig))")
                                    .font(.system(size: 11))
                                    .strikethrough()
                                    .foregroundColor(Color(uiColor: .tertiaryLabel))
                            }
                        }

                        Text("Total package fare • All taxes included")
                            .font(.system(size: 10))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }

                    Spacer()

                    Text("Book Package")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(ServiceType.hotels.accentTint)
                        .clipShape(Capsule())
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Package Booking Modal
    private func packageBookingModal(for package: HotelPackageItem) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Package Header
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(ServiceType.hotels.accentTint.opacity(0.12))
                                .frame(width: 60, height: 60)
                            Text(package.emoji)
                                .font(.system(size: 32))
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(package.resortName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))

                            Text(package.location)
                                .font(.system(size: 11))
                                .foregroundColor(Color(uiColor: .secondaryLabel))

                            Text(package.packageType.rawValue)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(ServiceType.hotels.accentTint)
                        }
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(14)

                    // Date & Stay Details Card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Check-in & Guests")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        DatePicker("Check-in Date", selection: $checkInDate, in: Date()..., displayedComponents: .date)
                            .font(.system(size: 13, weight: .semibold))

                        Divider()

                        HStack {
                            Text("Guests (Adults & Children)")
                                .font(.system(size: 13, weight: .medium))

                            Spacer()

                            HStack(spacing: 10) {
                                Button(action: { if numberOfGuests > 1 { numberOfGuests -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(numberOfGuests > 1 ? ServiceType.hotels.accentTint : Color(uiColor: .tertiaryLabel))
                                }
                                Text("\(numberOfGuests)")
                                    .font(.system(size: 13, weight: .bold))
                                    .frame(minWidth: 16)
                                Button(action: { if numberOfGuests < 8 { numberOfGuests += 1 } }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(ServiceType.hotels.accentTint)
                                }
                            }
                        }

                        Divider()

                        HStack {
                            Text("Number of Rooms / Cottages")
                                .font(.system(size: 13, weight: .medium))

                            Spacer()

                            HStack(spacing: 10) {
                                Button(action: { if numberOfRooms > 1 { numberOfRooms -= 1 } }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(numberOfRooms > 1 ? ServiceType.hotels.accentTint : Color(uiColor: .tertiaryLabel))
                                }
                                Text("\(numberOfRooms)")
                                    .font(.system(size: 13, weight: .bold))
                                    .frame(minWidth: 16)
                                Button(action: { if numberOfRooms < 4 { numberOfRooms += 1 } }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(ServiceType.hotels.accentTint)
                                }
                            }
                        }
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(14)

                    // Primary Guest Info Card
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Primary Guest Information")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        HStack(spacing: 10) {
                            Image("profile_user")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Text(guestName)
                                        .font(.system(size: 13, weight: .bold))
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(.blue)
                                }

                                Text(guestPhone)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }
                        }

                        TextField("Special requests / Arrival timing", text: $specialRequests)
                            .font(KivorlyTypography.caption)
                            .padding(10)
                            .background(Color(uiColor: .tertiarySystemFill).opacity(0.5))
                            .cornerRadius(10)
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(14)

                    // Payment Method Card
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Payment Method")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        HStack(spacing: 8) {
                            paymentPill(title: "bKash", isSelected: selectedPaymentMethod == "bKash") {
                                selectedPaymentMethod = "bKash"
                            }
                            paymentPill(title: "Nagad", isSelected: selectedPaymentMethod == "Nagad") {
                                selectedPaymentMethod = "Nagad"
                            }
                            paymentPill(title: "Pay at Check-in", isSelected: selectedPaymentMethod == "Check-in") {
                                selectedPaymentMethod = "Check-in"
                            }
                        }
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(14)

                    // Price Breakdown & Confirm CTA
                    VStack(spacing: 8) {
                        let totalPackageFare = package.price * Double(numberOfRooms)
                        HStack {
                            Text("Package Fare (\(numberOfRooms) Room)")
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Spacer()
                            Text("৳\(Int(totalPackageFare))")
                                .fontWeight(.semibold)
                        }

                        HStack {
                            Text("Resort Taxes & Service Charge")
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Spacer()
                            Text("Included")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }

                        Divider()

                        HStack {
                            Text("Total Payable")
                                .font(.system(size: 15, weight: .bold))
                            Spacer()
                            Text("৳\(Int(totalPackageFare))")
                                .font(.system(size: 20, weight: .black))
                                .foregroundColor(ServiceType.hotels.accentTint)
                        }

                        Button(action: {
                            confirmedBookingId = "KVH-\(Int.random(in: 100000...999999))-BD"
                            selectedPackageForBooking = nil
                            showConfirmationVoucher = true
                        }) {
                            HStack(spacing: 6) {
                                Text("Confirm Reservation")
                                    .font(KivorlyTypography.titleSmall)
                                Image(systemName: "checkmark")
                                    .font(.system(size: 13, weight: .bold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(ServiceType.hotels.accentTint)
                            .clipShape(Capsule())
                            .shadow(color: ServiceType.hotels.accentTint.opacity(0.3), radius: 6, y: 2)
                        }
                        .padding(.top, 4)
                    }
                    .font(.system(size: 12))
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(14)
                }
                .padding(16)
            }
            .navigationTitle("Package Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { selectedPackageForBooking = nil }
                }
            }
        }
    }

    private func paymentPill(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 11, weight: isSelected ? .bold : .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    isSelected ? ServiceType.hotels.accentTint.opacity(0.12) : Color(uiColor: .tertiarySystemFill).opacity(0.5)
                )
                .foregroundColor(isSelected ? ServiceType.hotels.accentTint : Color(uiColor: .secondaryLabel))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isSelected ? ServiceType.hotels.accentTint : Color.clear, lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Confirmed Booking Voucher Modal
    private var confirmedVoucherModal: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.12))
                        .frame(width: 90, height: 90)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                }

                VStack(spacing: 6) {
                    Text("Hotel Package Confirmed!")
                        .font(KivorlyTypography.titleMedium)
                        .foregroundColor(Color(uiColor: .label))

                    Text("Reservation PNR: \(confirmedBookingId)")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(ServiceType.hotels.accentTint)

                    Text("Primary Guest: \(guestName) • \(numberOfGuests) Guests • \(numberOfRooms) Room")
                        .font(KivorlyTypography.captionBold)
                        .foregroundColor(Color(uiColor: .label))

                    Text("Your reservation voucher has been sent to your phone via SMS. Complimentary airport/resort transfer coordination is active.")
                        .font(KivorlyTypography.caption)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Spacer()

                Button(action: { showConfirmationVoucher = false }) {
                    Text("Back to Hotels")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(ServiceType.hotels.accentTint)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        }
    }
}
