//
//  BangladeshTicketsBookingView.swift
//  Kivorly
//
//  Comprehensive Bangladeshi Ticketing & Travel Platform
//  Includes Inter-City Buses, Rental Cars/Microbuses, Bangladesh Railway,
//  River Launches, Domestic Plane Flights (Biman, US-Bangla, Air Astra, NOVOAIR),
//  All 8 Divisions & 64 Districts, Any-Date Native Calendar Selector, and Organized Badges.
//

import SwiftUI

public enum TransportVertical: String, CaseIterable, Identifiable {
    case all = "All Tickets"
    case air = "✈️ Domestic Flights"
    case bus = "🚌 Inter-City Bus"
    case car = "🚗 Rental Car & Micro"
    case train = "🚆 Bangladesh Rail"
    case launch = "🚢 River Launch"
    case cinema = "🎬 Cinema & Events"

    public var id: String { rawValue }
}

public struct CityTerminal: Identifiable, Hashable {
    public let id = UUID()
    public let city: String
    public let division: String
    public let terminals: [String]
}

public struct TransportTicketItem: Identifiable, Hashable {
    public let id: String
    public let operatorName: String
    public let vehicleModel: String
    public let category: TransportVertical
    public let originCity: String
    public let originTerminal: String
    public let destCity: String
    public let destTerminal: String
    public let departureTime: String
    public let arrivalTime: String
    public let duration: String
    public let price: Double
    public let priceText: String
    public let availableSeats: Int
    public let rating: Double
    public let reviewCount: Int
    public let classBadge: String
    public let badges: [String]
    public let amenities: [String]
    public let iconName: String
    public let boardingPoints: [String]
}

public struct BangladeshTicketsBookingView: View {
    @Environment(\.dismiss) private var dismiss

    // Nationwide Route State
    @State private var fromCity: String = "Dhaka"
    @State private var fromTerminal: String = "Sayedabad Counter"
    @State private var toCity: String = "Cox's Bazar"
    @State private var toTerminal: String = "Kolatoli Beach Point"

    // Any-Date Selection State
    @State private var selectedDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var showDatePickerModal: Bool = false

    // Filter & Search State
    @State private var selectedVertical: TransportVertical = .all
    @State private var isSearchActive: Bool = false
    @State private var searchQuery: String = ""

    // Sheet Pickers
    @State private var selectingRouteTarget: RouteSelectionTarget? = nil
    @State private var selectedTicket: TransportTicketItem? = nil
    @State private var selectedSeats: Set<String> = []
    @State private var selectedBoardingPoint: String = ""
    @State private var showConfirmedETicket: Bool = false
    @State private var confirmedPNR: String = ""

    public enum RouteSelectionTarget: Identifiable {
        case origin
        case destination
        public var id: Int { hashValue }
    }

    // Nationwide Hubs across all 8 Divisions of Bangladesh
    private let bangladeshHubs: [CityTerminal] = [
        CityTerminal(city: "Dhaka", division: "Dhaka Division", terminals: [
            "Hazrat Shahjalal Int'l Airport (DAC)", "Sayedabad Bus Terminal", "Mohakhali Inter-District Terminal", "Gabtoli Bus Terminal", "Arambagh VIP Counter", "Kalyanpur Counter", "Uttara Abdullahpur", "Kamalapur Railway Station", "Sadarghat Launch Terminal"
        ]),
        CityTerminal(city: "Cox's Bazar", division: "Chittagong Division", terminals: [
            "Cox's Bazar Airport (CXB)", "Kolatoli Beach Point", "Sugandha Beach Point", "Laboni Point Counter", "Main Central Bus Terminal"
        ]),
        CityTerminal(city: "Chittagong", division: "Chittagong Division", terminals: [
            "Shah Amanat Int'l Airport (CGP)", "Dampara Counter", "Station Road", "Cinema Palace", "Agrabad Commercial", "Chittagong Railway Station"
        ]),
        CityTerminal(city: "Sylhet", division: "Sylhet Division", terminals: [
            "Osmani Int'l Airport (ZYL)", "Kadamtoli Bus Terminal", "Subid Bazar Counter", "Sylhet Railway Station"
        ]),
        CityTerminal(city: "Saidpur (Rangpur)", division: "Rangpur Division", terminals: [
            "Saidpur Airport (SPD)", "Kamarpara Central Terminal", "Modern More Counter", "Rangpur Railway Station"
        ]),
        CityTerminal(city: "Jashore", division: "Khulna Division", terminals: [
            "Jashore Airport (JSR)", "Monihar Bus Stand", "Garikhana Counter", "Jashore Railway Junction"
        ]),
        CityTerminal(city: "Rajshahi", division: "Rajshahi Division", terminals: [
            "Shah Makhdum Airport (RJH)", "Shiroil Bus Terminal", "Bindur More Counter", "Rajshahi Railway Station"
        ]),
        CityTerminal(city: "Barishal", division: "Barishal Division", terminals: [
            "Barishal Airport (BZL)", "Nathullabad Bus Terminal", "Barishal River Port / Launch Ghat", "Rupatoli Counter"
        ]),
        CityTerminal(city: "Khulna", division: "Khulna Division", terminals: [
            "Sonadanga Central Bus Terminal", "Royal More VIP Counter", "Khulna Railway Station"
        ]),
        CityTerminal(city: "Bogura", division: "Rajshahi Division", terminals: [
            "Charmatha Central Terminal", "Thanthania Bus Stand", "Hakimpur More"
        ]),
        CityTerminal(city: "Mymensingh", division: "Mymensingh Division", terminals: [
            "Maskanda Central Bus Terminal", "Bridge More", "Mymensingh Railway Station"
        ]),
        CityTerminal(city: "Benapole", division: "Khulna Division", terminals: [
            "Benapole Land Port Checkpost", "Custom Terminal Counter"
        ]),
        CityTerminal(city: "Kuakata", division: "Barishal Division", terminals: [
            "Kuakata Zero Point", "Sea Beach Counter"
        ])
    ]

