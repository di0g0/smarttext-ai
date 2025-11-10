//
//  PaywallView.swift
//  QuickTranslateAI
//
//  Tela de upgrade para Premium
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var storeKit = StoreKitManager.shared
    @State private var selectedProduct: Product?
    
    let source: PaywallSource
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color.accentColor.opacity(0.15),
                    Color.purple.opacity(0.10),
                    Color.blue.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header
                    headerView
                    
                    // Features
                    featuresView
                    
                    // Products
                    productsView
                    
                    // Footer
                    footerView
                }
            }
        }
        .frame(width: 600, height: 700)
        .onAppear {
            // Seleciona o plano anual por padrão (melhor valor)
            if let yearlyProduct = storeKit.products.first(where: { $0.id == ProductID.yearlySubscription.rawValue }) {
                selectedProduct = yearlyProduct
            }
            
            // Adiciona listener para ESC
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                if event.keyCode == 53 { // ESC
                    dismiss()
                    return nil
                }
                return event
            }
        }
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        VStack(spacing: 12) {
            // Close button
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Icon
            Image(systemName: "star.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.yellow, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .padding(.top, 4)
            
            // Title
            Text(NSLocalizedString("paywall.title", comment: "Upgrade to Premium"))
                .font(.system(size: 32, weight: .bold))
            
            // Subtitle
            Text(getSubtitle())
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 20)
    }
    
    private func getSubtitle() -> String {
        switch source {
        case .limitReached:
            return NSLocalizedString("paywall.subtitle.limit", comment: "You've reached your daily limit")
        case .settings:
            return NSLocalizedString("paywall.subtitle.settings", comment: "Unlock unlimited translations")
        case .onboarding:
            return NSLocalizedString("paywall.subtitle.onboarding", comment: "Start with unlimited access")
        case .menu:
            return NSLocalizedString("paywall.subtitle.menu", comment: "Unlock unlimited translations and premium features")
        }
    }
    
    // MARK: - Features
    
    private var featuresView: some View {
        VStack(spacing: 16) {
            FeatureRow(
                icon: "infinity",
                title: NSLocalizedString("paywall.feature.unlimited.title", comment: "Unlimited Translations"),
                description: NSLocalizedString("paywall.feature.unlimited.description", comment: "No daily limits")
            )
            
            FeatureRow(
                icon: "clock.arrow.circlepath",
                title: NSLocalizedString("paywall.feature.history.title", comment: "Full History"),
                description: NSLocalizedString("paywall.feature.history.description", comment: "Never lose your translations")
            )
            
            FeatureRow(
                icon: "sparkles",
                title: NSLocalizedString("paywall.feature.support.title", comment: "Priority Support"),
                description: NSLocalizedString("paywall.feature.support.description", comment: "Get help faster")
            )
            
            FeatureRow(
                icon: "arrow.triangle.2.circlepath",
                title: NSLocalizedString("paywall.feature.updates.title", comment: "Future Features"),
                description: NSLocalizedString("paywall.feature.updates.description", comment: "Access to all new features")
            )
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 20)
    }
    
    // MARK: - Products
    
    private var productsView: some View {
        VStack(spacing: 12) {
            if storeKit.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
                    .padding()
            } else if storeKit.products.isEmpty {
                Text(NSLocalizedString("paywall.loading_error", comment: "Failed to load products"))
                    .foregroundColor(.secondary)
                
                Button(NSLocalizedString("button.retry", comment: "Retry")) {
                    Task {
                        await storeKit.loadProducts()
                    }
                }
                .buttonStyle(.bordered)
            } else {
                ForEach(storeKit.products, id: \.id) { product in
                    ProductCard(
                        product: product,
                        isSelected: selectedProduct?.id == product.id,
                        onTap: {
                            selectedProduct = product
                        }
                    )
                }
            }
            
            // Purchase button
            if let product = selectedProduct {
                Button(action: {
                    Task {
                        do {
                            try await storeKit.purchase(product)
                            dismiss()
                        } catch {
                            // Error já tratado no StoreKitManager
                        }
                    }
                }) {
                    HStack {
                        if storeKit.isLoading {
                            ProgressView()
                                .scaleEffect(0.8)
                                .tint(.white)
                        } else {
                            Text(NSLocalizedString("button.subscribe_now", comment: "Subscribe Now"))
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(storeKit.isLoading)
                .padding(.bottom, 20)
            }
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Footer
    
    private var footerView: some View {
        VStack(spacing: 12) {
            // Restore Purchases sempre visível
            Button(action: {
                Task {
                    await storeKit.restorePurchases()
                    // Fecha o paywall após restaurar
                    dismiss()
                }
            }) {
                Text(NSLocalizedString("button.restore_purchases", comment: "Restore Purchases"))
                    .font(.body)
                    .fontWeight(.medium)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            
            HStack(spacing: 16) {
                Link(NSLocalizedString("link.terms", comment: "Terms"), destination: URL(string: "https://di0g0.github.io/smarttext-ai/")!)
                Text("•")
                Link(NSLocalizedString("link.privacy", comment: "Privacy"), destination: URL(string: "https://di0g0.github.io/smarttext-ai/privacy")!)
            }
            .font(.caption2)
            .foregroundColor(.secondary)
        }
        .padding(.vertical, 20)
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Product Card

struct ProductCard: View {
    let product: Product
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(product.displayName)
                            .font(.headline)
                        
                        if isBestValue {
                            Text(NSLocalizedString("badge.best_value", comment: "Best Value"))
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(4)
                        }
                    }
                    
                    if let period = product.subscriptionPeriod {
                        Text(period)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(product.displayPrice)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if let savings = getSavings() {
                        Text(savings)
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .background(isSelected ? Color.accentColor.opacity(0.15) : Color.gray.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
    
    private var isBestValue: Bool {
        product.id == ProductID.yearlySubscription.rawValue
    }
    
    private func getSavings() -> String? {
        if product.id == ProductID.yearlySubscription.rawValue {
            return NSLocalizedString("savings.yearly", comment: "Save 33%")
        }
        return nil
    }
}

// MARK: - Paywall Source

enum PaywallSource {
    case limitReached
    case settings
    case onboarding
    case menu
}

// MARK: - Preview

#Preview {
    PaywallView(source: .limitReached)
}

