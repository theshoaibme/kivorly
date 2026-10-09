import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
});

export const metadata: Metadata = {
  title: "Kivorly 🇧🇩 | The Everything Super App for Bangladesh",
  description:
    "One unified app for everything you need daily across Dhaka and all 64 districts in Bangladesh. Rides, Tickets, Express Courier, Shopping Mall, Daily Fresh Grocery, Hotels, Food Delivery, and Home Services.",
  keywords: [
    "Kivorly",
    "Super App Bangladesh",
    "Dhaka Ride Sharing",
    "Food Delivery Dhaka",
    "Grocery Delivery Bangladesh",
    "bKash",
    "Nagad",
    "Cox's Bazar Hotel Booking",
  ],
  openGraph: {
    title: "Kivorly - Bangladesh's Everything Super App",
    description:
      "Rides, Inter-city Travel, Parcels, Shopping, Fresh Grocery, Hotels, Food, and Home Services across Bangladesh.",
    siteName: "Kivorly",
    locale: "en_US",
    type: "website",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${geistSans.variable} ${geistMono.variable} h-full antialiased dark`}
    >
      <body className="min-h-full flex flex-col bg-[#0b0f17] text-white selection:bg-[#006A4E] selection:text-white">
        {children}
      </body>
    </html>
  );
}
