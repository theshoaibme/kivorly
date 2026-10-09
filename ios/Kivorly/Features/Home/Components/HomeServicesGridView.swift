//
//  HomeServicesGridView.swift
//  Kivorly
//
//  8 services grid component.
//

import SwiftUI

public struct HomeServicesGridView: View {
    let onSelectService: (ServiceType) -> Void

    public var body: some View {
        VStack(alignment: .leading, spacing: KivorlySpacing.sm) {
            SectionHeader(title: "Services")

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 16
            ) {
                ForEach(ServiceType.allCases) { service in
                    ServiceIconTile(
                        service: service,
                        isSelected: false
                    ) {
                        onSelectService(service)
                    }
                }
            }
            .padding(.horizontal, KivorlySpacing.md)
        }
    }
}
