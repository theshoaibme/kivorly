//
//  ServiceDetailView.swift
//  Kivorly
//
//  Dedicated full page for all Kivorly services:
//  - Ride Sharing routes to UberRideBookingView (with interactive map & attached bottom drawer).
//  - All other services (Food Delivery, Grocery, Shopping, Courier, Home Services, Tickets, Hotels)
//    have dedicated e-commerce/booking feeds (NO map), featuring:
//    - Top Bar: Left Back Button, Center Service Logo & Name (Capsule, no green dot), Right Search Icon (only icon).
//    - Expandable Search Bar on search icon tap.
//    - Dedicated Hero Banner with service branding & value proposition.
//    - Category Filter Pills.
//    - Item Catalog with food visuals, ratings, preparation time, and prices in Bangladeshi Taka (৳).
//    - ServiceCheckoutModal for instant checkout & order placement.
//

import SwiftUI

public struct ServiceDetailView: View {
    let service: ServiceType
    @Environment(\.dismiss) private var dismiss

    @State private var selectedFilter: String = "All"
    @State private var isSearchActive: Bool = false
    @State private var searchQuery: String = ""
    @State private var selectedItemForCheckout: ServiceItemModel? = nil
    @State private var showOrderSuccessAlert: Bool = false

    public init(service: ServiceType) {
        self.service = service
    }

    private var allItems: [ServiceItemModel] {
        ServiceDataProvider.items(for: service)
    }

    private var categories: [String] {
        var set = ["All"]
        set.append(contentsOf: Set(allItems.map { $0.category }))
        return set
    }

    private var filteredItems: [ServiceItemModel] {
        allItems.filter { item in
            let matchesCategory = (selectedFilter == "All" || item.category == selectedFilter)
            let matchesSearch = searchQuery.isEmpty ||
                item.title.localizedCaseInsensitiveContains(searchQuery) ||
                item.category.localizedCaseInsensitiveContains(searchQuery)
            return matchesCategory && matchesSearch
        }
    }

    public var body: some View {
        Group {
            if service == .rideSharing {
                UberRideBookingView()
            } else if service == .tickets {
                BangladeshTicketsBookingView()
            } else if service == .courier {
                BangladeshParcelDeliveryView()
            } else if service == .shopping {
                BangladeshShoppingView()
            } else if service == .grocery {
                BangladeshGroceryView()
            } else if service == .hotels {
                BangladeshHotelsBookingView()
            } else {
                dedicatedVerticalView
            }
        }
    }

    // MARK: - Dedicated Service Page (Non-Map Verticals)
    private var dedicatedVerticalView: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            topNavBar

