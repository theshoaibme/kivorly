//
//  PhoneInputView.swift
//  Kivorly
//
//  Centered standalone phone number input component.
//

import SwiftUI

public struct PhoneInputView: View {
    @Binding var phoneNumber: String
    let countryCode: String

    public var body: some View {
        HStack(spacing: KivorlySpacing.xs) {
            HStack(spacing: 4) {
                Text("🇧🇩")
                    .font(.system(size: 20))
                Text(countryCode)
                    .font(KivorlyTypography.bodySemibold)
                    .foregroundColor(KivorlyColors.textPrimary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(Color(uiColor: .tertiarySystemFill))
            .clipShape(Capsule())

            TextField("Phone number", text: $phoneNumber)
                .font(KivorlyTypography.bodyLarge)
                .keyboardType(.numberPad)
                .padding(.horizontal, KivorlySpacing.lg)
                .padding(.vertical, 14)
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
    }
}
