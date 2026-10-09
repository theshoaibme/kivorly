//
//  PaymentMethodsView.swift
//  Kivorly
//
//  Saved payment methods (bKash, Nagad, Visa, Mastercard, Apple Pay).
//

import SwiftUI

public struct PaymentMethodItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let detail: String
    public let icon: String
    public let color: Color
    public var isDefault: Bool
}

public struct PaymentMethodsView: View {
    @State private var paymentMethods: [PaymentMethodItem] = [
        PaymentMethodItem(title: "Apple Pay", detail: "Connected", icon: "apple.logo", color: Color.black, isDefault: true),
        PaymentMethodItem(title: "bKash", detail: "017***5678", icon: "banknote.fill", color: Color(red: 0xE2 / 255.0, green: 0x13 / 255.0, blue: 0x6E / 255.0), isDefault: false),
        PaymentMethodItem(title: "Nagad", detail: "018***9012", icon: "creditcard.fill", color: Color(red: 0xF7 / 255.0, green: 0x94 / 255.0, blue: 0x1D / 255.0), isDefault: false),
        PaymentMethodItem(title: "Visa Card", detail: "•••• 4242", icon: "creditcard", color: KivorlyColors.primary, isDefault: false)
    ]
    @State private var showAddCardSheet: Bool = false
    @State private var cardNumber: String = ""
    @State private var cardExpiry: String = ""
    @State private var cardCvv: String = ""

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: KivorlySpacing.md) {
                ForEach(paymentMethods) { method in
                    methodCard(method)
                }

                KivorlyButton("Add Payment Method", icon: "plus", style: .outline) {
                    showAddCardSheet = true
                }
                .padding(.top, KivorlySpacing.sm)
            }
            .padding(KivorlySpacing.md)
        }
        .background(KivorlyColors.background.ignoresSafeArea())
        .navigationTitle("Payment Methods")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddCardSheet) {
            addCardSheet
        }
    }

    private func methodCard(_ method: PaymentMethodItem) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            HStack(spacing: KivorlySpacing.md) {
                ZStack {
                    Circle()
                        .fill(method.color.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: method.icon)
                        .font(.system(size: 18, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(method.color)
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Text(method.title)
                            .font(KivorlyTypography.titleSmall)
                            .foregroundColor(KivorlyColors.textPrimary)

                        if method.isDefault {
                            Text("Default")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(KivorlyColors.primary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(KivorlyColors.primary.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }

                    Text(method.detail)
                        .font(KivorlyTypography.caption)
                        .foregroundColor(KivorlyColors.textSecondary)
                }

                Spacer()

                Button(action: {
                    for i in 0..<paymentMethods.count {
                        paymentMethods[i].isDefault = (paymentMethods[i].id == method.id)
                    }
                }) {
                    Image(systemName: method.isDefault ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundColor(method.isDefault ? KivorlyColors.primary : KivorlyColors.slateGray)
                }
            }
        }
    }

    private var addCardSheet: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: KivorlySpacing.lg) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Card Number")
                        .font(KivorlyTypography.captionBold)
                    TextField("1234 5678 9012 3456", text: $cardNumber)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(uiColor: .tertiarySystemFill))
                        .clipShape(Capsule())
                }

                HStack(spacing: KivorlySpacing.md) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Expiry")
                            .font(KivorlyTypography.captionBold)
                        TextField("MM/YY", text: $cardExpiry)
                            .padding()
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Capsule())
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("CVV")
                            .font(KivorlyTypography.captionBold)
                        SecureField("123", text: $cardCvv)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Capsule())
                    }
                }

                KivorlyButton("Add Card", icon: "lock.fill", style: .primary) {
                    if !cardNumber.isEmpty {
                        paymentMethods.append(
                            PaymentMethodItem(
                                title: "Card (•••• " + String(cardNumber.suffix(4)) + ")",
                                detail: "Debit / Credit",
                                icon: "creditcard.fill",
                                color: KivorlyColors.primary,
                                isDefault: false
                            )
                        )
                        cardNumber = ""
                        showAddCardSheet = false
                    }
                }

                Spacer()
            }
            .padding(KivorlySpacing.md)
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle("New Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { showAddCardSheet = false }
                        .foregroundColor(KivorlyColors.primary)
                }
            }
        }
    }
}
