//
//  OtpInputView.swift
//  Kivorly
//
//  Standalone OTP input component.
//

import SwiftUI

public struct OtpInputView: View {
    @Binding var otpCode: String
    let countdown: Int
    let canResend: Bool
    let onResend: () -> Void

    public var body: some View {
        VStack(spacing: KivorlySpacing.md) {
            Text("Enter OTP")
                .font(KivorlyTypography.captionBold)
                .foregroundColor(KivorlyColors.textPrimary)

            TextField("000000", text: $otpCode)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .padding(.vertical, 14)
                .background(Color(uiColor: .tertiarySystemFill))
                .clipShape(Capsule())

            Button(action: onResend) {
                Text(canResend ? "Resend Code" : "Resend in \(countdown)s")
                    .font(KivorlyTypography.captionBold)
                    .foregroundColor(canResend ? KivorlyColors.primary : KivorlyColors.textSecondary)
            }
            .disabled(!canResend)
        }
    }
}
