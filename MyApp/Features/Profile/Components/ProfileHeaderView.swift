//
//  ProfileHeaderView.swift
//  Kivorly
//
//  User profile card component with edit trigger.
//

import SwiftUI

public struct ProfileHeaderView: View {
    let name: String
    let phone: String
    let onEditTap: () -> Void

    public init(name: String, phone: String, onEditTap: @escaping () -> Void) {
        self.name = name
        self.phone = phone
        self.onEditTap = onEditTap
    }

    public var body: some View {
        Button(action: onEditTap) {
            KivorlyCard(padding: KivorlySpacing.lg) {
                HStack(spacing: KivorlySpacing.md) {
                    Image("profile_user")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(KivorlyColors.primary.opacity(0.4), lineWidth: 2)
                        )
                        .shadow(color: Color.black.opacity(0.08), radius: 4, y: 2)

                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 6) {
                            Text(name)
                                .font(KivorlyTypography.titleSmall)
                                .foregroundColor(KivorlyColors.textPrimary)

                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(KivorlyColors.primary)
                                .font(.system(size: 14))
                        }

                        Text(phone)
                            .font(KivorlyTypography.caption)
                            .foregroundColor(KivorlyColors.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "square.and.pencil")
                        .foregroundColor(KivorlyColors.primary)
                        .font(.system(size: 18))
                }
            }
            .padding(.horizontal, KivorlySpacing.md)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
