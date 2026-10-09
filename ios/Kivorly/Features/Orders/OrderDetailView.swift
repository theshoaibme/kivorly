//
//  OrderDetailView.swift
//  Kivorly
//
//  End-to-End All-in-One Order Page featuring real-time tracking, live timeline stepper,
//  driver/courier partner details, digital boarding pass/hotel QR voucher, itemized bill,
//  and full lifecycle actions (Reorder, Cancel, Track, Receipt, Rate).
//

import SwiftUI
import MapKit

public struct OrderDetailView: View {
    @ObservedObject var ordersManager: OrdersManager = OrdersManager.shared
    let orderId: String
    let onDismiss: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var copiedOrderId: Bool = false
    @State private var showCancelConfirmation: Bool = false
    @State private var showReorderSuccessAlert: Bool = false
    @State private var showRatingSheet: Bool = false
    @State private var userRating: Int = 5
    @State private var ratingComment: String = ""
    @State private var showReceiptAlert: Bool = false

    // Map camera for live route tracking
    @State private var mapPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 23.7925, longitude: 90.4078),
            span: MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        )
    )

    public init(orderId: String, onDismiss: @escaping () -> Void = {}) {
        self.orderId = orderId
        self.onDismiss = onDismiss
    }

    private var order: SuperAppOrder? {
        ordersManager.orders.first(where: { $0.id == orderId })
    }

    public var body: some View {
        NavigationStack {
            Group {
                if let order = order {
                    ScrollView {
                        VStack(spacing: KivorlySpacing.md) {
                            // 1. Hero Status & Dynamic ETA Banner
                            orderHeroStatusBanner(order: order)

                            // 2. Interactive Timeline Stepper
                            orderTimelineSection(order: order)

                            // 3. Service-Specific Live Context Modules
                            if order.service == .rideSharing || order.service == .courier {
                                rideOrCourierLiveTracker(order: order)
                            } else if order.service == .tickets || order.service == .hotels {
                                digitalPassVoucherCard(order: order)
                            } else if order.service == .shopping {
                                shoppingLogisticsCard(order: order)
                            }

                            // 4. Itemized Order Line Items
                            orderItemsCard(order: order)

                            // 5. Delivery Route & Address
                            addressAndContactCard(order: order)

                            // 6. Payment & Financial Bill Breakdown
                            billPaymentCard(order: order)

                            // 7. Support & Safety Guarantee Card
                            supportAndGuaranteeCard(order: order)

                            // Spacer for bottom dock
                            Spacer()
                                .frame(height: 70)
                        }
                        .padding(.horizontal, KivorlySpacing.md)
                        .padding(.top, KivorlySpacing.sm)
                    }
                    .safeAreaInset(edge: .bottom) {
                        bottomActionDock(order: order)
                    }
                } else {
                    EmptyStateView(
                        icon: "doc.questionmark",
                        title: "Order Not Found",
                        actionTitle: "Close"
                    ) {
                        dismiss()
                        onDismiss()
                    }
                }
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Order Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                        onDismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showReceiptAlert = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(KivorlyColors.primary)
                    }
                }
            }
            .overlay(alignment: .top) {
                if copiedOrderId {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Order ID copied to clipboard")
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.black.opacity(0.85))
                    .clipShape(Capsule())
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 12)
                }
            }
            .alert("Cancel Order?", isPresented: $showCancelConfirmation) {
                Button("Keep Order", role: .cancel) {}
                Button("Yes, Cancel", role: .destructive) {
                    if let order = order {
                        ordersManager.cancelOrder(id: order.id)
                    }
                }
            } message: {
                Text("Are you sure you want to cancel this order? Any payments made via bKash/Nagad will be refunded instantly to your account.")
            }
            .alert("Order Replaced!", isPresented: $showReorderSuccessAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your items have been placed as a fresh order. You can track its live progress right now.")
            }
            .alert("Order Receipt", isPresented: $showReceiptAlert) {
                Button("Done", role: .cancel) {}
            } message: {
                if let order = order {
                    Text("Official Tax Invoice for \(order.id)\nAmount Paid: \(order.amount)\nPayment: \(order.paymentBreakdown.paymentMethod)\nTxn: \(order.paymentBreakdown.transactionId)")
                } else {
                    Text("Receipt unavailable")
                }
            }
            .sheet(isPresented: $showRatingSheet) {
                ratingSheetView
            }
        }
    }

    // MARK: - 1. Hero Status Banner
    private func orderHeroStatusBanner(order: SuperAppOrder) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(spacing: KivorlySpacing.sm) {
                HStack(alignment: .top, spacing: KivorlySpacing.md) {
                    // Service Icon with Vibrant Accent Tint
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(order.service.accentTint.opacity(0.14))
                            .frame(width: 58, height: 58)

                        Image(systemName: order.service.systemIcon)
                            .font(.system(size: 26, weight: .bold))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(order.service.accentTint)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 8) {
                            Text(order.service.title)
                                .font(KivorlyTypography.captionBold)
                                .foregroundColor(order.service.accentTint)
                                .textCase(.uppercase)

                            Spacer()

                            StatusBadge(order.status)
                        }

                        Text(order.title)
                            .font(KivorlyTypography.titleMedium)
                            .foregroundColor(Color(uiColor: .label))
                            .lineLimit(2)

                        // Order ID with Copy Action
                        Button(action: {
                            UIPasteboard.general.string = order.id
                            withAnimation(.spring()) {
                                copiedOrderId = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation {
                                    copiedOrderId = false
                                }
                            }
                        }) {
                            HStack(spacing: 4) {
                                Text(order.id)
                                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))

                                Image(systemName: "doc.on.doc")
                                    .font(.system(size: 10))
                                    .foregroundColor(KivorlyColors.primary)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Capsule())
                        }
                    }
                }

                Divider()
                    .padding(.vertical, 2)

                // Live Arrival / Status Strip
                HStack(spacing: 10) {
                    if order.status == .active || order.status == .inProgress {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle()
                                    .stroke(Color.green.opacity(0.4), lineWidth: 3)
                                    .scaleEffect(1.6)
                            )
                    } else if order.status == .confirmed {
                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 14))
                            .foregroundColor(KivorlyColors.primary)
                    } else if order.status == .completed {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                    } else {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.red)
                    }

                    VStack(alignment: .leading, spacing: 1) {
                        Text(order.etaText)
                            .font(KivorlyTypography.bodySemibold)
                            .foregroundColor(Color(uiColor: .label))

                        Text("Ordered on \(order.timestamp)")
                            .font(KivorlyTypography.caption)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }

                    Spacer()

                    Text(order.amount)
                        .font(KivorlyTypography.priceDisplay)
                        .foregroundColor(Color(uiColor: .label))
                }
            }
        }
    }

    // MARK: - 2. Timeline Stepper
    private func orderTimelineSection(order: SuperAppOrder) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: KivorlySpacing.sm) {
                HStack {
                    Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(KivorlyColors.primary)

                    Text("Tracking Timeline")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(Color(uiColor: .label))

                    Spacer()

                    if let trackingNumber = order.trackingNumber {
                        Text(trackingNumber)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 0) {
                    ForEach(order.timelineSteps.indices, id: \.self) { idx in
                        let step = order.timelineSteps[idx]
                        let isLast = idx == order.timelineSteps.count - 1

                        HStack(alignment: .top, spacing: 14) {
                            // Indicator Node & Vertical Line
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(step.isCompleted ? Color.green : (step.isCurrent ? KivorlyColors.primary : Color(uiColor: .tertiaryLabel).opacity(0.3)))
                                        .frame(width: 22, height: 22)

                                    if step.isCompleted {
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 11, weight: .black))
                                            .foregroundColor(.white)
                                    } else if step.isCurrent {
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 8, height: 8)
                                    }
                                }

                                if !isLast {
                                    Rectangle()
                                        .fill(step.isCompleted ? Color.green.opacity(0.6) : Color(uiColor: .separator))
                                        .frame(width: 2, height: 34)
                                }
                            }

                            // Step Details
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(step.title)
                                        .font(.system(size: 14, weight: step.isCurrent ? .bold : (step.isCompleted ? .semibold : .regular)))
                                        .foregroundColor(step.isCurrent ? KivorlyColors.primary : (step.isCompleted ? Color(uiColor: .label) : Color(uiColor: .secondaryLabel)))

                                    Spacer()

                                    Text(step.time)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                }

                                Text(step.subtitle)
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }
                            .padding(.bottom, isLast ? 0 : 16)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
    }

    // MARK: - 3A. Ride & Courier Live Tracking Module
    private func rideOrCourierLiveTracker(order: SuperAppOrder) -> some View {
        VStack(spacing: KivorlySpacing.sm) {
            // Live Map Preview
            ZStack(alignment: .topTrailing) {
                Map(position: $mapPosition) {
                    Marker("Pickup", coordinate: CLLocationCoordinate2D(latitude: 23.7937, longitude: 90.4066))
                        .tint(.green)
                    Marker("Destination", coordinate: CLLocationCoordinate2D(latitude: 23.7915, longitude: 90.4089))
                        .tint(KivorlyColors.primary)
                }
                .frame(height: 180)
                .clipShape(RoundedRectangle(cornerRadius: KivorlyRadius.medium))

                // Live Speed / ETA Pill Overlay
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text("Live GPS \u{2022} \(order.etaText)")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(uiColor: .label))
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color(uiColor: .systemBackground).opacity(0.92))
                .clipShape(Capsule())
                .shadow(radius: 4)
                .padding(10)
            }

            // Driver / Courier Partner Info Card
            if let partner = order.driverOrPartner {
                KivorlyCard(padding: KivorlySpacing.md) {
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(KivorlyColors.primary.opacity(0.12))
                                    .frame(width: 50, height: 50)

                                Image(systemName: "person.crop.circle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(KivorlyColors.midnightNavy)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 6) {
                                    Text(partner.name)
                                        .font(KivorlyTypography.titleSmall)
                                        .foregroundColor(Color(uiColor: .label))

                                    HStack(spacing: 2) {
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(.orange)
                                        Text(String(format: "%.1f", partner.rating))
                                            .font(.system(size: 11, weight: .bold))
                                    }
                                }

                                Text(partner.role)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))

                                if let vehicle = partner.vehicleInfo {
                                    Text(vehicle)
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(KivorlyColors.primary)
                                }
                            }

                            Spacer()

                            // Call & Message Buttons
                            HStack(spacing: 8) {
                                Button(action: {
                                    if let url = URL(string: "tel://\(partner.phone)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Circle()
                                        .fill(Color.green.opacity(0.15))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "phone.fill")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(.green)
                                        )
                                }

                                Button(action: {
                                    if let url = URL(string: "sms://\(partner.phone)") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    Circle()
                                        .fill(KivorlyColors.primary.opacity(0.15))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "message.fill")
                                                .font(.system(size: 16, weight: .bold))
                                                .foregroundColor(KivorlyColors.primary)
                                        )
                                }
                            }
                        }

                        // License Plate & Security PIN Badge
                        HStack {
                            if let plate = partner.licensePlate {
                                HStack(spacing: 4) {
                                    Image(systemName: "car.side.fill")
                                        .font(.system(size: 11))
                                    Text(plate)
                                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(8)
                            }

                            Spacer()

                            if let pin = order.securityPin {
                                HStack(spacing: 6) {
                                    Text("Start PIN:")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(Color(uiColor: .secondaryLabel))

                                    Text(pin)
                                        .font(.system(size: 14, weight: .black, design: .monospaced))
                                        .foregroundColor(KivorlyColors.primary)
                                }
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(KivorlyColors.primary.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - 3B. Digital Boarding Pass / Hotel Voucher
    private func digitalPassVoucherCard(order: SuperAppOrder) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(order.service == .tickets ? "OFFICIAL E-TICKET PASS" : "HOTEL CONFIRMATION VOUCHER")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(order.service.accentTint)

                        Text(order.title)
                            .font(KivorlyTypography.titleSmall)
                            .foregroundColor(Color(uiColor: .label))
                    }

                    Spacer()

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 22))
                        .foregroundColor(Color.green)
                }

                Divider()

                if let booking = order.bookingDetails {
                    // Seats & Boarding Points
                    HStack(alignment: .top, spacing: 16) {
                        if let seats = booking.seats {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ASSIGNED SEAT(S)")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                Text(seats.joined(separator: ", "))
                                    .font(.system(size: 16, weight: .black, design: .rounded))
                                    .foregroundColor(order.service.accentTint)
                            }
                        }

                        if let coachClass = booking.coachOrFlightClass {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("CLASS / SERVICE")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                Text(coachClass)
                                    .font(.system(size: 12, weight: .bold))
                                    .lineLimit(1)
                            }
                        }

                        if let room = booking.roomType {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("ROOM TYPE")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                Text(room)
                                    .font(.system(size: 12, weight: .bold))
                                    .lineLimit(1)
                            }
                        }
                    }

                    if let boarding = booking.boardingPoint {
                        HStack(spacing: 8) {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(KivorlyColors.primary)
                            VStack(alignment: .leading, spacing: 1) {
                                Text("Boarding Point")
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                Text(boarding)
                                    .font(.system(size: 12, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .cornerRadius(8)
                    }
                }

                // Barcode / QR Simulation View
                VStack(spacing: 6) {
                    HStack(spacing: 2) {
                        ForEach(0..<36) { i in
                            Rectangle()
                                .fill(i % 3 == 0 || i % 7 == 0 ? Color.black : (i % 2 == 0 ? Color.black.opacity(0.8) : Color.black.opacity(0.3)))
                                .frame(width: i % 4 == 0 ? 3 : 1.5, height: 44)
                        }
                    }
                    .frame(height: 44)

                    if let passCode = order.qrPassCode {
                        Text(passCode)
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                }
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.06), radius: 3)
            }
        }
    }

    // MARK: - 3C. Shopping & Logistics Card
    private func shoppingLogisticsCard(order: SuperAppOrder) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "shippingbox.fill")
                        .foregroundColor(ServiceType.shopping.accentTint)
                    Text("Express Logistics & Delivery")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(Color(uiColor: .label))

                    Spacer()

                    Text("Verified Seller")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.green)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.12))
                        .clipShape(Capsule())
                }

                Divider()

                if let partner = order.driverOrPartner {
                    HStack(spacing: 12) {
                        Image(systemName: "truck.box.fill")
                            .font(.system(size: 24))
                            .foregroundColor(ServiceType.shopping.accentTint)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(partner.name)
                                .font(KivorlyTypography.bodySemibold)
                            Text(partner.role)
                                .font(KivorlyTypography.caption)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }

                        Spacer()

                        Button(action: {
                            if let phone = order.driverOrPartner?.phone, let url = URL(string: "tel://\(phone)") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text("Call Hub")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(ServiceType.shopping.accentTint)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(ServiceType.shopping.accentTint.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }
    }

    // MARK: - 4. Itemized Order Items
    private func orderItemsCard(order: SuperAppOrder) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                        .foregroundColor(KivorlyColors.primary)

                    Text("Order Summary (\(order.items.count) items)")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(Color(uiColor: .label))

                    Spacer()
                }

                Divider()

                VStack(spacing: 10) {
                    ForEach(order.items) { item in
                        HStack(spacing: 12) {
                            // Item Thumbnail or Emoji
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(uiColor: .tertiarySystemFill))
                                    .frame(width: 44, height: 44)

                                if let assetName = item.imageAssetName, !assetName.isEmpty {
                                    Image(assetName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 44, height: 44)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else if let emoji = item.emoji {
                                    Text(emoji)
                                        .font(.system(size: 22))
                                } else {
                                    Image(systemName: order.service.systemIcon)
                                        .font(.system(size: 18))
                                        .foregroundColor(order.service.accentTint)
                                }
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(uiColor: .label))
                                    .lineLimit(1)

                                if let sub = item.subtitle {
                                    Text(sub)
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                        .lineLimit(1)
                                }

                                Text("\(item.quantity)x \u{2022} \u{09F3}\(Int(item.price))")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }

                            Spacer()

                            Text("\u{09F3}\(Int(item.price * Double(item.quantity)))")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))
                        }
                    }
                }
            }
        }
    }

    // MARK: - 5. Address & Route Card
    private func addressAndContactCard(order: SuperAppOrder) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(KivorlyColors.primary)

                    Text("Route & Locations")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(Color(uiColor: .label))

                    Spacer()
                }

                Divider()

                VStack(alignment: .leading, spacing: 14) {
                    if let pickup = order.pickupLocation {
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 10, height: 10)
                                .padding(.top, 4)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("PICKUP / MERCHANT")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                Text(pickup)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(uiColor: .label))
                            }
                        }
                    }

                    if let drop = order.destinationLocation {
                        HStack(alignment: .top, spacing: 10) {
                            Square()
                                .fill(KivorlyColors.primary)
                                .frame(width: 10, height: 10)
                                .padding(.top, 4)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("DELIVERY DESTINATION")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                Text(drop)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(Color(uiColor: .label))
                            }
                        }
                    }

                    HStack(spacing: 6) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 11))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                        Text("Customer Phone: +880 1712-345678 (MD Shoaib Khan)")
                            .font(.system(size: 11))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .padding(.top, 2)
                }
            }
        }
    }

    // MARK: - 6. Bill & Payment Card
    private func billPaymentCard(order: SuperAppOrder) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(KivorlyColors.primary)

                    Text("Payment & Bill Details")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(Color(uiColor: .label))

                    Spacer()

                    // Payment Method Pill
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.green)
                        Text(order.paymentBreakdown.paymentMethod)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(Capsule())
                }

                Divider()

                VStack(spacing: 8) {
                    HStack {
                        Text("Items Subtotal")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                        Spacer()
                        Text("\u{09F3}\(Int(order.paymentBreakdown.subtotal))")
                            .fontWeight(.medium)
                    }

                    if order.paymentBreakdown.deliveryOrFareFee > 0 {
                        HStack {
                            Text("Delivery / Distance Fare")
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Spacer()
                            Text("\u{09F3}\(Int(order.paymentBreakdown.deliveryOrFareFee))")
                                .fontWeight(.medium)
                        }
                    }

                    if order.paymentBreakdown.platformFee > 0 {
                        HStack {
                            Text("Platform & Safety Fee")
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Spacer()
                            Text("\u{09F3}\(Int(order.paymentBreakdown.platformFee))")
                                .fontWeight(.medium)
                        }
                    }

                    if order.paymentBreakdown.discount > 0 {
                        HStack {
                            Text("Promo Voucher Discount")
                                .foregroundColor(.green)
                            Spacer()
                            Text("-\u{09F3}\(Int(order.paymentBreakdown.discount))")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                    }

                    Divider()

                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total Paid")
                                .font(KivorlyTypography.titleSmall)
                                .foregroundColor(Color(uiColor: .label))

                            Text("Transaction: \(order.paymentBreakdown.transactionId)")
                                .font(.system(size: 10, design: .monospaced))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }

                        Spacer()

                        Text(order.amount)
                            .font(KivorlyTypography.priceDisplay)
                            .foregroundColor(order.service.accentTint)
                    }
                }
                .font(.system(size: 13))
            }
        }
    }

    // MARK: - 7. Support & Safety Guarantee
    private func supportAndGuaranteeCard(order: SuperAppOrder) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "shield.lefthalf.filled.badge.checkmark")
                .font(.system(size: 28))
                .foregroundColor(KivorlyColors.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text("Kivorly 100% Protection Guarantee")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(uiColor: .label))

                Text("24/7 dedicated Dhaka priority support, verified partners & instant refunds.")
                    .font(.system(size: 11))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }

            Spacer()
        }
        .padding(14)
        .background(KivorlyColors.primary.opacity(0.08))
        .cornerRadius(KivorlyRadius.medium)
    }

    // MARK: - Bottom Floating Action Dock
    private func bottomActionDock(order: SuperAppOrder) -> some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 12) {
                if order.status == .active || order.status == .inProgress {
                    // Active Actions: Cancel & Help
                    Button(action: {
                        showCancelConfirmation = true
                    }) {
                        Text("Cancel Order")
                            .font(KivorlyTypography.bodySemibold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.red.opacity(0.1))
                            .clipShape(Capsule())
                    }

                    Button(action: {
                        // Re-center on map or trigger live updates
                        withAnimation {
                            mapPosition = .region(
                                MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: 23.7930, longitude: 90.4075),
                                    span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
                                )
                            )
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "location.fill")
                            Text("Track Live")
                        }
                        .font(KivorlyTypography.bodySemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(KivorlyColors.primary)
                        .clipShape(Capsule())
                        .shadow(color: KivorlyColors.primary.opacity(0.3), radius: 6, y: 2)
                    }
                } else if order.status == .completed {
                    // Completed Actions: Reorder & Rate
                    Button(action: {
                        showRatingSheet = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                            Text("Rate")
                        }
                        .font(KivorlyTypography.bodySemibold)
                        .foregroundColor(Color(uiColor: .label))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .clipShape(Capsule())
                    }

                    Button(action: {
                        ordersManager.reorder(order: order)
                        showReorderSuccessAlert = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.clockwise")
                            Text("Reorder (\(order.amount))")
                        }
                        .font(KivorlyTypography.bodySemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(order.service.accentTint)
                        .clipShape(Capsule())
                        .shadow(color: order.service.accentTint.opacity(0.3), radius: 6, y: 2)
                    }
                } else if order.status == .confirmed {
                    // Upcoming Actions
                    Button(action: {
                        showReceiptAlert = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "qrcode")
                            Text("Show Pass")
                        }
                        .font(KivorlyTypography.bodySemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(order.service.accentTint)
                        .clipShape(Capsule())
                    }
                } else {
                    // Cancelled: Reorder
                    Button(action: {
                        ordersManager.reorder(order: order)
                        showReorderSuccessAlert = true
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.clockwise")
                            Text("Try Ordering Again")
                        }
                        .font(KivorlyTypography.bodySemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(KivorlyColors.primary)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(.horizontal, KivorlySpacing.md)
            .padding(.vertical, 10)
            .background(Color(uiColor: .systemBackground))
        }
    }

    // MARK: - Rating Sheet Modal
    private var ratingSheetView: some View {
        NavigationStack {
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.12))
                        .frame(width: 72, height: 72)

                    Image(systemName: "star.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.orange)
                }
                .padding(.top, 24)

                VStack(spacing: 6) {
                    Text("How was your experience?")
                        .font(KivorlyTypography.titleMedium)
                        .foregroundColor(Color(uiColor: .label))

                    if let order = order {
                        Text(order.title)
                            .font(KivorlyTypography.caption)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                }

                // 5-Star Rating Selector
                HStack(spacing: 12) {
                    ForEach(1...5, id: \.self) { star in
                        Button(action: {
                            userRating = star
                        }) {
                            Image(systemName: star <= userRating ? "star.fill" : "star")
                                .font(.system(size: 32))
                                .foregroundColor(star <= userRating ? .orange : Color(uiColor: .tertiaryLabel))
                        }
                    }
                }
                .padding(.vertical, 8)

                // Feedback text field
                TextField("Add feedback for merchant or driver (optional)", text: $ratingComment)
                    .font(KivorlyTypography.bodyMedium)
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(KivorlyRadius.medium)
                    .padding(.horizontal, KivorlySpacing.md)

                Spacer()

                Button(action: {
                    showRatingSheet = false
                }) {
                    Text("Submit Rating")
                        .font(KivorlyTypography.bodySemibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(KivorlyColors.primary)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.bottom, KivorlySpacing.xl)
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Rate Experience")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { showRatingSheet = false }
                }
            }
        }
    }
}
