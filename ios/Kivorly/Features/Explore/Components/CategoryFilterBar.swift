//
//  CategoryFilterBar.swift
//  Kivorly
//
//  Horizontal category chip selector with distinct service colors.
//

import SwiftUI

public struct CategoryFilterBar: View {
    @Binding var selectedCategory: ServiceType?
    var onSelect: ((ServiceType?) -> Void)? = nil

    public init(
        selectedCategory: Binding<ServiceType?>,
        onSelect: ((ServiceType?) -> Void)? = nil
    ) {
        self._selectedCategory = selectedCategory
        self.onSelect = onSelect
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // "All Services" Badge
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        selectedCategory = nil
                        onSelect?(nil)
                    }
                }) {
                    Text("All Services")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(
                            selectedCategory == nil ?
                            Color(uiColor: .label).opacity(0.1) :
                            Color(uiColor: .tertiarySystemFill)
                        )
                        .foregroundColor(
                            selectedCategory == nil ?
                            Color(uiColor: .label) :
                            Color(uiColor: .secondaryLabel)
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(
                                    selectedCategory == nil ?
                                    Color(uiColor: .label) :
                                    Color(uiColor: .separator).opacity(0.4),
                                    lineWidth: selectedCategory == nil ? 1.5 : 0.8
                                )
                        )
                }
                .buttonStyle(PlainButtonStyle())

                // Service Badges
                ForEach(ServiceType.allCases) { service in
                    let isSelected = selectedCategory == service
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            let newSelection: ServiceType? = (isSelected ? nil : service)
                            selectedCategory = newSelection
                            onSelect?(newSelection)
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: service.systemIcon)
                                .font(.system(size: 11, weight: .bold))
                                .symbolRenderingMode(.hierarchical)
                            Text(service.shortTitle)
                                .font(.system(size: 12, weight: .bold))
                        }
                        .padding(.horizontal, 13)
                        .padding(.vertical, 7)
                        .background(
                            isSelected ?
                            service.accentTint.opacity(0.12) :
                            Color(uiColor: .tertiarySystemFill)
                        )
                        .foregroundColor(
                            isSelected ?
                            service.accentTint :
                            Color(uiColor: .secondaryLabel)
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(
                                    isSelected ?
                                    service.accentTint :
                                    Color(uiColor: .separator).opacity(0.4),
                                    lineWidth: isSelected ? 1.5 : 0.8
                                )
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, KivorlySpacing.md)
            .padding(.vertical, 3)
        }
    }
}
