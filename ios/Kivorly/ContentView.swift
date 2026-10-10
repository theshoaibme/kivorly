//
//  ContentView.swift
//  Kivorly
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if let targetPage = ProcessInfo.processInfo.environment["SCREENSHOT_PAGE"], !targetPage.isEmpty {
            screenshotTargetView(for: targetPage)
        } else {
            AppCoordinatorView()
        }
    }

    @ViewBuilder
    private func screenshotTargetView(for page: String) -> some View {
        switch page {
        case "01_splash":
            SplashScreenView(onFinish: {})

        case "02_onboarding":
            OnboardingView(onComplete: {})

        case "03_authentication":
            AuthenticationView(onAuthenticated: {})

        case "04_home_dashboard":
            NavigationStack {
                HomeDashboardView(onSelectService: { _ in })
            }

        case "05_explore":
            ExploreView(onSelectService: { _ in })

        case "06_orders":
            NavigationStack {
                OrdersView()
            }

        case "07_activity":
            NavigationStack {
                ActivityView()
            }

        case "08_profile":
            ProfileView(onLogout: {})

        case "09_service_ride":
            UberRideBookingView()

        case "10_service_food":
            ServiceDetailView(service: .foodDelivery)

        case "11_service_grocery":
            BangladeshGroceryView()

        case "12_service_shopping":
            BangladeshShoppingView()

        case "13_service_tickets":
            BangladeshTicketsBookingView()

        case "14_service_courier":
            BangladeshParcelDeliveryView()

        case "15_service_hotels":
            BangladeshHotelsBookingView()

        case "16_service_home_services":
            ServiceDetailView(service: .homeServices)

        case "17_food_checkout":
            if let foodItem = ServiceDataProvider.items(for: .foodDelivery).first {
                ServiceCheckoutModal(item: foodItem, onOrderCompleted: {})
            } else {
                Text("No food items available")
            }

        case "18_order_detail":
            OrderDetailView(orderId: "KV-FOOD-892", onDismiss: {})

        case "19_profile_edit":
            EditProfileView(name: .constant("Shoaib"), phone: .constant("+880 1712 345678"))

        case "20_profile_payment":
            NavigationStack {
                PaymentMethodsView()
            }

        case "21_profile_privacy":
            NavigationStack {
                PrivacySecurityView()
            }

        case "22_profile_addresses":
            NavigationStack {
                SavedAddressesView()
            }

        case "23_profile_notifications":
            NavigationStack {
                NotificationPreferencesView()
            }

        case "24_profile_help":
            NavigationStack {
                HelpCenterView()
            }

        case "25_profile_terms":
            NavigationStack {
                TermsPrivacyView()
            }

        case "26_design_system":
            DesignSystemCatalogView()

        default:
            AppCoordinatorView()
        }
    }
}

#Preview {
    ContentView()
}
