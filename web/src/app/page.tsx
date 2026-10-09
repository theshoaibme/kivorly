"use client";

import Image from "next/image";
import Link from "next/link";
import { useState } from "react";

interface ServiceVertical {
  id: string;
  name: string;
  bangla: string;
  icon: string;
  tagline: string;
  description: string;
  badge: string;
  badgeColor: string;
  screenshot: string;
  popularItems: string[];
}

const SERVICES: ServiceVertical[] = [
  {
    id: "rides",
    name: "Ride Sharing",
    bangla: "রাইড শেয়ারিং",
    icon: "🚗",
    tagline: "Dhaka Live Map & City Transit",
    description:
      "Instant rides across Gulshan, Banani, Dhanmondi, Uttara & Mirpur. Fair transparent pricing with verified drivers and live trip sharing.",
    badge: "Live GPS",
    badgeColor: "bg-emerald-500/20 text-emerald-400 border-emerald-500/30",
    screenshot: "/screenshots/06_service_ride_sharing.png",
    popularItems: ["Car AC / Sedan", "Motorbike Express", "Microbus / HiAce", "CNG Auto"],
  },
  {
    id: "tickets",
    name: "Tickets & Travel",
    bangla: "টিকিট ও ভ্রমণ",
    icon: "🎫",
    tagline: "Inter-City Air, Bus, Train & Launch",
    description:
      "Seamless inter-city travel booking across domestic airlines (NovoAir, US-Bangla), AC sleeper coaches (Shohagh, Green Line), Bangladesh Railway, and Barishal river launches.",
    badge: "All 64 Districts",
    badgeColor: "bg-blue-500/20 text-blue-400 border-blue-500/30",
    screenshot: "/screenshots/07_service_tickets.png",
    popularItems: ["Domestic Flights", "AC Sleeper Bus", "Suborno Express Train", "VIP Launch Cabin"],
  },
  {
    id: "courier",
    name: "Express Courier",
    bangla: "পার্সেল ও কুরিয়ার",
    icon: "📦",
    tagline: "Doorstep Pick & 64-District COD",
    description:
      "Same-day emergency parcel delivery within Dhaka metro and nationwide cash-on-delivery courier network across all 64 districts.",
    badge: "Same-Day",
    badgeColor: "bg-amber-500/20 text-amber-400 border-amber-500/30",
    screenshot: "/screenshots/08_service_parcel_delivery.png",
    popularItems: ["Document Express", "Fragile Package", "Heavy Parcel", "E-commerce Bulk"],
  },
  {
    id: "mall",
    name: "Shopping Mall",
    bangla: "অনলাইন শপিং মল",
    icon: "🛍️",
    tagline: "Authentic Official Brand Outlets",
    description:
      "Shop 100% authentic collections from Aarong, Yellow, Apex, Walton, and Xiaomi with color/size pickers and instant doorstep exchange.",
    badge: "100% Authentic",
    badgeColor: "bg-purple-500/20 text-purple-400 border-purple-500/30",
    screenshot: "/screenshots/09_service_online_shopping.png",
    popularItems: ["Aarong Silk Panjabi", "Apex Leather Shoes", "Walton Smart LED", "Xiaomi Smartphones"],
  },
  {
    id: "grocery",
    name: "Fresh Grocery",
    bangla: "তাজা মুদি বাজার",
    icon: "🥬",
    tagline: "1-Hour Daily Bazaar Delivery",
    description:
      "Fresh Padma River Ilish, country vegetables, farm-fresh eggs, pantry rice, and butcher-cut halal meat delivered in under 60 minutes.",
    badge: "Fresh Daily",
    badgeColor: "bg-green-500/20 text-green-400 border-green-500/30",
    screenshot: "/screenshots/10_service_grocery.png",
    popularItems: ["Padma Ilish (1.2kg)", "Chinigura Aromatic Rice", "Organic Farm Eggs", "Fresh Deshi Vegetables"],
  },
  {
    id: "hotels",
    name: "Hotels & Stays",
    bangla: "হোটেল ও রিসোর্ট",
    icon: "🏖️",
    tagline: "Resorts & Vacation Packages",
    description:
      "Handpicked stays from Cox's Bazar beach retreats and Sajek cloud villas to Sylhet tea estates. Flexible packages: Day-cation, Weekend, or VIP Month.",
    badge: "Best Rate Guarantee",
    badgeColor: "bg-cyan-500/20 text-cyan-400 border-cyan-500/30",
    screenshot: "/screenshots/11_service_hotel_packages.png",
    popularItems: ["Cox's Bazar Beachfront", "Sajek Cloud Resort", "Sreemangal Tea Villa", "Dhaka 5-Star Staycation"],
  },
  {
    id: "food",
    name: "Food Delivery",
    bangla: "খাবার ডেলিভারি",
    icon: "🍔",
    tagline: "Dhaka's Favorite Restaurants",
    description:
      "Curb your cravings with Sultan's Dine Kacchi, Chillox Burgers, Madchef, Kacchi Bhai, and authentic Old Dhaka chaat with thermal-insulated speed delivery.",
    badge: "Hot & Fresh",
    badgeColor: "bg-rose-500/20 text-rose-400 border-rose-500/30",
    screenshot: "/screenshots/12_service_food_delivery.png",
    popularItems: ["Sultan's Dine Kacchi", "Chillox Double Patty", "Madchef Chicken Feast", "Old Dhaka Bakarkhani"],
  },
  {
    id: "services",
    name: "Home Services",
    bangla: "হোম সার্ভিস",
    icon: "🛠️",
    tagline: "Certified Technicians & Cleaning",
    description:
      "Verified AC servicing, licensed electrical repairs, leak plumbing, and comprehensive home deep-cleaning backed by Kivorly's 30-day warranty.",
    badge: "30-Day Guarantee",
    badgeColor: "bg-orange-500/20 text-orange-400 border-orange-500/30",
    screenshot: "/screenshots/13_service_home_services.png",
    popularItems: ["AC Jet Master Wash", "Home Electric Audit", "Deep Kitchen Cleaning", "Plumbing Pipe Fix"],
  },
];

