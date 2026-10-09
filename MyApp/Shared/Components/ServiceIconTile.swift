//
//  ServiceIconTile.swift
//  Kivorly
//
//  Premium title-only service tile utilizing transparent 3D illustrations with soft pastel background circles.
//

import SwiftUI

public struct ServiceIconTile: View {
    private let service: ServiceType
    private let isSelected: Bool
    private let action: () -> Void

    public init(
        service: ServiceType,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.service = service
        self.isSelected = isSelected
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: KivorlySpacing.xs) {
                // Soft colored circle with perfectly centered transparent 3D icon
                ZStack {
                    Circle()
                        .fill(service.softBackgroundColor)
                        .frame(width: 68, height: 68)
                        .overlay(
                            Circle()
                                .stroke(isSelected ? Color(uiColor: .tintColor) : Color.clear, lineWidth: 2)
                        )

                    Image(service.assetImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                }

                // Title only
                Text(service.shortTitle)
                    .font(KivorlyTypography.captionBold)
                    .foregroundColor(isSelected ? KivorlyColors.primary : Color(uiColor: .label))
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(service.title)
    }
}
