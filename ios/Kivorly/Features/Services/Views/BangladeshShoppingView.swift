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
import UIKit

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
    public let imageAssetName: String
    public let imageUrl: String
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

// MARK: - Reusable Real Product Image Component
public struct ShoppingProductImageView: View {
    public let assetName: String
    public let imageUrl: String
    public let emojiFallback: String
    public var height: CGFloat? = nil
    public var cornerRadius: CGFloat = 14
    public var contentMode: ContentMode = .fill

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
                                .scaleEffect(0.7)
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
        .frame(height: height)
        .frame(maxWidth: .infinity)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }

    private var fallbackView: some View {
        ZStack {
            Color(uiColor: .tertiarySystemFill)
            Text(emojiFallback)
                .font(.system(size: 34))
        }
    }
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
        "All", "Ethnic & Panjabi", "Casual Wear", "Women's Fashion", "Footwear", "Smartphones & Tech", "Electronics & Home", "Home Living", "Beauty & Care"
    ]

    private let brands = [
        "All", "Aarong", "Yellow", "Apex", "Bata", "Xiaomi BD", "Walton", "Apple", "Samsung", "Artisan", "Taaga", "Lafz"
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
            imageAssetName: "product_panjabi",
            imageUrl: "https://images.unsplash.com/photo-1583391733956-3750e0ff4e8b?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["38", "40", "42", "44"],
            availableColors: ["Royal Navy", "Pearl White", "Golden Beige"],
            badges: ["Official Store", "Handcrafted", "Best Seller"],
            deliveryTime: "Express 24h",
            warrantyText: "7-Day Easy Return",
            description: "Traditional Bangladeshi handloom silk-cotton blend with intricate Nakshi Kantha neck embroidery. Perfect for Eid, weddings, and formal occasions."
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
            imageAssetName: "product_shirt",
            imageUrl: "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["S", "M", "L", "XL"],
            availableColors: ["Olive Green", "Sky Blue", "Jet Black"],
            badges: ["Official Store", "100% Cotton"],
            deliveryTime: "Next Day",
            warrantyText: "7-Day Easy Return",
            description: "Tailored slim-fit long-sleeve casual shirt crafted with premium breathable Egyptian cotton with pearlized buttons."
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
            imageAssetName: "product_oxford_shoes",
            imageUrl: "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["40", "41", "42", "43", "44"],
            availableColors: ["Classic Tan", "Deep Mahogany", "Jet Black"],
            badges: ["Genuine Leather", "Memory Foam"],
            deliveryTime: "Next Day",
            warrantyText: "30-Day Leather Guarantee",
            description: "High-grade full-grain cow leather formal shoes with padded inner sole and durable rubber outsole for city commuting."
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
            imageAssetName: "product_xiaomi_phone",
            imageUrl: "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600&auto=format&fit=crop&q=80",
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
            category: "Electronics & Home",
            originalPrice: 33500,
            discountPrice: 28500,
            discountPercentage: "-15%",
            rating: 4.84,
            reviewCount: 520,
            iconName: "tv.fill",
            emoji: "📺",
            imageAssetName: "product_smart_tv",
            imageUrl: "https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=600&auto=format&fit=crop&q=80",
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
            imageAssetName: "product_ceramic_dinner",
            imageUrl: "https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["Standard 16 Pcs"],
            availableColors: ["Terracotta Rust", "Earthy Sand", "Glazed Sage"],
            badges: ["Microwave Safe", "Handmade"],
            deliveryTime: "Next Day",
            warrantyText: "Breakage Replacement",
            description: "Handcrafted eco-friendly stoneware ceramic dinner plates, bowls, and serving platters made by Bengal potters."
        ),
        ShoppingProductItem(
            id: "sp-7",
            title: "Traditional Dhakai Jamdani Handloom Silk Saree",
            brand: "Aarong",
            category: "Women's Fashion",
            originalPrice: 11000,
            discountPrice: 8500,
            discountPercentage: "-23%",
            rating: 4.98,
            reviewCount: 1140,
            iconName: "sparkles",
            emoji: "🥻",
            imageAssetName: "product_jamdani_saree",
            imageUrl: "https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["Standard 5.5m (With Blouse Piece)"],
            availableColors: ["Crimson Red", "Royal Indigo", "Golden Zari"],
            badges: ["GI Tag Certified", "Heritage Silk", "Official Store"],
            deliveryTime: "Express 24h",
            warrantyText: "Authenticity Verified",
            description: "Authentic Bangladeshi UNESCO heritage Dhakai Jamdani saree woven by master weavers in Sonargaon using fine mulberry silk."
        ),
        ShoppingProductItem(
            id: "sp-8",
            title: "Apple iPhone 15 Pro (128GB, Natural Titanium)",
            brand: "Apple",
            category: "Smartphones & Tech",
            originalPrice: 149999,
            discountPrice: 138000,
            discountPercentage: "-8%",
            rating: 4.97,
            reviewCount: 3820,
            iconName: "iphone.gen3",
            emoji: "📱",
            imageAssetName: "product_iphone",
            imageUrl: "https://images.unsplash.com/photo-1695048133142-1a20484d2569?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["128GB", "256GB", "512GB"],
            availableColors: ["Natural Titanium", "Blue Titanium", "Black Titanium"],
            badges: ["Official Apple Warranty", "BTRC Verified", "0% EMI"],
            deliveryTime: "Express Same-Day",
            warrantyText: "1-Year Apple Warranty",
            description: "Aerospace-grade titanium design, A17 Pro chip, Action button, 48MP main camera system with USB-C and 3x telephoto zoom."
        ),
        ShoppingProductItem(
            id: "sp-9",
            title: "Wireless Active Noise Cancelling Headphones",
            brand: "Xiaomi BD",
            category: "Smartphones & Tech",
            originalPrice: 5800,
            discountPrice: 4500,
            discountPercentage: "-22%",
            rating: 4.88,
            reviewCount: 840,
            iconName: "headphones",
            emoji: "🎧",
            imageAssetName: "product_headphones",
            imageUrl: "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["Over-Ear Studio"],
            availableColors: ["Matte Black", "Silver Gray", "Deep Navy"],
            badges: ["Hi-Res Audio", "40h Battery", "Hybrid ANC"],
            deliveryTime: "Next Day",
            warrantyText: "6-Month Brand Warranty",
            description: "40mm dynamic bio-cellulose drivers, 43dB hybrid active noise cancellation, dual transparency mode, and ultra-plush memory foam."
        ),
        ShoppingProductItem(
            id: "sp-10",
            title: "Bata Power Energy-Return Running Sneakers",
            brand: "Bata",
            category: "Footwear",
            originalPrice: 3990,
            discountPrice: 3290,
            discountPercentage: "-18%",
            rating: 4.85,
            reviewCount: 730,
            iconName: "figure.run",
            emoji: "👟",
            imageAssetName: "product_bata_sneakers",
            imageUrl: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["39", "40", "41", "42", "43", "44"],
            availableColors: ["Velocity Red", "Graphite Black", "Cloud White"],
            badges: ["Ultra Light", "Breathable Mesh", "Bata Official"],
            deliveryTime: "Next Day",
            warrantyText: "30-Day Sole Warranty",
            description: "Engineered high-rebound midsole technology for daily jogging, city walks, and high-impact training on Dhaka roads."
        ),
        ShoppingProductItem(
            id: "sp-11",
            title: "Handcrafted Vegetable-Tanned Leather Tote Bag",
            brand: "Aarong",
            category: "Women's Fashion",
            originalPrice: 5200,
            discountPrice: 4250,
            discountPercentage: "-18%",
            rating: 4.93,
            reviewCount: 510,
            iconName: "bag.fill",
            emoji: "👜",
            imageAssetName: "product_leather_bag",
            imageUrl: "https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["Medium (14x11 in)", "Large (16x13 in)"],
            availableColors: ["Caramel Tan", "Vintage Brown", "Midnight Black"],
            badges: ["100% Genuine Leather", "Aarong Artisan", "Best Seller"],
            deliveryTime: "Next Day",
            warrantyText: "1-Year Leather Warranty",
            description: "Full-grain natural cow leather with brass zippers and interior laptop sleeve. Handcrafted by rural artisans in Manikganj."
        ),
        ShoppingProductItem(
            id: "sp-12",
            title: "Samsung Galaxy Watch6 Bluetooth 44mm",
            brand: "Samsung",
            category: "Smartphones & Tech",
            originalPrice: 26000,
            discountPrice: 22500,
            discountPercentage: "-13%",
            rating: 4.91,
            reviewCount: 920,
            iconName: "applewatch",
            emoji: "⌚",
            imageAssetName: "product_smartwatch",
            imageUrl: "https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["40mm", "44mm"],
            availableColors: ["Graphite Black", "Silver", "Gold Sand"],
            badges: ["ECG & Sleep Coach", "Sapphire Crystal", "Official BD"],
            deliveryTime: "Express 24h",
            warrantyText: "1-Year Official Warranty",
            description: "Advanced health monitoring with personalized heart rate zones, body composition analysis, sapphire crystal glass, and IP68 waterproof rating."
        ),
        ShoppingProductItem(
            id: "sp-13",
            title: "Yellow Relaxed-Fit Washed Denim Jeans",
            brand: "Yellow",
            category: "Casual Wear",
            originalPrice: 3400,
            discountPrice: 2750,
            discountPercentage: "-19%",
            rating: 4.87,
            reviewCount: 1180,
            iconName: "figure.walk",
            emoji: "👖",
            imageAssetName: "product_denim_jeans",
            imageUrl: "https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["30", "32", "34", "36", "38"],
            availableColors: ["Vintage Medium Blue", "Dark Indigo", "Faded Charcoal"],
            badges: ["Stretch Denim", "Comfort Fit", "Official Store"],
            deliveryTime: "Next Day",
            warrantyText: "7-Day Easy Return",
            description: "Premium 99% ring-spun cotton denim with 1% elastane for flexible all-day comfort. Enzyme washed with reinforced stitching."
        ),
        ShoppingProductItem(
            id: "sp-14",
            title: "Walton Double-Door Frost-Free Refrigerator (252L)",
            brand: "Walton",
            category: "Electronics & Home",
            originalPrice: 44500,
            discountPrice: 38900,
            discountPercentage: "-13%",
            rating: 4.89,
            reviewCount: 670,
            iconName: "refrigerator.fill",
            emoji: "🧊",
            imageAssetName: "product_refrigerator",
            imageUrl: "https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["252 Litres", "310 Litres"],
            availableColors: ["Glass Mirror Black", "Floral Burgundy"],
            badges: ["12-Year Inverter Guarantee", "Free Installation", "A+++ Energy"],
            deliveryTime: "Scheduled 48h",
            warrantyText: "12-Year Compressor Warranty",
            description: "Intelligent inverter technology with nano silver anti-bacterial filter and wide voltage design suitable for Bangladesh power fluctuations."
        ),
        ShoppingProductItem(
            id: "sp-15",
            title: "Handloom Bengal Nakshi Kantha Bedspread",
            brand: "Artisan",
            category: "Home Living",
            originalPrice: 4600,
            discountPrice: 3800,
            discountPercentage: "-17%",
            rating: 4.96,
            reviewCount: 430,
            iconName: "bed.double.fill",
            emoji: "🛏️",
            imageAssetName: "product_nakshi_kantha",
            imageUrl: "https://images.unsplash.com/photo-1616046229478-9901c5536a45?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["King (90x100 in)", "Queen (80x90 in)"],
            availableColors: ["Ivory & Crimson", "Indigo Blue", "Multi-Color Classic"],
            badges: ["100% Pure Cotton", "Hand-Stitched", "Heritage Craft"],
            deliveryTime: "Next Day",
            warrantyText: "Authenticity Verified",
            description: "Traditional folk-art quilt made of layered pure cotton fabric, embroidered entirely by hand with mythological Bengal village motifs."
        ),
        ShoppingProductItem(
            id: "sp-16",
            title: "Taaga Contemporary Fusion Kurti Tunic",
            brand: "Taaga",
            category: "Women's Fashion",
            originalPrice: 2450,
            discountPrice: 1950,
            discountPercentage: "-20%",
            rating: 4.86,
            reviewCount: 690,
            iconName: "tshirt",
            emoji: "👗",
            imageAssetName: "product_fusion_kurti",
            imageUrl: "https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["XS", "S", "M", "L", "XL"],
            availableColors: ["Mustard Floral", "Olive Green", "Teal Geometric"],
            badges: ["Official Store", "Breathable Viscose"],
            deliveryTime: "Next Day",
            warrantyText: "7-Day Easy Return",
            description: "Modern bohemian-cut tunic crafted with soft breathable viscose georgette. Styled for casual university wear and corporate office days."
        ),
        ShoppingProductItem(
            id: "sp-17",
            title: "Apex Venturini Classic Leather Loafers",
            brand: "Apex",
            category: "Footwear",
            originalPrice: 4990,
            discountPrice: 3990,
            discountPercentage: "-20%",
            rating: 4.88,
            reviewCount: 580,
            iconName: "shoe.fill",
            emoji: "👞",
            imageAssetName: "product_loafers",
            imageUrl: "https://images.unsplash.com/photo-1533867617858-e7b97e060509?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["40", "41", "42", "43", "44"],
            availableColors: ["Rich Burgundy", "Deep Tan", "Jet Black"],
            badges: ["Venturini Signature", "Padded Insole"],
            deliveryTime: "Next Day",
            warrantyText: "30-Day Leather Guarantee",
            description: "Italian inspired slip-on penny loafers crafted from burnished genuine cowhide leather with a flexible anti-skid rubber sole."
        ),
        ShoppingProductItem(
            id: "sp-18",
            title: "Walton Convection Smart Microwave Oven (25L)",
            brand: "Walton",
            category: "Electronics & Home",
            originalPrice: 13500,
            discountPrice: 11200,
            discountPercentage: "-17%",
            rating: 4.82,
            reviewCount: 340,
            iconName: "microwave.fill",
            emoji: "🍳",
            imageAssetName: "product_microwave",
            imageUrl: "https://images.unsplash.com/photo-1585659722983-3a675dabf23d?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["25 Litres"],
            availableColors: ["Stainless Silver", "Obsidian Black"],
            badges: ["Bake & Grill", "Auto Deshi Menu", "Child Lock"],
            deliveryTime: "Scheduled 24h",
            warrantyText: "2-Year Official Warranty",
            description: "Multi-stage cooking with convection baking, quartz grill heater, 8 auto-cooking programs tailored for local cuisine, and easy-clean cavity."
        ),
        ShoppingProductItem(
            id: "sp-19",
            title: "Organic Saffron Radiance Facial Glow Serum",
            brand: "Lafz",
            category: "Beauty & Care",
            originalPrice: 1450,
            discountPrice: 1150,
            discountPercentage: "-21%",
            rating: 4.94,
            reviewCount: 1290,
            iconName: "sparkle",
            emoji: "✨",
            imageAssetName: "product_face_serum",
            imageUrl: "https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["30ml Dropper", "50ml Bottle"],
            availableColors: ["Pure Golden Elixir"],
            badges: ["100% Halal Certified", "Cruelty Free", "Top Rated"],
            deliveryTime: "Express 24h",
            warrantyText: "100% Original Guarantee",
            description: "Infused with pure Kashmiri saffron strands, niacinamide, and hyaluronic acid for glowing radiant skin without parabens or harsh chemicals."
        ),
        ShoppingProductItem(
            id: "sp-20",
            title: "Hand-Hammered Antique Brass Floor Lamp",
            brand: "Artisan",
            category: "Home Living",
            originalPrice: 6200,
            discountPrice: 4900,
            discountPercentage: "-21%",
            rating: 4.90,
            reviewCount: 280,
            iconName: "lamp.floor.fill",
            emoji: "🪔",
            imageAssetName: "product_brass_lamp",
            imageUrl: "https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=600&auto=format&fit=crop&q=80",
            availableSizes: ["4.5 ft Floor Stand"],
            availableColors: ["Aged Brass", "Brushed Copper"],
            badges: ["Solid Brass", "Hand-Etched Motifs"],
            deliveryTime: "Scheduled 24h",
            warrantyText: "Lifetime Brass Guarantee",
            description: "Traditional Bengali craft revival piece hand-carved with floral filigree patterns that cast warm enchanting ambient patterns on walls."
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
                    ShoppingProductImageView(
                        assetName: product.imageAssetName,
                        imageUrl: product.imageUrl,
                        emojiFallback: product.emoji,
                        height: 135,
                        cornerRadius: 14,
                        contentMode: .fill
                    )

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
                        ShoppingProductImageView(
                            assetName: product.imageAssetName,
                            imageUrl: product.imageUrl,
                            emojiFallback: product.emoji,
                            height: 250,
                            cornerRadius: 20,
                            contentMode: .fill
                        )

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
                                        ShoppingProductImageView(
                                            assetName: item.product.imageAssetName,
                                            imageUrl: item.product.imageUrl,
                                            emojiFallback: item.product.emoji,
                                            height: 48,
                                            cornerRadius: 10,
                                            contentMode: .fill
                                        )
                                        .frame(width: 48, height: 48)

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
                        let generatedOrderId = "KVS-\(Int.random(in: 100000...999999))-BD"
                        let deliveryFee = cartTotal >= 1500 ? 0.0 : 60.0
                        let totalAmt = cartTotal + deliveryFee

                        let lineItems = cartItems.map { ci in
                            OrderLineItem(
                                title: ci.product.title,
                                subtitle: "\(ci.selectedColor) • Size \(ci.selectedSize)",
                                quantity: ci.quantity,
                                price: ci.product.discountPrice,
                                imageAssetName: ci.product.imageAssetName,
                                emoji: ci.product.emoji
                            )
                        }

                        let shoppingOrder = SuperAppOrder(
                            id: generatedOrderId,
                            service: .shopping,
                            title: cartItems.first?.product.brand ?? "Kivorly Mall",
                            subtitle: "\(cartItems.count) item(s) • \(cartItems.first?.product.title ?? "")",
                            timestamp: "Just now",
                            amount: String(format: "\u{09F3}%.0f", totalAmt),
                            rawAmount: totalAmt,
                            status: .inProgress,
                            etaText: "Delivery by Tomorrow, 4:00 PM",
                            pickupLocation: "Kivorly Mall Central Hub, Tejgaon, Dhaka",
                            destinationLocation: "Road 71, House 14, Flat 4B, Gulshan 2, Dhaka",
                            driverOrPartner: OrderPartner(
                                name: "Steadfast Express Delivery",
                                role: "Official Courier Hub",
                                rating: 4.9,
                                completedTrips: 15400,
                                phone: "+880 9612-004488",
                                vehicleInfo: "Delivery Van • Dhaka Metro Da 12-4011"
                            ),
                            securityPin: String(format: "%04d", Int.random(in: 1000...9999)),
                            trackingNumber: "STEADFAST-BD-\(Int.random(in: 100000...999999))",
                            qrPassCode: nil,
                            bookingDetails: nil,
                            items: lineItems,
                            timelineSteps: [
                                OrderTimelineStep(title: "Order Placed", subtitle: "Payment confirmed via \(selectedPaymentMethod)", time: "Just now", isCompleted: true),
                                OrderTimelineStep(title: "Confirmed by Merchant", subtitle: "Official seller packing order", time: "Just now", isCompleted: true, isCurrent: true),
                                OrderTimelineStep(title: "Dispatched from Tejgaon Hub", subtitle: "Assigned to Steadfast Express", time: "Pending", isCompleted: false),
                                OrderTimelineStep(title: "Out for Delivery", subtitle: "Courier will call before arrival", time: "Tomorrow 02:00 PM", isCompleted: false),
                                OrderTimelineStep(title: "Delivered & Verified", subtitle: "Delivery to Gulshan 2", time: "Tomorrow 04:00 PM", isCompleted: false)
                            ],
                            paymentBreakdown: OrderPaymentBreakdown(
                                subtotal: cartTotal,
                                deliveryOrFareFee: deliveryFee,
                                platformFee: 0,
                                discount: 0,
                                total: totalAmt,
                                paymentMethod: selectedPaymentMethod,
                                transactionId: "TXN-\(Int.random(in: 10000000...99999999))"
                            )
                        )
                        OrdersManager.shared.addOrder(shoppingOrder)

                        confirmedOrderId = generatedOrderId
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
