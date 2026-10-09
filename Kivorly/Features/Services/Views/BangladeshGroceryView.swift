//
//  BangladeshGroceryView.swift
//  Kivorly
//
//  End-to-End Bangladeshi Grocery Experience (Chaldal / Shwapno Style)
//  Features 1-Hour Dhaka Express Delivery, Fresh Daily Bazaar,
//  Padma River Fish, Meat & Poultry, Pantry Staples, In-line Quantity Steppers,
//  Free Delivery Progress Tracker, Floating Basket, and Checkout in Taka (৳).
//

import SwiftUI

public struct GroceryItem: Identifiable {
    public let id: String
    public let name: String
    public let category: String
    public let unit: String
    public let price: Double
    public let originalPrice: Double?
    public let emoji: String
    public let origin: String
    public let freshnessBadge: String
    public let inStock: Bool
}

public struct GroceryCartEntry: Identifiable {
    public let id = UUID()
    public let item: GroceryItem
    public var quantity: Int
}

public struct BangladeshGroceryView: View {
    @Environment(\.dismiss) private var dismiss

    // Search and Category Filters
    @State private var searchQuery: String = ""
    @State private var isSearchActive: Bool = false
    @State private var selectedCategory: String = "All"

    // Delivery Slot & Location
    @State private var deliverySlot: String = "⚡ Express (45 - 60 mins)"
    @State private var showSlotSheet: Bool = false

    // Cart Management
    @State private var cart: [String: Int] = [:] // itemId: quantity
    @State private var showBasketSheet: Bool = false

    // Checkout Flow
    @State private var selectedPaymentMethod: String = "bKash"
    @State private var deliveryNote: String = "Leave at door / Call before arrival"
    @State private var showOrderConfirmed: Bool = false
    @State private var confirmedOrderId: String = ""

    private let categories = [
        "All", "🐟 Fresh Fish", "🥩 Meat & Poultry", "🥦 Fresh Vegetables", "🌾 Rice & Oil", "🥛 Dairy & Eggs", "🌶️ Spices & Salt"
    ]

    private let availableSlots = [
        "⚡ Express (45 - 60 mins)",
        "🕒 Today Afternoon (2:00 PM - 4:00 PM)",
        "🌆 Today Evening (6:00 PM - 8:00 PM)",
        "🌅 Tomorrow Morning (8:00 AM - 10:00 AM)"
    ]

    private let groceryCatalog: [GroceryItem] = [
        GroceryItem(
            id: "gr-1",
            name: "Padma River Deshi Ilish (Fresh Catch)",
            category: "🐟 Fresh Fish",
            unit: "1 kg (Whole Fish)",
            price: 1650,
            originalPrice: 1850,
            emoji: "🐟",
            origin: "Chandpur Ghat",
            freshnessBadge: "River Fresh",
            inStock: true
        ),
        GroceryItem(
            id: "gr-2",
            name: "Fresh Deshi Chicken (Skin-off Dressed)",
            category: "🥩 Meat & Poultry",
            unit: "1 kg Pack",
            price: 380,
            originalPrice: 420,
            emoji: "🍗",
            origin: "Local Farm",
            freshnessBadge: "Antibiotic Free",
            inStock: true
        ),
        GroceryItem(
            id: "gr-3",
            name: "Premium Miniket Rice (Thin Grain)",
            category: "🌾 Rice & Oil",
            unit: "5 kg Bag",
            price: 410,
            originalPrice: 440,
            emoji: "🍚",
            origin: "Dinajpur Mills",
            freshnessBadge: "100% Sorted",
            inStock: true
        ),
        GroceryItem(
            id: "gr-4",
            name: "Rupchanda Fortified Soybean Oil",
            category: "🌾 Rice & Oil",
            unit: "5 Liter Bottle",
            price: 920,
            originalPrice: 950,
            emoji: "🛢️",
            origin: "BEOL Bangladesh",
            freshnessBadge: "Vitamin A",
            inStock: true
        ),
        GroceryItem(
            id: "gr-5",
            name: "Radhuni Pure Mustard Oil (Cold Pressed)",
            category: "🌾 Rice & Oil",
            unit: "1 Liter Bottle",
            price: 310,
            originalPrice: 330,
            emoji: "🧴",
            origin: "Square Consumer",
            freshnessBadge: "Kachi Ghani",
            inStock: true
        ),
        GroceryItem(
            id: "gr-6",
            name: "Farm Fresh Brown Layer Eggs",
            category: "🥛 Dairy & Eggs",
            unit: "12 Pieces (Dozen)",
            price: 165,
            originalPrice: 180,
            emoji: "🥚",
            origin: "Gazipur Poultry",
            freshnessBadge: "Daily Fresh",
            inStock: true
        ),
        GroceryItem(
            id: "gr-7",
            name: "Fresh Red Potatoes (Deshi Alu)",
            category: "🥦 Fresh Vegetables",
            unit: "1 kg Pack",
            price: 55,
            originalPrice: 65,
            emoji: "🥔",
            origin: "Bogra Farms",
            freshnessBadge: "Farm Harvest",
            inStock: true
        ),
        GroceryItem(
            id: "gr-8",
            name: "Fresh Green Chillies & Coriander Leaves",
            category: "🥦 Fresh Vegetables",
            unit: "250g Combo",
            price: 40,
            originalPrice: 50,
            emoji: "🌶️",
            origin: "Manikganj Bazaar",
            freshnessBadge: "Morning Picked",
            inStock: true
        ),
        GroceryItem(
            id: "gr-9",
            name: "Aarong Dairy Pure Pasteurized Liquid Milk",
            category: "🥛 Dairy & Eggs",
            unit: "1 Liter Pouch",
            price: 95,
            originalPrice: nil,
            emoji: "🥛",
            origin: "BRAC Dairy",
            freshnessBadge: "Chilled",
            inStock: true
        ),
        GroceryItem(
            id: "gr-10",
            name: "Halal Beef Curry Cut (Bone-in)",
            category: "🥩 Meat & Poultry",
            unit: "1 kg Pack",
            price: 780,
            originalPrice: 820,
            emoji: "🥩",
            origin: "Bengal Meat",
            freshnessBadge: "Daily Butchered",
            inStock: true
        )
    ]

