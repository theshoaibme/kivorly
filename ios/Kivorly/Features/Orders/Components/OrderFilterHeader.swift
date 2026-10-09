//
//  OrderFilterHeader.swift
//  Kivorly
//
//  Orders status tab bar.
//

import SwiftUI

public struct OrderFilterHeader: View {
    @Binding var selectedTab: OrderFilterTab

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(OrderFilterTab.allCases) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(tab.rawValue)
                            .font(KivorlyTypography.bodySemibold)
                            .foregroundColor(selectedTab == tab ? KivorlyColors.primary : KivorlyColors.textSecondary)

                        Rectangle()
                            .fill(selectedTab == tab ? KivorlyColors.primary : Color.clear)
                            .frame(height: 2.5)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, KivorlySpacing.xs)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }
}
