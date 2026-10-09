//
//  BangladeshParcelDeliveryView.swift
//  Kivorly
//
//  End-to-End Bangladeshi Parcel Delivery & Tracking System
//  Includes Express Intra-City Bike Delivery, Same-Day & Nationwide 64 Districts,
//  Cash on Delivery (COD) Collection, Weight Tiers, Live Rider Tracking, and History.
//

import SwiftUI

public enum ParcelCategory: String, CaseIterable, Identifiable {
    case document = "📄 Documents"
    case smallBox = "📦 Small Box & Clothing"
    case electronics = "📱 Gadget & Fragile"
    case heavy = "🧳 Heavy / Wholesale"

    public var id: String { rawValue }

    public var weightLimit: String {
        switch self {
        case .document: return "Up to 500g"
        case .smallBox: return "Up to 1kg"
        case .electronics: return "Up to 2kg"
        case .heavy: return "Up to 10kg"
        }
    }

    public var baseFare: Double {
        switch self {
        case .document: return 60
        case .smallBox: return 90
        case .electronics: return 140
        case .heavy: return 220
        }
    }
}

public enum ParcelDeliverySpeed: String, CaseIterable, Identifiable {
    case instant = "⚡ Instant Express (Bike)"
    case sameDay = "🚚 Same-Day Delivery"
    case nationwide = "📦 Next-Day Nationwide"

    public var id: String { rawValue }

    public var estimatedTime: String {
        switch self {
        case .instant: return "30 - 60 Mins"
        case .sameDay: return "Within 4 - 6 Hours"
        case .nationwide: return "24 - 48 Hours (All 64 Districts)"
        }
    }

    public var extraFare: Double {
        switch self {
        case .instant: return 60
        case .sameDay: return 30
        case .nationwide: return 40
        }
    }
}

public struct RecentParcelItem: Identifiable {
    public let id: String
    public let trackingNumber: String
    public let recipientName: String
    public let destination: String
    public let date: String
    public let category: String
    public let fare: String
    public let codAmount: String
    public let status: String
    public let statusColor: Color
}

public struct BangladeshParcelDeliveryView: View {
    @Environment(\.dismiss) private var dismiss

    // Active View Mode: 0 = Send Parcel, 1 = Live Tracking & History
    @State private var activeTab: Int = 0

    // Sender Details (MD Shoaib Khan)
    @State private var senderName: String = "MD Shoaib Khan"
    @State private var senderPhone: String = "+880 1712-345678"
    @State private var senderArea: String = "Gulshan 2, Dhaka"
    @State private var senderAddress: String = "Road 71, House 14, Flat 4B"

    // Receiver Details
    @State private var receiverName: String = "Tanvir Hasan"
    @State private var receiverPhone: String = "01819876543"
    @State private var isInsideDhaka: Bool = true
    @State private var receiverDistrict: String = "Dhanmondi, Dhaka"
    @State private var receiverAddress: String = "Road 27, House 52, 3rd Floor"

    // Package Details
    @State private var selectedCategory: ParcelCategory = .smallBox
    @State private var selectedSpeed: ParcelDeliverySpeed = .instant
    @State private var packageDescription: String = "Clothes & Personal Accessories"

    // Cash on Delivery (COD)
    @State private var isCodEnabled: Bool = false
    @State private var codAmount: String = "1500"

    // Payment Selection
    @State private var selectedPaymentMethod: String = "bKash"

    // Confirmed Tracking State
    @State private var showTrackingSheet: Bool = false
    @State private var activeTrackingNumber: String = "KVP-892401-BD"
    @State private var isBookingSuccessAlert: Bool = false

    private let dhakaPickupHubs = [
        "Gulshan 2, Dhaka", "Banani, Dhaka", "Dhanmondi, Dhaka", "Uttara Sector 4, Dhaka",
        "Mohakhali DOHS, Dhaka", "Bashundhara R/A, Dhaka", "Mirpur 10, Dhaka", "Old Dhaka (Nazimuddin Rd)"
    ]

