//
//  OrdersManager.swift
//  Kivorly
//
//  Centralized orders store and state manager powering the end-to-end All Orders
//  and All-in-One Order tracking experiences across all Kivorly services.
//

import SwiftUI
import Combine

// MARK: - Order Line Item
public struct OrderLineItem: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let quantity: Int
    public let price: Double
    public let imageAssetName: String?
    public let emoji: String?

    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        quantity: Int = 1,
        price: Double,
        imageAssetName: String? = nil,
        emoji: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.quantity = quantity
        self.price = price
        self.imageAssetName = imageAssetName
        self.emoji = emoji
    }
}

// MARK: - Order Timeline Step
public struct OrderTimelineStep: Identifiable, Hashable {
    public let id: String
    public let title: String
    public let subtitle: String
    public let time: String
    public var isCompleted: Bool
    public var isCurrent: Bool

    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String,
        time: String,
        isCompleted: Bool,
        isCurrent: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.time = time
        self.isCompleted = isCompleted
        self.isCurrent = isCurrent
    }
}

// MARK: - Order Partner / Driver / Technician
public struct OrderPartner: Identifiable, Hashable {
    public let id: String
    public let name: String
    public let role: String
    public let rating: Double
    public let completedTrips: Int
    public let phone: String
    public let vehicleInfo: String?
    public let licensePlate: String?
    public let photoAssetName: String?

    public init(
        id: String = UUID().uuidString,
        name: String,
        role: String,
        rating: Double,
        completedTrips: Int,
        phone: String,
        vehicleInfo: String? = nil,
        licensePlate: String? = nil,
        photoAssetName: String? = nil
    ) {
        self.id = id
        self.name = name
        self.role = role
        self.rating = rating
        self.completedTrips = completedTrips
        self.phone = phone
        self.vehicleInfo = vehicleInfo
        self.licensePlate = licensePlate
        self.photoAssetName = photoAssetName
    }
}

// MARK: - Booking Specific Details (Tickets, Hotels)
public struct OrderBookingDetails: Hashable {
    public let seats: [String]?
    public let coachOrFlightClass: String?
    public let boardingPoint: String?
    public let droppingPoint: String?
    public let roomType: String?
    public let checkInDate: String?
    public let checkOutDate: String?
    public let guestCount: Int?

    public init(
        seats: [String]? = nil,
        coachOrFlightClass: String? = nil,
        boardingPoint: String? = nil,
        droppingPoint: String? = nil,
        roomType: String? = nil,
        checkInDate: String? = nil,
        checkOutDate: String? = nil,
        guestCount: Int? = nil
    ) {
        self.seats = seats
        self.coachOrFlightClass = coachOrFlightClass
        self.boardingPoint = boardingPoint
        self.droppingPoint = droppingPoint
        self.roomType = roomType
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.guestCount = guestCount
    }
}

// MARK: - Payment Breakdown
public struct OrderPaymentBreakdown: Hashable {
    public let subtotal: Double
    public let deliveryOrFareFee: Double
    public let platformFee: Double
    public let discount: Double
    public let total: Double
    public let paymentMethod: String
    public let transactionId: String

    public init(
        subtotal: Double,
        deliveryOrFareFee: Double = 0,
        platformFee: Double = 30,
        discount: Double = 0,
        total: Double,
        paymentMethod: String = "bKash",
        transactionId: String = "TXN-\(Int.random(in: 10000000...99999999))"
    ) {
        self.subtotal = subtotal
        self.deliveryOrFareFee = deliveryOrFareFee
        self.platformFee = platformFee
        self.discount = discount
        self.total = total
        self.paymentMethod = paymentMethod
        self.transactionId = transactionId
    }
}

