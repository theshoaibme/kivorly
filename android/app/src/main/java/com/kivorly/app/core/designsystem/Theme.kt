package com.kivorly.app.core.designsystem

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable

private val DarkColorScheme = darkColorScheme(
    primary = KivorlyPrimary,
    secondary = KivorlySecondary,
    tertiary = KivorlyAccent,
    background = KivorlyBackground,
    surface = KivorlySurface,
    onPrimary = KivorlyTextPrimary,
    onSecondary = KivorlyTextPrimary,
    onBackground = KivorlyTextPrimary,
    onSurface = KivorlyTextPrimary
)

@Composable
fun KivorlyTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = DarkColorScheme,
        content = content
    )
}
