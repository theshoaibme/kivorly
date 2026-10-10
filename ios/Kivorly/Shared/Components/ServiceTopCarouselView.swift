//
//  ServiceTopCarouselView.swift
//  Kivorly
//
//  Autopaging promotional carousel for each individual service screen.
//  Uses ACTUAL high-resolution stock photography (no icon images, no emojis),
//  solid backgrounds (no gradients), flat styling (no shadows), and standard
//  default iPhone button variants.
//

import SwiftUI
import Combine

public struct ServicePromoSlide: Identifiable {
    public let id: String
    public let tag: String
    public let title: String
    public let subtitle: String
    public let actionTitle: String
    public let imageAssetName: String
    public let imageUrl: String?

    public init(
        id: String = UUID().uuidString,
        tag: String,
        title: String,
        subtitle: String,
        actionTitle: String = "Explore",
        imageAssetName: String,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.tag = tag
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.imageAssetName = imageAssetName
        self.imageUrl = imageUrl
    }
}

public struct ServiceTopCarouselView: View {
    public let service: ServiceType
    public let slides: [ServicePromoSlide]
    public var onSelectSlide: ((ServicePromoSlide) -> Void)? = nil

    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 4.0, on: .main, in: .common).autoconnect()

    public init(
        service: ServiceType,
        slides: [ServicePromoSlide],
        onSelectSlide: ((ServicePromoSlide) -> Void)? = nil
    ) {
        self.service = service
        self.slides = slides
        self.onSelectSlide = onSelectSlide
    }

    public var body: some View {
        guard !slides.isEmpty else { return AnyView(EmptyView()) }

        return AnyView(
            VStack(spacing: 8) {
                TabView(selection: $currentIndex) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        slideCard(slides[index])
                            .tag(index)
                    }
                }
                .frame(height: 136)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onReceive(timer) { _ in
                    guard slides.count > 1 else { return }
                    withAnimation(.easeInOut(duration: 0.35)) {
                        currentIndex = (currentIndex + 1) % slides.count
                    }
                }

                // Default iOS Page Indicators
                if slides.count > 1 {
                    HStack(spacing: 6) {
                        ForEach(0..<slides.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentIndex ? service.accentTint : Color(uiColor: .tertiarySystemFill))
                                .frame(width: index == currentIndex ? 18 : 6, height: 5)
                                .animation(.easeInOut(duration: 0.2), value: currentIndex)
                        }
                    }
                    .padding(.top, 2)
                }
            }
        )
    }

    private func slideCard(_ slide: ServicePromoSlide) -> some View {
        Button(action: {
            onSelectSlide?(slide)
        }) {
            HStack(spacing: 12) {
                // Left: Info Content
                VStack(alignment: .leading, spacing: 5) {
                    // Tag Badge
                    Text(slide.tag)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(service.accentTint)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(service.accentTint.opacity(0.12))
                        .clipShape(Capsule())

                    // Slide Title
                    Text(slide.title)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(uiColor: .label))
                        .lineLimit(1)

                    // Subtitle
                    Text(slide.subtitle)
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: 2)

                    // Default iPhone Button Style (Standard height: 32pt, no shadow, no gradient)
                    HStack(spacing: 4) {
                        Text(slide.actionTitle)
                            .font(.system(size: 11, weight: .bold))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 9, weight: .bold))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(service.accentTint)
                    .clipShape(Capsule())
                }

                Spacer()

                // Right: ACTUAL HIGH-QUALITY REAL STOCK PHOTO (No icon images, no emojis)
                Group {
                    if UIImage(named: slide.imageAssetName) != nil {
                        Image(slide.imageAssetName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if let urlStr = slide.imageUrl, let url = URL(string: urlStr) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let img):
                                img.resizable().aspectRatio(contentMode: .fill)
                            default:
                                Color(uiColor: .tertiarySystemFill)
                            }
                        }
                    } else {
                        Color(uiColor: .tertiarySystemFill)
                    }
                }
                .frame(width: 96, height: 96)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(Color(uiColor: .separator).opacity(0.2), lineWidth: 0.8)
                )
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: 136)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(uiColor: .separator).opacity(0.2), lineWidth: 0.8)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
