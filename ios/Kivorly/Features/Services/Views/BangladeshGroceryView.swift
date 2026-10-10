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
    public let imageAssetName: String
    public let imageUrl: String
    public let itemDescription: String
    public let storageGuide: String

    public init(
        id: String,
        name: String,
        category: String,
        unit: String,
        price: Double,
        originalPrice: Double?,
        emoji: String,
        origin: String,
        freshnessBadge: String,
        inStock: Bool,
        imageAssetName: String = "",
        imageUrl: String = "",
        itemDescription: String = "",
        storageGuide: String = "Store in a cool dry place or refrigerate immediately upon arrival."
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.unit = unit
        self.price = price
        self.originalPrice = originalPrice
        self.emoji = emoji
        self.origin = origin
        self.freshnessBadge = freshnessBadge
        self.inStock = inStock
        self.imageAssetName = imageAssetName
        self.imageUrl = imageUrl
        self.itemDescription = itemDescription
        self.storageGuide = storageGuide
    }
}

// MARK: - Reusable Real High Quality Grocery Stock Image
public struct GroceryItemImageView: View {
    public let assetName: String
    public let imageUrl: String
    public let emojiFallback: String
    public var size: CGFloat?
    public var height: CGFloat?
    public var cornerRadius: CGFloat
    public var contentMode: ContentMode

    public init(
        assetName: String,
        imageUrl: String = "",
        emojiFallback: String,
        size: CGFloat? = 58,
        height: CGFloat? = nil,
        cornerRadius: CGFloat = 12,
        contentMode: ContentMode = .fill
    ) {
        self.assetName = assetName
        self.imageUrl = imageUrl
        self.emojiFallback = emojiFallback
        self.size = size
        self.height = height
        self.cornerRadius = cornerRadius
        self.contentMode = contentMode
    }

    public var body: some View {
        ZStack {
            Color(uiColor: .secondarySystemFill)

            if !assetName.isEmpty, let uiImage = UIImage(named: assetName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if !imageUrl.isEmpty, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color(uiColor: .tertiarySystemFill)
                            ProgressView()
                                .scaleEffect(0.6)
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                    case .failure:
                        fallbackView
                    @unknown default:
                        fallbackView
                    }
                }
            } else {
                fallbackView
            }
        }
        .modifier(GroceryImageFrameModifier(size: size, height: height))
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    private var fallbackView: some View {
        ZStack {
            Color(uiColor: .tertiarySystemFill)
            Text(emojiFallback)
                .font(.system(size: (height ?? size ?? 58) * 0.35))
        }
    }
}

