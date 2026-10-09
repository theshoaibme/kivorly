package com.kivorly.app.core.navigation

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.navigation.NavGraph.Companion.findStartDestination
import androidx.navigation.compose.*
import com.kivorly.app.core.designsystem.*
import com.kivorly.app.features.home.HomeScreen
import com.kivorly.app.features.rides.RideBookingScreen

@Composable
fun AppNavigation() {
    val navController = rememberNavController()
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = navBackStackEntry?.destination?.route

    val bottomNavItems = listOf(
        Screen.Home,
        Screen.Explore,
        Screen.Orders,
        Screen.Profile
    )

    Scaffold(
        bottomBar = {
            if (currentRoute != Screen.RideBooking.route) {
                NavigationBar(
                    containerColor = KivorlySurface,
                    contentColor = Color.White
                ) {
                    bottomNavItems.forEach { screen ->
                        val isSelected = currentRoute == screen.route
                        NavigationBarItem(
                            icon = { Text(screen.icon) },
                            label = { Text(screen.title) },
                            selected = isSelected,
                            colors = NavigationBarItemDefaults.colors(
                                selectedIconColor = Color.White,
                                selectedTextColor = KivorlyPrimary,
                                unselectedIconColor = KivorlyTextSecondary,
                                unselectedTextColor = KivorlyTextSecondary,
                                indicatorColor = KivorlyPrimary.copy(alpha = 0.25f)
                            ),
                            onClick = {
                                navController.navigate(screen.route) {
                                    popUpTo(navController.graph.findStartDestination().id) {
                                        saveState = true
                                    }
                                    launchSingleTop = true
                                    restoreState = true
                                }
                            }
                        )
                    }
                }
            }
        }
    ) { innerPadding ->
        NavHost(
            navController = navController,
            startDestination = Screen.Home.route,
            modifier = Modifier.padding(innerPadding)
        ) {
            composable(Screen.Home.route) {
                HomeScreen(
                    onNavigateToRide = {
                        navController.navigate(Screen.RideBooking.route)
                    }
                )
            }
            composable(Screen.Explore.route) {
                HomeScreen(onNavigateToRide = {})
            }
            composable(Screen.Orders.route) {
                HomeScreen(onNavigateToRide = {})
            }
            composable(Screen.Profile.route) {
                HomeScreen(onNavigateToRide = {})
            }
            composable(Screen.RideBooking.route) {
                RideBookingScreen(
                    onBack = { navController.popBackStack() }
                )
            }
        }
    }
}
