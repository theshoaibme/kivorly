//
//  ActivityDetailSheet.swift
//  Kivorly
//
//  Rich modal detail sheet for an activity event.
//

import SwiftUI

public struct ActivityDetailSheet: View {
    let item: ActivityItem
    let onDismiss: () -> Void
    @Environment(\.dismiss) private var dismiss

    public init(item: ActivityItem, onDismiss: @escaping () -> Void) {
        self.item = item
        self.onDismiss = onDismiss
    }

    public var body: some View {
        NavigationStack {
            VStack(spacing: KivorlySpacing.lg) {
                // Large 3D Icon with Muted Background
                ZStack {
                    Circle()
                        .fill(item.serviceType?.accentTint.opacity(0.12) ?? KivorlyColors.primary.opacity(0.12))
                        .frame(width: 88, height: 88)

                    Image(systemName: item.icon)
                        .font(.system(size: 38, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(item.serviceType?.accentTint ?? KivorlyColors.primary)
                }
                .padding(.top, KivorlySpacing.xl)

                // Title
                VStack(spacing: 6) {
                    Text(item.title)
                        .font(KivorlyTypography.titleLarge)
                        .foregroundColor(KivorlyColors.textPrimary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, KivorlySpacing.md)

                    Text(item.timeAgo)
                        .font(KivorlyTypography.caption)
                        .foregroundColor(KivorlyColors.textSecondary)
                }

                // Metadata Card
                KivorlyCard(padding: KivorlySpacing.md) {
                    VStack(spacing: KivorlySpacing.sm) {
                        infoRow(label: "Category", value: item.category.rawValue)
                        if let service = item.serviceType {
                            Divider()
                            infoRow(label: "Service", value: service.title)
                        }
                        if let refId = item.referenceId {
                            Divider()
                            infoRow(label: "Reference", value: refId)
                        }
                    }
                }
                .padding(.horizontal, KivorlySpacing.md)

                Spacer()

                // Action Button
                if let actionLabel = item.actionButtonTitle {
                    KivorlyButton(actionLabel, icon: "arrow.right", style: .primary) {
                        dismiss()
                        onDismiss()
                    }
                    .padding(.horizontal, KivorlySpacing.md)
                }

                KivorlyButton("Close", style: .outline) {
                    dismiss()
                }
                .padding(.horizontal, KivorlySpacing.md)
                .padding(.bottom, KivorlySpacing.md)
            }
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle("Activity Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(KivorlyTypography.bodySemibold)
                    .foregroundColor(KivorlyColors.primary)
                }
            }
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(KivorlyTypography.bodyMedium)
                .foregroundColor(KivorlyColors.textSecondary)
            Spacer()
            Text(value)
                .font(KivorlyTypography.bodySemibold)
                .foregroundColor(KivorlyColors.textPrimary)
        }
    }
}
