//
//  DesignSystemCatalogView.swift
//  Kivorly
//
//  Component catalog previewing iOS standard system themes, single primary color, and modular components.
//

import SwiftUI

public struct DesignSystemCatalogView: View {
    @State private var searchText: String = ""
    @State private var selectedService: ServiceType? = .rideSharing
    @State private var isButtonLoading: Bool = false
    @State private var currentThemeDark: Bool = false

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: KivorlySpacing.xl) {
                    Text("Design System")
                        .font(KivorlyTypography.titleLarge)
                        .foregroundColor(KivorlyColors.textPrimary)
                        .padding(.horizontal, KivorlySpacing.md)

                    // Search Bar Preview
                    VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                        SectionHeader(title: "Search Bar")
                        KivorlySearchBar(text: $searchText, placeholder: "Search", onFilterTap: {
                            print("Filter tapped")
                        })
                        .padding(.horizontal, KivorlySpacing.md)
                    }

                    // 8-Service 3D Icon Grid
                    VStack(alignment: .leading, spacing: KivorlySpacing.sm) {
                        SectionHeader(title: "Services")

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 16) {
                            ForEach(ServiceType.allCases) { service in
                                ServiceIconTile(
                                    service: service,
                                    isSelected: selectedService == service,
                                    action: {
                                        selectedService = service
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, KivorlySpacing.md)
                    }

                    // Buttons
                    VStack(alignment: .leading, spacing: KivorlySpacing.sm) {
                        SectionHeader(title: "Buttons")

                        VStack(spacing: KivorlySpacing.sm) {
                            KivorlyButton("Primary Action", icon: "sparkles", style: .primary) {
                                isButtonLoading.toggle()
                            }

                            KivorlyButton("Secondary Action", style: .secondary) {
                                print("Secondary")
                            }

                            KivorlyButton("Outline Button", style: .outline) {
                                print("Outline")
                            }
                        }
                        .padding(.horizontal, KivorlySpacing.md)
                    }

                    // Status Badges
                    VStack(alignment: .leading, spacing: KivorlySpacing.sm) {
                        SectionHeader(title: "Status Badges")

                        HStack(spacing: 8) {
                            StatusBadge(.confirmed)
                            StatusBadge(.inProgress)
                            StatusBadge(.pending)
                            StatusBadge(.cancelled)
                        }
                        .padding(.horizontal, KivorlySpacing.md)
                    }
                }
                .padding(.vertical, KivorlySpacing.lg)
            }
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle("Design System")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(currentThemeDark ? .dark : .light)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { currentThemeDark.toggle() }) {
                        Image(systemName: currentThemeDark ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(KivorlyColors.primary)
                    }
                    .accessibilityLabel("Toggle light and dark mode")
                }
            }
        }
    }
}
