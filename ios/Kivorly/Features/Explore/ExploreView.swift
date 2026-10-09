//
//  ExploreView.swift
//  Kivorly
//
//  Highly organized Explore screen with segmented display (All, Daily Essentials, Lifestyle & Travel),
//  search, dynamic category filtering, and default iOS system themes.
//

import SwiftUI

public enum ExploreSectionTab: String, CaseIterable, Identifiable {
    case all = "All"
    case daily = "Daily Essentials"
    case lifestyle = "Lifestyle & Travel"

    public var id: String { rawValue }
}

public struct ExploreView: View {
    private let onSelectService: (ServiceType) -> Void

    @State private var selectedTab: ExploreSectionTab = .all
    @State private var selectedCategory: ServiceType? = nil
    @State private var searchText: String = ""
    @State private var activeModalService: ServiceType? = nil

    public init(onSelectService: @escaping (ServiceType) -> Void) {
        self.onSelectService = onSelectService
    }

    private var filteredServices: [ServiceType] {
        var list: [ServiceType] = []

        switch selectedTab {
        case .all:
            list = ServiceType.allCases
        case .daily:
            list = [.rideSharing, .foodDelivery, .grocery, .courier]
        case .lifestyle:
            list = [.shopping, .homeServices, .tickets, .hotels]
        }

        if let selected = selectedCategory {
            list = list.filter { $0 == selected }
        }

        if !searchText.isEmpty {
            list = list.filter { service in
                let titleMatch = service.title.localizedCaseInsensitiveContains(searchText)
                let itemMatch = ServiceDataProvider.items(for: service).contains {
                    $0.title.localizedCaseInsensitiveContains(searchText) ||
                    $0.category.localizedCaseInsensitiveContains(searchText)
                }
                return titleMatch || itemMatch
            }
        }

        return list
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Search Bar (Default System Tertiary Fill)
                KivorlySearchBar(
                    text: $searchText,
                    placeholder: "Search services or items"
                )
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.top, KivorlySpacing.xs)

                // Native iOS Segmented Control
                Picker("Section", selection: $selectedTab) {
                    ForEach(ExploreSectionTab.allCases) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.vertical, KivorlySpacing.xs)

                // Category Filter Bar (Pills)
                CategoryFilterBar(
                    selectedCategory: $selectedCategory,
                    onSelect: { service in
                        selectedCategory = service
                    }
                )
                .padding(.bottom, KivorlySpacing.xs)

                // Organized Services Feed
                ScrollView {
                    VStack(spacing: KivorlySpacing.md) {
                        if filteredServices.isEmpty {
                            EmptyStateView(
                                icon: "magnifyingglass",
                                title: "No Services Found",
                                actionTitle: "Reset Filters"
                            ) {
                                searchText = ""
                                selectedCategory = nil
                                selectedTab = .all
                            }
                            .padding(.top, 40)
                        } else {
                            ForEach(filteredServices) { service in
                                ExploreCollectionCard(
                                    service: service,
                                    onSelect: { activeModalService = service }
                                )
                            }
                        }
                    }
                    .padding(KivorlySpacing.md)
                }
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $activeModalService) { service in
                ServiceDetailView(service: service)
            }
        }
    }
}