fileprivate struct GroceryImageFrameModifier: ViewModifier {
    let size: CGFloat?
    let height: CGFloat?

    func body(content: Content) -> some View {
        if let h = height {
            content
                .frame(maxWidth: .infinity)
                .frame(height: h)
        } else if let s = size {
            content
                .frame(width: s, height: s)
        } else {
            content
                .frame(width: 58, height: 58)
        }
    }
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

    // Cart & Detail Management
    @State private var cart: [String: Int] = [:] // itemId: quantity
    @State private var showBasketSheet: Bool = false
    @State private var selectedItemForDetail: GroceryItem? = nil

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
            inStock: true,
            imageAssetName: "grocery_ilish_fish",
            imageUrl: "https://images.unsplash.com/photo-1534482421-64566f976cfa?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Authentic wild Padma River silver Hilsha sourced directly from Chandpur Ghat. Prized for its rich oily marbling, tender texture, and signature aroma. Perfect for traditional Shorshe Ilish, Ilish Bhaja, and Panta Ilish.",
            storageGuide: "Keep refrigerated between 0°C to 4°C and cook within 24 hours, or freeze immediately."
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
            inStock: true,
            imageAssetName: "grocery_chicken_meat",
            imageUrl: "https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Naturally raised village poultry from local farms. Cleaned, dressed, and skin-off cut into standard curry pieces. Completely antibiotic-free with tender, organic flavor.",
            storageGuide: "Store chilled below 4°C and cook within 48 hours."
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
            inStock: true,
            imageAssetName: "grocery_miniket_rice",
            imageUrl: "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Aged Miniket rice from the paddy fields of Dinajpur. Double-polished, extra-thin grain that cooks fluffy, non-sticky, and aromatic.",
            storageGuide: "Store in an airtight container in a dry, ventilated pantry."
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
            inStock: true,
            imageAssetName: "grocery_soybean_oil",
            imageUrl: "https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Triple-refined pure soybean oil enriched with essential Vitamin A by BEOL Bangladesh. Light, odorless, and perfect for high-temperature frying and daily curries.",
            storageGuide: "Keep away from direct sunlight; seal lid tightly after use."
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
            inStock: true,
            imageAssetName: "grocery_mustard_oil",
            imageUrl: "https://images.unsplash.com/photo-1471864190281-a93a3070b6de?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Cold-pressed Kachi Ghani mustard oil prepared from select mustard seeds. Brings the classic pungent kick, aroma, and rich golden color to traditional bhortas and pickles.",
            storageGuide: "Store in a cool, dark place away from heat."
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
            inStock: true,
            imageAssetName: "grocery_brown_eggs",
            imageUrl: "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Clean, graded brown layer eggs collected daily from bio-secure farms in Gazipur. Rich golden yolks with high protein and essential vitamins.",
            storageGuide: "Keep refrigerated pointy end down for maximum freshness."
        ),
        GroceryItem(
            id: "gr-7",
            name: "Fresh Red Potatoes (Deshi Alu)",
            category: "🥬 Fresh Vegetables",
            unit: "1 kg Pack",
            price: 55,
            originalPrice: 65,
            emoji: "🥔",
            origin: "Bogra Farms",
            freshnessBadge: "Farm Harvest",
            inStock: true,
            imageAssetName: "grocery_red_potatoes",
            imageUrl: "https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Famous Bogra red soil potatoes. Firm texture and naturally sweet earthiness that absorbs rich spices during curries, alu bhaji, and bhortaa.",
            storageGuide: "Store in a cool, dark, well-ventilated basket; do not refrigerate."
        ),
        GroceryItem(
            id: "gr-8",
            name: "Fresh Green Chillies & Coriander Leaves",
            category: "🥬 Fresh Vegetables",
            unit: "250g Combo",
            price: 40,
            originalPrice: 50,
            emoji: "🌶️",
            origin: "Manikganj Bazaar",
            freshnessBadge: "Morning Picked",
            inStock: true,
            imageAssetName: "grocery_green_chillies",
            imageUrl: "https://images.unsplash.com/photo-1588252303782-cb80119abd6d?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Spicy vibrant green chillies paired with fragrant fresh cilantro coriander leaves. Freshly harvested at dawn from Manikganj.",
            storageGuide: "Wrap stems in dry paper towel and refrigerate in crisper drawer."
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
            inStock: true,
            imageAssetName: "grocery_fresh_milk",
            imageUrl: "https://images.unsplash.com/photo-1550583724-b2692b85b150?w=600&auto=format&fit=crop&q=80",
            itemDescription: "100% pure cow milk pasteurized and chilled under stringent food safety standards by BRAC Dairy. Rich source of calcium and protein.",
            storageGuide: "Keep refrigerated at 4°C at all times; boil before drinking once pouch is opened."
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
            inStock: true,
            imageAssetName: "grocery_beef_cut",
            imageUrl: "https://images.unsplash.com/photo-1603048588665-791ca8aea617?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Premium halal young bull beef prepared by Bengal Meat. Expertly butchered into bone-in curry cubes for rich gravy bhuna, rezala, and tehari.",
            storageGuide: "Keep chilled or freeze at -18°C for long-term storage."
        ),
        GroceryItem(
            id: "gr-11",
            name: "Fresh Red Onions (Deshi Peyaj)",
            category: "🥬 Fresh Vegetables",
            unit: "1 kg Pack",
            price: 75,
            originalPrice: 85,
            emoji: "🧅",
            origin: "Faridpur Farms",
            freshnessBadge: "New Harvest",
            inStock: true,
            imageAssetName: "grocery_red_onions",
            imageUrl: "https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Locally grown pungent red shallot onions from Faridpur. Crisp texture with sharp savory flavor essential for curries, biryani beresta, and salads.",
            storageGuide: "Store in a breathable wire basket in a dry shaded corner."
        ),
        GroceryItem(
            id: "gr-12",
            name: "Farm Fresh Ripe Tomatoes",
            category: "🥬 Fresh Vegetables",
            unit: "1 kg Pack",
            price: 60,
            originalPrice: 70,
            emoji: "🍅",
            origin: "Narsingdi Harvest",
            freshnessBadge: "Vine Ripe",
            inStock: true,
            imageAssetName: "grocery_ripe_tomatoes",
            imageUrl: "https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Plump, naturally vine-ripened red tomatoes from Narsingdi growers. Balanced sweet and tangy acidity for salads, sauces, and slow-simmered fish gravies.",
            storageGuide: "Store at room temperature until fully ripe, then refrigerate."
        ),
        GroceryItem(
            id: "gr-13",
            name: "Radhuni Pure Spices Combo Pack",
            category: "🌶️ Spices & Salt",
            unit: "400g (Turmeric + Chili)",
            price: 260,
            originalPrice: 290,
            emoji: "🧂",
            origin: "Square Consumer",
            freshnessBadge: "100% Pure",
            inStock: true,
            imageAssetName: "grocery_spices_combo",
            imageUrl: "https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=600&auto=format&fit=crop&q=80",
            itemDescription: "Authentic 400g combo pack containing pure turmeric and chili powders. Milled from sun-dried whole spices without artificial colors or preservatives.",
            storageGuide: "Store in an airtight jar away from steam and humidity."
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

    private let groceryPromoSlides: [ServicePromoSlide] = [
        ServicePromoSlide(
            id: "gr-slide-1",
            tag: "RIVER FRESH",
            title: "Padma River Deshi Ilish",
            subtitle: "Wild Hilsha caught fresh daily from Chandpur Ghat with authentic aroma.",
            actionTitle: "Shop Fresh",
            imageAssetName: "hero_grocery_ilish"
        ),
        ServicePromoSlide(
            id: "gr-slide-2",
            tag: "FREE DELIVERY",
            title: "Zero Express Delivery Fee",
            subtitle: "Add ৳800 or more in fresh groceries and unlock free 1-hour doorstep delivery.",
            actionTitle: "Fill Basket",
            imageAssetName: "hero_grocery_basket"
        ),
        ServicePromoSlide(
            id: "gr-slide-3",
            tag: "100% TESTED",
            title: "Formalin-Free Farm Harvest",
            subtitle: "Strictly tested daily vegetables and milk from Bogra and Manikganj growers.",
            actionTitle: "Explore",
            imageAssetName: "hero_grocery_organic"
        )
    ]

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
                    // Top Promotional Carousel
                    ServiceTopCarouselView(
                        service: .grocery,
                        slides: groceryPromoSlides
                    )
                    // Express 1-Hour Slot & Location Context (Shows when items are picked/added)
                    if basketItemCount > 0 {
                        deliveryContextBar
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // Free Delivery Progress Banner (Shows when items are picked/added)
                    if basketItemCount > 0 {
                        freeDeliveryProgressBar
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }

                    // Bazaar Categories Bar
                    categoryFilterBar

                    // 2 by 2 Grocery Items Grid
                    groceryItemsGrid
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.vertical, KivorlySpacing.md)
                .animation(.easeInOut(duration: 0.25), value: basketItemCount > 0)
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
        .sheet(item: $selectedItemForDetail) { item in
            groceryItemDetailSheet(for: item)
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

    // MARK: - 2 by 2 Grocery Items Grid
    private let gridColumns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var groceryItemsGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 12) {
            ForEach(filteredItems) { item in
                groceryItemCard(for: item)
            }
        }
    }

    private func groceryItemCard(for item: GroceryItem) -> some View {
        let count = cart[item.id] ?? 0

        return Button(action: {
            selectedItemForDetail = item
        }) {
            VStack(alignment: .leading, spacing: 0) {
                // Top Image Container with badges
                ZStack(alignment: .topLeading) {
                    GroceryItemImageView(
                        assetName: item.imageAssetName,
                        imageUrl: item.imageUrl,
                        emojiFallback: item.emoji,
                        height: 125,
                        cornerRadius: 14,
                        contentMode: .fill
                    )

                    // Freshness Badge (Top Leading)
                    Text(item.freshnessBadge)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.green)
                        .clipShape(Capsule())
                        .padding(6)

                    // Discount Badge (Top Trailing)
                    if let orig = item.originalPrice, orig > item.price {
                        let savings = Int(((orig - item.price) / orig) * 100)
                        HStack {
                            Spacer()
                            Text("\(savings)% OFF")
                                .font(.system(size: 9, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 3)
                                .background(Color.red)
                                .clipShape(Capsule())
                                .padding(6)
                        }
                    }
                }

                // Info Area
                VStack(alignment: .leading, spacing: 4) {
                    // Origin & Unit
                    HStack(spacing: 4) {
                        Text(item.origin)
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(ServiceType.grocery.accentTint)
                            .lineLimit(1)
                        Text("•")
                            .font(.system(size: 10))
                            .foregroundColor(Color(uiColor: .tertiaryLabel))
                        Text(item.unit)
                            .font(.system(size: 10))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .lineLimit(1)
                    }
                    .padding(.top, 8)

                    // Item Name (Fixed 2 lines height)
                    Text(item.name)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(uiColor: .label))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 32, alignment: .topLeading)

                    Spacer(minLength: 4)

                    // Price & Stepper Row
                    HStack(alignment: .bottom, spacing: 4) {
                        VStack(alignment: .leading, spacing: 1) {
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

                        Spacer()

                        // Add / Quantity Stepper Button
                        if count == 0 {
                            Button(action: {
                                cart[item.id] = 1
                            }) {
                                HStack(spacing: 3) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 9, weight: .bold))
                                    Text("Add")
                                        .font(.system(size: 11, weight: .bold))
                                }
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(ServiceType.grocery.accentTint)
                                .clipShape(Capsule())
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            HStack(spacing: 6) {
                                Button(action: {
                                    if count > 1 {
                                        cart[item.id] = count - 1
                                    } else {
                                        cart.removeValue(forKey: item.id)
                                    }
                                }) {
                                    Image(systemName: "minus")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(ServiceType.grocery.accentTint)
                                        .frame(width: 20, height: 20)
                                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                                        .clipShape(Circle())
                                }

                                Text("\(count)")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(Color(uiColor: .label))
                                    .frame(minWidth: 12)

                                Button(action: {
                                    cart[item.id] = count + 1
                                }) {
                                    Image(systemName: "plus")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                        .background(ServiceType.grocery.accentTint)
                                        .clipShape(Circle())
                                }
                            }
                            .padding(.horizontal, 4)
                            .padding(.vertical, 3)
                            .background(Color(uiColor: .tertiarySystemFill))
                            .clipShape(Capsule())
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(uiColor: .separator).opacity(0.2), lineWidth: 0.8)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Grocery Item Detail Sheet
    private func groceryItemDetailSheet(for item: GroceryItem) -> some View {
        let count = cart[item.id] ?? 0
        let itemSavings: Double? = item.originalPrice.map { $0 - item.price }

        return NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Big Stock Image Container
                    ZStack(alignment: .topTrailing) {
                        GroceryItemImageView(
                            assetName: item.imageAssetName,
                            imageUrl: item.imageUrl,
                            emojiFallback: item.emoji,
                            height: 240,
                            cornerRadius: 20,
                            contentMode: .fill
                        )

                        // Freshness Badge
                        HStack {
                            Text(item.freshnessBadge)
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.green)
                                .clipShape(Capsule())

                            Spacer()

                            if let orig = item.originalPrice, orig > item.price {
                                let savings = Int(((orig - item.price) / orig) * 100)
                                Text("\(savings)% OFF")
                                    .font(.system(size: 11, weight: .black))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(Color.red)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(14)
                    }

                    // Title & Origin Header
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Text(item.category)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(ServiceType.grocery.accentTint)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(ServiceType.grocery.accentTint.opacity(0.12))
                                .clipShape(Capsule())

                            Spacer()

                            HStack(spacing: 4) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(ServiceType.grocery.accentTint)
                                Text(item.origin)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }
                        }

                        Text(item.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))

                        Text("Pack Size: \(item.unit)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }

                    // Price Section
                    HStack(alignment: .bottom, spacing: 10) {
                        Text("৳\(Int(item.price))")
                            .font(.system(size: 28, weight: .black))
                            .foregroundColor(ServiceType.grocery.accentTint)

                        if let orig = item.originalPrice {
                            Text("৳\(Int(orig))")
                                .font(.system(size: 16, weight: .medium))
                                .strikethrough()
                                .foregroundColor(Color(uiColor: .tertiaryLabel))

                            if let savings = itemSavings, savings > 0 {
                                Text("Save ৳\(Int(savings))")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.green)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.green.opacity(0.12))
                                    .clipShape(Capsule())
                            }
                        }
                    }

                    // Delivery Time & Slot Notice (Shows when picking this item)
                    HStack(spacing: 8) {
                        Image(systemName: "clock.badge.checkmark.fill")
                            .font(.system(size: 14))
                            .foregroundColor(ServiceType.grocery.accentTint)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Delivery Time: \(deliverySlot)")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))

                            Text("Express doorstep dispatch to Gulshan 2, Dhaka")
                                .font(.system(size: 10))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }

                        Spacer()

                        Button(action: { showSlotSheet = true }) {
                            Text("Change")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(ServiceType.grocery.accentTint)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(ServiceType.grocery.accentTint.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }
                    .padding(10)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(12)

                    Divider()

                    // Quality Guarantees
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Kivorly Fresh Guarantee")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))

                        VStack(spacing: 8) {
                            guaranteeRow(
                                icon: "bolt.shield.fill",
                                title: "1-Hour Express Dhaka Delivery",
                                subtitle: "Packed in temperature-controlled bags direct from nearest micro-hub"
                            )
                            guaranteeRow(
                                icon: "leaf.circle.fill",
                                title: "100% Formalin-Free & Tested",
                                subtitle: "Quality checked on arrival every morning at 4:30 AM"
                            )
                            guaranteeRow(
                                icon: "arrow.triangle.2.circlepath.circle.fill",
                                title: "Instant Doorstep Return",
                                subtitle: "Inspect on delivery; return immediately if not completely satisfied"
                            )
                        }
                        .padding(12)
                        .background(Color(uiColor: .secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Product Details")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))

                        Text(item.itemDescription.isEmpty ? "\(item.name) is sourced daily from \(item.origin) to guarantee maximum freshness, premium taste, and nutritional value for authentic Bangladeshi home cooking." : item.itemDescription)
                            .font(.system(size: 13))
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .lineSpacing(3)
                    }

                    // Storage Guide
                    HStack(spacing: 10) {
                        Image(systemName: "thermometer.snowflake")
                            .font(.system(size: 18))
                            .foregroundColor(ServiceType.grocery.accentTint)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Storage Instructions")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))
                            Text(item.storageGuide)
                                .font(.system(size: 11))
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .cornerRadius(12)
                }
                .padding(16)
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("Item Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        selectedItemForDetail = nil
                    }
                    .font(.system(size: 14, weight: .bold))
                }
            }
            .safeAreaInset(edge: .bottom) {
                // Bottom Basket Bar in Sheet
                HStack(spacing: 12) {
                    // Stepper
                    HStack(spacing: 12) {
                        Button(action: {
                            if count > 1 {
                                cart[item.id] = count - 1
                            } else {
                                cart.removeValue(forKey: item.id)
                            }
                        }) {
                            Image(systemName: "minus")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(count > 0 ? Color(uiColor: .label) : Color(uiColor: .tertiaryLabel))
                                .frame(width: 32, height: 32)
                                .background(Color(uiColor: .tertiarySystemFill))
                                .clipShape(Circle())
                        }
                        .disabled(count == 0)

                        Text("\(max(1, count))")
                            .font(.system(size: 16, weight: .bold))
                            .frame(minWidth: 24)

                        Button(action: {
                            cart[item.id] = (count == 0 ? 1 : count + 1)
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(uiColor: .label))
                                .frame(width: 32, height: 32)
                                .background(Color(uiColor: .tertiarySystemFill))
                                .clipShape(Circle())
                        }
                    }
                    .padding(6)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(Capsule())

                    // Action Button (Standard default iPhone button size: 48pt height)
                    Button(action: {
                        if count == 0 {
                            cart[item.id] = 1
                        }
                        selectedItemForDetail = nil
                    }) {
                        HStack {
                            Text(count == 0 ? "Add to Basket" : "Update Basket")
                                .font(.system(size: 15, weight: .bold))
                            Spacer()
                            Text("৳\(Int(item.price * Double(max(1, count))))")
                                .font(.system(size: 15, weight: .black))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .frame(height: 48)
                        .background(ServiceType.grocery.accentTint)
                        .clipShape(Capsule())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(uiColor: .systemBackground))
            }
        }
    }

    private func guaranteeRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(ServiceType.grocery.accentTint)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(uiColor: .label))
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(Color(uiColor: .secondaryLabel))
            }
        }
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
                                            GroceryItemImageView(
                                                assetName: item.imageAssetName,
                                                imageUrl: item.imageUrl,
                                                emojiFallback: item.emoji,
                                                size: 44,
                                                cornerRadius: 8,
                                                contentMode: .fill
                                            )

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
                        confirmGroceryOrder()
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
    private func confirmGroceryOrder() {
        let generatedOrderId = "KVG-\(Int.random(in: 100000...999999))-BD"
        let fee: Double = basketTotal >= freeDeliveryThreshold ? 0.0 : 40.0
        let totalAmt = basketTotal + fee
        let lineItems = cart.compactMap { (itemId, qty) -> OrderLineItem? in
            guard let p = groceryCatalog.first(where: { $0.id == itemId }) else { return nil }
            return OrderLineItem(
                title: p.name,
                subtitle: p.unit,
                quantity: qty,
                price: p.price,
                emoji: p.emoji
            )
        }

        let groceryOrder = SuperAppOrder(
            id: generatedOrderId,
            service: .grocery,
            title: "Daily Fresh Farm & Groceries",
            subtitle: "\(cart.count) item(s) • Fresh Mart Dhaka",
            timestamp: "Just now",
            amount: String(format: "\u{09F3}%.0f", totalAmt),
            rawAmount: totalAmt,
            status: .inProgress,
            etaText: "Arriving in ~25 mins",
            pickupLocation: "Shwapno Express Mart, Gulshan 2",
            destinationLocation: "Road 71, House 14, Flat 4B, Gulshan 2, Dhaka",
            driverOrPartner: OrderPartner(
                name: "Sajjad Hossain",
                role: "Grocery Delivery Partner",
                rating: 4.8,
                completedTrips: 1120,
                phone: "+880 1711-998877",
                vehicleInfo: "Electric Delivery Scooter"
            ),
            securityPin: String(format: "%04d", Int.random(in: 1000...9999)),
            trackingNumber: "GROC-BD-\(Int.random(in: 100000...999999))",
            qrPassCode: nil,
            bookingDetails: nil,
            items: lineItems,
            timelineSteps: [
                OrderTimelineStep(title: "Order Placed", subtitle: "Payment confirmed via \(selectedPaymentMethod)", time: "Just now", isCompleted: true),
                OrderTimelineStep(title: "Packed by Store", subtitle: "Freshly selected from shelf", time: "Just now", isCompleted: true, isCurrent: true),
                OrderTimelineStep(title: "Rider En Route", subtitle: "Heading to your doorstep", time: "Estimated 15m", isCompleted: false),
                OrderTimelineStep(title: "Delivered", subtitle: "Handed over safely", time: "Estimated 25m", isCompleted: false)
            ],
            paymentBreakdown: OrderPaymentBreakdown(
                subtotal: basketTotal,
                deliveryOrFareFee: fee,
                platformFee: 0,
                discount: 0,
                total: totalAmt,
                paymentMethod: selectedPaymentMethod,
                transactionId: "TXN-\(Int.random(in: 10000000...99999999))"
            )
        )
        OrdersManager.shared.addOrder(groceryOrder)

        confirmedOrderId = generatedOrderId
        cart.removeAll()
        showBasketSheet = false
        showOrderConfirmed = true
    }
}
