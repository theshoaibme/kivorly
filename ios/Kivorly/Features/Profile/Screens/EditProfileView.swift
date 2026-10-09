//
//  EditProfileView.swift
//  Kivorly
//
//  Edit personal account details (Name, Phone, Email, City).
//

import SwiftUI

public struct EditProfileView: View {
    @Binding var name: String
    @Binding var phone: String
    @State private var email: String = "shoaib@kivorly.com"
    @State private var city: String = "Dhaka, Bangladesh"
    @Environment(\.dismiss) private var dismiss

    public init(name: Binding<String>, phone: Binding<String>) {
        self._name = name
        self._phone = phone
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: KivorlySpacing.lg) {
                    // Avatar with edit badge
                    ZStack(alignment: .bottomTrailing) {
                        Image("profile_user")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 96, height: 96)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(KivorlyColors.primary.opacity(0.4), lineWidth: 2.5)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 6, y: 3)

                        ZStack {
                            Circle()
                                .fill(KivorlyColors.primary)
                                .frame(width: 30, height: 30)
                            Image(systemName: "camera.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, KivorlySpacing.md)

                    // Input Form
                    VStack(alignment: .leading, spacing: KivorlySpacing.md) {
                        fieldGroup(title: "Full Name", text: $name, icon: "person.text.rectangle")
                        fieldGroup(title: "Phone Number", text: $phone, icon: "phone.fill")
                        fieldGroup(title: "Email Address", text: $email, icon: "envelope.fill")
                        fieldGroup(title: "City", text: $city, icon: "mappin.and.ellipse")
                    }
                    .padding(.horizontal, KivorlySpacing.md)

                    KivorlyButton("Save Changes", icon: "checkmark", style: .primary) {
                        dismiss()
                    }
                    .padding(.horizontal, KivorlySpacing.md)
                    .padding(.top, KivorlySpacing.sm)
                }
                .padding(.vertical, KivorlySpacing.md)
            }
            .background(KivorlyColors.background.ignoresSafeArea())
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(KivorlyColors.primary)
                }
            }
        }
    }

    private func fieldGroup(title: String, text: Binding<String>, icon: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(KivorlyTypography.captionBold)
                .foregroundColor(KivorlyColors.textPrimary)

            HStack(spacing: KivorlySpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(KivorlyColors.primary)
                    .frame(width: 20)

                TextField(title, text: text)
                    .font(KivorlyTypography.bodyLarge)
                    .foregroundColor(KivorlyColors.textPrimary)
            }
            .padding(.horizontal, KivorlySpacing.md)
            .padding(.vertical, 14)
            .background(Color(uiColor: .tertiarySystemFill))
            .clipShape(Capsule())
        }
    }
}