    private let sampleTickets: [TransportTicketItem] = [
        // 1. Domestic Planes / Flights across Bangladesh
        TransportTicketItem(
            id: "tkt_flight_1",
            operatorName: "Biman Bangladesh Airlines (BG 433)",
            vehicleModel: "Boeing 737-800 Jet (Direct)",
            category: .air,
            originCity: "Dhaka (DAC)",
            originTerminal: "Hazrat Shahjalal Int'l Airport Terminal 2",
            destCity: "Cox's Bazar (CXB)",
            destTerminal: "Cox's Bazar Domestic Terminal",
            departureTime: "11:00 AM",
            arrivalTime: "12:00 PM",
            duration: "1h 00m",
            price: 4200,
            priceText: "৳4,200",
            availableSeats: 11,
            rating: 4.88,
            reviewCount: 3100,
            classBadge: "Economy (20kg Check-in)",
            badges: ["Direct Flight", "National Flag Carrier"],
            amenities: ["In-Flight Snacks", "20kg Baggage", "7kg Cabin", "Comfort Legroom"],
            iconName: "airplane",
            boardingPoints: ["Hazrat Shahjalal Domestic Terminal 2"]
        ),
        TransportTicketItem(
            id: "tkt_flight_2",
            operatorName: "US-Bangla Airlines (BS 141)",
            vehicleModel: "Boeing 737-800 / ATR 72-600",
            category: .air,
            originCity: "Dhaka (DAC)",
            originTerminal: "Domestic Terminal, Dhaka Airport",
            destCity: "Chittagong (CGP)",
            destTerminal: "Shah Amanat Int'l Airport",
            departureTime: "02:15 PM",
            arrivalTime: "03:05 PM",
            duration: "50m",
            price: 3800,
            priceText: "৳3,800",
            availableSeats: 14,
            rating: 4.89,
            reviewCount: 4200,
            classBadge: "Premium Economy",
            badges: ["On-Time Leader", "Daily Express"],
            amenities: ["Complimentary Snack", "20kg Bag", "Web Check-in"],
            iconName: "airplane",
            boardingPoints: ["Dhaka Domestic Departure Gate 4"]
        ),
        TransportTicketItem(
            id: "tkt_flight_3",
            operatorName: "Air Astra (2A 511)",
            vehicleModel: "ATR 72-600 Turboprop",
            category: .air,
            originCity: "Dhaka (DAC)",
            originTerminal: "Domestic Terminal, Dhaka Airport",
            destCity: "Sylhet (ZYL)",
            destTerminal: "Osmani Int'l Airport",
            departureTime: "09:30 AM",
            arrivalTime: "10:20 AM",
            duration: "50m",
            price: 3400,
            priceText: "৳3,400",
            availableSeats: 8,
            rating: 4.92,
            reviewCount: 1650,
            classBadge: "Standard Economy",
            badges: ["New French Fleet", "Eco Comfort"],
            amenities: ["Snack Pack", "Leather Seats", "Fast Boarding"],
            iconName: "airplane",
            boardingPoints: ["Dhaka Domestic Terminal Gate 2"]
        ),
        TransportTicketItem(
            id: "tkt_flight_4",
            operatorName: "NOVOAIR (VQ 961)",
            vehicleModel: "ATR 72-500 Express",
            category: .air,
            originCity: "Dhaka (DAC)",
            originTerminal: "Domestic Terminal, Dhaka Airport",
            destCity: "Saidpur (SPD)",
            destTerminal: "Saidpur Airport",
            departureTime: "03:45 PM",
            arrivalTime: "04:45 PM",
            duration: "1h 00m",
            price: 3600,
            priceText: "৳3,600",
            availableSeats: 6,
            rating: 4.84,
            reviewCount: 2200,
            classBadge: "Smiles Class",
            badges: ["North Bengal Express", "Smooth Landings"],
            amenities: ["Complimentary Beverage", "20kg Baggage", "Quick Baggage Claim"],
            iconName: "airplane",
            boardingPoints: ["Domestic Terminal Gate 3"]
        ),

        // 2. Inter-City Buses
        TransportTicketItem(
            id: "tkt_bus_1",
            operatorName: "Green Line Paribahan",
            vehicleModel: "Scania Multi-Axle Double Decker AC",
            category: .bus,
            originCity: "Dhaka",
            originTerminal: "Sayedabad Counter",
            destCity: "Cox's Bazar",
            destTerminal: "Kolatoli Beach Point",
            departureTime: "11:15 PM",
            arrivalTime: "07:30 AM",
            duration: "8h 15m",
            price: 2200,
            priceText: "৳2,200",
            availableSeats: 6,
            rating: 4.92,
            reviewCount: 3200,
            classBadge: "Sleeper Class",
            badges: ["Scania V8 Multi-Axle", "Flagship Route"],
            amenities: ["Free WiFi", "Mineral Water", "Blanket", "USB Charging"],
            iconName: "bus.fill",
            boardingPoints: ["Sayedabad Counter", "Arambagh Counter", "Kalyanpur", "Abdullahpur Uttara"]
        ),
        TransportTicketItem(
            id: "tkt_bus_2",
            operatorName: "Shohagh Paribahan",
            vehicleModel: "Scania 1x2 Luxury Recliner",
            category: .bus,
            originCity: "Dhaka",
            originTerminal: "Panthapath VIP Counter",
            destCity: "Chittagong",
            destTerminal: "Dampara Counter",
            departureTime: "08:30 AM",
            arrivalTime: "01:45 PM",
            duration: "5h 15m",
            price: 1500,
            priceText: "৳1,500",
            availableSeats: 9,
            rating: 4.88,
            reviewCount: 2450,
            classBadge: "1x2 Business Recliner",
            badges: ["Luxury Recliner", "Express Transit"],
            amenities: ["AC Recliner", "Snack Box", "Live GPS Tracking"],
            iconName: "bus.fill",
            boardingPoints: ["Panthapath", "Sayedabad", "Arambagh", "Kalyanpur"]
        ),
        TransportTicketItem(
            id: "tkt_bus_3",
            operatorName: "ENA Transport",
            vehicleModel: "Hyundai Universe Super Express AC",
            category: .bus,
            originCity: "Dhaka",
            originTerminal: "Mohakhali Terminal",
            destCity: "Sylhet",
            destTerminal: "Kadamtoli Terminal",
            departureTime: "09:30 AM",
            arrivalTime: "02:30 PM",
            duration: "5h 00m",
            price: 850,
            priceText: "৳850",
            availableSeats: 12,
            rating: 4.82,
            reviewCount: 1890,
            classBadge: "Super Express AC",
            badges: ["Highway Direct", "High Frequency"],
            amenities: ["Chilled AC", "Mineral Water", "CCTV Security"],
            iconName: "bus.fill",
            boardingPoints: ["Mohakhali Inter-District Terminal", "Uttara Jasimuddin"]
        ),
        TransportTicketItem(
            id: "tkt_bus_4",
            operatorName: "Hanif Enterprise",
            vehicleModel: "Hyundai Universe Executive AC",
            category: .bus,
            originCity: "Dhaka",
            originTerminal: "Gabtoli Counter",
            destCity: "Rajshahi",
            destTerminal: "Shiroil Bus Terminal",
            departureTime: "07:00 AM",
            arrivalTime: "01:00 PM",
            duration: "6h 00m",
            price: 950,
            priceText: "৳950",
            availableSeats: 14,
            rating: 4.75,
            reviewCount: 4100,
            classBadge: "Executive AC",
            badges: ["Padma Bridge Route", "Smooth Highway"],
            amenities: ["Chilled AC", "Water Bottle", "Audio System"],
            iconName: "bus.fill",
            boardingPoints: ["Gabtoli Counter", "Kalyanpur", "Sayedabad"]
        ),
        TransportTicketItem(
            id: "tkt_bus_5",
            operatorName: "Desh Travels",
            vehicleModel: "Volvo B11R Multi-Axle Elite AC",
            category: .bus,
            originCity: "Dhaka",
            originTerminal: "Arambagh Counter",
            destCity: "Benapole",
            destTerminal: "Land Port Checkpost",
            departureTime: "10:30 PM",
            arrivalTime: "05:00 AM",
            duration: "6h 30m",
            price: 1400,
            priceText: "৳1,400",
            availableSeats: 4,
            rating: 4.9,
            reviewCount: 1650,
            classBadge: "Volvo Elite AC",
            badges: ["Air Suspension", "Border Express"],
            amenities: ["WiFi", "Blanket", "USB Port", "Water"],
            iconName: "bus.fill",
            boardingPoints: ["Gabtoli", "Kalyanpur", "Arambagh"]
        ),

        // 3. Rental Cars & Microbus
        TransportTicketItem(
            id: "tkt_car_1",
            operatorName: "Kivorly Chauffeur Car Rental",
            vehicleModel: "Toyota HiAce Grand Cabin (11-14 Seats)",
            category: .car,
            originCity: "Dhaka (All Areas)",
            originTerminal: "Doorstep Pickup in Dhaka",
            destCity: "Any District in Bangladesh",
            destTerminal: "Custom Destination Drop",
            departureTime: "On-Demand / Flexible",
            arrivalTime: "Custom Timing",
            duration: "Full Day Rental",
            price: 7500,
            priceText: "৳7,500/day",
            availableSeats: 12,
            rating: 4.95,
            reviewCount: 880,
            classBadge: "Grand Cabin VIP",
            badges: ["Verified Chauffeur", "Luggage Roof Carrier"],
            amenities: ["Dual AC", "Music System", "Sanitized Interior", "Toll Option"],
            iconName: "car.2.fill",
            boardingPoints: ["Doorstep Pickup in Dhaka", "Airport Terminal", "Gulshan/Banani"]
        ),
        TransportTicketItem(
            id: "tkt_car_2",
            operatorName: "Kivorly Micro Express",
            vehicleModel: "Toyota Noah / VOXY Hybrid (7-8 Seats)",
            category: .car,
            originCity: "Dhaka",
            originTerminal: "Banani / Dhanmondi",
            destCity: "Padma Bridge / Mawa / Ctg",
            destTerminal: "Direct Point Drop",
            departureTime: "Instant Dispatch",
            arrivalTime: "On Demand",
            duration: "Full Day Trip",
            price: 5800,
            priceText: "৳5,800/day",
            availableSeats: 7,
            rating: 4.92,
            reviewCount: 1120,
            classBadge: "Captain Hybrid",
            badges: ["Dual Power Doors", "Leather Captain Seats"],
            amenities: ["Reclining Chairs", "Ice-Cold AC", "Phone Chargers"],
            iconName: "car.side.fill",
            boardingPoints: ["Home Doorstep Pickup", "Dhanmondi", "Uttara", "Mirpur"]
        ),

        // 4. Bangladesh Railway
        TransportTicketItem(
            id: "tkt_train_1",
            operatorName: "Bangladesh Railway",
            vehicleModel: "Suborno Express (Train 701/702)",
            category: .train,
            originCity: "Kamalapur, Dhaka",
            originTerminal: "Platform 1, Kamalapur",
            destCity: "Chittagong",
            destTerminal: "Chittagong Railway Station",
            departureTime: "04:30 PM",
            arrivalTime: "09:50 PM",
            duration: "5h 20m",
            price: 725,
            priceText: "৳725",
            availableSeats: 18,
            rating: 4.85,
            reviewCount: 5400,
            classBadge: "Snigdha AC Chair",
            badges: ["Non-Stop Express", "Scenic Highway Track"],
            amenities: ["Snigdha AC", "Dining Car", "Power Outlets"],
            iconName: "tram.fill",
            boardingPoints: ["Kamalapur Railway Station", "Dhaka Airport Railway Station"]
        ),
        TransportTicketItem(
            id: "tkt_train_2",
            operatorName: "Bangladesh Railway",
            vehicleModel: "Sonar Bangla Express (Train 787/788)",
            category: .train,
            originCity: "Kamalapur, Dhaka",
            originTerminal: "Platform 3, Kamalapur",
            destCity: "Chittagong",
            destTerminal: "Chittagong Station",
            departureTime: "07:00 AM",
            arrivalTime: "12:15 PM",
            duration: "5h 15m",
            price: 1100,
            priceText: "৳1,100",
            availableSeats: 8,
            rating: 4.9,
            reviewCount: 4600,
            classBadge: "AC Berth Sleeper",
            badges: ["Red-Green Coaches", "Breakfast Included"],
            amenities: ["AC Berth", "Indonesian Coaches", "Catering Service"],
            iconName: "tram.fill",
            boardingPoints: ["Kamalapur Railway Station", "Dhaka Airport Railway Station"]
        ),

        // 5. River Launch
        TransportTicketItem(
            id: "tkt_launch_1",
            operatorName: "MV Manami Luxury Launch",
            vehicleModel: "VIP Duplex AC Suite with Private Balcony",
            category: .launch,
            originCity: "Sadarghat, Dhaka",
            originTerminal: "VIP Pontoon 2, Sadarghat",
            destCity: "Barishal",
            destTerminal: "Barishal River Port Pontoon",
            departureTime: "08:30 PM",
            arrivalTime: "05:00 AM",
            duration: "8h 30m",
            price: 4500,
            priceText: "৳4,500",
            availableSeats: 3,
            rating: 4.96,
            reviewCount: 1750,
            classBadge: "VIP Balcony Suite",
            badges: ["5-Star River Cruise", "Private Balcony"],
            amenities: ["Attached Bath", "LED TV", "Complimentary Dinner", "Card Entry"],
            iconName: "ferry.fill",
            boardingPoints: ["Sadarghat VIP Pontoon 2", "Shashanghat"]
        ),

        // 6. Cinema & Events
        TransportTicketItem(
            id: "tkt_cinema_1",
            operatorName: "Star Cineplex",
            vehicleModel: "VIP Recliner Hall (Bashundhara City)",
            category: .cinema,
            originCity: "Panthapath, Dhaka",
            originTerminal: "Level 8, Bashundhara City Mall",
            destCity: "Dhaka",
            destTerminal: "Screen 1 (Laser 4K & Dolby Atmos)",
            departureTime: "07:30 PM",
            arrivalTime: "10:15 PM",
            duration: "2h 45m",
            price: 650,
            priceText: "৳650",
            availableSeats: 18,
            rating: 4.94,
            reviewCount: 5200,
            classBadge: "VIP Motorized Recliner",
            badges: ["Laser 4K", "Dolby Atmos 7.1"],
            amenities: ["Leather Recliner", "Popcorn Butler", "Air Conditioned"],
            iconName: "film.fill",
            boardingPoints: ["Level 8, Bashundhara City Mall, Panthapath"]
        )
    ]

