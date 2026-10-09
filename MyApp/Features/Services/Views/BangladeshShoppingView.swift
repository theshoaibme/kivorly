//
//  BangladeshShoppingView.swift
//  Kivorly
//
//  End-to-End Bangladeshi Online Shopping Experience (Mall & Lifestyle)
//  Features Authentic Brand Stores (Aarong, Yellow, Apex, Walton, Xiaomi),
//  Flash Deals Countdown, 2-Column Product Grid, Variant Selectors (Size/Color),
//  Cart Management, and Checkout in Bangladeshi Taka (৳).
//

import SwiftUI

public struct ShoppingProductItem: Identifiable {
    public let id: String
    public let title: String
    public let brand: String
    public let category: String
    public let originalPrice: Double
    public let discountPrice: Double
    public let discountPercentage: String
    public let rating: Double
    public let reviewCount: Int
    public let iconName: String
    public let emoji: String
    public let availableSizes: [String]
    public let availableColors: [String]
    public let badges: [String]
    public let deliveryTime: String
    public let warrantyText: String
    public let description: String
}

public struct ShoppingCartItem: Identifiable {
    public let id = UUID()
    public let product: ShoppingProductItem
    public var selectedSize: String
    public var selectedColor: String
    public var quantity: Int
}

public struct BangladeshShoppingView: View {
    @Environment(\.dismiss) private var dismiss

    // Search and Filters
    @State private var searchQuery: String = ""
    @State private var isSearchActive: Bool = false
    @State private var selectedCategory: String = "All"
    @State private var selectedBrand: String = "All"

    // Cart State
    @State private var cartItems: [ShoppingCartItem] = []
    @State private var showCartSheet: Bool = false

    // Product Detail Sheet
    @State private var selectedProduct: ShoppingProductItem? = nil
    @State private var detailSelectedSize: String = "M"
    @State private var detailSelectedColor: String = "Navy Blue"
    @State private var detailQuantity: Int = 1

    // Checkout & Confirmation
    @State private var showOrderConfirmation: Bool = false
    @State private var confirmedOrderId: String = ""
    @State private var selectedPaymentMethod: String = "bKash"

    private let categories = [
        "All", "Ethnic & Panjabi", "Casual Wear", "Footwear", "Smartphones & Tech", "Home Living"
    ]

    private let brands = [
        "All", "Aarong", "Yellow", "Apex", "Xiaomi BD", "Walton", "Artisan"
    ]

