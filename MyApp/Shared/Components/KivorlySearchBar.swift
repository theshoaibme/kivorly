//
//  KivorlySearchBar.swift
//  Kivorly
//
//  Native iOS styled search input using system gray fill with zero shadow.
//

import SwiftUI

public struct KivorlySearchBar: View {
    @Binding private var text: String
    private let placeholder: String
    private let onFilterTap: (() -> Void)?

    public init(
        text: Binding<String>,
        placeholder: String = "Search",
        onFilterTap: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.onFilterTap = onFilterTap
    }

    public var body: some View {
        HStack(spacing: KivorlySpacing.xs) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(KivorlyColors.textSecondary)
                .font(.system(size: 16, weight: .medium))

            TextField(placeholder, text: $text)
                .font(KivorlyTypography.bodyLarge)
                .foregroundColor(KivorlyColors.textPrimary)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(KivorlyColors.textSecondary)
                        .font(.system(size: 16))
                }
                .accessibilityLabel("Clear search")
            }

            if let onFilterTap = onFilterTap {
                Rectangle()
                    .fill(KivorlyColors.border)
                    .frame(width: 1, height: 18)
                    .padding(.horizontal, 4)

                Button(action: onFilterTap) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(KivorlyColors.primary)
                        .font(.system(size: 16, weight: .medium))
                }
                .accessibilityLabel("Filter options")
            }
        }
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.vertical, 12)
        .background(Color(uiColor: .tertiarySystemFill))
        .clipShape(Capsule())
    }
}