    private let nationwideDistricts = [
        "Dhanmondi, Dhaka", "Uttara, Dhaka", "Mirpur, Dhaka", "Motijheel, Dhaka",
        "GEC Circle, Chittagong", "Agrabad, Chittagong", "Zindabazar, Sylhet",
        "Shaheb Bazar, Rajshahi", "Shib Bari, Khulna", "Kolatoli, Cox's Bazar",
        "Satmatha, Bogura", "Sadar Road, Barishal", "Kamarpara, Rangpur"
    ]

    private let sampleHistory: [RecentParcelItem] = [
        RecentParcelItem(
            id: "p1",
            trackingNumber: "KVP-892401-BD",
            recipientName: "Tanvir Hasan",
            destination: "Dhanmondi Road 27, Dhaka",
            date: "Today, 07:45 AM",
            category: "📦 Small Box & Clothing",
            fare: "৳150",
            codAmount: "৳1,500 (COD)",
            status: "Rider on the Way",
            statusColor: .orange
        ),
        RecentParcelItem(
            id: "p2",
            trackingNumber: "KVP-774912-BD",
            recipientName: "Sabbir Rahman",
            destination: "GEC Circle, Chittagong",
            date: "08 Oct 2026",
            category: "📱 Electronics & Gadget",
            fare: "৳180",
            codAmount: "৳4,200 (COD)",
            status: "Delivered",
            statusColor: .green
        ),
        RecentParcelItem(
            id: "p3",
            trackingNumber: "KVP-663810-BD",
            recipientName: "Farhana Yasmin",
            destination: "Zindabazar, Sylhet",
            date: "06 Oct 2026",
            category: "📄 Legal Documents",
            fare: "৳100",
            codAmount: "No COD",
            status: "Delivered",
            statusColor: .green
        )
    ]

