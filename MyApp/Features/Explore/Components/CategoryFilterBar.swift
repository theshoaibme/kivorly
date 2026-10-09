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
                Button(action: {
                    selectedCategory = nil
                    onSelect?(nil)
                }) {
                    Text("All Services")
                        .font(KivorlyTypography.captionBold)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(selectedCategory == nil ? Color(uiColor: .tintColor).opacity(0.12) : Color(uiColor: .tertiarySystemFill))
                        .foregroundColor(selectedCategory == nil ? Color(uiColor: .tintColor) : KivorlyColors.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(
                                    selectedCategory == nil ? Color(uiColor: .tintColor) : Color(uiColor: .separator).opacity(0.3),
                                    lineWidth: selectedCategory == nil ? 2 : 0.6
                                )
                        )
                }

                ForEach(ServiceType.allCases) { service in
                    Button(action: {
                        let newSelection: ServiceType? = (selectedCategory == service ? nil : service)
                        selectedCategory = newSelection
                        onSelect?(newSelection)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: service.systemIcon)
                                .font(.system(size: 11, weight: .bold))
                                .symbolRenderingMode(.hierarchical)
                            Text(service.shortTitle)
                                .font(KivorlyTypography.captionBold)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(selectedCategory == service ? service.softBackgroundColor : Color(uiColor: .tertiarySystemFill))
                        .foregroundColor(selectedCategory == service ? Color(uiColor: .tintColor) : KivorlyColors.textPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(
                                    selectedCategory == service ? Color(uiColor: .tintColor) : Color(uiColor: .separator).opacity(0.3),
                                    lineWidth: selectedCategory == service ? 2 : 0.6
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, KivorlySpacing.md)
        }
    }
}
