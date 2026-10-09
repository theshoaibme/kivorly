//
//  SplashScreenView.swift
//  Kivorly
//
//  Clean title-only splash screen with official Kivorly app logo.
//

import SwiftUI

public struct SplashScreenView: View {
    private let onFinish: () -> Void

    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0.0

    public init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

    public var body: some View {
        ZStack {
            KivorlyColors.background
                .ignoresSafeArea()

            VStack(spacing: KivorlySpacing.lg) {
                Spacer()

                // Official Kivorly Brand Logo
                Image("AppLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 96, height: 96)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                Text("Kivorly")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundColor(KivorlyColors.textPrimary)

                Spacer()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: KivorlyColors.primary))
                    .scaleEffect(1.0)
                    .padding(.bottom, KivorlySpacing.xl)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    onFinish()
                }
            }
        }
    }
}
