//
//  ExploreCollectionCard.swift
//  Kivorly
//
//  Rich categorized card displaying a curated service collection with item previews and default system theme colors.
//

import SwiftUI

public struct ExploreCollectionCard: View {
    let service: ServiceType
    let onSelect: () -> Void

    public init(service: ServiceType, onSelect: @escaping () -> Void) {
        self.service = service
        self.onSelect = onSelect
    }

    private var previewItems: [ServiceItemModel] {
        Array(ServiceDataProvider.items(for: service).prefix(3))
    }

    public var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: KivorlySpacing.sm) {
                // Header Row
                HStack(spacing: KivorlySpacing.sm) {
                    ZStack {
                        Circle()
                            .fill(service.softBackgroundColor)
                            .frame(width: 48, height: 48)

                        Image(service.assetImageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(service.title)
                            .font(KivorlyTypography.titleSmall)
                            .foregroundColor(Color(uiColor: .label))

                        Text("\(ServiceDataProvider.items(for: service).count) options available")
                            .font(KivorlyTypography.caption)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text("View All")
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(service.accentTint)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(service.accentTint)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(service.softBackgroundColor)
                    .clipShape(Capsule())
                }

                Divider()
                    .background(Color(uiColor: .separator))

                // Horizontal Mini Previews
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(previewItems) { item in
                            miniPreviewTile(item)
                        }
                    }
                }
            }
            .padding(KivorlySpacing.md)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(KivorlyRadius.medium)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func miniPreviewTile(_ item: ServiceItemModel) -> some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color(uiColor: .tertiarySystemFill))
                    .frame(width: 32, height: 32)

                Image(systemName: item.icon)
                    .font(.system(size: 13, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(service.accentTint)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(KivorlyTypography.captionBold)
                    .foregroundColor(Color(uiColor: .label))
                    .lineLimit(1)

                Text(item.priceText)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundColor(service.accentTint)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Color(uiColor: .tertiarySystemGroupedBackground))
        .clipShape(Capsule())
    }
}
