//
//  ServiceItemModel.swift
//  Kivorly
//
//  Extensible data model for items, vendors, drivers, products, and services across all Kivorly verticals.
//

import SwiftUI

public struct ServiceItemModel: Identifiable, Hashable {
    public let id = UUID()
    public let title: String
    public let category: String
    public let priceText: String
    public let numericPrice: Double
    public let rating: Double
    public let reviewCount: Int
    public let etaOrDuration: String
    public let icon: String
    public let serviceType: ServiceType
    public let badges: [String]
    public let imageEmoji: String?

    public init(
        title: String,
        category: String,
        priceText: String,
        numericPrice: Double,
        rating: Double,
        reviewCount: Int,
        etaOrDuration: String,
        icon: String,
        serviceType: ServiceType,
        badges: [String] = [],
        imageEmoji: String? = nil
    ) {
        self.title = title
        self.category = category
        self.priceText = priceText
        self.numericPrice = numericPrice
        self.rating = rating
        self.reviewCount = reviewCount
        self.etaOrDuration = etaOrDuration
        self.icon = icon
        self.serviceType = serviceType
        self.badges = badges
        self.imageEmoji = imageEmoji
    }
}
