//
//  SavedAddressesView.swift
//  Kivorly
//
//  Full address management with add, delete, and set default.
//

import SwiftUI

public struct SavedAddress: Identifiable {
    public let id = UUID()
    public var label: String
    public var address: String
    public var icon: String
    public var isDefault: Bool
}

public struct SavedAddressesView: View {
    @State private var addresses: [SavedAddress] = [
        SavedAddress(label: "Home", address: "House 14, Road 7, Gulshan-2, Dhaka", icon: "house.fill", isDefault: true),
        SavedAddress(label: "Office", address: "Plot 88, Kemal Ataturk Ave, Banani, Dhaka", icon: "briefcase.fill", isDefault: false),
        SavedAddress(label: "Parents", address: "Dhanmondi 9/A, Dhaka", icon: "heart.fill", isDefault: false)
    ]
    @State private var showAddAddressSheet: Bool = false
    @State private var newLabel: String = ""
    @State private var newAddress: String = ""

    public init() {}

    public var body: some View {
        ScrollView {
            VStack(spacing: KivorlySpacing.md) {
                ForEach(addresses) { item in
                    addressCard(item)
                }

                KivorlyButton("Add New Address", icon: "plus", style: .outline) {
                    showAddAddressSheet = true
                }
                .padding(.top, KivorlySpacing.sm)
            }
            .padding(KivorlySpacing.md)
        }
        .background(KivorlyColors.background.ignoresSafeArea())
        .navigationTitle("Saved Addresses")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddAddressSheet) {
            addAddressSheet
        }
    }

    private func addressCard(_ item: SavedAddress) -> some View {
        KivorlyCard(padding: KivorlySpacing.md) {
            HStack(spacing: KivorlySpacing.md) {
                ZStack {
                    Circle()
                        .fill(KivorlyColors.primary.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: item.icon)
                        .font(.system(size: 18, weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(KivorlyColors.primary)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(item.label)
                            .font(KivorlyTypography.titleSmall)
                            .foregroundColor(KivorlyColors.textPrimary)

                        if item.isDefault {
                            Text("Default")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(KivorlyColors.primary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(KivorlyColors.primary.opacity(0.12))
                                .clipShape(Capsule())
                        }
                    }

                    Text(item.address)
                        .font(KivorlyTypography.caption)
                        .foregroundColor(KivorlyColors.textSecondary)
                        .lineLimit(2)
                }

                Spacer()

                Button(action: {
                    addresses.removeAll { $0.id == item.id }
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                        .foregroundColor(KivorlyColors.error)
                        .padding(8)
                }
            }
        }
    }

    private var addAddressSheet: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: KivorlySpacing.lg) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Label (e.g. Home, Gym)")
                        .font(KivorlyTypography.captionBold)
                    TextField("Home", text: $newLabel)
                        .padding()
                        .background(Color(uiColor: .tertiarySystemFill))
                        .clipShape(Capsule())
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Full Address")
                        .font(KivorlyTypography.captionBold)
                    TextField("Street address, area, city", text: $newAddress)
                        .padding()
                        .background(Color(uiColor: .tertiarySystemFill))
                        .clipShape(Capsule())
                }

                KivorlyButton("Save Address", icon: "checkmark", style: .primary) {
                    if !newLabel.isEmpty && !newAddress.isEmpty {
                        addresses.append(SavedAddress(label: newLabel, address: newAddress, icon: "mappin.circle.fill", isDefault: false))
                        newLabel = ""
                        newAddress = ""
                        showAddAddressSheet = false
                    }
                }

                Spacer()
            }
            .padding(KivorlySpacing.md)
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle("New Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { showAddAddressSheet = false }
                        .foregroundColor(KivorlyColors.primary)
                }
            }
        }
    }
}
