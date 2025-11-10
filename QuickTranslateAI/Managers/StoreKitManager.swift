//
//  StoreKitManager.swift
//  QuickTranslateAI
//
//  Gerencia compras in-app com StoreKit 2
//

import Foundation
import StoreKit

// MARK: - Product IDs
enum ProductID: String, CaseIterable {
    case monthlySubscription = "com.quicktranslate.ai.premium.monthly"
    case yearlySubscription = "com.quicktranslate.ai.premium.yearly"
    case lifetime = "com.quicktranslate.ai.premium.lifetime"
    
    var displayName: String {
        switch self {
        case .monthlySubscription:
            return NSLocalizedString("subscription.monthly.name", comment: "Monthly Premium")
        case .yearlySubscription:
            return NSLocalizedString("subscription.yearly.name", comment: "Yearly Premium")
        case .lifetime:
            return NSLocalizedString("subscription.lifetime.name", comment: "Lifetime Premium")
        }
    }
}

// MARK: - StoreKit Manager
@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    
    private var updateListenerTask: Task<Void, Error>?
    
    private init() {
        // Inicia listener de transações
        updateListenerTask = listenForTransactions()
        
        Task {
            await loadProducts()
            await updatePurchasedProducts()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Load Products
    
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let productIDs = ProductID.allCases.map { $0.rawValue }
            print("🔍 Requesting products with IDs: \(productIDs)")
            
            let loadedProducts = try await Product.products(for: productIDs)
            
            print("📦 Received \(loadedProducts.count) products from StoreKit")
            for product in loadedProducts {
                print("  - \(product.id): \(product.displayName) - \(product.displayPrice)")
            }
            
            // Ordena: Monthly, Yearly, Lifetime
            products = loadedProducts.sorted { product1, product2 in
                let order1 = productOrder(product1.id)
                let order2 = productOrder(product2.id)
                return order1 < order2
            }
            
            print("✅ Loaded \(products.count) products")
            
            if products.isEmpty {
                errorMessage = "No products available. Please configure IAP in App Store Connect."
                print("⚠️ WARNING: No products loaded. Check App Store Connect configuration.")
            } else {
                // Após carregar produtos, verifica compras ativas
                print("🔍 Products loaded, now checking for active purchases...")
                await updatePurchasedProducts()
            }
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            print("❌ Error loading products: \(error)")
        }
        
        isLoading = false
    }
    
    private func productOrder(_ id: String) -> Int {
        switch id {
        case ProductID.monthlySubscription.rawValue: return 0
        case ProductID.yearlySubscription.rawValue: return 1
        case ProductID.lifetime.rawValue: return 2
        default: return 999
        }
    }
    
    // MARK: - Purchase
    
    func purchase(_ product: Product) async throws {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Verifica a transação
                let transaction = try checkVerified(verification)
                
                // Atualiza produtos comprados
                await updatePurchasedProducts()
                
                // Finaliza a transação
                await transaction.finish()
                
                print("✅ Purchase successful: \(product.id)")
                
            case .userCancelled:
                print("⚠️ User cancelled purchase")
                
            case .pending:
                print("⏳ Purchase pending")
                
            @unknown default:
                break
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            print("❌ Purchase error: \(error)")
            throw error
        }
        
        isLoading = false
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
            print("✅ Purchases restored")
        } catch {
            errorMessage = "Failed to restore purchases: \(error.localizedDescription)"
            print("❌ Restore error: \(error)")
        }
        
        isLoading = false
    }
    
    // MARK: - Update Purchased Products
    
    func updatePurchasedProducts() async {
        print("🔄 Checking for purchased products...")
        var purchasedIDs: Set<String> = []
        
        // Verifica assinaturas ativas
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                // Adiciona à lista de produtos comprados
                purchasedIDs.insert(transaction.productID)
                
                print("📦 Active entitlement found: \(transaction.productID)")
            } catch {
                print("❌ Transaction verification failed: \(error)")
            }
        }
        
        await MainActor.run {
            purchasedProductIDs = purchasedIDs
            print("✅ Updated purchased products: \(purchasedIDs.count) active")
            if purchasedIDs.isEmpty {
                print("⚠️ No active purchases found")
            }
        }
    }
    
    // MARK: - Listen for Transactions
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            guard let self = self else { return }
            
            // Escuta por novas transações
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    
                    // Atualiza produtos comprados
                    await self.updatePurchasedProducts()
                    
                    // Finaliza a transação
                    await transaction.finish()
                    
                    print("🔄 Transaction updated: \(transaction.productID)")
                } catch {
                    print("❌ Transaction update failed: \(error)")
                }
            }
        }
    }
    
    // MARK: - Verification
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Premium Status
    
    var isPremium: Bool {
        !purchasedProductIDs.isEmpty
    }
    
    // DEBUG: Limpa status premium (apenas para testes)
    func debugResetPremium() {
        purchasedProductIDs.removeAll()
        print("🔧 DEBUG: Premium status reset")
    }
    
    var hasActiveSubscription: Bool {
        purchasedProductIDs.contains(ProductID.monthlySubscription.rawValue) ||
        purchasedProductIDs.contains(ProductID.yearlySubscription.rawValue)
    }
    
    var hasLifetime: Bool {
        purchasedProductIDs.contains(ProductID.lifetime.rawValue)
    }
}

// MARK: - Store Error

enum StoreError: Error {
    case failedVerification
}

// MARK: - Product Extensions

extension Product {
    var localizedPrice: String {
        displayPrice
    }
    
    var subscriptionPeriod: String? {
        guard let subscription = subscription else { return nil }
        
        switch subscription.subscriptionPeriod.unit {
        case .day:
            return NSLocalizedString("subscription.period.daily", comment: "Daily")
        case .week:
            return NSLocalizedString("subscription.period.weekly", comment: "Weekly")
        case .month:
            return NSLocalizedString("subscription.period.monthly", comment: "Monthly")
        case .year:
            return NSLocalizedString("subscription.period.yearly", comment: "Yearly")
        @unknown default:
            return nil
        }
    }
}