    private let catalogProducts: [ShoppingProductItem] = [
        ShoppingProductItem(
            id: "sp-1",
            title: "Royal Silk & Cotton Embroidered Panjabi",
            brand: "Aarong",
            category: "Ethnic & Panjabi",
            originalPrice: 4600,
            discountPrice: 3450,
            discountPercentage: "-25%",
            rating: 4.92,
            reviewCount: 1420,
            iconName: "tshirt.fill",
            emoji: "✨",
            availableSizes: ["38", "40", "42", "44"],
            availableColors: ["Royal Navy", "Pearl White", "Golden Beige"],
            badges: ["Official Store", "Handcrafted", "Best Seller"],
            deliveryTime: "Express 24h",
            warrantyText: "7-Day Easy Return",
            description: "Traditional Bangladeshi handloom silk-cotton blend with intricate Nakshi Kantha neck embroidery. Perfect for Eid and weddings."
        ),
        ShoppingProductItem(
            id: "sp-2",
            title: "Slim-Fit Egyptian Cotton Casual Shirt",
            brand: "Yellow",
            category: "Casual Wear",
            originalPrice: 2800,
            discountPrice: 2200,
            discountPercentage: "-21%",
            rating: 4.86,
            reviewCount: 890,
            iconName: "tshirt.fill",
            emoji: "👔",
            availableSizes: ["S", "M", "L", "XL"],
            availableColors: ["Olive Green", "Sky Blue", "Jet Black"],
            badges: ["Official Store", "100% Cotton"],
            deliveryTime: "Next Day",
            warrantyText: "7-Day Easy Return",
            description: "Tailored slim-fit long-sleeve casual shirt crafted with premium breathable Egyptian cotton."
        ),
        ShoppingProductItem(
            id: "sp-3",
            title: "Handcrafted Genuine Leather Oxford Shoes",
            brand: "Apex",
            category: "Footwear",
            originalPrice: 5990,
            discountPrice: 4800,
            discountPercentage: "-20%",
            rating: 4.89,
            reviewCount: 640,
            iconName: "shoeprints.fill",
            emoji: "👞",
            availableSizes: ["40", "41", "42", "43", "44"],
            availableColors: ["Classic Tan", "Deep Mahogany", "Jet Black"],
            badges: ["Genuine Leather", "Memory Foam"],
            deliveryTime: "Next Day",
            warrantyText: "30-Day Leather Guarantee",
            description: "High-grade full-grain cow leather formal shoes with padded inner sole and durable rubber outsole."
        ),
        ShoppingProductItem(
            id: "sp-4",
            title: "Xiaomi Redmi Note 13 Pro 5G (8/256GB)",
            brand: "Xiaomi BD",
            category: "Smartphones & Tech",
            originalPrice: 32999,
            discountPrice: 29999,
            discountPercentage: "-9%",
            rating: 4.95,
            reviewCount: 2150,
            iconName: "iphone",
            emoji: "📱",
            availableSizes: ["8GB/256GB", "12GB/512GB"],
            availableColors: ["Midnight Black", "Aurora Purple", "Ocean Teal"],
            badges: ["Official BTRC Approved", "0% EMI Available"],
            deliveryTime: "Express Same-Day",
            warrantyText: "1-Year Official Warranty",
            description: "200MP OIS Ultra-Clear Camera, 120Hz AMOLED 1.5K Display, 67W Turbo Charge with official national warranty."
        ),
        ShoppingProductItem(
            id: "sp-5",
            title: "Walton Primo 4K Ultra HD Smart TV 43\"",
            brand: "Walton",
            category: "Smartphones & Tech",
            originalPrice: 33500,
            discountPrice: 28500,
            discountPercentage: "-15%",
            rating: 4.84,
            reviewCount: 520,
            iconName: "tv.fill",
            emoji: "📺",
            availableSizes: ["43 Inch", "50 Inch", "55 Inch"],
            availableColors: ["Frameless Black"],
            badges: ["Official Store", "Free Home Setup"],
            deliveryTime: "Scheduled 24h",
            warrantyText: "5-Year Panel Warranty",
            description: "Voice-activated Android TV with Dolby Atmos, Frameless Bezel, HDR10+, and pre-installed YouTube, Netflix & Chorki."
        ),
        ShoppingProductItem(
            id: "sp-6",
            title: "Clay Artisan Ceramic Dinner Set (16 Pcs)",
            brand: "Artisan",
            category: "Home Living",
            originalPrice: 3200,
            discountPrice: 2600,
            discountPercentage: "-18%",
            rating: 4.91,
            reviewCount: 380,
            iconName: "cup.and.saucer.fill",
            emoji: "🏺",
            availableSizes: ["Standard 16 Pcs"],
            availableColors: ["Terracotta Rust", "Earthy Sand", "Glazed Sage"],
            badges: ["Microwave Safe", "Handmade"],
            deliveryTime: "Next Day",
            warrantyText: "Breakage Replacement",
            description: "Handcrafted eco-friendly stoneware ceramic dinner plates, bowls, and serving platters made by Bengal potters."
        )
    ]

    private var filteredProducts: [ShoppingProductItem] {
        catalogProducts.filter { item in
            let matchesCategory = (selectedCategory == "All" || item.category == selectedCategory)
            let matchesBrand = (selectedBrand == "All" || item.brand == selectedBrand)
            let matchesSearch = searchQuery.isEmpty ||
                item.title.localizedCaseInsensitiveContains(searchQuery) ||
                item.brand.localizedCaseInsensitiveContains(searchQuery) ||
                item.category.localizedCaseInsensitiveContains(searchQuery)
            return matchesCategory && matchesBrand && matchesSearch
        }
    }

    private var cartTotal: Double {
        cartItems.reduce(0) { $0 + ($1.product.discountPrice * Double($1.quantity)) }
    }

