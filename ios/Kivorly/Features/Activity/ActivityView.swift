//
//  ActivityView.swift
//  Kivorly
//
//  Highly organized timeline activity & notification panel featuring pinned Live Activity card.
//

import SwiftUI

public enum ActivityCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case orders = "Orders"
    case offers = "Offers"
    case security = "Security"

    public var id: String { rawValue }
}

public struct ActivityItem: Identifiable {
    public let id = UUID()
    public let category: ActivityCategory
    public let title: String
    public let timeAgo: String
    public let icon: String
    public var isUnread: Bool
    public let section: String // "Today", "Yesterday", "Earlier"
    public let serviceType: ServiceType?
    public let referenceId: String?
    public let actionButtonTitle: String?
}

public struct ActivityView: View {
    @State private var selectedCategory: ActivityCategory = .all
    @State private var filterUnreadOnly: Bool = false
    @State private var selectedDetailItem: ActivityItem? = nil

    @State private var activities: [ActivityItem] = [
        ActivityItem(
            category: .orders,
            title: "Driver is 3 minutes away from pickup",
            timeAgo: "2m ago",
            icon: "car.fill",
            isUnread: true,
            section: "Today",
            serviceType: .rideSharing,
            referenceId: "KV-RIDE-902",
            actionButtonTitle: "Track Ride on Map"
        ),
        ActivityItem(
            category: .offers,
            title: "Weekend 25% Discount Voucher Unlocked",
            timeAgo: "45m ago",
            icon: "ticket.fill",
            isUnread: true,
            section: "Today",
            serviceType: .foodDelivery,
            referenceId: "VOUCHER-WKND25",
            actionButtonTitle: "Use Voucher Now"
        ),
        ActivityItem(
            category: .orders,
            title: "Food Order Delivered: Burger & Co.",
            timeAgo: "3h ago",
            icon: "fork.knife",
            isUnread: false,
            section: "Today",
            serviceType: .foodDelivery,
            referenceId: "KV-FOOD-892",
            actionButtonTitle: "Rate Experience"
        ),
        ActivityItem(
            category: .security,
            title: "Apple ID Sign-in from iPhone 17 Verified",
            timeAgo: "Yesterday, 08:30 PM",
            icon: "shield.checkmark.fill",
            isUnread: false,
            section: "Yesterday",
            serviceType: nil,
            referenceId: "SEC-AUTH-091",
            actionButtonTitle: nil
        ),
        ActivityItem(
            category: .orders,
            title: "Green Line Express Bus Tickets Confirmed",
            timeAgo: "Yesterday, 02:15 PM",
            icon: "ticket.fill",
            isUnread: false,
            section: "Yesterday",
            serviceType: .tickets,
            referenceId: "KV-TICK-441",
            actionButtonTitle: "View QR Pass"
        ),
        ActivityItem(
            category: .orders,
            title: "Master AC Deep Servicing Completed",
            timeAgo: "03 Oct 2026",
            icon: "wrench.and.screwdriver.fill",
            isUnread: false,
            section: "Earlier",
            serviceType: .homeServices,
            referenceId: "KV-SERV-301",
            actionButtonTitle: "Download Invoice"
        ),
        ActivityItem(
            category: .offers,
            title: "Grand Palace Hotel Staycation Cashback Added",
            timeAgo: "28 Sep 2026",
            icon: "bed.double.fill",
            isUnread: false,
            section: "Earlier",
            serviceType: .hotels,
            referenceId: "KV-HOTEL-109",
            actionButtonTitle: "View Booking"
        )
    ]

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Category Filter Chips
                categoryPillsBar