// MARK: - Comprehensive SuperAppOrder Model
public struct SuperAppOrder: Identifiable, Hashable {
    public let id: String
    public let service: ServiceType
    public let title: String
    public let subtitle: String
    public let timestamp: String
    public let amount: String
    public let rawAmount: Double
    public var status: KivorlyStatus
    public var etaText: String
    public let pickupLocation: String?
    public let destinationLocation: String?
    public let driverOrPartner: OrderPartner?
    public let securityPin: String?
    public let trackingNumber: String?
    public let qrPassCode: String?
    public let bookingDetails: OrderBookingDetails?
    public let items: [OrderLineItem]
    public var timelineSteps: [OrderTimelineStep]
    public let paymentBreakdown: OrderPaymentBreakdown

    public init(
        id: String,
        service: ServiceType,
        title: String,
        subtitle: String,
        timestamp: String,
        amount: String,
        rawAmount: Double,
        status: KivorlyStatus,
        etaText: String,
        pickupLocation: String? = nil,
        destinationLocation: String? = nil,
        driverOrPartner: OrderPartner? = nil,
        securityPin: String? = nil,
        trackingNumber: String? = nil,
        qrPassCode: String? = nil,
        bookingDetails: OrderBookingDetails? = nil,
        items: [OrderLineItem],
        timelineSteps: [OrderTimelineStep],
        paymentBreakdown: OrderPaymentBreakdown
    ) {
        self.id = id
        self.service = service
        self.title = title
        self.subtitle = subtitle
        self.timestamp = timestamp
        self.amount = amount
        self.rawAmount = rawAmount
        self.status = status
        self.etaText = etaText
        self.pickupLocation = pickupLocation
        self.destinationLocation = destinationLocation
        self.driverOrPartner = driverOrPartner
        self.securityPin = securityPin
        self.trackingNumber = trackingNumber
        self.qrPassCode = qrPassCode
        self.bookingDetails = bookingDetails
        self.items = items
        self.timelineSteps = timelineSteps
        self.paymentBreakdown = paymentBreakdown
    }

    public static func == (lhs: SuperAppOrder, rhs: SuperAppOrder) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Central Orders Manager Store
public final class OrdersManager: ObservableObject {
    public static let shared = OrdersManager()

    @Published public var orders: [SuperAppOrder] = []

    public init() {
        self.orders = Self.seedOrders()
    }

    // MARK: - Filter Helpers
    public var activeOrders: [SuperAppOrder] {
        orders.filter { $0.status == .active || $0.status == .inProgress }
    }

    public var upcomingOrders: [SuperAppOrder] {
        orders.filter { $0.status == .confirmed }
    }

    public var completedOrders: [SuperAppOrder] {
        orders.filter { $0.status == .completed }
    }

    public var cancelledOrders: [SuperAppOrder] {
        orders.filter { $0.status == .cancelled || $0.status == .refunded }
    }

    public var totalSpentThisMonth: Double {
        orders.filter { $0.status == .completed || $0.status == .confirmed || $0.status == .active || $0.status == .inProgress }
            .reduce(0) { $0 + $1.rawAmount }
    }

