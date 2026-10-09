package com.kivorly.app.features.rides

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.kivorly.app.core.designsystem.*

@Composable
fun RideBookingScreen(
    onBack: () -> Unit,
    modifier: Modifier = Modifier
) {
    var selectedTier by remember { mutableStateOf("Sedan AC") }

    Column(
        modifier = modifier
            .fillMaxSize()
            .background(KivorlyBackground)
            .padding(16.dp)
    ) {
        Row(
            modifier = Modifier.fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            TextButton(onClick = onBack) {
                Text(text = "← Back", color = KivorlyPrimary, fontWeight = FontWeight.Bold)
            }
            Text(
                text = "Dhaka Ride Booking",
                color = Color.White,
                fontSize = 18.sp,
                fontWeight = FontWeight.Bold
            )
            Spacer(modifier = Modifier.width(48.dp))
        }

        Spacer(modifier = Modifier.height(16.dp))

        // Pickup / Destination Card
        Box(
            modifier = Modifier
                .fillMaxWidth()
                .clip(RoundedCornerShape(16.dp))
                .background(KivorlySurface)
                .padding(16.dp)
        ) {
            Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(text = "🟢", fontSize = 12.sp)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "Pickup: Road 11, Banani, Dhaka",
                        color = Color.White,
                        fontSize = 14.sp
                    )
                }
                Divider(color = KivorlyDivider)
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(text = "🔴", fontSize = 12.sp)
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "Destination: Dhanmondi 27, Dhaka",
                        color = Color.White,
                        fontSize = 14.sp
                    )
                }
            }
        }

        Spacer(modifier = Modifier.height(20.dp))

        Text(
            text = "Select Vehicle Class",
            color = Color.White,
            fontSize = 16.sp,
            fontWeight = FontWeight.Bold
        )

        Spacer(modifier = Modifier.height(12.dp))

        val tiers = listOf(
            Triple("Sedan AC", "৳ 320", "Comfortable private AC car"),
            Triple("Motorbike Express", "৳ 140", "Fastest through Dhaka traffic"),
            Triple("Microbus / HiAce", "৳ 650", "Seats up to 7 passengers"),
            Triple("CNG Auto Rickshaw", "৳ 180", "Economy 3-wheeler")
        )

        tiers.forEach { (name, price, desc) ->
            val isSelected = selectedTier == name
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 4.dp)
                    .clip(RoundedCornerShape(14.dp))
                    .background(if (isSelected) KivorlyPrimary.copy(alpha = 0.2f) else KivorlySurface)
                    .padding(14.dp)
            ) {
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Column {
                        Text(
                            text = name,
                            color = Color.White,
                            fontSize = 15.sp,
                            fontWeight = FontWeight.Bold
                        )
                        Text(
                            text = desc,
                            color = KivorlyTextSecondary,
                            fontSize = 12.sp
                        )
                    }
                    Text(
                        text = price,
                        color = if (isSelected) KivorlyPrimary else Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }

        Spacer(modifier = Modifier.weight(1f))

        Button(
            onClick = { /* Confirm Ride */ },
            modifier = Modifier
                .fillMaxWidth()
                .height(54.dp),
            shape = RoundedCornerShape(16.dp),
            colors = ButtonDefaults.buttonColors(containerColor = KivorlyPrimary)
        ) {
            Text(
                text = "Confirm $selectedTier",
                fontSize = 16.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
        }
    }
}