                // Content Timeline
                ScrollView {
                    VStack(alignment: .leading, spacing: KivorlySpacing.md) {
                        // 1. PINNED LIVE ACTIVITY (in Notification / Activity Panel)
                        if selectedCategory == .all || selectedCategory == .orders {
                            VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                                Text("Live Activity")
                                    .font(KivorlyTypography.captionBold)
                                    .foregroundColor(KivorlyColors.textSecondary)
                                    .padding(.horizontal, KivorlySpacing.md)
                                    .padding(.top, KivorlySpacing.xs)

                                LiveActivityNotificationBanner(
                                    service: .rideSharing,
                                    title: "Toyota Prius • Driver 3m away",
                                    eta: "3 min",
                                    progress: 0.75,
                                    referenceId: "KV-RIDE-902"
                                ) {
                                    if let first = activities.first {
                                        selectedDetailItem = first
                                    }
                                }
                                .padding(.horizontal, KivorlySpacing.md)
                            }
                        }

                        // 2. Chronological Notifications
                        let filtered = getFilteredActivities()

                        if filtered.isEmpty {
                            EmptyStateView(
                                icon: "bell.slash",
                                title: "No Activities",
                                actionTitle: "Clear Filters"
                            ) {
                                selectedCategory = .all
                                filterUnreadOnly = false
                            }
                        } else {
                            let sections = ["Today", "Yesterday", "Earlier"]
                            ForEach(sections, id: \.self) { sectionTitle in
                                let itemsInSection = filtered.filter { $0.section == sectionTitle }
                                if !itemsInSection.isEmpty {
                                    VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                                        Text(sectionTitle)
                                            .font(KivorlyTypography.captionBold)
                                            .foregroundColor(KivorlyColors.textSecondary)
                                            .padding(.horizontal, KivorlySpacing.md)
                                            .padding(.top, KivorlySpacing.xs)

                                        VStack(spacing: KivorlySpacing.xs) {
                                            ForEach(itemsInSection) { item in
                                                ActivityRowView(item: item) {
                                                    markAsRead(item.id)
                                                    selectedDetailItem = item
                                                }
                                            }
                                        }
                                        .padding(.horizontal, KivorlySpacing.md)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, KivorlySpacing.md)
                }
            }
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: markAllAsRead) {
                            Label("Mark All as Read", systemImage: "checkmark.circle")
                        }
                        Button(action: { filterUnreadOnly.toggle() }) {
                            Label(
                                filterUnreadOnly ? "Show All Activities" : "Show Unread Only",
                                systemImage: filterUnreadOnly ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle"
                            )
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 17))
                            .foregroundColor(KivorlyColors.primary)
                    }
                }
            }
            .sheet(item: $selectedDetailItem) { detailItem in
                ActivityDetailSheet(item: detailItem) {
                    print("Detail action tapped for \(detailItem.title)")
                }
            }
        }
    }

    private var categoryPillsBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ActivityCategory.allCases) { category in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCategory = category
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(category.rawValue)
                                .font(KivorlyTypography.captionBold)

                            let unreadCount = countUnread(for: category)
                            if unreadCount > 0 {
                                Text("\(unreadCount)")
                                    .font(.system(size: 10, weight: .bold))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 1)
                                    .background(selectedCategory == category ? Color.white.opacity(0.3) : KivorlyColors.primary)
                                    .foregroundColor(Color.white)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedCategory == category ? KivorlyColors.primary : Color(uiColor: .tertiarySystemFill))
                        .foregroundColor(selectedCategory == category ? Color.white : KivorlyColors.textPrimary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, KivorlySpacing.md)
            .padding(.vertical, KivorlySpacing.sm)
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }

    private func getFilteredActivities() -> [ActivityItem] {
        activities.filter { item in
            let matchesCategory = (selectedCategory == .all || item.category == selectedCategory)
            let matchesUnread = (!filterUnreadOnly || item.isUnread)
            return matchesCategory && matchesUnread
        }
    }

    private func countUnread(for category: ActivityCategory) -> Int {
        activities.filter { item in
            item.isUnread && (category == .all || item.category == category)
        }.count
    }

    private func markAsRead(_ id: UUID) {
        if let index = activities.firstIndex(where: { $0.id == id }) {
            activities[index].isUnread = false
        }
    }

    private func markAllAsRead() {
        withAnimation {
            for i in 0..<activities.count {
                activities[i].isUnread = false
            }
        }
    }
}
