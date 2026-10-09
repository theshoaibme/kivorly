//
//  AuthenticationView.swift
//  Kivorly
//
//  Clean centered authentication screen with official Kivorly app logo.
//

import SwiftUI

public struct AuthenticationView: View {
    private let onAuthenticated: () -> Void

    @State private var phoneNumber: String = ""
    @State private var countryCode: String = "+880"
    @State private var otpCode: String = ""
    @State private var isOtpSent: Bool = false
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    @State private var timerCountdown: Int = 45
    @State private var canResend: Bool = false

    public init(onAuthenticated: @escaping () -> Void) {
        self.onAuthenticated = onAuthenticated
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                KivorlyColors.background.ignoresSafeArea()

                VStack(spacing: KivorlySpacing.xl) {
                    Spacer()

                    // Official Kivorly Brand Logo
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                    // Centered Title
                    Text(isOtpSent ? "Verification Code" : "Sign In to Kivorly")
                        .font(KivorlyTypography.displayMedium)
                        .foregroundColor(KivorlyColors.textPrimary)
                        .multilineTextAlignment(.center)

                    // Centered Input Section (No Card Background)
                    VStack(spacing: KivorlySpacing.md) {
                        if !isOtpSent {
                            PhoneInputView(
                                phoneNumber: $phoneNumber,
                                countryCode: countryCode
                            )
                        } else {
                            OtpInputView(
                                otpCode: $otpCode,
                                countdown: timerCountdown,
                                canResend: canResend,
                                onResend: handleResend
                            )
                        }

                        if let errorMessage = errorMessage {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(KivorlyColors.error)
                                Text(errorMessage)
                                    .font(KivorlyTypography.caption)
                                    .foregroundColor(KivorlyColors.error)
                            }
                        }

                        KivorlyButton(
                            isOtpSent ? "Verify" : "Continue",
                            icon: isOtpSent ? "checkmark" : "arrow.right",
                            style: .primary,
                            isLoading: isLoading
                        ) {
                            handleMainAction()
                        }
                    }
                    .padding(.horizontal, KivorlySpacing.md)

                    // Alternative Sign-in (Apple)
                    if !isOtpSent {
                        appleSignInSection
                            .padding(.horizontal, KivorlySpacing.md)
                    }

                    Spacer()
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isOtpSent {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            isOtpSent = false
                            errorMessage = nil
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(KivorlyTypography.bodySemibold)
                            .foregroundColor(KivorlyColors.primary)
                        }
                    }
                }
            }
        }
    }

    private var appleSignInSection: some View {
        VStack(spacing: KivorlySpacing.md) {
            HStack {
                Rectangle().fill(KivorlyColors.border).frame(height: 1)
                Text("or").font(KivorlyTypography.caption).foregroundColor(KivorlyColors.textSecondary)
                Rectangle().fill(KivorlyColors.border).frame(height: 1)
            }

            KivorlyButton(
                "Continue with Apple",
                icon: "apple.logo",
                style: .secondary
            ) {
                isLoading = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    isLoading = false
                    onAuthenticated()
                }
            }
        }
    }

    private func handleResend() {
        if canResend {
            timerCountdown = 45
            canResend = false
            errorMessage = nil
        }
    }

    private func handleMainAction() {
        errorMessage = nil

        if !isOtpSent {
            guard phoneNumber.count >= 8 else {
                errorMessage = "Please enter a valid phone number."
                return
            }
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isLoading = false
                isOtpSent = true
                canResend = true
            }
        } else {
            guard otpCode.count >= 4 else {
                errorMessage = "Please enter a valid 6-digit OTP code."
                return
            }
            isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                isLoading = false
                onAuthenticated()
            }
        }
    }
}