    private var formattedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy"
        return formatter.string(from: selectedDate)
    }

    private var filteredTickets: [TransportTicketItem] {
        sampleTickets.filter { ticket in
            let matchesCategory = (selectedVertical == .all || ticket.category == selectedVertical)
            let matchesSearch = searchQuery.isEmpty ||
                ticket.operatorName.localizedCaseInsensitiveContains(searchQuery) ||
                ticket.vehicleModel.localizedCaseInsensitiveContains(searchQuery) ||
                ticket.destCity.localizedCaseInsensitiveContains(searchQuery) ||
                ticket.originCity.localizedCaseInsensitiveContains(searchQuery) ||
                ticket.destTerminal.localizedCaseInsensitiveContains(searchQuery) ||
                ticket.originTerminal.localizedCaseInsensitiveContains(searchQuery) ||
                ticket.classBadge.localizedCaseInsensitiveContains(searchQuery)
            return matchesCategory && matchesSearch
        }
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Standard Top Navigation Bar
            topControlBar

            // Expandable Search Bar
            if isSearchActive {
                expandableSearchBar
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            ScrollView {
                VStack(spacing: 14) {
                    // Nationwide Route & Any-Date Selector Card
                    nationwideRouteCard

                    // Transport Category Filter Pills
                    verticalCategoryFilterBar

                    // Organized Tickets Feed
                    ticketsFeedSection
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.vertical, KivorlySpacing.md)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(item: $selectingRouteTarget) { target in
            nationwidePickerSheet(for: target)
        }
        .sheet(isPresented: $showDatePickerModal) {
            calendarPickerSheet
        }
        .sheet(item: $selectedTicket) { ticket in
            seatSelectionModal(for: ticket)
        }
        .sheet(isPresented: $showConfirmedETicket) {
            confirmedETicketView
        }
    }

    // MARK: - Top Navigation Bar
    private var topControlBar: some View {
        HStack {
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

            HStack(spacing: 8) {
                Image(ServiceType.tickets.assetImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)

                Text(ServiceType.tickets.title)
                    .font(KivorlyTypography.titleSmall)
                    .foregroundColor(Color(uiColor: .label))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Color(uiColor: .systemBackground))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)

            Spacer()

            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isSearchActive.toggle()
                    if !isSearchActive {
                        searchQuery = ""
                    }
                }
            }) {
                Circle()
                    .fill(isSearchActive ? ServiceType.tickets.accentTint : Color(uiColor: .systemBackground))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: isSearchActive ? "xmark" : "magnifyingglass")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isSearchActive ? Color.white : Color(uiColor: .label))
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)
            }
        }
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.top, 10)
        .padding(.bottom, 6)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }

    // MARK: - Expandable Search Bar
    private var expandableSearchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(uiColor: .secondaryLabel))

            TextField("Search flights, buses, trains, models or terminals...", text: $searchQuery)
                .font(KivorlyTypography.bodyMedium)

            if !searchQuery.isEmpty {
                Button(action: { searchQuery = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(uiColor: .tertiarySystemFill))
        .clipShape(Capsule())
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.vertical, 8)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }

    // MARK: - Nationwide Route & Any-Date Card
    private var nationwideRouteCard: some View {
        VStack(spacing: 12) {
            // Origin & Destination Row with Swap
            HStack(spacing: 12) {
                // FROM Block
                Button(action: {
                    selectingRouteTarget = .origin
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(ServiceType.tickets.accentTint)
                                .frame(width: 8, height: 8)
                            Text("From (Nationwide)")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }

                        Text(fromCity)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))

                        Text(fromTerminal)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(Color(uiColor: .tertiarySystemFill).opacity(0.6))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())

                // Swap Button
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        let cCity = fromCity
                        let cTerm = fromTerminal
                        fromCity = toCity
                        fromTerminal = toTerminal
                        toCity = cCity
                        toTerminal = cTerm
                    }
                }) {
                    Circle()
                        .fill(ServiceType.tickets.accentTint)
                        .frame(width: 38, height: 38)
                        .overlay(
                            Image(systemName: "arrow.left.arrow.right")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .shadow(color: ServiceType.tickets.accentTint.opacity(0.3), radius: 6, y: 2)
                }

                // TO Block
                Button(action: {
                    selectingRouteTarget = .destination
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 10))
                                .foregroundColor(.red)
                            Text("To (Nationwide)")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }

                        Text(toCity)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))

                        Text(toTerminal)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(Color(uiColor: .tertiarySystemFill).opacity(0.6))
                    .cornerRadius(12)
                }
                .buttonStyle(PlainButtonStyle())
            }

            Divider()

            // Any-Date Native Calendar Selector Row
            Button(action: {
                showDatePickerModal = true
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(ServiceType.tickets.accentTint.opacity(0.12))
                            .frame(width: 38, height: 38)

                        Image(systemName: "calendar.badge.clock")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ServiceType.tickets.accentTint)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Journey Date (Select any date)")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        Text(formattedDateString)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                    }

                    Spacer()

                    HStack(spacing: 4) {
                        Text("Change Date")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(ServiceType.tickets.accentTint)

                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(ServiceType.tickets.accentTint)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(ServiceType.tickets.accentTint.opacity(0.1))
                    .clipShape(Capsule())
                }
                .padding(10)
                .background(Color(uiColor: .tertiarySystemFill).opacity(0.4))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)
    }

    // MARK: - Calendar Picker Sheet
    private var calendarPickerSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                DatePicker(
                    "Select Travel Date",
                    selection: $selectedDate,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .tint(ServiceType.tickets.accentTint)
                .padding()
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .cornerRadius(20)

                Spacer()

                Button(action: {
                    showDatePickerModal = false
                }) {
                    Text("Confirm Journey Date")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(ServiceType.tickets.accentTint)
                        .clipShape(Capsule())
                }
            }
            .padding()
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Select Any Journey Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { showDatePickerModal = false }
                }
            }
        }
    }

    // MARK: - Nationwide Station & Airport Picker Sheet
    private func nationwidePickerSheet(for target: RouteSelectionTarget) -> some View {
        NavigationStack {
            List {
                ForEach(bangladeshHubs) { hub in
                    Section(header: Text("\(hub.city) • \(hub.division)").font(.system(size: 12, weight: .bold))) {
                        ForEach(hub.terminals, id: \.self) { terminal in
                            Button(action: {
                                if target == .origin {
                                    fromCity = hub.city
                                    fromTerminal = terminal
                                } else {
                                    toCity = hub.city
                                    toTerminal = terminal
                                }
                                selectingRouteTarget = nil
                            }) {
                                HStack {
                                    Image(systemName: terminal.contains("Airport") ? "airplane.circle.fill" : "mappin.and.ellipse")
                                        .foregroundColor(ServiceType.tickets.accentTint)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(terminal)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(uiColor: .label))
                                        Text("\(hub.city), \(hub.division)")
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(uiColor: .secondaryLabel))
                                    }

                                    Spacer()

                                    let isCurrent = (target == .origin && fromCity == hub.city && fromTerminal == terminal) ||
                                                    (target == .destination && toCity == hub.city && toTerminal == terminal)
                                    if isCurrent {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(ServiceType.tickets.accentTint)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle(target == .origin ? "Select Departure Station / Airport" : "Select Arrival Station / Airport")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { selectingRouteTarget = nil }
                }
            }
        }
    }

    // MARK: - Transport Category Filter Bar
    private var verticalCategoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(TransportVertical.allCases) { vertical in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedVertical = vertical
                        }
                    }) {
                        Text(vertical.rawValue)
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                selectedVertical == vertical ?
                                Color(uiColor: .systemFill) :
                                Color(uiColor: .tertiarySystemFill)
                            )
                            .foregroundColor(
                                selectedVertical == vertical ?
                                Color(uiColor: .label) :
                                Color(uiColor: .secondaryLabel)
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(
                                        selectedVertical == vertical ?
                                        ServiceType.tickets.accentTint :
                                        Color(uiColor: .separator).opacity(0.3),
                                        lineWidth: selectedVertical == vertical ? 2 : 0.6
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 2)
            .padding(.vertical, 2)
        }
    }

    // MARK: - Organized Tickets Feed Section
    private var ticketsFeedSection: some View {
        VStack(spacing: 12) {
            ForEach(filteredTickets) { ticket in
                organizedTicketCard(for: ticket)
            }
        }
    }

    private func organizedTicketCard(for ticket: TransportTicketItem) -> some View {
        Button(action: {
            selectedTicket = ticket
            selectedBoardingPoint = ticket.boardingPoints.first ?? ticket.originTerminal
            selectedSeats = ["A1"]
        }) {
            VStack(alignment: .leading, spacing: 12) {
                // Header Row: Operator, Vehicle Class, Verified Badge & Rating Chip
                HStack(alignment: .center) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(ServiceType.tickets.accentTint.opacity(0.12))
                                .frame(width: 42, height: 42)

                            Image(systemName: ticket.iconName)
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(ServiceType.tickets.accentTint)
                        }

                        VStack(alignment: .leading, spacing: 2) {
                            HStack(spacing: 4) {
                                Text(ticket.operatorName)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(uiColor: .label))

                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(.blue)
                            }

                            Text(ticket.vehicleModel)
                                .font(KivorlyTypography.caption)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    // Rating Chip in Header
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.orange)
                        Text(String(format: "%.1f", ticket.rating))
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(Capsule())
                }

                // Middle Route Timeline
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(ticket.departureTime)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                        Text(ticket.originTerminal)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .lineLimit(1)
                    }

                    Spacer()

                    VStack(spacing: 3) {
                        Text(ticket.duration)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        HStack(spacing: 4) {
                            Circle().fill(ServiceType.tickets.accentTint).frame(width: 4, height: 4)
                            Rectangle().fill(Color(uiColor: .separator)).frame(width: 36, height: 1.5)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(ServiceType.tickets.accentTint)
                        }

                        Text(ticket.category == .air ? "Direct Air Route" : "Direct Highway")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(Color(uiColor: .tertiaryLabel))
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text(ticket.arrivalTime)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                        Text(ticket.destTerminal)
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .lineLimit(1)
                    }
                }
                .padding(10)
                .background(Color(uiColor: .tertiarySystemFill).opacity(0.45))
                .cornerRadius(12)

                // Single Uninterrupted Line Badges Row
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        // Class Badge (Highlighted)
                        Text(ticket.classBadge)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(ServiceType.tickets.accentTint)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 4)
                            .background(ServiceType.tickets.accentTint.opacity(0.12))
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(ServiceType.tickets.accentTint.opacity(0.3), lineWidth: 1)
                            )

                        // Route Badges
                        ForEach(ticket.badges, id: \.self) { badge in
                            Text(badge)
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundColor(Color(uiColor: .label))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(uiColor: .secondarySystemFill))
                                .clipShape(Capsule())
                        }

                        // Amenities Badges
                        ForEach(ticket.amenities, id: \.self) { amenity in
                            HStack(spacing: 3) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(ServiceType.tickets.accentTint)
                                Text(amenity)
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Capsule())
                        }
                    }
                }

                Divider()

                // Footer Row: Seat Count + Price & Action Button
                HStack(alignment: .center) {
                    HStack(spacing: 5) {
                        Circle()
                            .fill(ticket.availableSeats <= 5 ? Color.red : Color.green)
                            .frame(width: 7, height: 7)
                        Text("\(ticket.availableSeats) seats left")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(ticket.availableSeats <= 5 ? Color.red : Color.green)
                    }

                    Spacer()

                    HStack(spacing: 10) {
                        VStack(alignment: .trailing, spacing: 1) {
                            Text(ticket.priceText)
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(ServiceType.tickets.accentTint)
                            Text("per seat")
                                .font(.system(size: 9, weight: .semibold))
                                .foregroundColor(Color(uiColor: .tertiaryLabel))
                        }

                        HStack(spacing: 4) {
                            Text(ticket.category == .air ? "Select Flight" : "Select Seats")
                                .font(.system(size: 12, weight: .bold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 10, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(ServiceType.tickets.accentTint)
                        .clipShape(Capsule())
                    }
                }
            }
            .padding(14)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            .shadow(color: Color.black.opacity(0.06), radius: 8, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Interactive Seat Selection Modal
    private func seatSelectionModal(for ticket: TransportTicketItem) -> some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Header Summary
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(ticket.operatorName)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))

                            Text("\(ticket.originTerminal) ➔ \(ticket.destTerminal)")
                                .font(KivorlyTypography.caption)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }

                        Spacer()

                        Text(ticket.priceText)
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(ServiceType.tickets.accentTint)
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(14)

                    // Boarding Point Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Boarding Point / Terminal")
                            .font(KivorlyTypography.captionBold)
                            .foregroundColor(Color(uiColor: .label))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(ticket.boardingPoints, id: \.self) { point in
                                    Button(action: {
                                        selectedBoardingPoint = point
                                    }) {
                                        Text(point)
                                            .font(.system(size: 12, weight: .semibold))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 7)
                                            .background(
                                                selectedBoardingPoint == point ?
                                                ServiceType.tickets.accentTint.opacity(0.15) :
                                                Color(uiColor: .tertiarySystemFill)
                                            )
                                            .foregroundColor(
                                                selectedBoardingPoint == point ?
                                                ServiceType.tickets.accentTint :
                                                Color(uiColor: .label)
                                            )
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(
                                                        selectedBoardingPoint == point ?
                                                        ServiceType.tickets.accentTint :
                                                        Color.clear,
                                                        lineWidth: 1.5
                                                    )
                                            )
                                    }
                                }
                            }
                        }
                    }

                    // Seat Legend
                    HStack(spacing: 16) {
                        legendItem(title: "Available", color: Color(uiColor: .systemFill), border: Color(uiColor: .separator))
                        legendItem(title: "Selected", color: ServiceType.tickets.accentTint, border: ServiceType.tickets.accentTint)
                        legendItem(title: "Booked", color: Color(uiColor: .systemGray4), border: Color.clear)
                    }
                    .padding(.vertical, 4)

                    // Layout Grid
                    VStack(spacing: 12) {
                        HStack {
                            Spacer()
                            HStack(spacing: 6) {
                                Text(ticket.category == .air ? "Cockpit / Front Exit" : "Driver Cabin")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                                Image(systemName: ticket.category == .air ? "airplane" : "steeringwheel")
                                    .font(.system(size: 16))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Capsule())
                        }

                        // 7 Rows of Seats (A to G)
                        ForEach(["A", "B", "C", "D", "E", "F", "G"], id: \.self) { row in
                            HStack(spacing: 12) {
                                seatButton(seatNumber: "\(row)1", isBooked: row == "C" || row == "E")
                                seatButton(seatNumber: "\(row)2", isBooked: row == "D")

                                Spacer()
                                Text(row)
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(Color(uiColor: .tertiaryLabel))
                                Spacer()

                                seatButton(seatNumber: "\(row)3", isBooked: row == "B" || row == "F")
                                seatButton(seatNumber: "\(row)4", isBooked: false)
                            }
                        }
                    }
                    .padding(16)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

                    // Selected Seat Bar & Checkout Action
                    VStack(spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Seats: \(selectedSeats.sorted().joined(separator: ", "))")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(uiColor: .label))

                                Text("Total: ৳\(Int(ticket.price * Double(max(1, selectedSeats.count))))")
                                    .font(.system(size: 16, weight: .black))
                                    .foregroundColor(ServiceType.tickets.accentTint)
                            }

                            Spacer()

                            Button(action: {
                                confirmTicket(ticket: ticket, from: fromCity, to: toCity)
                            }) {
                                Text("Confirm & E-Ticket")
                                    .font(KivorlyTypography.titleSmall)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 12)
                                    .background(ServiceType.tickets.accentTint)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .padding(14)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(16)
                }
                .padding(KivorlySpacing.md)
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle(ticket.category == .air ? "Select Flight Seats" : "Select Seats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { selectedTicket = nil }
                }
            }
        }
    }

    private func legendItem(title: String, color: Color, border: Color) -> some View {
        HStack(spacing: 6) {
            RoundedRectangle(cornerRadius: 6)
                .fill(color)
                .frame(width: 18, height: 18)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(border, lineWidth: 1)
                )

            Text(title)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(Color(uiColor: .secondaryLabel))
        }
    }

    private func seatButton(seatNumber: String, isBooked: Bool) -> some View {
        Button(action: {
            if !isBooked {
                if selectedSeats.contains(seatNumber) {
                    selectedSeats.remove(seatNumber)
                } else {
                    selectedSeats.insert(seatNumber)
                }
            }
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        isBooked ?
                        Color(uiColor: .systemGray4) :
                        (selectedSeats.contains(seatNumber) ? ServiceType.tickets.accentTint : Color(uiColor: .systemBackground))
                    )
                    .frame(width: 48, height: 42)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(
                                selectedSeats.contains(seatNumber) ?
                                ServiceType.tickets.accentTint :
                                Color(uiColor: .separator).opacity(0.5),
                                lineWidth: 1.2
                            )
                    )

                if isBooked {
                    Image(systemName: "xmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                } else {
                    Text(seatNumber)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(
                            selectedSeats.contains(seatNumber) ? .white : Color(uiColor: .label)
                        )
                }
            }
        }
        .disabled(isBooked)
    }

    // MARK: - Confirmed E-Ticket Card View
    private var confirmedETicketView: some View {
        NavigationStack {
            VStack(spacing: KivorlySpacing.lg) {
                // Success Badge
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 60, height: 60)

                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 32))
                            .foregroundColor(.green)
                    }

                    Text("E-Ticket Confirmed!")
                        .font(KivorlyTypography.titleLarge)
                        .foregroundColor(Color(uiColor: .label))

                    Text("PNR: \(confirmedPNR)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(ServiceType.tickets.accentTint)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(ServiceType.tickets.accentTint.opacity(0.12))
                        .clipShape(Capsule())
                }
                .padding(.top, 10)

                // E-Ticket Boarding Pass
                VStack(spacing: 14) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Biman / Green Line / Rail")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))
                            Text("Confirmed Electronic Boarding Pass")
                                .font(KivorlyTypography.caption)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }

                        Spacer()

                        Image(systemName: "ticket.fill")
                            .font(.system(size: 24))
                            .foregroundColor(ServiceType.tickets.accentTint)
                    }

                    Divider()

                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text("From")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Text(fromCity)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))
                            Text(fromTerminal)
                                .font(KivorlyTypography.caption)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                                .lineLimit(1)
                        }

                        Spacer()

                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ServiceType.tickets.accentTint)

                        Spacer()

                        VStack(alignment: .trailing, spacing: 3) {
                            Text("TO")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Text(toCity)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))
                            Text(toTerminal)
                                .font(KivorlyTypography.caption)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                                .lineLimit(1)
                        }
                    }

                    Divider()

                    // Passenger, Date & Seat info
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Passenger")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Text("MD Shoaib Khan")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))
                        }

                        Spacer()

                        VStack(alignment: .center, spacing: 2) {
                            Text("Seat(s)")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Text(selectedSeats.isEmpty ? "A1" : selectedSeats.sorted().joined(separator: ", "))
                                .font(.system(size: 14, weight: .black))
                                .foregroundColor(ServiceType.tickets.accentTint)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Date")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Text(formattedDateString)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))
                        }
                    }

                    // Scannable Barcode
                    VStack(spacing: 4) {
                        Image(systemName: "barcode.viewfinder")
                            .font(.system(size: 48))
                            .foregroundColor(Color(uiColor: .label))

                        Text("Scan at Airport Gate / Bus Terminal Counter")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .padding(.top, 8)
                }
                .padding(16)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.black.opacity(0.08), radius: 10, y: 3)

                Spacer()

                Button(action: { showConfirmedETicket = false }) {
                    Text("Done")
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
            .navigationTitle("Your E-Ticket")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { showConfirmedETicket = false }
                }
            }
        }
    }
    private func confirmTicket(ticket: TransportTicketItem, from: String, to: String) {
        let seatsCount = max(1, selectedSeats.count)
        let totalFare = ticket.price * Double(seatsCount)
        let pnr = "KV-TICK-\(Int.random(in: 100000...999999))-BD"
        let seatsArray = selectedSeats.isEmpty ? ["A1"] : Array(selectedSeats).sorted()

        let ticketOrder = SuperAppOrder(
            id: pnr,
            service: .tickets,
            title: "\(ticket.operatorName) (\(seatsArray.joined(separator: ", ")))",
            subtitle: "\(from) → \(to) • \(ticket.vehicleModel)",
            timestamp: "Just now",
            amount: String(format: "\u{09F3}%.0f", totalFare),
            rawAmount: totalFare,
            status: .confirmed,
            etaText: "Departs at \(ticket.departureTime)",
            pickupLocation: "\(from) Central Counter",
            destinationLocation: "\(to) Terminal Point",
            driverOrPartner: OrderPartner(
                name: ticket.operatorName,
                role: "Official Transport Partner",
                rating: 4.8,
                completedTrips: 24000,
                phone: "+880 1970-017777",
                vehicleInfo: "\(ticket.vehicleModel) AC Coach",
                licensePlate: "Dhaka Metro Ba 15-9922"
            ),
            securityPin: String(format: "%04d", Int.random(in: 1000...9999)),
            trackingNumber: "PASS-\(pnr)",
            qrPassCode: "TICKET-\(pnr)-SECURE",
            bookingDetails: OrderBookingDetails(
                seats: seatsArray,
                coachOrFlightClass: ticket.vehicleModel,
                boardingPoint: "\(from) Terminal Counter",
                droppingPoint: "\(to) Arrival Point"
            ),
            items: seatsArray.map { seat in
                OrderLineItem(
                    title: "\(ticket.operatorName) \(ticket.vehicleModel) Seat",
                    subtitle: "Seat \(seat) • \(from) to \(to)",
                    quantity: 1,
                    price: ticket.price,
                    emoji: "🎫"
                )
            },
            timelineSteps: [
                OrderTimelineStep(title: "Ticket Purchased", subtitle: "Seats locked & payment received", time: "Just now", isCompleted: true),
                OrderTimelineStep(title: "E-Pass Issued", subtitle: "Digital Boarding pass generated", time: "Just now", isCompleted: true, isCurrent: true),
                OrderTimelineStep(title: "Reporting at Counter", subtitle: "Report 30 mins before departure", time: "\(ticket.departureTime) Reporting", isCompleted: false),
                OrderTimelineStep(title: "Journey Started", subtitle: "Departs on scheduled route", time: ticket.departureTime, isCompleted: false),
                OrderTimelineStep(title: "Arrived at Destination", subtitle: "Arrival at \(to)", time: ticket.arrivalTime, isCompleted: false)
            ],
            paymentBreakdown: OrderPaymentBreakdown(
                subtotal: totalFare,
                deliveryOrFareFee: 0,
                platformFee: 0,
                discount: 0,
                total: totalFare,
                paymentMethod: "bKash",
                transactionId: "TXN-\(Int.random(in: 10000000...99999999))"
            )
        )
        OrdersManager.shared.addOrder(ticketOrder)

        selectedTicket = nil
        confirmedPNR = pnr
        showConfirmedETicket = true
    }
}
