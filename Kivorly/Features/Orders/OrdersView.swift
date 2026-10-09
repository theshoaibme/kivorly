//
//  OrdersView.swift
//  Kivorly
//
//  Unified orders screen composed of modular sub-views with amounts in Bangladeshi Taka (৳).
//

import SwiftUI

public enum OrderFilterTab: String, CaseIterable, Identifiable {
    case active = "Active"
    case upcoming = "Upcoming"
    case completed = "Completed"
    case cancelled = "Cancelled"

    public var id: String { rawValue }
}

public struct SuperAppOrder: Identifiable {
    public let id: String
    public let service: ServiceType
    public let title: String
    public let timestamp: String
    public let amount: String
    public let status: KivorlyStatus
}

public struct OrdersView: View {
    @State private var selectedTab: OrderFilterTab = .active

    private let sampleOrders: [SuperAppOrder] = [
        SuperAppOrder(
            id: "KV-RIDE-902",
            service: .rideSharing,
            title: "Toyota Prius • Kamal H.",
            timestamp: "Today, 10:30 AM",
            amount: "৳450",
            status: .inProgress
        ),
        SuperAppOrder(
            id: "KV-FOOD-892",
            service: .foodDelivery,
            title: "Burger & Co. (2 items)",
            timestamp: "Today, 09:45 AM",
            amount: "৳900",
            status: .active
        ),
        SuperAppOrder(
            id: "KV-TICK-441",
            service: .tickets,
            title: "Green Line Express (B3, B4)",
            timestamp: "Tomorrow, 07:00 AM",
            amount: "৳2,200",
            status: .confirmed
        ),
        SuperAppOrder(
            id: "KV-HOTEL-109",
            service: .hotels,
            title: "Grand Palace Hotel & Resort",
            timestamp: "12 Oct - 14 Oct",
            amount: "৳17,000",
            status: .confirmed
        ),
        SuperAppOrder(
            id: "KV-GROC-712",
            service: .grocery,
            title: "Daily Farm Organic Basket",
            timestamp: "Yesterday, 04:15 PM",
            amount: "৳820",
            status: .completed
        ),
        SuperAppOrder(
            id: "KV-SERV-301",
            service: .homeServices,
            title: "Master AC Deep Servicing",
            timestamp: "03 Oct 2026",
            amount: "৳1,200",
            status: .completed
        )
    ]

    public init() {}

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Modular Segment Filter Bar
                OrderFilterHeader(selectedTab: $selectedTab)

                // List of Orders
                ScrollView {
                    VStack(spacing: KivorlySpacing.md) {
                        let filtered = filterOrders()

                        if filtered.isEmpty {
                            EmptyStateView(
                                icon: "doc.plaintext",
                                title: "No Orders",
                                actionTitle: "Browse Services"
                            ) {
                                print("Explore tapped from orders")
                            }
                        } else {
                            ForEach(filtered) { order in
                                OrderCardView(order: order)
                            }
                        }
                    }
                    .padding(KivorlySpacing.md)
                }
            }
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle("Orders")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func filterOrders() -> [SuperAppOrder] {
        switch selectedTab {
        case .active:
            return sampleOrders.filter { $0.status == .active || $0.status == .inProgress }
        case .upcoming:
            return sampleOrders.filter { $0.status == .confirmed }
        case .completed:
            return sampleOrders.filter { $0.status == .completed }
        case .cancelled:
            return sampleOrders.filter { $0.status == .cancelled || $0.status == .refunded }
        }
    }
}
