//
//  KivorlyCard.swift
//  Kivorly
//
//  Native iOS styled card using secondarySystemGroupedBackground with no shadow.
//

import SwiftUI

public struct KivorlyCard<Content: View>: View {
    private let cornerRadius: CGFloat
    private let padding: CGFloat
    private let content: Content

    public init(
        cornerRadius: CGFloat = KivorlyRadius.medium,
        padding: CGFloat = KivorlySpacing.md,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(cornerRadius)
    }
}
