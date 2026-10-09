//
//  OrderFilterHeader.swift
//  Kivorly
//
//  Orders status tab bar with badge counts and smooth transition indicators.
//

import SwiftUI

public enum OrderFilterTab: String, CaseIterable, Identifiable {
    case all = "All"
    case active = "Active"
    case upcoming = "Upcoming"
    case completed = "Completed"
    case cancelled = "Cancelled"

    public var id: String { rawValue }
}

public struct OrderFilterHeader: View {
    @Binding var selectedTab: OrderFilterTab
    var badgeCounts: [OrderFilterTab: Int] = [:]

    public init(selectedTab: Binding<OrderFilterTab>, badgeCounts: [OrderFilterTab: Int] = [:]) {
        self._selectedTab = selectedTab
        self.badgeCounts = badgeCounts
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(OrderFilterTab.allCases) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Text(tab.rawValue)
                                .font(KivorlyTypography.bodySemibold)
                                .foregroundColor(selectedTab == tab ? KivorlyColors.primary : Color(uiColor: .secondaryLabel))

                            if let count = badgeCounts[tab], count > 0 {
                                Text("\(count)")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(selectedTab == tab ? .white : Color(uiColor: .secondaryLabel))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(selectedTab == tab ? KivorlyColors.primary : Color(uiColor: .tertiarySystemFill))
                                    .clipShape(Capsule())
                            }
                        }

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
