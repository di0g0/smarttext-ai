//
//  SubscriptionManager.swift
//  QuickTranslateAI
//
//  Gerencia limites de uso e status de assinatura
//

import Foundation
import Combine

@MainActor
class SubscriptionManager: ObservableObject {
    static let shared = SubscriptionManager()
    
    // MARK: - Published Properties
    
    @Published var isPremium: Bool = false
    @Published var dailyUsageCount: Int = 0
    @Published var dailyLimit: Int = 10 // Free tier: 10 traduções/dia
    
    // MARK: - Private Properties
    
    private let usageKey = "daily_usage_count"
    private let lastResetDateKey = "last_reset_date"
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    private init() {
        loadDailyUsage()
        checkPremiumStatus()
        observeStoreKit()
        resetUsageIfNeeded()
    }
    
    // MARK: - Premium Status
    
    func checkPremiumStatus() {
        // Verifica StoreKit primeiro
        let storeKitPremium = StoreKitManager.shared.isPremium
        
        // DEBUG: Se não conseguir carregar produtos, usa fallback do UserDefaults
        #if DEBUG
        if !storeKitPremium && UserDefaults.standard.bool(forKey: "debug_premium_active") {
            isPremium = true
            print("📊 Premium status: true (DEBUG fallback)")
            return
        }
        #endif
        
        isPremium = storeKitPremium
        print("📊 Premium status: \(isPremium)")
    }
    
    private func observeStoreKit() {
        // Observa mudanças no status de compra
        StoreKitManager.shared.$purchasedProductIDs
            .sink { [weak self] _ in
                self?.checkPremiumStatus()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Usage Tracking
    
    func canUseTranslation() -> Bool {
        // Premium: sempre pode usar
        if isPremium {
            return true
        }
        
        // Free: verifica limite diário
        return dailyUsageCount < dailyLimit
    }
    
    func incrementUsage() {
        // Premium: não conta uso
        if isPremium {
            return
        }
        
        // Free: incrementa contador
        dailyUsageCount += 1
        saveDailyUsage()
        
        print("📊 Daily usage: \(dailyUsageCount)/\(dailyLimit)")
    }
    
    func getRemainingTranslations() -> Int {
        if isPremium {
            return Int.max // Ilimitado
        }
        
        return max(0, dailyLimit - dailyUsageCount)
    }
    
    // MARK: - Reset Logic
    
    private func resetUsageIfNeeded() {
        let calendar = Calendar.current
        let now = Date()
        
        // Pega a última data de reset
        if let lastResetDate = UserDefaults.standard.object(forKey: lastResetDateKey) as? Date {
            // Verifica se é um novo dia
            if !calendar.isDate(lastResetDate, inSameDayAs: now) {
                resetDailyUsage()
            }
        } else {
            // Primeira vez - salva data atual
            UserDefaults.standard.set(now, forKey: lastResetDateKey)
        }
        
        // Agenda próximo reset à meia-noite
        scheduleNextReset()
    }
    
    func resetDailyUsage() {
        dailyUsageCount = 0
        saveDailyUsage()
        
        let now = Date()
        UserDefaults.standard.set(now, forKey: lastResetDateKey)
        
        print("🔄 Daily usage reset at \(now)")
    }
    
    private func scheduleNextReset() {
        let calendar = Calendar.current
        let now = Date()
        
        // Calcula meia-noite do próximo dia
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now),
           let midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow) {
            
            let timeInterval = midnight.timeIntervalSince(now)
            
            // Agenda reset
            DispatchQueue.main.asyncAfter(deadline: .now() + timeInterval) { [weak self] in
                self?.resetDailyUsage()
                self?.scheduleNextReset() // Agenda próximo
            }
            
            print("⏰ Next reset scheduled for: \(midnight)")
        }
    }
    
    // MARK: - Persistence
    
    private func loadDailyUsage() {
        dailyUsageCount = UserDefaults.standard.integer(forKey: usageKey)
    }
    
    private func saveDailyUsage() {
        UserDefaults.standard.set(dailyUsageCount, forKey: usageKey)
    }
    
    // MARK: - Usage Info
    
    func getUsageInfo() -> (used: Int, total: Int, remaining: Int) {
        if isPremium {
            return (used: 0, total: Int.max, remaining: Int.max)
        }
        
        let remaining = getRemainingTranslations()
        return (used: dailyUsageCount, total: dailyLimit, remaining: remaining)
    }
    
    // MARK: - Time Until Reset
    
    func getTimeUntilReset() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now),
              let midnight = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow) else {
            return "24h"
        }
        
        let components = calendar.dateComponents([.hour, .minute], from: now, to: midnight)
        
        if let hours = components.hour, let minutes = components.minute {
            if hours > 0 {
                return "\(hours)h \(minutes)min"
            } else {
                return "\(minutes)min"
            }
        }
        
        return "24h"
    }
}