            // Expandable Search Bar
            if isSearchActive {
                expandableSearchBar
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            // Scrollable Content
            ScrollView {
                VStack(spacing: KivorlySpacing.md) {
                    // Context Bar (Location, ETA, Guarantee)
                    serviceContextBar

                    // Dedicated Service Feature Banner
                    dedicatedServiceBanner

                    // Promotional Coupon Strip
                    promotionalCouponStrip

                    // Category Filter Pills
                    categoryFilterBar

                    // Items Catalog
                    itemsCatalogSection
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.vertical, KivorlySpacing.md)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(item: $selectedItemForCheckout) { item in
            ServiceCheckoutModal(item: item) {
                selectedItemForCheckout = nil
                showOrderSuccessAlert = true
            }
        }
        .alert("Order Placed Successfully", isPresented: $showOrderSuccessAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your \(service.title) request has been placed. You can track live updates in Activity.")
        }
    }

    // MARK: - Top Navigation Bar
    private var topNavBar: some View {
        HStack {
            // Left: Back button
            Button(action: {
                dismiss()
            }) {
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

            // Center: Service Logo and Service Name (No green dot, no app logo)
            HStack(spacing: 8) {
                Image(service.assetImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)

                Text(service.title)
                    .font(KivorlyTypography.titleSmall)
                    .foregroundColor(Color(uiColor: .label))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(uiColor: .systemBackground))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)

            Spacer()

            // Right: Search Button (only has icon)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isSearchActive.toggle()
                    if !isSearchActive {
                        searchQuery = ""
                    }
                }
            }) {
                Circle()
                    .fill(isSearchActive ? service.accentTint : Color(uiColor: .systemBackground))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: isSearchActive ? "xmark" : "magnifyingglass")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isSearchActive ? Color.white : Color(uiColor: .label))
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

            TextField("Search in \(service.title)...", text: $searchQuery)
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

    // MARK: - Dedicated Service Hero Banner
    private var dedicatedServiceBanner: some View {
        HStack(spacing: KivorlySpacing.md) {
            ZStack {
                Circle()
                    .fill(service.accentTint.opacity(0.12))
                    .frame(width: 52, height: 52)

                Image(service.assetImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(serviceTagline)
                    .font(KivorlyTypography.titleSmall)
                    .foregroundColor(Color(uiColor: .label))

                Text(serviceDescription)
                    .font(KivorlyTypography.caption)
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(KivorlySpacing.md)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var serviceTagline: String {
        switch service {
        case .rideSharing: return "Instant City Rides"
        case .foodDelivery: return "Hot & Fresh from Top Kitchens"
        case .grocery: return "15-Minute Supermarket"
        case .shopping: return "Official Kivorly Mall"
        case .courier: return "Reliable Parcel Delivery"
        case .homeServices: return "Verified Home Experts"
        case .tickets: return "Live Events & Travel"
        case .hotels: return "Curated Boutique Stays"
        }
    }

    private var serviceDescription: String {
        switch service {
        case .rideSharing: return "Book bikes, sedans & SUVs with upfront transparent fares."
        case .foodDelivery: return "Explore gourmet meals, fast food & authentic biryani with quick doorstep delivery."
        case .grocery: return "Daily fresh vegetables, fruits, dairy & household staples in 15 minutes."
        case .shopping: return "Premium gadgets, lifestyle & fashion with express delivery & warranty."
        case .courier: return "Door-to-door express parcel delivery for documents, packages & COD across Bangladesh."
        case .homeServices: return "AC master servicing, electrical repairs, plumbing & deep cleaning."
        case .tickets: return "Book cinema premiere tickets, live concerts & luxury inter-city coach travel."
        case .hotels: return "Reserve handpicked hotel rooms and luxury suites with guaranteed best rates."
        }
    }

    // MARK: - Category Filter Bar
    private var categoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedFilter = category
                        }
                    }) {
                        Text(category)
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                selectedFilter == category ?
                                Color(uiColor: .systemFill) :
                                Color(uiColor: .tertiarySystemFill)
                            )
                            .foregroundColor(
                                selectedFilter == category ?
                                Color(uiColor: .label) :
                                Color(uiColor: .secondaryLabel)
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(
                                        selectedFilter == category ?
                                        service.accentTint :
                                        Color(uiColor: .separator).opacity(0.3),
                                        lineWidth: selectedFilter == category ? 2 : 0.6
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 2)
        }
    }

    // MARK: - Items Catalog Section
    private var itemsCatalogSection: some View {
        VStack(spacing: KivorlySpacing.sm) {
            if filteredItems.isEmpty {
                EmptyStateView(
                    icon: "magnifyingglass",
                    title: "No Items Found",
                    message: "Try selecting another category or changing your search terms.",
                    actionTitle: "Reset"
                ) {
                    searchQuery = ""
                    selectedFilter = "All"
                }
                .padding(.top, 30)
            } else {
                ForEach(filteredItems) { item in
                    ServiceItemRowView(item: item) {
                        selectedItemForCheckout = item
                    }
                }
            }
        }
    }

    // MARK: - Service Context Bar (Location / Speed / Guarantee)
    private var serviceContextBar: some View {
        HStack(spacing: 8) {
            Image(systemName: serviceContextIcon)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(service.accentTint)

            Text(serviceContextText)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(uiColor: .label))

            Spacer()

            Text(serviceContextBadge)
                .font(.system(size: 10, weight: .black))
                .padding(.horizontal, 8)
                .padding(.vertical, 3.5)
                .background(service.accentTint.opacity(0.12))
                .foregroundColor(service.accentTint)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var serviceContextIcon: String {
        switch service {
        case .foodDelivery: return "mappin.circle.fill"
        case .grocery: return "bolt.fill"
        case .shopping: return "shield.lefthalf.filled"
        case .homeServices: return "checkmark.seal.fill"
        case .hotels: return "sparkles"
        default: return "info.circle.fill"
        }
    }

    private var serviceContextText: String {
        switch service {
        case .foodDelivery: return "Delivering to Gulshan 2, Dhaka"
        case .grocery: return "1-Hour Express Dhaka Delivery"
        case .shopping: return "100% Genuine Brand Stores"
        case .homeServices: return "Police Verified Technicians"
        case .hotels: return "Direct Hotel Reservations"
        default: return "Instant Kivorly Booking"
        }
    }

    private var serviceContextBadge: String {
        switch service {
        case .foodDelivery: return "20-30 mins"
        case .grocery: return "FREE > ৳500"
        case .shopping: return "7-Day Return"
        case .homeServices: return "30-Day Warranty"
        case .hotels: return "Best Price"
        default: return "Verified"
        }
    }

    // MARK: - Promotional Coupon Strip
    private var promotionalCouponStrip: some View {
        HStack(spacing: 10) {
            Image(systemName: "tag.fill")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)

            Text(promotionalCouponText)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)

            Spacer()

            Text("Copy Code")
                .font(.system(size: 10, weight: .black))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.white)
                .foregroundColor(service.accentTint)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(service.accentTint)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var promotionalCouponText: String {
        switch service {
        case .foodDelivery: return "20% OFF on Sultan's Dine • Code: KIVFOOD"
        case .grocery: return "৳100 OFF on Bazaar Over ৳1,000 • Code: KIVBAZAAR"
        case .shopping: return "Eid Festival 15% OFF • Code: KIVEID"
        case .homeServices: return "৳200 OFF on AC Master Service • Code: KIVAC"
        case .hotels: return "10% OFF on Cox's Bazar Resorts • Code: KIVHOTEL"
        default: return "Special Offer • Code: KIVORLY"
        }
    }

}
