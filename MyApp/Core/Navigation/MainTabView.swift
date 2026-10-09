//
//  MainTabView.swift
//  Kivorly
//
//  Root 5-destination bottom navigation bar with independent navigation stacks.
//

import SwiftUI

public struct MainTabView: View {
    private let onSelectService: (ServiceType) -> Void
    private let onLogout: () -> Void

    @State private var selectedTab: AppTab = .home

    public init(
        onSelectService: @escaping (ServiceType) -> Void,
        onLogout: @escaping () -> Void
    ) {
        self.onSelectService = onSelectService
        self.onLogout = onLogout
    }

    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeDashboardView(onSelectService: onSelectService)
                .tabItem {
                    Label(AppTab.home.title, systemImage: AppTab.home.icon)
                }
                .tag(AppTab.home)

            ExploreView(onSelectService: onSelectService)
                .tabItem {
                    Label(AppTab.explore.title, systemImage: AppTab.explore.icon)
                }
                .tag(AppTab.explore)

            OrdersView()
                .tabItem {
                    Label(AppTab.orders.title, systemImage: AppTab.orders.icon)
                }
                .tag(AppTab.orders)

            ActivityView()
                .tabItem {
                    Label(AppTab.activity.title, systemImage: AppTab.activity.icon)
                }
                .tag(AppTab.activity)

            ProfileView(onLogout: onLogout)
                .tabItem {
                    Label(AppTab.profile.title, systemImage: AppTab.profile.icon)
                }
                .tag(AppTab.profile)
        }
        .tint(KivorlyColors.midnightNavy)
    }
}