    // MARK: - Mutations
    public func addOrder(_ order: SuperAppOrder) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            orders.insert(order, at: 0)
        }
    }

    public func cancelOrder(id: String) {
        if let idx = orders.firstIndex(where: { $0.id == id }) {
            withAnimation(.spring()) {
                orders[idx].status = .cancelled
                orders[idx].etaText = "Cancelled"
            }
        }
    }

    public func reorder(order: SuperAppOrder) {
        let newId = "\(order.service.shortTitle.uppercased())-\(Int.random(in: 100000...999999))-BD"
        let reordered = SuperAppOrder(
            id: newId,
            service: order.service,
            title: order.title,
            subtitle: "\(order.items.count) item(s) \u{2022} Reordered",
            timestamp: "Just now",
            amount: order.amount,
            rawAmount: order.rawAmount,
            status: .inProgress,
            etaText: "Arriving in ~25 mins",
            pickupLocation: order.pickupLocation,
            destinationLocation: order.destinationLocation,
            driverOrPartner: order.driverOrPartner,
            securityPin: String(format: "%04d", Int.random(in: 1000...9999)),
            trackingNumber: "TRK-\(Int.random(in: 100000...999999))-BD",
            qrPassCode: order.qrPassCode,
            bookingDetails: order.bookingDetails,
            items: order.items,
            timelineSteps: [
                OrderTimelineStep(title: "Order Replaced", subtitle: "Sent to merchant", time: "Just now", isCompleted: true),
                OrderTimelineStep(title: "Confirmed by Merchant", subtitle: "Processing requested items", time: "Just now", isCompleted: true, isCurrent: true),
                OrderTimelineStep(title: "Preparing Order", subtitle: "Kitchen / Warehouse packing", time: "Pending", isCompleted: false),
                OrderTimelineStep(title: "Rider En Route", subtitle: "Pickup and transit", time: "Estimated 15m", isCompleted: false),
                OrderTimelineStep(title: "Delivered", subtitle: "Handed over at doorstep", time: "Estimated 25m", isCompleted: false)
            ],
            paymentBreakdown: order.paymentBreakdown
        )
        addOrder(reordered)
    }

    // MARK: - Initial Seed Orders
    private static func seedOrders() -> [SuperAppOrder] {
        return [
            // 1. Ride Sharing (Active / In Progress)
            SuperAppOrder(
                id: "KV-RIDE-902",
                service: .rideSharing,
                title: "Toyota Axio \u{2022} Kamal Hossain",
                subtitle: "Gulshan 2 \u{2192} Banani 11",
                timestamp: "Today, 10:30 AM",
                amount: "\u{09F3}450",
                rawAmount: 450,
                status: .inProgress,
                etaText: "3 mins away",
                pickupLocation: "House 14, Road 71, Gulshan 2, Dhaka",
                destinationLocation: "Road 11, Block D, Banani, Dhaka",
                driverOrPartner: OrderPartner(
                    name: "Kamal Hossain",
                    role: "Premier Driver",
                    rating: 4.9,
                    completedTrips: 1840,
                    phone: "+880 1712-345678",
                    vehicleInfo: "White Toyota Axio Sedan (AC)",
                    licensePlate: "Dhaka Metro Ga 14-8921",
                    photoAssetName: "profile_user"
                ),
                securityPin: "4892",
                trackingNumber: "RIDE-DHAKA-902",
                qrPassCode: nil,
                bookingDetails: nil,
                items: [
                    OrderLineItem(title: "Kivorly Sedan Premier", subtitle: "4 Passengers \u{2022} AC Comfort", quantity: 1, price: 420, emoji: "\u{1F697}"),
                    OrderLineItem(title: "Airport Toll / Expressway", subtitle: "Included in upfront fare", quantity: 1, price: 30, emoji: "\u{1F6E3}\u{FE0F}")
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Ride Requested", subtitle: "Matched with nearest driver", time: "10:28 AM", isCompleted: true),
                    OrderTimelineStep(title: "Driver Accepted", subtitle: "Kamal Hossain is approaching", time: "10:29 AM", isCompleted: true),
                    OrderTimelineStep(title: "Driver Arriving", subtitle: "3 mins away \u{2022} White Axio", time: "10:30 AM", isCompleted: true, isCurrent: true),
                    OrderTimelineStep(title: "Trip in Progress", subtitle: "Heading to Banani 11", time: "Estimated 10:35 AM", isCompleted: false),
                    OrderTimelineStep(title: "Destination Reached", subtitle: "Drop-off and receipt", time: "Estimated 10:50 AM", isCompleted: false)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: 420,
                    deliveryOrFareFee: 30,
                    platformFee: 0,
                    discount: 0,
                    total: 450,
                    paymentMethod: "bKash (01712-***871)",
                    transactionId: "TXN-BK-9201948"
                )
            ),

            // 2. Food Delivery (Active / Preparing)
            SuperAppOrder(
                id: "KV-FOOD-892",
                service: .foodDelivery,
                title: "Burger & Co. (Bashundhara)",
                subtitle: "2 items \u{2022} Beef Bacon & Garlic Fries",
                timestamp: "Today, 09:45 AM",
                amount: "\u{09F3}900",
                rawAmount: 900,
                status: .active,
                etaText: "Arriving in ~14 mins",
                pickupLocation: "Burger & Co., Block C, Bashundhara R/A",
                destinationLocation: "Road 14, House 22, Bashundhara, Dhaka",
                driverOrPartner: OrderPartner(
                    name: "Rahim Mia",
                    role: "Kivorly Express Rider",
                    rating: 4.8,
                    completedTrips: 920,
                    phone: "+880 1819-223344",
                    vehicleInfo: "Honda Livo 110cc",
                    licensePlate: "Dhaka Metro Ha 22-1049"
                ),
                securityPin: "7124",
                trackingNumber: "FOOD-BASH-892",
                qrPassCode: nil,
                bookingDetails: nil,
                items: [
                    OrderLineItem(title: "Smoky BBQ Bacon Burger", subtitle: "Double Patty, Extra Cheese", quantity: 1, price: 580, emoji: "\u{1F354}"),
                    OrderLineItem(title: "Parmesan Garlic Fries", subtitle: "Large \u{2022} Dip Sauce Included", quantity: 1, price: 240, emoji: "\u{1F35F}"),
                    OrderLineItem(title: "Mint Lemonade Mojito", subtitle: "Chilled 330ml", quantity: 1, price: 80, emoji: "\u{1F964}")
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Order Placed", subtitle: "Payment confirmed via bKash", time: "09:45 AM", isCompleted: true),
                    OrderTimelineStep(title: "Restaurant Accepted", subtitle: "Kitchen preparing your food", time: "09:46 AM", isCompleted: true),
                    OrderTimelineStep(title: "Food Being Prepared", subtitle: "Freshly grilling burgers", time: "09:50 AM", isCompleted: true, isCurrent: true),
                    OrderTimelineStep(title: "Rider Picked Up", subtitle: "Rahim Mia heading to you", time: "Estimated 10:05 AM", isCompleted: false),
                    OrderTimelineStep(title: "Delivered", subtitle: "Handed over at doorstep", time: "Estimated 10:15 AM", isCompleted: false)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: 900,
                    deliveryOrFareFee: 40,
                    platformFee: 20,
                    discount: 60,
                    total: 900,
                    paymentMethod: "bKash (01712-***871)",
                    transactionId: "TXN-BK-4482012"
                )
            ),

            // 3. Online Shopping (Active / Dispatched)
            SuperAppOrder(
                id: "KVS-849201-BD",
                service: .shopping,
                title: "Aarong & Yellow Collection",
                subtitle: "Premium Silk Panjabi & Slim Denim",
                timestamp: "Today, 08:15 AM",
                amount: "\u{09F3}5,350",
                rawAmount: 5350,
                status: .active,
                etaText: "Delivery by 4:00 PM",
                pickupLocation: "Aarong Flagship Hub, Tejgaon Industrial Area",
                destinationLocation: "Road 71, House 14, Flat 4B, Gulshan 2, Dhaka",
                driverOrPartner: OrderPartner(
                    name: "Steadfast Express Delivery",
                    role: "Official Courier Hub",
                    rating: 4.9,
                    completedTrips: 15400,
                    phone: "+880 9612-004488",
                    vehicleInfo: "Delivery Van \u{2022} Dhaka Metro Da 12-4011"
                ),
                securityPin: "9021",
                trackingNumber: "STEADFAST-BD-849201",
                qrPassCode: nil,
                bookingDetails: nil,
                items: [
                    OrderLineItem(title: "Aarong Silk Embroidered Panjabi", subtitle: "Navy Blue \u{2022} Size 42 \u{2022} Eid Special", quantity: 1, price: 3850, imageAssetName: "product_panjabi"),
                    OrderLineItem(title: "Yellow Stretch Slim-Fit Denim", subtitle: "Dark Indigo \u{2022} Size 32", quantity: 1, price: 1500, imageAssetName: "product_denim_jeans")
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Order Confirmed", subtitle: "Verified with official Aarong & Yellow", time: "08:15 AM", isCompleted: true),
                    OrderTimelineStep(title: "Quality Check & Packed", subtitle: "Tamper-evident Kivorly seal applied", time: "08:45 AM", isCompleted: true),
                    OrderTimelineStep(title: "Dispatched from Tejgaon Hub", subtitle: "Loaded onto delivery van", time: "09:30 AM", isCompleted: true, isCurrent: true),
                    OrderTimelineStep(title: "Out for Delivery", subtitle: "Courier will call before arrival", time: "Estimated 02:30 PM", isCompleted: false),
                    OrderTimelineStep(title: "Delivered & Signed", subtitle: "Delivered to Gulshan 2", time: "Estimated 04:00 PM", isCompleted: false)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: 5350,
                    deliveryOrFareFee: 0,
                    platformFee: 30,
                    discount: 30,
                    total: 5350,
                    paymentMethod: "Nagad (01819-***441)",
                    transactionId: "TXN-NG-889104"
                )
            ),

            // 4. Tickets (Upcoming / Confirmed)
            SuperAppOrder(
                id: "KV-TICK-441",
                service: .tickets,
                title: "Green Line Paribahan (B3, B4)",
                subtitle: "Dhaka \u{2192} Cox's Bazar \u{2022} Scania AC",
                timestamp: "Tomorrow, 07:00 AM",
                amount: "\u{09F3}2,200",
                rawAmount: 2200,
                status: .confirmed,
                etaText: "Departs in 18 hrs",
                pickupLocation: "Arambagh Green Line Central Counter, Dhaka",
                destinationLocation: "Kolatoli Beach Main Point, Cox's Bazar",
                driverOrPartner: OrderPartner(
                    name: "Green Line Paribahan",
                    role: "Official Transport Partner",
                    rating: 4.8,
                    completedTrips: 24000,
                    phone: "+880 1970-017777",
                    vehicleInfo: "Scania Multi-Axle Double Decker AC",
                    licensePlate: "Dhaka Metro Ba 15-9922"
                ),
                securityPin: "6710",
                trackingNumber: "PASS-GL-CXB-441",
                qrPassCode: "TICKET-GL-B3B4-DHAKACXB-SECURE",
                bookingDetails: OrderBookingDetails(
                    seats: ["B3", "B4"],
                    coachOrFlightClass: "Business Class 2x1 AC Sleeper",
                    boardingPoint: "Arambagh Counter 2, Dhaka (06:30 AM Reporting)",
                    droppingPoint: "Hotel Motel Zone, Kolatoli, Cox's Bazar"
                ),
                items: [
                    OrderLineItem(title: "Green Line Scania Multi-Axle Ticket", subtitle: "Seat B3 (Window) \u{2022} Dhaka to Cox's Bazar", quantity: 1, price: 1100, emoji: "\u{1F68C}"),
                    OrderLineItem(title: "Green Line Scania Multi-Axle Ticket", subtitle: "Seat B4 (Aisle) \u{2022} Dhaka to Cox's Bazar", quantity: 1, price: 1100, emoji: "\u{1F68C}")
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Ticket Purchased", subtitle: "Seats locked & payment received", time: "Yesterday, 02:15 PM", isCompleted: true),
                    OrderTimelineStep(title: "E-Pass Issued", subtitle: "QR Boarding pass generated", time: "Yesterday, 02:16 PM", isCompleted: true, isCurrent: true),
                    OrderTimelineStep(title: "Reporting at Counter", subtitle: "Arambagh counter by 06:30 AM", time: "Tomorrow 06:30 AM", isCompleted: false),
                    OrderTimelineStep(title: "Journey Started", subtitle: "Expressway via Meghna Bridge", time: "Tomorrow 07:00 AM", isCompleted: false),
                    OrderTimelineStep(title: "Arrived at Destination", subtitle: "Kolatoli beach arrival", time: "Tomorrow 03:00 PM", isCompleted: false)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: 2200,
                    deliveryOrFareFee: 0,
                    platformFee: 50,
                    discount: 50,
                    total: 2200,
                    paymentMethod: "bKash (01712-***871)",
                    transactionId: "TXN-BK-1102941"
                )
            ),

            // 5. Hotels & Resorts (Upcoming / Confirmed)
            SuperAppOrder(
                id: "KV-HOTEL-109",
                service: .hotels,
                title: "Grand Palace Hotel & Resort",
                subtitle: "Sylhet \u{2022} Executive Deluxe Suite (2 Nights)",
                timestamp: "12 Oct \u{2013} 14 Oct 2026",
                amount: "\u{09F3}17,000",
                rawAmount: 17000,
                status: .confirmed,
                etaText: "Check-in in 2 days",
                pickupLocation: nil,
                destinationLocation: "Jail Road, Nayasharak, Sylhet 3100",
                driverOrPartner: OrderPartner(
                    name: "Grand Palace Front Desk",
                    role: "5-Star Hospitality Partner",
                    rating: 4.9,
                    completedTrips: 5200,
                    phone: "+880 821-728200",
                    vehicleInfo: "Airport Shuttle Available on Request"
                ),
                securityPin: "4491",
                trackingNumber: "RES-GP-SYL-109",
                qrPassCode: "HOTEL-GP-DLX-2026-CONFIRMED",
                bookingDetails: OrderBookingDetails(
                    roomType: "Executive Mountain View Deluxe Suite",
                    checkInDate: "12 Oct 2026, 02:00 PM",
                    checkOutDate: "14 Oct 2026, 12:00 PM",
                    guestCount: 2
                ),
                items: [
                    OrderLineItem(title: "Executive Suite (Night 1)", subtitle: "Buffet Breakfast included for 2", quantity: 1, price: 8500, emoji: "\u{1F3E8}"),
                    OrderLineItem(title: "Executive Suite (Night 2)", subtitle: "Buffet Breakfast included for 2", quantity: 1, price: 8500, emoji: "\u{1F3E8}")
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Reservation Confirmed", subtitle: "Guaranteed by Grand Palace", time: "05 Oct 2026", isCompleted: true),
                    OrderTimelineStep(title: "Pre-Checkin Voucher Ready", subtitle: "Instant keyless QR pass", time: "05 Oct 2026", isCompleted: true, isCurrent: true),
                    OrderTimelineStep(title: "Guest Arrival & Check-In", subtitle: "Front desk welcome drink", time: "12 Oct, 02:00 PM", isCompleted: false),
                    OrderTimelineStep(title: "Checkout", subtitle: "Luggage assistance & billing", time: "14 Oct, 12:00 PM", isCompleted: false)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: 17000,
                    deliveryOrFareFee: 0,
                    platformFee: 0,
                    discount: 1000,
                    total: 17000,
                    paymentMethod: "Visa Card (**** 4192)",
                    transactionId: "TXN-VISA-99201"
                )
            ),

            // 6. Grocery (Completed)
            SuperAppOrder(
                id: "KV-GROC-712",
                service: .grocery,
                title: "Daily Farm Organic Basket",
                subtitle: "6 items \u{2022} Farm Fresh Milk, Eggs & Veggies",
                timestamp: "Yesterday, 04:15 PM",
                amount: "\u{09F3}820",
                rawAmount: 820,
                status: .completed,
                etaText: "Delivered",
                pickupLocation: "Shwapno Express, Gulshan 2 Hub",
                destinationLocation: "House 14, Road 71, Flat 4B, Gulshan 2",
                driverOrPartner: OrderPartner(
                    name: "Sajjad Hossain",
                    role: "Grocery Courier",
                    rating: 4.8,
                    completedTrips: 1120,
                    phone: "+880 1711-998877"
                ),
                securityPin: "3182",
                trackingNumber: "GROC-SHW-712",
                qrPassCode: nil,
                bookingDetails: nil,
                items: [
                    OrderLineItem(title: "Farm Fresh Pasteurized Milk (1L)", subtitle: "2 Packs \u{2022} Chilled", quantity: 2, price: 190, emoji: "\u{1F95B}"),
                    OrderLineItem(title: "Organic Brown Eggs (Pack of 12)", subtitle: "Free-range native hens", quantity: 1, price: 180, emoji: "\u{1F95A}"),
                    OrderLineItem(title: "Aarong Dairy Pure Ghee (400g)", subtitle: "Aromatic Premium Jar", quantity: 1, price: 450, emoji: "\u{1FAD9}")
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Order Placed", subtitle: "Payment confirmed", time: "03:40 PM", isCompleted: true),
                    OrderTimelineStep(title: "Picked by Shwapno", subtitle: "Freshly selected batch", time: "03:52 PM", isCompleted: true),
                    OrderTimelineStep(title: "Out for Delivery", subtitle: "Courier on electric scooter", time: "04:02 PM", isCompleted: true),
                    OrderTimelineStep(title: "Delivered", subtitle: "Received and verified", time: "04:15 PM", isCompleted: true)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: 820,
                    deliveryOrFareFee: 30,
                    platformFee: 10,
                    discount: 40,
                    total: 820,
                    paymentMethod: "bKash (01712-***871)",
                    transactionId: "TXN-BK-772911"
                )
            ),

            // 7. Courier / Parcel Delivery (Completed)
            SuperAppOrder(
                id: "KV-PARC-552",
                service: .courier,
                title: "Steadfast Express Parcel",
                subtitle: "Confidential Legal Documents \u{2022} Express",
                timestamp: "04 Oct 2026",
                amount: "\u{09F3}250",
                rawAmount: 250,
                status: .completed,
                etaText: "Delivered",
                pickupLocation: "Road 27, Dhanmondi, Dhaka",
                destinationLocation: "Sector 4, Uttara, Dhaka",
                driverOrPartner: OrderPartner(
                    name: "Tanvir Ahmed",
                    role: "Express Courier Rider",
                    rating: 4.9,
                    completedTrips: 2150,
                    phone: "+880 1677-554433",
                    vehicleInfo: "Yamaha Saluto 125cc"
                ),
                securityPin: "5512",
                trackingNumber: "KVP-902144-BD",
                qrPassCode: nil,
                bookingDetails: nil,
                items: [
                    OrderLineItem(title: "Express Same-Day Document Parcel", subtitle: "Secure waterproof sealed envelope", quantity: 1, price: 250, emoji: "\u{1F4E6}")
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Pickup Requested", subtitle: "Assigned to nearest courier", time: "11:00 AM", isCompleted: true),
                    OrderTimelineStep(title: "Picked Up from Dhanmondi", subtitle: "Sealed & scanned", time: "11:25 AM", isCompleted: true),
                    OrderTimelineStep(title: "In Transit via Elevated Expressway", subtitle: "Heading to Uttara", time: "12:10 PM", isCompleted: true),
                    OrderTimelineStep(title: "Delivered & OTP Verified", subtitle: "Signed by recipient", time: "12:45 PM", isCompleted: true)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: 250,
                    deliveryOrFareFee: 0,
                    platformFee: 0,
                    discount: 0,
                    total: 250,
                    paymentMethod: "Cash on Pickup",
                    transactionId: "TXN-CSH-55201"
                )
            ),

            // 8. Home Services (Completed)
            SuperAppOrder(
                id: "KV-SERV-301",
                service: .homeServices,
                title: "Master AC Deep Servicing",
                subtitle: "Jet Wash, Filter Cleansing & Gas Top-up",
                timestamp: "03 Oct 2026",
                amount: "\u{09F3}1,200",
                rawAmount: 1200,
                status: .completed,
                etaText: "Completed",
                pickupLocation: nil,
                destinationLocation: "House 14, Road 71, Flat 4B, Gulshan 2",
                driverOrPartner: OrderPartner(
                    name: "Al-Amin Sheikh",
                    role: "Certified HVAC Master Technician",
                    rating: 4.9,
                    completedTrips: 760,
                    phone: "+880 1912-887766",
                    vehicleInfo: "Kivorly Tool Van \u{2022} Dhaka Metro Tha 11-2090"
                ),
                securityPin: "8821",
                trackingNumber: "SERV-AC-301",
                qrPassCode: nil,
                bookingDetails: nil,
                items: [
                    OrderLineItem(title: "Split AC Master Jet Wash", subtitle: "Indoor + Outdoor Unit High-Pressure Cleansing", quantity: 1, price: 800, emoji: "\u{1F527}"),
                    OrderLineItem(title: "R410A Refrigerant Top-up", subtitle: "Gas Pressure calibrated to 120 PSI", quantity: 1, price: 400, emoji: "\u{2744}\u{FE0F}")
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Booking Confirmed", subtitle: "Verified technician scheduled", time: "09:00 AM", isCompleted: true),
                    OrderTimelineStep(title: "Technician Arrived", subtitle: "ID verified at building gate", time: "11:00 AM", isCompleted: true),
                    OrderTimelineStep(title: "Service Executed", subtitle: "Jet wash & refrigerant top-up", time: "11:55 AM", isCompleted: true),
                    OrderTimelineStep(title: "Completed & Warrantied", subtitle: "30-day Kivorly cooling warranty active", time: "12:15 PM", isCompleted: true)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: 1200,
                    deliveryOrFareFee: 0,
                    platformFee: 0,
                    discount: 0,
                    total: 1200,
                    paymentMethod: "bKash (01712-***871)",
                    transactionId: "TXN-BK-330192"
                )
            ),

            // 9. Cancelled Order
            SuperAppOrder(
                id: "KVS-910244-BD",
                service: .shopping,
                title: "Xiaomi BD Official Store",
                subtitle: "Xiaomi Smart Band 8 (Graphite Black)",
                timestamp: "28 Sep 2026",
                amount: "\u{09F3}4,200",
                rawAmount: 4200,
                status: .cancelled,
                etaText: "Cancelled & Refunded",
                pickupLocation: "Xiaomi Flagship Hub, Jamuna Future Park",
                destinationLocation: "House 14, Road 71, Flat 4B, Gulshan 2",
                driverOrPartner: nil,
                securityPin: nil,
                trackingNumber: "KVS-CNCL-910244",
                qrPassCode: nil,
                bookingDetails: nil,
                items: [
                    OrderLineItem(title: "Xiaomi Smart Band 8", subtitle: "Color: Graphite Black \u{2022} 1 Year Warranty", quantity: 1, price: 4200, imageAssetName: "product_smartwatch")
                ],
                timelineSteps: [
                    OrderTimelineStep(title: "Order Placed", subtitle: "Card authorized", time: "02:00 PM", isCompleted: true),
                    OrderTimelineStep(title: "Stock Verification", subtitle: "Item went temporarily out of stock", time: "02:15 PM", isCompleted: true),
                    OrderTimelineStep(title: "Order Cancelled", subtitle: "Auto cancelled by system", time: "02:20 PM", isCompleted: true),
                    OrderTimelineStep(title: "Full Refund Dispatched", subtitle: "\u{09F3}4,200 refunded to original payment", time: "02:21 PM", isCompleted: true)
                ],
                paymentBreakdown: OrderPaymentBreakdown(
                    subtotal: 4200,
                    deliveryOrFareFee: 0,
                    platformFee: 0,
                    discount: 0,
                    total: 4200,
                    paymentMethod: "Refunded to bKash",
                    transactionId: "REF-BK-910244"
                )
            )
        ]
    }
}