    private var calculatedFare: Double {
        var total = selectedCategory.baseFare + selectedSpeed.extraFare
        if !isInsideDhaka {
            total += 40
        }
        if isCodEnabled {
            let amount = Double(codAmount) ?? 0
            total += max(15, amount * 0.01) // 1% COD fee
        }
        return total
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Standard Top Navigation Bar
            topControlBar

            // Tab Segment Control: Send Parcel vs Tracking & History
            tabSelectorBar

            // Main Content Area
            ScrollView {
                if activeTab == 0 {
                    sendParcelContent
                        .padding(.horizontal, KivorlySpacing.md)
                        .padding(.vertical, KivorlySpacing.md)
                } else {
                    trackingAndHistoryContent
                        .padding(.horizontal, KivorlySpacing.md)
                        .padding(.vertical, KivorlySpacing.md)
                }
            }
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $showTrackingSheet) {
            liveParcelTrackingModal
        }
    }

    // MARK: - Top Navigation Bar
    private var topControlBar: some View {
        HStack {
            // Left: Back button
            Button(action: { dismiss() }) {
                Circle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)
            }

            Spacer()

            // Center: Service Logo & Name
            HStack(spacing: 8) {
                Image(ServiceType.courier.assetImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)

                Text(ServiceType.courier.title)
                    .font(KivorlyTypography.titleSmall)
                    .foregroundColor(Color(uiColor: .label))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(uiColor: .systemBackground))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)

            Spacer()

            // Right: Live Tracking Quick Button
            Button(action: {
                showTrackingSheet = true
            }) {
                Circle()
                    .fill(Color(uiColor: .systemBackground))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: "shippingbox.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ServiceType.courier.accentTint)
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)
            }
        }
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.top, 10)
        .padding(.bottom, 6)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }

    // MARK: - Tab Selector Bar
    private var tabSelectorBar: some View {
        HStack(spacing: 12) {
            tabButton(title: "Send Parcel", icon: "paperplane.fill", index: 0)
            tabButton(title: "Tracking & History", icon: "clock.arrow.circlepath", index: 1)
        }
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.vertical, 8)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }

    private func tabButton(title: String, icon: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                activeTab = index
            }
        }) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .bold))
                Text(title)
                    .font(.system(size: 13, weight: .bold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 9)
            .background(
                activeTab == index ?
                ServiceType.courier.accentTint :
                Color(uiColor: .tertiarySystemFill)
            )
            .foregroundColor(
                activeTab == index ? .white : Color(uiColor: .secondaryLabel)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Send Parcel Form
    private var sendParcelContent: some View {
        VStack(spacing: 16) {
            // 1. Sender (Pickup) Card
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(ServiceType.courier.accentTint)
                        .frame(width: 8, height: 8)
                    Text("Pickup Details (Sender)")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }

                HStack(spacing: 12) {
                    Image("profile_user")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 44, height: 44)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(ServiceType.courier.accentTint.opacity(0.3), lineWidth: 1.5))

                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 4) {
                            Text(senderName)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))

                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.blue)
                        }

                        Text(senderPhone)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 6) {
                    Text("Pickup Area in Dhaka")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(uiColor: .secondaryLabel))

                    Menu {
                        ForEach(dhakaPickupHubs, id: \.self) { hub in
                            Button(hub) { senderArea = hub }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(ServiceType.courier.accentTint)
                            Text(senderArea)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Color(uiColor: .label))
                            Spacer()
                            Image(systemName: "chevron.down")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(uiColor: .tertiaryLabel))
                        }
                        .padding(10)
                        .background(Color(uiColor: .tertiarySystemFill).opacity(0.6))
                        .cornerRadius(10)
                    }

                    TextField("House, Road, Apartment / Floor details", text: $senderAddress)
                        .font(KivorlyTypography.caption)
                        .padding(10)
                        .background(Color(uiColor: .tertiarySystemFill).opacity(0.4))
                        .cornerRadius(10)
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)

            // 2. Receiver (Drop-off) Card
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.red)
                    Text("Delivery Details (Recipient)")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }

                HStack(spacing: 10) {
                    TextField("Recipient Full Name", text: $receiverName)
                        .font(KivorlyTypography.bodyMedium)
                        .padding(10)
                        .background(Color(uiColor: .tertiarySystemFill).opacity(0.5))
                        .cornerRadius(10)

                    TextField("Phone Number", text: $receiverPhone)
                        .font(KivorlyTypography.bodyMedium)
                        .padding(10)
                        .background(Color(uiColor: .tertiarySystemFill).opacity(0.5))
                        .cornerRadius(10)
                }

                // Inside Dhaka vs Nationwide
                HStack(spacing: 8) {
                    destinationPill(title: "Inside Dhaka City", isSelected: isInsideDhaka) {
                        isInsideDhaka = true
                        receiverDistrict = "Dhanmondi, Dhaka"
                    }
                    destinationPill(title: "Outside Dhaka (64 Districts)", isSelected: !isInsideDhaka) {
                        isInsideDhaka = false
                        receiverDistrict = "GEC Circle, Chittagong"
                    }
                }

                // Destination Area Picker
                Menu {
                    ForEach(nationwideDistricts, id: \.self) { dist in
                        Button(dist) { receiverDistrict = dist }
                    }
                } label: {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.red)
                        Text(receiverDistrict)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color(uiColor: .label))
                        Spacer()
                        Image(systemName: "chevron.down")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(uiColor: .tertiaryLabel))
                    }
                    .padding(10)
                    .background(Color(uiColor: .tertiarySystemFill).opacity(0.6))
                    .cornerRadius(10)
                }

                TextField("Detailed delivery address / Landmark", text: $receiverAddress)
                    .font(KivorlyTypography.caption)
                    .padding(10)
                    .background(Color(uiColor: .tertiarySystemFill).opacity(0.4))
                    .cornerRadius(10)
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)

            // 3. Package Category & Weight Card
            VStack(alignment: .leading, spacing: 10) {
                Text("Package Category & Weight")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(Color(uiColor: .secondaryLabel))

                VStack(spacing: 8) {
                    ForEach(ParcelCategory.allCases) { cat in
                        Button(action: {
                            selectedCategory = cat
                        }) {
                            HStack {
                                Text(cat.rawValue)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(uiColor: .label))

                                Spacer()

                                Text(cat.weightLimit)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))

                                Text("৳\(Int(cat.baseFare))")
                                    .font(.system(size: 13, weight: .black))
                                    .foregroundColor(ServiceType.courier.accentTint)

                                Image(systemName: selectedCategory == cat ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedCategory == cat ? ServiceType.courier.accentTint : Color(uiColor: .tertiaryLabel))
                            }
                            .padding(10)
                            .background(
                                selectedCategory == cat ?
                                ServiceType.courier.accentTint.opacity(0.1) :
                                Color(uiColor: .tertiarySystemFill).opacity(0.4)
                            )
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(
                                        selectedCategory == cat ? ServiceType.courier.accentTint : Color.clear,
                                        lineWidth: 1.5
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)

            // 4. Delivery Speed Selection Card
            VStack(alignment: .leading, spacing: 10) {
                Text("Delivery Speed Mode")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(Color(uiColor: .secondaryLabel))

                VStack(spacing: 8) {
                    ForEach(ParcelDeliverySpeed.allCases) { speed in
                        Button(action: {
                            selectedSpeed = speed
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(speed.rawValue)
                                        .font(.system(size: 13, weight: .bold))
                                        .foregroundColor(Color(uiColor: .label))
                                    Text(speed.estimatedTime)
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                }

                                Spacer()

                                Text("+৳\(Int(speed.extraFare))")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(ServiceType.courier.accentTint)

                                Image(systemName: selectedSpeed == speed ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedSpeed == speed ? ServiceType.courier.accentTint : Color(uiColor: .tertiaryLabel))
                            }
                            .padding(10)
                            .background(
                                selectedSpeed == speed ?
                                ServiceType.courier.accentTint.opacity(0.1) :
                                Color(uiColor: .tertiarySystemFill).opacity(0.4)
                            )
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(
                                        selectedSpeed == speed ? ServiceType.courier.accentTint : Color.clear,
                                        lineWidth: 1.5
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)

            // 5. Cash on Delivery (COD) Collection Card
            VStack(alignment: .leading, spacing: 10) {
                Toggle(isOn: $isCodEnabled) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Collect Cash on Delivery (COD)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                        Text("Rider will collect payment from recipient & transfer to your account")
                            .font(.system(size: 11))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                }
                .tint(ServiceType.courier.accentTint)

                if isCodEnabled {
                    HStack {
                        Text("Collection Amount (৳):")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        Spacer()

                        HStack(spacing: 4) {
                            Text("৳")
                                .font(.system(size: 16, weight: .black))
                                .foregroundColor(ServiceType.courier.accentTint)
                            TextField("1500", text: $codAmount)
                                .font(.system(size: 16, weight: .bold))
                                .frame(width: 80)
                                .keyboardType(.numberPad)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .cornerRadius(8)
                    }
                    .padding(.top, 4)
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)

            // 6. Fare Breakdown & Confirm Booking
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Total Delivery Fee")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        Text("৳\(Int(calculatedFare))")
                            .font(.system(size: 24, weight: .black))
                            .foregroundColor(ServiceType.courier.accentTint)
                    }

                    Spacer()

                    // Payment Method Pill
                    Menu {
                        Button("bKash") { selectedPaymentMethod = "bKash" }
                        Button("Nagad") { selectedPaymentMethod = "Nagad" }
                        Button("Cash on Pickup") { selectedPaymentMethod = "Cash on Pickup" }
                        Button("Kivorly Wallet") { selectedPaymentMethod = "Kivorly Wallet" }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "creditcard.fill")
                                .font(.system(size: 12))
                            Text(selectedPaymentMethod)
                                .font(.system(size: 12, weight: .bold))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color(uiColor: .tertiarySystemFill))
                        .clipShape(Capsule())
                        .foregroundColor(Color(uiColor: .label))
                    }
                }

                Button(action: {
                    let tracking = "KVP-\(Int.random(in: 100000...999999))-BD"
                    activeTrackingNumber = tracking

                    let parcelOrder = SuperAppOrder(
                        id: tracking,
                        service: .courier,
                        title: "Express Parcel • \(receiverDistrict)",
                        subtitle: "\(selectedCategory.rawValue) • \(selectedSpeed.rawValue)",
                        timestamp: "Just now",
                        amount: String(format: "\u{09F3}%.0f", calculatedFare),
                        rawAmount: calculatedFare,
                        status: .inProgress,
                        etaText: selectedSpeed.estimatedTime,
                        pickupLocation: "\(senderArea), Dhaka",
                        destinationLocation: "\(receiverDistrict), Bangladesh",
                        driverOrPartner: OrderPartner(
                            name: "Tanvir Ahmed",
                            role: "Express Courier Rider",
                            rating: 4.9,
                            completedTrips: 2150,
                            phone: "+880 1677-554433",
                            vehicleInfo: "Yamaha Saluto 125cc"
                        ),
                        securityPin: String(format: "%04d", Int.random(in: 1000...9999)),
                        trackingNumber: tracking,
                        qrPassCode: nil,
                        bookingDetails: nil,
                        items: [
                            OrderLineItem(
                                title: "\(selectedCategory.rawValue) (\(selectedCategory.weightLimit))",
                                subtitle: "\(senderArea) to \(receiverDistrict)",
                                quantity: 1,
                                price: calculatedFare,
                                emoji: "📦"
                            )
                        ],
                        timelineSteps: [
                            OrderTimelineStep(title: "Pickup Requested", subtitle: "Courier assigned", time: "Just now", isCompleted: true),
                            OrderTimelineStep(title: "Rider Heading to Sender", subtitle: "Arriving in \(senderArea)", time: "Just now", isCompleted: true, isCurrent: true),
                            OrderTimelineStep(title: "Parcel Picked Up", subtitle: "Sealed & scanned", time: "Pending", isCompleted: false),
                            OrderTimelineStep(title: "In Transit", subtitle: "En route to destination", time: "Estimated \(selectedSpeed.estimatedTime)", isCompleted: false),
                            OrderTimelineStep(title: "Delivered", subtitle: "OTP verified handover", time: "Estimated \(selectedSpeed.estimatedTime)", isCompleted: false)
                        ],
                        paymentBreakdown: OrderPaymentBreakdown(
                            subtotal: calculatedFare,
                            deliveryOrFareFee: 0,
                            platformFee: 0,
                            discount: 0,
                            total: calculatedFare,
                            paymentMethod: selectedPaymentMethod,
                            transactionId: "TXN-\(Int.random(in: 10000000...99999999))"
                        )
                    )
                    OrdersManager.shared.addOrder(parcelOrder)

                    showTrackingSheet = true
                }) {
                    HStack(spacing: 8) {
                        Text("Request Parcel Pickup")
                            .font(KivorlyTypography.titleSmall)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(ServiceType.courier.accentTint)
                    .clipShape(Capsule())
                    .shadow(color: ServiceType.courier.accentTint.opacity(0.3), radius: 8, y: 3)
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)
        }
    }

    private func destinationPill(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: isSelected ? .bold : .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                    ServiceType.courier.accentTint.opacity(0.12) :
                    Color(uiColor: .tertiarySystemFill).opacity(0.5)
                )
                .foregroundColor(isSelected ? ServiceType.courier.accentTint : Color(uiColor: .secondaryLabel))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isSelected ? ServiceType.courier.accentTint : Color.clear, lineWidth: 1.2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Tracking & History View
    private var trackingAndHistoryContent: some View {
        VStack(spacing: 16) {
            // Active In-Transit Banner
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Active Parcel In-Transit")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(ServiceType.courier.accentTint)

                        Text("KVP-892401-BD")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                    }

                    Spacer()

                    Text("Rider Assigned")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.15))
                        .clipShape(Capsule())
                }

                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(ServiceType.courier.accentTint.opacity(0.12))
                            .frame(width: 44, height: 44)
                        Image(systemName: "bicycle")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(ServiceType.courier.accentTint)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Kamrul Islam (Rider)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))

                        Text("Yamaha FZ-S • Dhaka Metro Ha-5421")
                            .font(.system(size: 11))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }

                    Spacer()

                    Button(action: { showTrackingSheet = true }) {
                        Text("Live Map")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(ServiceType.courier.accentTint)
                            .clipShape(Capsule())
                    }
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)

            // Past Parcels List
            VStack(alignment: .leading, spacing: 10) {
                Text("Recent Parcel Deliveries")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(Color(uiColor: .secondaryLabel))

                ForEach(sampleHistory) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(item.trackingNumber)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))

                            Spacer()

                            Text(item.status)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(item.statusColor)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(item.statusColor.opacity(0.12))
                                .clipShape(Capsule())
                        }

                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("To: \(item.recipientName)")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .label))

                                Text(item.destination)
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                    .lineLimit(1)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text(item.fare)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(uiColor: .label))

                                Text(item.codAmount)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(ServiceType.courier.accentTint)
                            }
                        }
                    }
                    .padding(12)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(12)
                }
            }
        }
    }

    // MARK: - Live Parcel Tracking Sheet
    private var liveParcelTrackingModal: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Tracking Number Banner
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Tracking Number")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        Text(activeTrackingNumber)
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(ServiceType.courier.accentTint)
                    }

                    Spacer()

                    Image(systemName: "barcode.viewfinder")
                        .font(.system(size: 32))
                        .foregroundColor(Color(uiColor: .label))
                }
                .padding(14)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(16)

                // Rider Information Card
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(ServiceType.courier.accentTint.opacity(0.15))
                            .frame(width: 52, height: 52)
                        Image(systemName: "person.fill")
                            .font(.system(size: 22))
                            .foregroundColor(ServiceType.courier.accentTint)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 4) {
                            Text("Kamrul Islam")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))

                            Image(systemName: "star.fill")
                                .font(.system(size: 11))
                                .foregroundColor(.orange)
                            Text("4.9")
                                .font(.system(size: 12, weight: .bold))
                        }

                        Text("Yamaha FZ-S • Dhaka Metro Ha-5421")
                            .font(.system(size: 11))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }

                    Spacer()

                    HStack(spacing: 8) {
                        Button(action: {}) {
                            Circle()
                                .fill(Color.green.opacity(0.15))
                                .frame(width: 38, height: 38)
                                .overlay(
                                    Image(systemName: "phone.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.green)
                                )
                        }

                        Button(action: {}) {
                            Circle()
                                .fill(ServiceType.courier.accentTint.opacity(0.15))
                                .frame(width: 38, height: 38)
                                .overlay(
                                    Image(systemName: "message.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(ServiceType.courier.accentTint)
                                )
                        }
                    }
                }
                .padding(14)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(16)

                // Live Timeline Stepper
                VStack(alignment: .leading, spacing: 14) {
                    Text("Live Shipment Status")
                        .font(.system(size: 11, weight: .black))
                        .foregroundColor(Color(uiColor: .secondaryLabel))

                    timelineStep(title: "Order Placed & Confirmed", time: "07:45 AM", isCompleted: true, isCurrent: false)
                    timelineStep(title: "Rider Assigned (Kamrul Islam)", time: "07:48 AM", isCompleted: true, isCurrent: true)
                    timelineStep(title: "Package Picked Up from Gulshan 2", time: "Estimated 08:05 AM", isCompleted: false, isCurrent: false)
                    timelineStep(title: "In Transit via Mohakhali Express Hub", time: "Estimated 08:25 AM", isCompleted: false, isCurrent: false)
                    timelineStep(title: "Out for Delivery to Dhanmondi", time: "Estimated 08:45 AM", isCompleted: false, isCurrent: false)
                    timelineStep(title: "Delivered & Signed", time: "Estimated 09:00 AM", isCompleted: false, isCurrent: false)
                }
                .padding(16)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(18)

                Spacer()

                Button(action: { showTrackingSheet = false }) {
                    Text("Close Live Tracking")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(KivorlyColors.primary)
                        .clipShape(Capsule())
                }
            }
            .padding(KivorlySpacing.md)
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Parcel Tracking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { showTrackingSheet = false }
                }
            }
        }
    }

    private func timelineStep(title: String, time: String, isCompleted: Bool, isCurrent: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 0) {
                Circle()
                    .fill(isCompleted ? ServiceType.courier.accentTint : (isCurrent ? Color.orange : Color(uiColor: .systemGray4)))
                    .frame(width: 14, height: 14)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: isCurrent ? .bold : (isCompleted ? .semibold : .medium)))
                    .foregroundColor(isCurrent ? Color(uiColor: .label) : (isCompleted ? Color(uiColor: .label) : Color(uiColor: .secondaryLabel)))

                Text(time)
                    .font(.system(size: 10))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }

            Spacer()
        }
    }
}