    private var cartItemCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }

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
                    // Delivery Address Context Chip
                    addressContextBar

                    // Mega Festival Sale Banner
                    festivalSaleBanner

                    // Brand Stores Filter Bar
                    brandStoresFilterBar

                    // Category Filter Pills
                    categoryFilterBar

                    // Clean 2-Column Product Grid
                    productGridSection
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.vertical, KivorlySpacing.md)
            }

            // Floating Bottom Cart Drawer (if cart has items)
            if cartItemCount > 0 {
                floatingCartBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .sheet(item: $selectedProduct) { product in
            productDetailSheet(for: product)
        }
        .sheet(isPresented: $showCartSheet) {
            cartCheckoutSheet
        }
        .sheet(isPresented: $showOrderConfirmation) {
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
                Image(ServiceType.shopping.assetImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)

                Text(ServiceType.shopping.title)
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
                // Search Toggle
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSearchActive.toggle()
                        if !isSearchActive { searchQuery = "" }
                    }
                }) {
                    Circle()
                        .fill(isSearchActive ? ServiceType.shopping.accentTint : Color(uiColor: .systemBackground))
                        .frame(width: 42, height: 42)
                        .overlay(
                            Image(systemName: isSearchActive ? "xmark" : "magnifyingglass")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(isSearchActive ? .white : Color(uiColor: .label))
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)
                }

                // Cart Icon with Badge
                Button(action: { showCartSheet = true }) {
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(Color(uiColor: .systemBackground))
                            .frame(width: 42, height: 42)
                            .overlay(
                                Image(systemName: "bag.fill")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(ServiceType.shopping.accentTint)
                            )
                            .shadow(color: Color.black.opacity(0.08), radius: 6, y: 2)

                        if cartItemCount > 0 {
                            Text("\(cartItemCount)")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(ServiceType.shopping.accentTint)
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
            TextField("Search in Kivorly Mall...", text: $searchQuery)
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

    // MARK: - Address Context Bar
    private var addressContextBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(ServiceType.shopping.accentTint)

            Text("Delivering to MD Shoaib Khan • Gulshan 2, Dhaka")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color(uiColor: .label))
                .lineLimit(1)

            Spacer()

            Text("Change")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(ServiceType.shopping.accentTint)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: Color.black.opacity(0.04), radius: 4, y: 1)
    }

    // MARK: - Festival Sale Banner
    private var festivalSaleBanner: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("🔥 Mega Festival Sale")
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.white.opacity(0.25))
                        .clipShape(Capsule())

                    Text("Up to 40% off")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                }

                Text("Aarong, Yellow, Xiaomi & More")
                    .font(.system(size: 15, weight: .black))
                    .foregroundColor(.white)

                Text("Use Code: KIVEID for extra ৳300 discount")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.85))
            }

            Spacer()

            Text("🛍️")
                .font(.system(size: 42))
        }
        .padding(14)
        .background(
            LinearGradient(
                colors: [Color(red: 0x93 / 255.0, green: 0x33 / 255.0, blue: 0xEA / 255.0), Color(red: 0xC0 / 255.0, green: 0x26 / 255.0, blue: 0xD3 / 255.0)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.purple.opacity(0.25), radius: 8, y: 3)
    }

    // MARK: - Brand Stores Filter Bar
    private var brandStoresFilterBar: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Official Brand Stores")
                .font(.system(size: 11, weight: .black))
                .foregroundColor(Color(uiColor: .secondaryLabel))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(brands, id: \.self) { brand in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                selectedBrand = brand
                            }
                        }) {
                            HStack(spacing: 4) {
                                if brand != "All" {
                                    Image(systemName: "checkmark.seal.fill")
                                        .font(.system(size: 10))
                                        .foregroundColor(selectedBrand == brand ? .white : .blue)
                                }
                                Text(brand)
                                    .font(.system(size: 12, weight: .bold))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                selectedBrand == brand ?
                                ServiceType.shopping.accentTint :
                                Color(uiColor: .secondarySystemGroupedBackground)
                            )
                            .foregroundColor(
                                selectedBrand == brand ? .white : Color(uiColor: .label)
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(
                                        selectedBrand == brand ? Color.clear : Color(uiColor: .separator).opacity(0.4),
                                        lineWidth: 0.8
                                    )
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
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
                                Color(uiColor: .systemFill) :
                                Color(uiColor: .tertiarySystemFill)
                            )
                            .foregroundColor(
                                selectedCategory == cat ? Color(uiColor: .label) : Color(uiColor: .secondaryLabel)
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .strokeBorder(
                                        selectedCategory == cat ? ServiceType.shopping.accentTint : Color.clear,
                                        lineWidth: 1.5
                                    )
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    // MARK: - Product Grid (Clean 2-Column UI)
    private var productGridSection: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            ForEach(filteredProducts) { product in
                productCard(for: product)
            }
        }
    }

    private func productCard(for product: ShoppingProductItem) -> some View {
        Button(action: {
            selectedProduct = product
            detailSelectedSize = product.availableSizes.first ?? "M"
            detailSelectedColor = product.availableColors.first ?? "Black"
            detailQuantity = 1
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // Top Image & Discount Tag Container
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(ServiceType.shopping.accentTint.opacity(0.08))
                        .frame(height: 125)

                    Text(product.emoji)
                        .font(.system(size: 52))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                    // Discount Pill
                    Text(product.discountPercentage)
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.white)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3.5)
                        .background(Color.red)
                        .clipShape(Capsule())
                        .padding(8)
                }

                // Brand & Title
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 3) {
                        Text(product.brand)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(ServiceType.shopping.accentTint)

                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 9))
                            .foregroundColor(.blue)
                    }

                    Text(product.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(uiColor: .label))
                        .lineLimit(2)
                        .frame(height: 34, alignment: .topLeading)
                }

                // Rating & Delivery Tag
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 9))
                        .foregroundColor(.orange)
                    Text(String(format: "%.1f", product.rating))
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(uiColor: .label))

                    Spacer()

                    Text(product.deliveryTime)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }

                // Pricing Row & Quick Add
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("৳\(Int(product.discountPrice))")
                            .font(.system(size: 16, weight: .black))
                            .foregroundColor(ServiceType.shopping.accentTint)

                        Text("৳\(Int(product.originalPrice))")
                            .font(.system(size: 10, weight: .medium))
                            .strikethrough()
                            .foregroundColor(Color(uiColor: .tertiaryLabel))
                    }

                    Spacer()

                    // Add Button
                    Button(action: {
                        addToCart(product: product, size: product.availableSizes.first ?? "M", color: product.availableColors.first ?? "Default")
                    }) {
                        Circle()
                            .fill(ServiceType.shopping.accentTint)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(10)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func addToCart(product: ShoppingProductItem, size: String, color: String, qty: Int = 1) {
        if let idx = cartItems.firstIndex(where: { $0.product.id == product.id && $0.selectedSize == size && $0.selectedColor == color }) {
            cartItems[idx].quantity += qty
        } else {
            cartItems.append(ShoppingCartItem(product: product, selectedSize: size, selectedColor: color, quantity: qty))
        }
    }

    // MARK: - Floating Bottom Cart Drawer
    private var floatingCartBar: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(cartItemCount) \(cartItemCount == 1 ? "Item" : "Items") in Bag")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.85))

                Text("৳\(Int(cartTotal))")
                    .font(.system(size: 19, weight: .black))
                    .foregroundColor(.white)
            }

            Spacer()

            Button(action: { showCartSheet = true }) {
                HStack(spacing: 6) {
                    Text("View Bag & Checkout")
                        .font(.system(size: 13, weight: .bold))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 11, weight: .bold))
                }
                .foregroundColor(ServiceType.shopping.accentTint)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(ServiceType.shopping.accentTint)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, KivorlySpacing.md)
        .padding(.bottom, 8)
        .shadow(color: ServiceType.shopping.accentTint.opacity(0.35), radius: 10, y: 4)
    }

    // MARK: - Product Detail Sheet
    private func productDetailSheet(for product: ShoppingProductItem) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Big Image Container
                    ZStack(alignment: .topTrailing) {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(ServiceType.shopping.accentTint.opacity(0.08))
                            .frame(height: 220)

                        Text(product.emoji)
                            .font(.system(size: 96))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                        Text(product.discountPercentage)
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .padding(14)
                    }

                    // Product Title & Brand
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 4) {
                            Text(product.brand)
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(ServiceType.shopping.accentTint)
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                        }

                        Text(product.title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(uiColor: .label))

                        HStack(spacing: 8) {
                            HStack(spacing: 3) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(.orange)
                                Text(String(format: "%.1f", product.rating))
                                    .font(.system(size: 13, weight: .bold))
                                Text("(\(product.reviewCount) reviews)")
                                    .font(.system(size: 11))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }

                            Text("•")
                                .foregroundColor(Color(uiColor: .tertiaryLabel))

                            Text(product.warrantyText)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(.green)
                        }
                    }

                    // Price Section
                    HStack(alignment: .bottom, spacing: 8) {
                        Text("৳\(Int(product.discountPrice))")
                            .font(.system(size: 26, weight: .black))
                            .foregroundColor(ServiceType.shopping.accentTint)

                        Text("৳\(Int(product.originalPrice))")
                            .font(.system(size: 15, weight: .semibold))
                            .strikethrough()
                            .foregroundColor(Color(uiColor: .tertiaryLabel))
                    }

                    Divider()

                    // Color Selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Color")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(product.availableColors, id: \.self) { color in
                                    Button(action: { detailSelectedColor = color }) {
                                        Text(color)
                                            .font(.system(size: 12, weight: .bold))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 7)
                                            .background(
                                                detailSelectedColor == color ?
                                                ServiceType.shopping.accentTint.opacity(0.12) :
                                                Color(uiColor: .tertiarySystemFill)
                                            )
                                            .foregroundColor(
                                                detailSelectedColor == color ?
                                                ServiceType.shopping.accentTint :
                                                Color(uiColor: .label)
                                            )
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(
                                                        detailSelectedColor == color ?
                                                        ServiceType.shopping.accentTint : Color.clear,
                                                        lineWidth: 1.5
                                                    )
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }

                    // Size Selector
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Select Size / Variant")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(product.availableSizes, id: \.self) { size in
                                    Button(action: { detailSelectedSize = size }) {
                                        Text(size)
                                            .font(.system(size: 12, weight: .bold))
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 7)
                                            .background(
                                                detailSelectedSize == size ?
                                                ServiceType.shopping.accentTint.opacity(0.12) :
                                                Color(uiColor: .tertiarySystemFill)
                                            )
                                            .foregroundColor(
                                                detailSelectedSize == size ?
                                                ServiceType.shopping.accentTint :
                                                Color(uiColor: .label)
                                            )
                                            .clipShape(Capsule())
                                            .overlay(
                                                Capsule()
                                                    .strokeBorder(
                                                        detailSelectedSize == size ?
                                                        ServiceType.shopping.accentTint : Color.clear,
                                                        lineWidth: 1.5
                                                    )
                                            )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Product Description")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(Color(uiColor: .secondaryLabel))

                        Text(product.description)
                            .font(KivorlyTypography.bodyMedium)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                            .lineSpacing(4)
                    }

                    // Action Buttons (Add to Bag & Buy Now)
                    HStack(spacing: 12) {
                        Button(action: {
                            addToCart(product: product, size: detailSelectedSize, color: detailSelectedColor, qty: detailQuantity)
                            selectedProduct = nil
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "bag.badge.plus")
                                Text("Add to Bag")
                            }
                            .font(.system(size: 14, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(uiColor: .secondarySystemFill))
                            .foregroundColor(Color(uiColor: .label))
                            .clipShape(Capsule())
                        }

                        Button(action: {
                            addToCart(product: product, size: detailSelectedSize, color: detailSelectedColor, qty: detailQuantity)
                            selectedProduct = nil
                            showCartSheet = true
                        }) {
                            HStack(spacing: 6) {
                                Text("Buy Now")
                                Image(systemName: "arrow.right")
                            }
                            .font(.system(size: 14, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(ServiceType.shopping.accentTint)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .shadow(color: ServiceType.shopping.accentTint.opacity(0.3), radius: 6, y: 2)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding(16)
            }
            .navigationTitle(product.brand)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") { selectedProduct = nil }
                }
            }
        }
    }

    // MARK: - Cart & Checkout Sheet
    private var cartCheckoutSheet: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if cartItems.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "bag")
                            .font(.system(size: 54))
                            .foregroundColor(Color(uiColor: .tertiaryLabel))
                        Text("Your Shopping Bag is Empty")
                            .font(KivorlyTypography.titleMedium)
                            .foregroundColor(Color(uiColor: .label))
                        Text("Explore Aarong, Yellow, Xiaomi & more official stores!")
                            .font(KivorlyTypography.caption)
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        VStack(spacing: 14) {
                            // Items List
                            VStack(spacing: 10) {
                                ForEach(cartItems.indices, id: \.self) { idx in
                                    let item = cartItems[idx]
                                    HStack(spacing: 12) {
                                        Text(item.product.emoji)
                                            .font(.system(size: 28))
                                            .frame(width: 44, height: 44)
                                            .background(ServiceType.shopping.accentTint.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(item.product.title)
                                                .font(.system(size: 13, weight: .bold))
                                                .foregroundColor(Color(uiColor: .label))
                                                .lineLimit(1)

                                            Text("\(item.selectedColor) • Size \(item.selectedSize)")
                                                .font(.system(size: 11))
                                                .foregroundColor(Color(uiColor: .secondaryLabel))

                                            Text("৳\(Int(item.product.discountPrice))")
                                                .font(.system(size: 13, weight: .black))
                                                .foregroundColor(ServiceType.shopping.accentTint)
                                        }

                                        Spacer()

                                        // Stepper
                                        HStack(spacing: 8) {
                                            Button(action: {
                                                if cartItems[idx].quantity > 1 {
                                                    cartItems[idx].quantity -= 1
                                                } else {
                                                    cartItems.remove(at: idx)
                                                }
                                            }) {
                                                Image(systemName: "minus.circle.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(Color(uiColor: .tertiaryLabel))
                                            }

                                            Text("\(item.quantity)")
                                                .font(.system(size: 13, weight: .bold))
                                                .frame(minWidth: 18)

                                            Button(action: {
                                                cartItems[idx].quantity += 1
                                            }) {
                                                Image(systemName: "plus.circle.fill")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(ServiceType.shopping.accentTint)
                                            }
                                        }
                                    }
                                    .padding(10)
                                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                                    .cornerRadius(12)
                                }
                            }

                            // Delivery Address Card
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Delivery Address")
                                    .font(.system(size: 10, weight: .black))
                                    .foregroundColor(Color(uiColor: .secondaryLabel))

                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("MD Shoaib Khan • +880 1712-345678")
                                            .font(.system(size: 13, weight: .bold))
                                        Text("Road 71, House 14, Flat 4B, Gulshan 2, Dhaka")
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(uiColor: .secondaryLabel))
                                    }
                                    Spacer()
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                                .padding(10)
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

                            // Cost Breakdown
                            VStack(spacing: 6) {
                                HStack {
                                    Text("Bag Subtotal")
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                    Spacer()
                                    Text("৳\(Int(cartTotal))")
                                        .fontWeight(.semibold)
                                }
                                HStack {
                                    Text("Express Delivery (Dhaka)")
                                        .foregroundColor(Color(uiColor: .secondaryLabel))
                                    Spacer()
                                    Text(cartTotal >= 1500 ? "Free" : "৳60")
                                        .fontWeight(.bold)
                                        .foregroundColor(cartTotal >= 1500 ? .green : Color(uiColor: .label))
                                }
                                Divider()
                                HStack {
                                    Text("Total Payable")
                                        .font(.system(size: 15, weight: .bold))
                                    Spacer()
                                    Text("৳\(Int(cartTotal + (cartTotal >= 1500 ? 0 : 60)))")
                                        .font(.system(size: 18, weight: .black))
                                        .foregroundColor(ServiceType.shopping.accentTint)
                                }
                            }
                            .font(.system(size: 12))
                            .padding(12)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(12)
                        }
                        .padding(16)
                    }

                    // Checkout Button
                    Button(action: {
                        confirmedOrderId = "KVS-\(Int.random(in: 100000...999999))-BD"
                        cartItems.removeAll()
                        showCartSheet = false
                        showOrderConfirmation = true
                    }) {
                        HStack(spacing: 6) {
                            Text("Place Order")
                                .font(KivorlyTypography.titleSmall)
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .bold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(ServiceType.shopping.accentTint)
                        .clipShape(Capsule())
                        .shadow(color: ServiceType.shopping.accentTint.opacity(0.3), radius: 6, y: 2)
                    }
                    .padding(16)
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                }
            }
            .navigationTitle("Shopping Bag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { showCartSheet = false }
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
                    isSelected ? ServiceType.shopping.accentTint.opacity(0.12) : Color(uiColor: .secondarySystemGroupedBackground)
                )
                .foregroundColor(isSelected ? ServiceType.shopping.accentTint : Color(uiColor: .secondaryLabel))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(isSelected ? ServiceType.shopping.accentTint : Color(uiColor: .separator).opacity(0.4), lineWidth: 1)
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
                    Text("Order Placed Successfully!")
                        .font(KivorlyTypography.titleMedium)
                        .foregroundColor(Color(uiColor: .label))

                    Text("Order ID: \(confirmedOrderId)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(ServiceType.shopping.accentTint)

                    Text("We've dispatched your order to our delivery network. Estimated delivery within 24 hours to Gulshan 2, Dhaka.")
                        .font(KivorlyTypography.caption)
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Spacer()

                Button(action: { showOrderConfirmation = false }) {
                    Text("Continue Shopping")
                        .font(KivorlyTypography.titleSmall)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(ServiceType.shopping.accentTint)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        }
    }
}
