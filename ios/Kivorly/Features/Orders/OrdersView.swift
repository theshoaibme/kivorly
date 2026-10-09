//
//  OrdersView.swift
//  Kivorly
//
//  Comprehensive unified All Orders and Bookings screen in Bangladeshi Taka (৳)
//  with live tracking, multi-category filters, search, and end-to-end details sheet.
//

import SwiftUI

public struct OrdersView: View {
    @ObservedObject private var ordersManager: OrdersManager = OrdersManager.shared

    @State private var selectedTab: OrderFilterTab = .all
    @State private var selectedServiceFilter: ServiceType? = nil
    @State private var searchQuery: String = ""
    @State private var selectedDetailOrderId: String? = nil

    public init() {}

    private var badgeCounts: [OrderFilterTab: Int] {
        [
            .all: ordersManager.orders.count,
            .active: ordersManager.activeOrders.count,
            .upcoming: ordersManager.upcomingOrders.count,
            .completed: ordersManager.completedOrders.count,
            .cancelled: ordersManager.cancelledOrders.count
        ]
    }

    private var filteredOrders: [SuperAppOrder] {
        var baseList: [SuperAppOrder]

        switch selectedTab {
        case .all:
            baseList = ordersManager.orders
        case .active:
            baseList = ordersManager.activeOrders
        case .upcoming:
            baseList = ordersManager.upcomingOrders
        case .completed:
            baseList = ordersManager.completedOrders
        case .cancelled:
            baseList = ordersManager.cancelledOrders
        }

        // Filter by service if selected
        if let serviceFilter = selectedServiceFilter {
            baseList = baseList.filter { $0.service == serviceFilter }
        }

        // Filter by search query
        if !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let query = searchQuery.lowercased()
            baseList = baseList.filter { order in
                order.id.lowercased().contains(query) ||
                order.title.lowercased().contains(query) ||
                order.subtitle.lowercased().contains(query) ||
                order.service.title.lowercased().contains(query) ||
                order.items.contains(where: { $0.title.lowercased().contains(query) })
            }
        }

        return baseList
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                searchHeader

                // Modular Segment Filter Bar
                OrderFilterHeader(selectedTab: $selectedTab, badgeCounts: badgeCounts)

                // Service Category Horizontal Filter Pills
                serviceCategoryFilterBar

                // Orders List
                ScrollView {
                    VStack(spacing: KivorlySpacing.md) {
                        // Spotlight Card for Top Active Order
                        if (selectedTab == .all || selectedTab == .active),
                           let topActive = ordersManager.activeOrders.first,
                           selectedServiceFilter == nil || selectedServiceFilter == topActive.service,
                           searchQuery.isEmpty {
                            activeSpotlightBanner(order: topActive)
                        }

                        // Monthly Spending Quick Insights Bar
                        monthlySpendBanner

                        // Filtered Orders List
                        if filteredOrders.isEmpty {
                            EmptyStateView(
                                icon: "doc.plaintext",
                                title: "No Orders Found",
                                actionTitle: "Clear Filters"
                            ) {
                                withAnimation {
                                    searchQuery = ""
                                    selectedServiceFilter = nil
                                    selectedTab = .all
                                }
                            }
                            .padding(.top, 40)
                        } else {
                            VStack(spacing: KivorlySpacing.sm) {
                                ForEach(filteredOrders) { order in
                                    OrderCardView(
                                        order: order,
                                        onTap: {
                                            selectedDetailOrderId = order.id
                                        },
                                        onQuickAction: {
                                            selectedDetailOrderId = order.id
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(KivorlySpacing.md)
                }
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Orders & Bookings")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: Binding<IdentifiableString?>(
                get: { selectedDetailOrderId.map { IdentifiableString(id: $0) } },
                set: { selectedDetailOrderId = $0?.id }
            )) { item in
                OrderDetailView(orderId: item.id) {
                    selectedDetailOrderId = nil
                }
            }
        }
    }

    // MARK: - Search Header
    private var searchHeader: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(uiColor: .secondaryLabel))
                .font(.system(size: 15))

            TextField("Search by ID, item, or merchant...", text: $searchQuery)
                .font(KivorlyTypography.bodyMedium)

            if !searchQuery.isEmpty {
                Button(action: { searchQuery = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(KivorlyRadius.medium)
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.vertical, 8)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }

    // MARK: - Service Category Horizontal Filter Bar
    private var serviceCategoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // All Services Pill
                Button(action: {
                    withAnimation { selectedServiceFilter = nil }
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "square.grid.2x2.fill")
                            .font(.system(size: 11))
                        Text("All")
                            .font(KivorlyTypography.captionBold)
                    }
                    .foregroundColor(selectedServiceFilter == nil ? .white : Color(uiColor: .label))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(selectedServiceFilter == nil ? KivorlyColors.primary : Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(selectedServiceFilter == nil ? 0.15 : 0.03), radius: 2)
                }

                // Vertical Service Filters
                ForEach(ServiceType.allCases) { service in
                    let isSelected = selectedServiceFilter == service
                    Button(action: {
                        withAnimation {
                            selectedServiceFilter = isSelected ? nil : service
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: service.systemIcon)
                                .font(.system(size: 11))
                            Text(service.shortTitle)
                                .font(KivorlyTypography.captionBold)
                        }
                        .foregroundColor(isSelected ? .white : Color(uiColor: .label))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(isSelected ? service.accentTint : Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(Capsule())
                        .shadow(color: Color.black.opacity(isSelected ? 0.15 : 0.03), radius: 2)
                    }
                }
            }
            .padding(.horizontal, KivorlySpacing.md)
            .padding(.vertical, 8)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground).opacity(0.6))
    }

    // MARK: - Spotlight Active Order Banner
    private func activeSpotlightBanner(order: SuperAppOrder) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                            .overlay(
                                Circle()
                                    .stroke(Color.green.opacity(0.4), lineWidth: 2)
                                    .scaleEffect(1.4)
                            )

                        Text("IN-PROGRESS LIVE ACTIVITY")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(Color.green)
                    }

                    Spacer()

                    Text(order.etaText)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(KivorlyColors.primary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(KivorlyColors.primary.opacity(0.1))
                        .clipShape(Capsule())
                }

                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(order.service.accentTint.opacity(0.14))
                            .frame(width: 44, height: 44)

                        Image(systemName: order.service.systemIcon)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(order.service.accentTint)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(order.title)
                            .font(KivorlyTypography.titleSmall)
                            .foregroundColor(Color(uiColor: .label))

                        Text(order.subtitle)
                            .font(KivorlyTypography.caption)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }

                    Spacer()

                    Button(action: {
                        selectedDetailOrderId = order.id
                    }) {
                        HStack(spacing: 4) {
                            Text("Track")
                            Image(systemName: "location.fill")
                        }
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(KivorlyColors.primary)
                        .clipShape(Capsule())
                        .shadow(color: KivorlyColors.primary.opacity(0.3), radius: 4, y: 1)
                    }
                }
            }
        }
    }

    // MARK: - Monthly Spend Summary
    private var monthlySpendBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(KivorlyColors.primary)

            VStack(alignment: .leading, spacing: 1) {
                Text("Total Spend (October 2026)")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(uiColor: .secondaryLabel))

                Text("\u{09F3}\(Int(ordersManager.totalSpentThisMonth)) across \(ordersManager.orders.count) orders")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(uiColor: .label))
            }

            Spacer()

            Text("Summary")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(KivorlyColors.primary)
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(KivorlyRadius.medium)
    }
}

// MARK: - Helper Identifiable String for Sheet
private struct IdentifiableString: Identifiable {
    let id: String
}
