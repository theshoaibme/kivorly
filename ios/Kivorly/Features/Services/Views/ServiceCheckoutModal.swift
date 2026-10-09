//
//  ServiceCheckoutModal.swift
//  Kivorly
//
//  End-to-end checkout, booking, and confirmation workflow modal in Bangladeshi Taka (৳).
//

import SwiftUI

public struct ServiceCheckoutModal: View {
    let item: ServiceItemModel
    let onOrderCompleted: () -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var quantity: Int = 1
    @State private var selectedPaymentMethod: String = "Cash"
    @State private var deliveryNote: String = ""
    @State private var isProcessing: Bool = false
    @State private var isSuccess: Bool = false

    public init(item: ServiceItemModel, onOrderCompleted: @escaping () -> Void) {
        self.item = item
        self.onOrderCompleted = onOrderCompleted
    }

    private var totalPrice: Double {
        item.numericPrice * Double(quantity)
    }

    private let platformFee: Double = 30.0

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if isSuccess {
                    successView
                } else {
                    orderFormView
                }
            }
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle(isSuccess ? "Order Confirmed" : item.serviceType.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if !isSuccess {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(KivorlyColors.primary)
                    }
                }
            }
        }
    }

    private var orderFormView: some View {
        ScrollView {
            VStack(spacing: KivorlySpacing.lg) {
                // Item Header Banner
                KivorlyCard(padding: KivorlySpacing.md) {
                    HStack(spacing: KivorlySpacing.md) {
                        ZStack {
                            Circle()
                                .fill(item.serviceType.accentTint.opacity(0.15))
                                .frame(width: 56, height: 56)

                            Image(systemName: item.icon)
                                .font(.system(size: 24, weight: .bold))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundColor(item.serviceType.accentTint)
                        }

                        VStack(alignment: .leading, spacing: 3) {
                            Text(item.title)
                                .font(KivorlyTypography.titleSmall)
                                .foregroundColor(KivorlyColors.textPrimary)

                            Text(item.category)
                                .font(KivorlyTypography.caption)
                                .foregroundColor(KivorlyColors.textSecondary)

                            Text(item.etaOrDuration)
                                .font(KivorlyTypography.captionBold)
                                .foregroundColor(item.serviceType.accentTint)
                        }

                        Spacer()

                        Text(item.priceText)
                            .font(KivorlyTypography.titleMedium)
                            .foregroundColor(item.serviceType.accentTint)
                    }
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.top, KivorlySpacing.md)

                // Quantity / Units Selector
                VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                    SectionHeader(title: "Booking Quantity")

                    KivorlyCard(padding: KivorlySpacing.md) {
                        HStack {
                            Text("Units / Passengers")
                                .font(KivorlyTypography.bodyMedium)
                                .foregroundColor(KivorlyColors.textPrimary)

                            Spacer()

                            HStack(spacing: 14) {
                                Button(action: {
                                    if quantity > 1 { quantity -= 1 }
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(quantity > 1 ? item.serviceType.accentTint : Color(uiColor: .tertiaryLabel))
                                }

                                Text("\(quantity)")
                                    .font(KivorlyTypography.titleMedium)
                                    .frame(minWidth: 24)

                                Button(action: {
                                    if quantity < 10 { quantity += 1 }
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(item.serviceType.accentTint)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, KivorlySpacing.md)
                }

                // Payment Method Selector
                VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                    SectionHeader(title: "Payment Method")

                    KivorlyCard(padding: 0) {
                        VStack(spacing: 0) {
                            paymentOptionRow(title: "Cash on Delivery (COD)", icon: "banknote.fill", tag: "Cash", badge: "Cash on Delivery", badgeColor: KivorlyColors.success)
                            Divider().padding(.leading, 56)
                            paymentOptionRow(title: "bKash Digital MFS", icon: "iphone.radiowaves.left.and.right", tag: "bKash", badge: "bKash MFS", badgeColor: Color(red: 0xE2 / 255.0, green: 0x13 / 255.0, blue: 0x6E / 255.0))
                            Divider().padding(.leading, 56)
                            paymentOptionRow(title: "Nagad Digital Bank", icon: "creditcard.circle.fill", tag: "Nagad", badge: "Nagad", badgeColor: Color(red: 0xF7 / 255.0, green: 0x93 / 255.0, blue: 0x1E / 255.0))
                            Divider().padding(.leading, 56)
                            paymentOptionRow(title: "Visa / Mastercard", icon: "creditcard.fill", tag: "Card", badge: "Card", badgeColor: Color(red: 0x7C / 255.0, green: 0x3A / 255.0, blue: 0xED / 255.0))
                        }
                    }
                    .padding(.horizontal, KivorlySpacing.md)
                }

                // Special Notes / Instructions
                VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                    SectionHeader(title: "Special Instructions")

                    TextField("Add pickup note, gate code, or requests", text: $deliveryNote)
                        .font(KivorlyTypography.bodyMedium)
                        .padding()
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .cornerRadius(KivorlyRadius.medium)
                        .padding(.horizontal, KivorlySpacing.md)
                }

                // Cost Breakdown
                KivorlyCard(padding: KivorlySpacing.md) {
                    VStack(spacing: 8) {
                        HStack {
                            Text("Subtotal")
                                .font(KivorlyTypography.bodyMedium)
                                .foregroundColor(KivorlyColors.textSecondary)
                            Spacer()
                            Text(String(format: "৳%.0f", totalPrice))
                                .font(KivorlyTypography.bodyMedium)
                        }

                        HStack {
                            Text("Platform Fee")
                                .font(KivorlyTypography.bodyMedium)
                                .foregroundColor(KivorlyColors.textSecondary)
                            Spacer()
                            Text(String(format: "৳%.0f", platformFee))
                                .font(KivorlyTypography.bodyMedium)
                        }

                        Divider()

                        HStack {
                            Text("Total Payable")
                                .font(KivorlyTypography.titleSmall)
                                .foregroundColor(KivorlyColors.textPrimary)
                            Spacer()
                            Text(String(format: "৳%.0f", totalPrice + platformFee))
                                .font(KivorlyTypography.titleLarge)
                                .foregroundColor(item.serviceType.accentTint)
                        }
                    }
                }
                .padding(.horizontal, KivorlySpacing.md)

                // Confirm & Pay Button
                KivorlyButton(
                    "Confirm & Book (৳\(Int(totalPrice + platformFee)))",
                    icon: "lock.shield.fill",
                    style: .primary,
                    isLoading: isProcessing
                ) {
                    processOrder()
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.bottom, KivorlySpacing.xl)
            }
        }
    }

    private func paymentOptionRow(title: String, icon: String, tag: String, badge: String, badgeColor: Color) -> some View {
        Button(action: {
            selectedPaymentMethod = tag
        }) {
            HStack(spacing: KivorlySpacing.md) {
                ZStack {
                    Circle()
                        .fill(badgeColor.opacity(0.12))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(badgeColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(title)
                            .font(KivorlyTypography.bodyMedium)
                            .foregroundColor(Color(uiColor: .label))

                        Text(badge)
                            .font(.system(size: 9, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(badgeColor)
                            .clipShape(Capsule())
                    }
                }

                Spacer()

                Image(systemName: selectedPaymentMethod == tag ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(selectedPaymentMethod == tag ? Color(uiColor: .tintColor) : Color(uiColor: .tertiaryLabel))
            }
            .padding(.horizontal, KivorlySpacing.md)
            .padding(.vertical, KivorlySpacing.sm)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(selectedPaymentMethod == tag ? Color(uiColor: .tintColor).opacity(0.08) : Color.clear)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(
                        selectedPaymentMethod == tag ? Color(uiColor: .tintColor) : Color.clear,
                        lineWidth: selectedPaymentMethod == tag ? 1.5 : 0
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var successView: some View {
        VStack(spacing: KivorlySpacing.xl) {
            Spacer()

            ZStack {
                Circle()
                    .fill(item.serviceType.accentTint.opacity(0.15))
                    .frame(width: 96, height: 96)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 54, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(item.serviceType.accentTint)
            }

            VStack(spacing: 8) {
                Text("Order Confirmed!")
                    .font(KivorlyTypography.displayMedium)
                    .foregroundColor(KivorlyColors.textPrimary)

                Text("Your request for \(item.title) has been dispatched.")
                    .font(KivorlyTypography.bodyMedium)
                    .foregroundColor(KivorlyColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, KivorlySpacing.lg)
            }

            KivorlyCard(padding: KivorlySpacing.md) {
                VStack(spacing: 10) {
                    HStack {
                        Text("Order Reference")
                            .font(KivorlyTypography.caption)
                            .foregroundColor(KivorlyColors.textSecondary)
                        Spacer()
                        Text("KV-\(Int.random(in: 1000...9999))")
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(KivorlyColors.textPrimary)
                    }

                    HStack {
                        Text("Payment")
                            .font(KivorlyTypography.caption)
                            .foregroundColor(KivorlyColors.textSecondary)
                        Spacer()
                        Text(selectedPaymentMethod)
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(KivorlyColors.textPrimary)
                    }

                    HStack {
                        Text("Total Amount")
                            .font(KivorlyTypography.caption)
                            .foregroundColor(KivorlyColors.textSecondary)
                        Spacer()
                        Text(String(format: "৳%.0f", totalPrice + platformFee))
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(item.serviceType.accentTint)
                    }

                    HStack {
                        Text("ETA")
                            .font(KivorlyTypography.caption)
                            .foregroundColor(KivorlyColors.textSecondary)
                        Spacer()
                        Text(item.etaOrDuration)
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(item.serviceType.accentTint)
                    }
                }
            }
            .padding(.horizontal, KivorlySpacing.xl)

            Spacer()

            KivorlyButton("Track Live in Activity", icon: "bell.badge.fill", style: .primary) {
                dismiss()
                onOrderCompleted()
            }
            .padding(.horizontal, KivorlySpacing.md)

            KivorlyButton("Done", style: .outline) {
                dismiss()
            }
            .padding(.horizontal, KivorlySpacing.md)
            .padding(.bottom, KivorlySpacing.xl)
        }
    }

    private func processOrder() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isProcessing = false
            let cleanCode = item.serviceType.shortTitle.replacingOccurrences(of: " ", with: "").uppercased()
            let orderId = "KV-\(cleanCode)-\(Int.random(in: 100000...999999))-BD"
            let finalTotal = totalPrice + platformFee

            let newOrder = SuperAppOrder(
                id: orderId,
                service: item.serviceType,
                title: item.title,
                subtitle: "\(quantity) unit(s) • \(item.category)",
                timestamp: "Just now",
                amount: String(format: "\u{09F3}%.0f", finalTotal),
                rawAmount: finalTotal,
                status: .inProgress,
                etaText: "Arriving in \(item.etaOrDuration)",
                pickupLocation: "\(item.title) Hub, Dhaka",
                destinationLocation: "Road 71, House 14, Gulshan 2, Dhaka",
                driverOrPartner: OrderPartner(
                    name: "Kivorly Verified Specialist",
                    role: "\(item.serviceType.shortTitle) Partner",
                    rating: 4.9,
                    completedTrips: 1140,
                    phone: "+880 1712-345678"
                ),
                securityPin: String(format: "%04d", Int.random(in: 1000...9999)),
                trackingNumber: "TRK-\(Int.random(in: 100000...999999))-BD",
                qrPassCode: "\(orderId)-QR",
                bookingDetails: nil,
                items: [
                    OrderLineItem(
                        title: item.title,
                        subtitle: item.category,
                        quantity: quantity,
                        price: item.numericPrice,
                        emoji: "📦"
                    )
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Order Placed", subtitle: "Payment confirmed via \(selectedPaymentMethod)", time: "Just now", isCompleted: true),
                    OrderTimelineStep(title: "Confirmed by Merchant", subtitle: "Processing requested service", time: "Just now", isCompleted: true, isCurrent: true),
                    OrderTimelineStep(title: "Preparing Order", subtitle: "Packing items / preparing specialist", time: "Pending", isCompleted: false),
                    OrderTimelineStep(title: "En Route", subtitle: "Heading to delivery destination", time: "Estimated \(item.etaOrDuration)", isCompleted: false),
                    OrderTimelineStep(title: "Delivered & Verified", subtitle: "Handed over at doorstep", time: "Estimated \(item.etaOrDuration)", isCompleted: false)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: totalPrice,
                    deliveryOrFareFee: 0,
                    platformFee: platformFee,
                    discount: 0,
                    total: finalTotal,
                    paymentMethod: selectedPaymentMethod,
                    transactionId: "TXN-\(Int.random(in: 10000000...99999999))"
                )
            )
            OrdersManager.shared.addOrder(newOrder)

            withAnimation(.spring()) {
                isSuccess = true
            }
        }
    }
}