    private var filteredItems: [GroceryItem] {
        groceryCatalog.filter { item in
            let matchesCategory = (selectedCategory == "All" || item.category == selectedCategory)
            let matchesSearch = searchQuery.isEmpty ||
                item.name.localizedCaseInsensitiveContains(searchQuery) ||
                item.category.localizedCaseInsensitiveContains(searchQuery) ||
                item.origin.localizedCaseInsensitiveContains(searchQuery)
            return matchesCategory && matchesSearch
        }
    }

    private var basketTotal: Double {
        cart.reduce(0) { total, pair in
            if let item = groceryCatalog.first(where: { $0.id == pair.key }) {
                return total + (item.price * Double(pair.value))
            }
            return total
        }
    }

    private var basketItemCount: Int {
        cart.values.reduce(0, +)
    }

    private let freeDeliveryThreshold: Double = 800.0

    public var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            topControlBar

            // Expandable Search Bar
            if isSearchActive {
                expandableSearchBar
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            ScrollView {
                VStack(spacing: 14) {
                    // Express 1-Hour Slot & Location Context
                    deliveryContextBar

                    // Free Delivery Progress Banner
                    freeDeliveryProgressBar

                    // Bazaar Categories Bar
                    categoryFilterBar

                    // Grocery Items Grid / Rows
                    groceryItemsList
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.vertical, KivorlySpacing.md)
            }

            // Floating Live Basket Bar (if items in cart)
            if basketItemCount > 0 {
                floatingBasketBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(isPresented: $showSlotSheet) {
            slotSelectorModal
        }
        .sheet(isPresented: $showBasketSheet) {
            basketCheckoutSheet
        }
        .sheet(isPresented: $showOrderConfirmed) {
            orderSuccessModal
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
                Image(ServiceType.grocery.assetImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)

                Text(ServiceType.grocery.title)
                    .font(KivorlyTypography.titleSmall)
                    .foregroundColor(Color(uiColor: .label))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(uiColor: .systemBackground))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)

            Spacer()

            HStack(spacing: 8) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearchActive.toggle()
                        if !isSearchActive { searchQuery = "" }
                    }
                }) {
                    Circle()
                        .fill(isSearchActive ? ServiceType.grocery.accentTint : Color(uiColor: .systemBackground))
                        .frame(width: 42, height: 42)
                        .overlay(
                            Image(systemName: isSearchActive ? "xmark" : "magnifyingglass")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(isSearchActive ? .white : Color(uiColor: .label))
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)
                }

                Button(action: { showBasketSheet = true }) {
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(Color(uiColor: .systemBackground))
                            .frame(width: 42, height: 42)
                            .overlay(
                                Image(systemName: "basket.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(ServiceType.grocery.accentTint)
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)

                        if basketItemCount > 0 {
                            Text("\(basketItemCount)")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(ServiceType.grocery.accentTint)
                                .clipShape(Capsule())
                                .offset(x: 4, y: -2)
                        }
                    }
                }
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
            TextField("Search fresh fish, vegetables, rice...", text: $searchQuery)
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

    // MARK: - Delivery Context & Slot Selector
    private var deliveryContextBar: some View {
        Button(action: { showSlotSheet = true }) {
            HStack(spacing: 8) {
                Image(systemName: "bolt.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(ServiceType.grocery.accentTint)

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(deliverySlot)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }

                    Text("Delivering to MD Shoaib Khan • Gulshan 2, Dhaka")
                        .font(.system(size: 10))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }

                Spacer()

                Text("Slot")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(ServiceType.grocery.accentTint)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(ServiceType.grocery.accentTint.opacity(0.12))
                    .clipShape(Capsule())
            }
            .padding(12)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Color.black.opacity(0.04), radius: 4, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Free Delivery Progress Bar
    private var freeDeliveryProgressBar: some View {
        let diff = max(0, freeDeliveryThreshold - basketTotal)
        let progress = min(1.0, basketTotal / freeDeliveryThreshold)

        return VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(diff == 0 ? "🎉 Congratulations! FREE Express Delivery Unlocked" : "Add ৳\(Int(diff)) more for FREE Express Delivery")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(diff == 0 ? .green : Color(uiColor: .label))

                Spacer()

                Text(diff == 0 ? "Free" : "Threshold ৳\(Int(freeDeliveryThreshold))")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(ServiceType.grocery.accentTint)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(uiColor: .tertiarySystemFill))
                        .frame(height: 6)

                    Capsule()
                        .fill(diff == 0 ? Color.green : ServiceType.grocery.accentTint)
                        .frame(width: geo.size.width * CGFloat(progress), height: 6)
                }
            }
            .frame(height: 6)
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 4, y: 1)
    }

    // MARK: - Category Filter Bar
    private var categoryFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories, id: \.self) { cat in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedCategory = cat
                        }
                    }) {
                        Text(cat)
                            .font(.system(size: 12, weight: .bold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(
                                selectedCategory == cat ?
                                ServiceType.grocery.accentTint :
                                Color(uiColor: .secondarySystemGroupedBackground)
                            )
                            .foregroundColor(
                                selectedCategory == cat ? .white : Color(uiColor: .label)
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(
                                        selectedCategory == cat ? Color.clear : Color(uiColor: .separator).opacity(0.4),
                                        lineWidth: 0.8
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    // MARK: - Grocery Items List
    private var groceryItemsList: some View {
        VStack(spacing: 10) {
            ForEach(filteredItems) { item in
                groceryItemRow(for: item)
            }
        }
    }

    private func groceryItemRow(for item: GroceryItem) -> some View {
        let count = cart[item.id] ?? 0

        return HStack(spacing: 12) {
            // Freshness Container
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(ServiceType.grocery.accentTint.opacity(0.1))
                    .frame(width: 54, height: 54)

                Text(item.emoji)
                    .font(.system(size: 32))
            }

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(uiColor: .label))
                    .lineLimit(1)

                HStack(spacing: 6) {
                    Text(item.unit)
                        .font(.system(size: 11))
                        .foregroundColor(Color(uiColor: .secondaryLabel))

                    Text("•")
                        .foregroundColor(Color(uiColor: .tertiaryLabel))

                    Text(item.origin)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(ServiceType.grocery.accentTint)
                }

                // Freshness Badge
                Text(item.freshnessBadge)
                    .font(.system(size: 9, weight: .black))
                    .foregroundColor(.green)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.green.opacity(0.12))
                    .clipShape(Capsule())
            }

            Spacer()

            // Price & Stepper
            VStack(alignment: .trailing, spacing: 6) {
                HStack(alignment: .bottom, spacing: 4) {
                    Text("৳\(Int(item.price))")
                        .font(.system(size: 15, weight: .black))
                        .foregroundColor(ServiceType.grocery.accentTint)

                    if let orig = item.originalPrice {
                        Text("৳\(Int(orig))")
                            .font(.system(size: 10))
                            .strikethrough()
                            .foregroundColor(Color(uiColor: .tertiaryLabel))
                    }
                }

                // In-line Stepper
                if count == 0 {
                    Button(action: {
                        cart[item.id] = 1
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                                .font(.system(size: 10, weight: .bold))
                            Text("Add")
                                .font(.system(size: 11, weight: .black))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 6)
                        .background(ServiceType.grocery.accentTint)
                        .clipShape(Capsule())
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    HStack(spacing: 8) {
                        Button(action: {
                            if count > 1 {
                                cart[item.id] = count - 1
                            } else {
                                cart.removeValue(forKey: item.id)
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(ServiceType.grocery.accentTint)
                                .frame(width: 24, height: 24)
                                .background(ServiceType.grocery.accentTint.opacity(0.15))
                                .clipShape(Circle())
                        }

                        Text("\(count)")
                            .font(.system(size: 13, weight: .bold))
                            .frame(minWidth: 16)

                        Button(action: {
                            cart[item.id] = count + 1
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background(ServiceType.grocery.accentTint)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(Color(uiColor: .tertiarySystemFill))
                    .clipShape(Capsule())
                }
            }
        }
        .padding(12)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: Color.black.opacity(0.03), radius: 4, y: 1)
    }

    // MARK: - Floating Basket Bar
    private var floatingBasketBar: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(basketItemCount) \(basketItemCount == 1 ? "Item" : "Items") in Basket")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))

                Text("৳\(Int(basketTotal))")
                    .font(.system(size: 19, weight: .black))
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: { showBasketSheet = true }) {
                HStack(spacing: 6) {
                    Text("View Basket & Checkout")
                        .font(.system(size: 13, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundColor(ServiceType.grocery.accentTint)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(ServiceType.grocery.accentTint)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.bottom, 8)
        .shadow(color: ServiceType.grocery.accentTint.opacity(0.35), radius: 10, y: 4)
    }

    // MARK: - Delivery Slot Selector Modal
    private var slotSelectorModal: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 14) {
                Text("Choose Delivery Time Slot")
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
                    .padding(.top, 10)

                VStack(spacing: 10) {
                    ForEach(availableSlots, id: \.self) { slot in
                        Button(action: {
                            deliverySlot = slot
                            showSlotSheet = false
                        }) {
                            HStack {
                                Text(slot)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(uiColor: .label))

                                Spacer()

                                if deliverySlot == slot {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(ServiceType.grocery.accentTint)
                                }
                            }
                            .padding(14)
                            .background(
                                deliverySlot == slot ?
                                ServiceType.grocery.accentTint.opacity(0.12) :
                                Color(uiColor: .secondarySystemGroupedBackground)
                            )
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(deliverySlot == slot ? ServiceType.grocery.accentTint : Color.clear, lineWidth: 1.5)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                Spacer()
            }
            .padding(16)
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Delivery Slot")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { showSlotSheet = false }
                }
            }
        }
    }

    // MARK: - Basket Checkout Sheet
    private var basketCheckoutSheet: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if basketItemCount == 0 {
                    VStack(spacing: 12) {
                        Image(systemName: "basket")
                            .font(.system(size: 54))
                            .foregroundColor(Color(uiColor: .tertiaryLabel))
                        Text("Your Grocery Basket is Empty")
                            .font(KivorlyTypography.titleMedium)
                        Text("Add fresh fish, vegetables, or pantry essentials!")
                            .font(KivorlyTypography.caption)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 14) {
                            // Basket Items
                            VStack(spacing: 10) {
                                ForEach(cart.sorted(by: { $0.key < $1.key }), id: \.key) { key, qty in
                                    if let item = groceryCatalog.first(where: { $0.id == key }) {
                                        HStack(spacing: 12) {
                                            Text(item.emoji)
                                                .font(.system(size: 26))
                                                .frame(width: 42, height: 42)
                                                .background(ServiceType.grocery.accentTint.opacity(0.1))
                                                .cornerRadius(10)

                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(item.name)
                                                    .font(.system(size: 13, weight: .bold))
                                                    .foregroundColor(Color(uiColor: .label))
                                                    .lineLimit(1)

                                                Text(item.unit)
                                                    .font(.system(size: 11))
                                                    .foregroundColor(Color(uiColor: .secondaryLabel))

                                                Text("৳\(Int(item.price * Double(qty)))")
                                                    .font(.system(size: 13, weight: .black))
                                                    .foregroundColor(ServiceType.grocery.accentTint)
                                            }

                                            Spacer()

                                            HStack(spacing: 8) {
                                                Button(action: {
                                                    if qty > 1 {
                                                        cart[key] = qty - 1
                                                    } else {
                                                        cart.removeValue(forKey: key)
                                                    }
                                                }) {
                                                    Image(systemName: "minus.circle.fill")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(Color(uiColor: .tertiaryLabel))
                                                }

                                                Text("\(qty)")
                                                    .font(.system(size: 13, weight: .bold))
                                                    .frame(minWidth: 18)

                                                Button(action: {
                                                    cart[key] = qty + 1
                                                }) {
                                                    Image(systemName: "plus.circle.fill")
                                                        .font(.system(size: 20))
                                                        .foregroundColor(ServiceType.grocery.accentTint)
                                                }
                                            }
                                        }
                                        .padding(10)
                                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                                        .cornerRadius(12)
                                    }
                                }
                            }

                            // Slot & Address
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Delivery Details")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))

                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Image(systemName: "clock.fill")
                                            .foregroundColor(ServiceType.grocery.accentTint)
                                        Text(deliverySlot)
                                            .font(.system(size: 12, weight: .bold))
                                    }
                                    HStack {
                                        Image(systemName: "mappin.fill")
                                            .foregroundColor(.red)
                                        Text("MD Shoaib Khan • Gulshan 2 (Road 71, Flat 4B)")
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(uiColor: .secondaryLabel))
                                    }
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color(uiColor: .secondarySystemGroupedBackground))
                                .cornerRadius(12)
                            }

                            // Payment Method
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Payment Method")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))

                                HStack(spacing: 8) {
                                    paymentPill(title: "bKash", isSelected: selectedPaymentMethod == "bKash") {
                                        selectedPaymentMethod = "bKash"
                                    }
                                    paymentPill(title: "Nagad", isSelected: selectedPaymentMethod == "Nagad") {
                                        selectedPaymentMethod = "Nagad"
                                    }
                                    paymentPill(title: "Cash on Delivery", isSelected: selectedPaymentMethod == "COD") {
                                        selectedPaymentMethod = "COD"
                                    }
                                }
                            }

                            // Bill Summary
                            let deliveryFee = basketTotal >= freeDeliveryThreshold ? 0.0 : 40.0
                            VStack(spacing: 6) {
                                HStack {
                                    Text("Groceries Subtotal")
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                    Spacer()
                                    Text("৳\(Int(basketTotal))")
                                        .fontWeight(.semibold)
                                }
                                HStack {
                                    Text("Delivery Charge")
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                    Spacer()
                                    Text(deliveryFee == 0 ? "Free" : "৳\(Int(deliveryFee))")
                                        .fontWeight(.bold)
                                        .foregroundColor(deliveryFee == 0 ? .green : Color(uiColor: .label))
                                }
                                Divider()
                                HStack {
                                    Text("Total Amount")
                                        .font(.system(size: 15, weight: .bold))
                                    Spacer()
                                    Text("৳\(Int(basketTotal + deliveryFee))")
                                        .font(.system(size: 18, weight: .black))
                                        .foregroundColor(ServiceType.grocery.accentTint)
                                }
                            }
                            .font(.system(size: 12))
                            .padding(12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(12)
                        }
                        .padding(16)
                    }

                    // Confirm Order Button
                    Button(action: {
                        confirmedOrderId = "KVG-\(Int.random(in: 100000...999999))-BD"
                        cart.removeAll()
                        showBasketSheet = false
                        showOrderConfirmed = true
                    }) {
                        HStack(spacing: 6) {
                            Text("Confirm Grocery Order")
                                .font(KivorlyTypography.titleSmall)
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(ServiceType.grocery.accentTint)
                        .clipShape(Capsule())
                        .shadow(color: ServiceType.grocery.accentTint.opacity(0.3), radius: 6, y: 2)
                    }
                    .padding(16)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                }
            }
            .navigationTitle("Grocery Basket")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { showBasketSheet = false }
                }
            }
        }
    }

    private func paymentPill(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 11, weight: isSelected ? .bold : .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    isSelected ? ServiceType.grocery.accentTint.opacity(0.12) : Color(uiColor: .secondarySystemGroupedBackground)
                )
                .foregroundColor(isSelected ? ServiceType.grocery.accentTint : Color(uiColor: .secondaryLabel))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isSelected ? ServiceType.grocery.accentTint : Color(uiColor: .separator).opacity(0.4), lineWidth: 1)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Order Success Modal
    private var orderSuccessModal: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.12))
                        .frame(width: 90, height: 90)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.green)
                }

                VStack(spacing: 6) {
                    Text("Grocery Order Placed!")
                        .font(KivorlyTypography.titleMedium)
                        .foregroundColor(Color(uiColor: .label))

                    Text("Order ID: \(confirmedOrderId)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(ServiceType.grocery.accentTint)

                    Text("Our fulfillment center is packing your fresh items now. Estimated arrival in \(deliverySlot) to Gulshan 2, Dhaka.")
                        .font(KivorlyTypography.caption)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Spacer()

                Button(action: { showOrderConfirmed = false }) {
                    Text("Back to Grocery")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(ServiceType.grocery.accentTint)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        }
    }
}
