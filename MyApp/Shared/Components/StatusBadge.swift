//
//  StatusBadge.swift
//  Kivorly
//
//  Semantic indicator pill using iOS system tints.
//

import SwiftUI

public enum KivorlyStatus {
    case active
    case pending
    case inProgress
    case confirmed
    case completed
    case cancelled
    case refunded

    public var title: String {
        switch self {
        case .active: return "Active"
        case .pending: return "Pending"
        case .inProgress: return "In Progress"
        case .confirmed: return "Confirmed"
        case .completed: return "Completed"
        case .cancelled: return "Cancelled"
        case .refunded: return "Refunded"
        }
    }

    public var color: Color {
        switch self {
        case .active, .inProgress:
            return KivorlyColors.primary
        case .confirmed, .completed:
            return KivorlyColors.success
        case .pending:
            return KivorlyColors.warning
        case .cancelled, .refunded:
            return KivorlyColors.error
        }
    }
}

public struct StatusBadge: View {
    private let status: KivorlyStatus

    public init(_ status: KivorlyStatus) {
        self.status = status
    }

    public var body: some View {
        Text(status.title)
            .font(KivorlyTypography.captionBold)
            .foregroundColor(status.color)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.12))
            .clipShape(Capsule())
    }
}