const METRICS = [
  { value: "64", label: "Districts Covered", sublabel: "Nationwide reach" },
  { value: "8+", label: "Dedicated Verticals", sublabel: "All in one app" },
  { value: "৳0", label: "Hidden Fees", sublabel: "Transparent pricing" },
  { value: "99.9%", label: "On-Time Dispatch", sublabel: "Real-time tracking" },
];

export default function Home() {
  const [activeVertical, setActiveVertical] = useState<ServiceVertical>(SERVICES[0]);
  const [searchQuery, setSearchQuery] = useState("");

  const filteredServices = searchQuery.trim()
    ? SERVICES.filter(
        (s) =>
          s.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
          s.description.toLowerCase().includes(searchQuery.toLowerCase()) ||
          s.popularItems.some((item) => item.toLowerCase().includes(searchQuery.toLowerCase()))
      )
    : SERVICES;

  return (
    <div className="relative min-h-screen overflow-x-hidden bg-[#0a0e17] text-slate-100">
      {/* Background Glows */}
      <div className="pointer-events-none absolute -top-40 left-1/2 -z-10 h-[600px] w-[1000px] -translate-x-1/2 rounded-full bg-gradient-to-tr from-emerald-600/15 via-teal-500/10 to-red-500/10 blur-[140px]" />
      <div className="pointer-events-none absolute top-[900px] right-0 -z-10 h-[500px] w-[500px] rounded-full bg-emerald-600/10 blur-[130px]" />

      {/* Top Navigation */}
      <header className="sticky top-0 z-50 border-b border-white/10 bg-[#0a0e17]/80 backdrop-blur-xl">
        <div className="mx-auto flex max-w-7xl items-center justify-between px-6 py-4">
          <div className="flex items-center gap-3">
            <div className="flex h-11 w-11 items-center justify-center rounded-xl bg-gradient-to-br from-[#006A4E] to-[#004d38] shadow-lg shadow-emerald-900/30">
              <span className="text-xl font-black text-white">K</span>
            </div>
            <div>
              <div className="flex items-center gap-2">
                <span className="text-xl font-extrabold tracking-tight text-white">Kivorly</span>
                <span className="rounded-full bg-emerald-500/20 px-2 py-0.5 text-[11px] font-semibold text-emerald-400">
                  🇧🇩 Bangladesh
                </span>
              </div>
              <p className="text-xs text-slate-400">The Everything Super App</p>
            </div>
          </div>

          <nav className="hidden items-center gap-8 md:flex">
            <a href="#services" className="text-sm font-medium text-slate-300 transition-colors hover:text-white">
              Services
            </a>
            <a href="#coverage" className="text-sm font-medium text-slate-300 transition-colors hover:text-white">
              64 Districts
            </a>
            <a href="#payments" className="text-sm font-medium text-slate-300 transition-colors hover:text-white">
              Payments
            </a>
            <a href="#preview" className="text-sm font-medium text-slate-300 transition-colors hover:text-white">
              App Preview
            </a>
          </nav>

          <div className="flex items-center gap-3">
            <Link
              href="#download"
              className="group relative inline-flex items-center justify-center overflow-hidden rounded-xl bg-gradient-to-r from-[#006A4E] to-emerald-600 px-5 py-2.5 text-sm font-semibold text-white shadow-lg shadow-emerald-950/40 transition-all hover:scale-[1.02] hover:shadow-emerald-700/30 active:scale-[0.98]"
            >
              Get App
            </Link>
          </div>
        </div>
      </header>

      {/* Hero Section */}
      <section className="relative px-6 pt-16 pb-24 md:pt-24 md:pb-32">
        <div className="mx-auto max-w-5xl text-center">
          <div className="inline-flex items-center gap-2 rounded-full border border-emerald-500/30 bg-emerald-500/10 px-4 py-1.5 text-xs font-semibold text-emerald-400 backdrop-blur-md">
            <span>✨</span> One Unified App for Everyday Life Across Bangladesh
          </div>

          <h1 className="mt-8 text-4xl font-extrabold tracking-tight text-white sm:text-6xl md:text-7xl">
            Everything You Need.
            <br />
            <span className="bg-gradient-to-r from-emerald-400 via-teal-300 to-rose-400 bg-clip-text text-transparent">
              One Super App.
            </span>
          </h1>

          <p className="mx-auto mt-6 max-w-2xl text-lg text-slate-300 sm:text-xl">
            Rides across Dhaka, inter-city travel tickets, same-day parcels, brand shopping, fresh daily bazaar, hotel stays, food delivery, and certified home services.
          </p>

          {/* Quick Search */}
          <div className="mx-auto mt-10 max-w-xl">
            <div className="relative flex items-center overflow-hidden rounded-2xl border border-white/15 bg-white/5 p-2 shadow-2xl backdrop-blur-xl transition-all focus-within:border-emerald-500/60 focus-within:ring-2 focus-within:ring-emerald-500/20">
              <span className="pl-3 text-slate-400">🔍</span>
              <input
                type="text"
                placeholder="Search rides, tickets, ilish fish, Sultan's Dine, AC service..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="w-full bg-transparent px-3 py-2 text-sm text-white placeholder-slate-400 focus:outline-none"
              />
              {searchQuery && (
                <button
                  onClick={() => setSearchQuery("")}
                  className="mr-2 text-xs text-slate-400 hover:text-white"
                >
                  Clear
                </button>
              )}
            </div>
          </div>

          {/* Metric Stats */}
          <div className="mt-14 grid grid-cols-2 gap-4 sm:grid-cols-4">
            {METRICS.map((metric) => (
              <div
                key={metric.label}
                className="rounded-2xl border border-white/5 bg-white/[0.03] p-4 backdrop-blur-sm"
              >
                <div className="text-2xl font-black text-white sm:text-3xl">{metric.value}</div>
                <div className="text-xs font-semibold text-emerald-400">{metric.label}</div>
                <div className="text-[11px] text-slate-400">{metric.sublabel}</div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Dedicated Verticals Interactive Showcase */}
      <section id="services" className="relative border-t border-white/10 bg-[#0d131f]/70 py-24 backdrop-blur-md">
        <div className="mx-auto max-w-7xl px-6">
          <div className="flex flex-col items-center justify-between gap-4 md:flex-row">
            <div>
              <span className="text-xs font-bold uppercase tracking-wider text-emerald-400">
                8 Dedicated Verticals
              </span>
              <h2 className="mt-1 text-3xl font-extrabold text-white sm:text-4xl">
                Explore The Kivorly Ecosystem
              </h2>
            </div>
            <p className="max-w-md text-sm text-slate-400">
              Each vertical is built specifically for local needs with transparent pricing in Taka (৳) and live order status.
            </p>
          </div>

          {/* Service Selector Tabs */}
          <div className="mt-10 flex gap-2 overflow-x-auto pb-4 scrollbar-none">
            {filteredServices.map((service) => {
              const isActive = activeVertical.id === service.id;
              return (
                <button
                  key={service.id}
                  onClick={() => setActiveVertical(service)}
                  className={`flex shrink-0 items-center gap-2.5 rounded-xl border px-4 py-3 text-sm font-semibold transition-all ${
                    isActive
                      ? "border-emerald-500/80 bg-emerald-500/15 text-white shadow-lg shadow-emerald-950/40"
                      : "border-white/10 bg-white/5 text-slate-300 hover:border-white/20 hover:bg-white/[0.08]"
                  }`}
                >
                  <span className="text-lg">{service.icon}</span>
                  <span>{service.name}</span>
                </button>
              );
            })}
          </div>

          {/* Active Service Showcase Card */}
          <div className="mt-8 grid grid-cols-1 items-center gap-8 rounded-3xl border border-white/10 bg-gradient-to-br from-white/[0.05] to-white/[0.01] p-8 backdrop-blur-2xl lg:grid-cols-12">
            <div className="lg:col-span-6">
              <div className="flex items-center gap-3">
                <span className="text-3xl">{activeVertical.icon}</span>
                <div>
                  <h3 className="text-2xl font-bold text-white sm:text-3xl">
                    {activeVertical.name}
                  </h3>
                  <p className="text-xs font-semibold text-emerald-400">{activeVertical.bangla}</p>
                </div>
                <span
                  className={`ml-auto rounded-full border px-3 py-1 text-xs font-semibold ${activeVertical.badgeColor}`}
                >
                  {activeVertical.badge}
                </span>
              </div>

              <h4 className="mt-4 text-lg font-semibold text-slate-200">
                {activeVertical.tagline}
              </h4>

              <p className="mt-3 text-sm leading-relaxed text-slate-300">
                {activeVertical.description}
              </p>

              <div className="mt-6">
                <div className="text-xs font-semibold uppercase tracking-wider text-slate-400">
                  Featured Offerings
                </div>
                <div className="mt-2.5 flex flex-wrap gap-2">
                  {activeVertical.popularItems.map((item) => (
                    <span
                      key={item}
                      className="rounded-lg border border-white/10 bg-white/5 px-3 py-1.5 text-xs font-medium text-slate-200"
                    >
                      {item}
                    </span>
                  ))}
                </div>
              </div>

              <div className="mt-8 flex items-center gap-4">
                <a
                  href="#download"
                  className="inline-flex items-center gap-2 rounded-xl bg-gradient-to-r from-emerald-500 to-teal-600 px-5 py-2.5 text-sm font-semibold text-white shadow-lg transition-transform hover:scale-[1.02]"
                >
                  Book on App →
                </a>
                <span className="text-xs text-slate-400">Live order tracking with Dynamic Island</span>
              </div>
            </div>

            {/* Screenshot Mockup Container */}
            <div className="flex justify-center lg:col-span-6">
              <div className="relative overflow-hidden rounded-2xl border border-white/15 bg-black/40 shadow-2xl transition-all">
                <Image
                  src={activeVertical.screenshot}
                  alt={`${activeVertical.name} Interface Screenshot`}
                  width={340}
                  height={680}
                  className="rounded-2xl object-cover"
                />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Payment Methods Section */}
      <section id="payments" className="border-t border-white/10 py-20">
        <div className="mx-auto max-w-5xl px-6 text-center">
          <span className="text-xs font-bold uppercase tracking-wider text-rose-400">
            Localized Payments
          </span>
          <h2 className="mt-2 text-3xl font-extrabold text-white sm:text-4xl">
            Pay with What You Already Use
          </h2>
          <p className="mx-auto mt-3 max-w-xl text-sm text-slate-400">
            Transparent price breakdowns with zero hidden fees. Instant PIN validation and Cash on Delivery for all services.
          </p>

          <div className="mt-10 grid grid-cols-1 gap-4 sm:grid-cols-3">
            <div className="flex flex-col items-center justify-center rounded-2xl border border-pink-500/20 bg-pink-500/5 p-6 backdrop-blur-sm">
              <div className="text-3xl font-black text-pink-400">bKash</div>
              <div className="mt-2 text-sm font-semibold text-white">Instant MFS Pay</div>
              <div className="text-xs text-slate-400">Cashback offers & 1-tap PIN authorization</div>
            </div>

            <div className="flex flex-col items-center justify-center rounded-2xl border border-orange-500/20 bg-orange-500/5 p-6 backdrop-blur-sm">
              <div className="text-3xl font-black text-orange-400">Nagad</div>
              <div className="mt-2 text-sm font-semibold text-white">Postal MFS Gateway</div>
              <div className="text-xs text-slate-400">Lowest transaction fees and quick refunds</div>
            </div>

            <div className="flex flex-col items-center justify-center rounded-2xl border border-emerald-500/20 bg-emerald-500/5 p-6 backdrop-blur-sm">
              <div className="text-3xl font-black text-emerald-400">COD ৳</div>
              <div className="mt-2 text-sm font-semibold text-white">Cash on Delivery</div>
              <div className="text-xs text-slate-400">Pay cash upon parcel or grocery arrival</div>
            </div>
          </div>
        </div>
      </section>

      {/* Full App Showcase Grid */}
      <section id="preview" className="border-t border-white/10 bg-[#0c101c] py-24">
        <div className="mx-auto max-w-7xl px-6">
          <div className="text-center">
            <span className="text-xs font-bold uppercase tracking-wider text-emerald-400">
              Interactive Gallery
            </span>
            <h2 className="mt-2 text-3xl font-extrabold text-white sm:text-4xl">
              Crafted for iOS, Android & Web
            </h2>
            <p className="mx-auto mt-3 max-w-xl text-sm text-slate-400">
              Native SwiftUI on iOS, Jetpack Compose on Android, and Next.js on the Web for speed and reliability.
            </p>
          </div>

          <div className="mt-14 grid grid-cols-2 gap-6 sm:grid-cols-3 md:grid-cols-5">
            {[
              { title: "Home Dashboard", src: "/screenshots/01_home_dashboard.png" },
              { title: "Explore Directory", src: "/screenshots/02_explore_directory.png" },
              { title: "Orders & History", src: "/screenshots/03_orders_history.png" },
              { title: "Live Activity", src: "/screenshots/04_activity_live.png" },
              { title: "Profile & Settings", src: "/screenshots/05_profile_settings.png" },
            ].map((shot) => (
              <div
                key={shot.title}
                className="group relative flex flex-col items-center overflow-hidden rounded-2xl border border-white/10 bg-white/[0.03] p-2 transition-all hover:border-emerald-500/50 hover:bg-white/[0.06]"
              >
                <div className="relative aspect-[9/19] w-full overflow-hidden rounded-xl bg-black/40">
                  <Image
                    src={shot.src}
                    alt={shot.title}
                    fill
                    sizes="(max-width: 768px) 50vw, 20vw"
                    className="object-cover transition-transform duration-300 group-hover:scale-105"
                  />
                </div>
                <div className="py-2 text-center text-xs font-semibold text-slate-300">
                  {shot.title}
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* Download / CTA Section */}
      <section id="download" className="relative border-t border-white/10 py-24">
        <div className="mx-auto max-w-4xl px-6 text-center">
          <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-to-br from-[#006A4E] to-emerald-500 shadow-xl shadow-emerald-900/40">
            <span className="text-3xl font-black text-white">K</span>
          </div>

          <h2 className="mt-6 text-3xl font-black text-white sm:text-5xl">
            Get Kivorly Today
          </h2>
          <p className="mx-auto mt-4 max-w-xl text-base text-slate-300">
            Available on iOS with native Dynamic Island support, Android with Jetpack Compose, and modern Web.
          </p>

          <div className="mt-10 flex flex-wrap items-center justify-center gap-4">
            <div className="flex items-center gap-3 rounded-2xl border border-white/15 bg-white/10 px-6 py-3.5 backdrop-blur-md transition-all hover:bg-white/15">
              <span className="text-2xl"></span>
              <div className="text-left">
                <div className="text-[10px] uppercase text-slate-400">Available for</div>
                <div className="text-sm font-bold text-white">Apple iOS (17+)</div>
              </div>
            </div>

            <div className="flex items-center gap-3 rounded-2xl border border-white/15 bg-white/10 px-6 py-3.5 backdrop-blur-md transition-all hover:bg-white/15">
              <span className="text-2xl">🤖</span>
              <div className="text-left">
                <div className="text-[10px] uppercase text-slate-400">Available for</div>
                <div className="text-sm font-bold text-white">Android (Compose)</div>
              </div>
            </div>

            <div className="flex items-center gap-3 rounded-2xl border border-white/15 bg-white/10 px-6 py-3.5 backdrop-blur-md transition-all hover:bg-white/15">
              <span className="text-2xl">🌐</span>
              <div className="text-left">
                <div className="text-[10px] uppercase text-slate-400">Instant Access</div>
                <div className="text-sm font-bold text-white">Web Portal (Next.js)</div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-white/10 bg-black/40 py-12 text-center text-xs text-slate-400">
        <div className="mx-auto max-w-7xl px-6 flex flex-col items-center justify-between gap-4 sm:flex-row">
          <div className="flex items-center gap-2">
            <span className="font-extrabold text-white">Kivorly 🇧🇩</span>
            <span>— The Everything Super App for Bangladesh</span>
          </div>
          <div>
            Copyright © 2026 Kivorly Technologies. All rights reserved.
          </div>
        </div>
      </footer>
    </div>
  );
}
