//
//  HelpCenterView.swift
//  Kivorly
//
//  FAQ and customer support resolution topics.
//

import SwiftUI

public struct FAQItem: Identifiable {
    public let id = UUID()
    public let question: String
    public let answer: String
}

public struct HelpCenterView: View {
    @State private var expandedFaq: UUID? = nil
    @State private var searchHelp: String = ""

    private let faqs: [FAQItem] = [
        FAQItem(
            question: "How do I track my ride driver?",
            answer: "Open the Orders or Activity tab and tap on your active ride to view real-time location."
        ),
        FAQItem(
            question: "What payment methods are supported?",
            answer: "Kivorly supports bKash, Nagad, Visa, Mastercard, Apple Pay, and Cash on Delivery."
        ),
        FAQItem(
            question: "How do I cancel a food delivery?",
            answer: "You can cancel free of charge before the restaurant begins meal preparation."
        ),
        FAQItem(
            question: "Are hotel reservations refundable?",
            answer: "Refund policies vary per property and are explicitly listed under each room tier."
        )
    ]

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: KivorlySpacing.md) {
                KivorlySearchBar(text: $searchHelp, placeholder: "Search help articles")

                VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                    SectionHeader(title: "Frequently Asked Questions")

                    ForEach(faqs) { item in
                        faqRow(item)
                    }
                }

                VStack(alignment: .leading, spacing: KivorlySpacing.xs) {
                    SectionHeader(title: "Direct Support")

                    KivorlyCard(padding: 0) {
                        VStack(spacing: 0) {
                            ProfileMenuRow(icon: "message.fill", title: "Live Chat with Agent")
                            Divider().padding(.leading, 56)
                            ProfileMenuRow(icon: "phone.fill", title: "Call Helpline (24/7)")
                            Divider().padding(.leading, 56)
                            ProfileMenuRow(icon: "envelope.fill", title: "Email Support")
                        }
                    }
                }
            }
            .padding(KivorlySpacing.md)
        }
        .background(KivorlyColors.background.ignoresSafeArea())
        .navigationTitle("Help Center")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func faqRow(_ item: FAQItem) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            VStack(alignment: .leading, spacing: 8) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        expandedFaq = (expandedFaq == item.id ? nil : item.id)
                    }
                }) {
                    HStack {
                        Text(item.question)
                            .font(KivorlyTypography.titleSmall)
                            .foregroundColor(KivorlyColors.textPrimary)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(systemName: expandedFaq == item.id ? "chevron.up" : "chevron.down")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(KivorlyColors.primary)
                    }
                }

                if expandedFaq == item.id {
                    Text(item.answer)
                        .font(KivorlyTypography.bodyMedium)
                        .foregroundColor(KivorlyColors.textSecondary)
                        .padding(.top, 4)
                }
            }
        }
    }
}
