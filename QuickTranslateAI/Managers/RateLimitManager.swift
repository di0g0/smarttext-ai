//
//  RateLimitManager.swift
//  QuickTranslateAI
//
//  Gerencia rate limiting para controlar custos
//

import Foundation

class RateLimitManager {
    static let shared = RateLimitManager()
    
    private let maxRequestsPerDay = 50 // Limite diário por instalação
    private let storageKey = "rate_limit_data"
    
    private init() {}
    
    // Estrutura para armazenar dados de rate limiting
    private struct RateLimitData: Codable {
        var date: String // Formato: "YYYY-MM-DD"
        var requestCount: Int
        var firstRequestTime: Date?
    }
    
    /// Verifica se o usuário pode fazer uma requisição
    func canMakeRequest() -> Bool {
        let today = getTodayString()
        var data = loadData()
        
        // Se é um novo dia, reseta o contador
        if data.date != today {
            data = RateLimitData(date: today, requestCount: 0, firstRequestTime: Date())
            saveData(data)
            return true
        }
        
        // Verifica se está dentro do limite
        return data.requestCount < maxRequestsPerDay
    }
    
    /// Registra uma requisição
    func recordRequest() {
        let today = getTodayString()
        var data = loadData()
        
        // Se é um novo dia, reseta
        if data.date != today {
            data = RateLimitData(date: today, requestCount: 1, firstRequestTime: Date())
        } else {
            data.requestCount += 1
        }
        
        saveData(data)
        
        // Log para monitoramento
        print("📊 Rate Limit: \(data.requestCount)/\(maxRequestsPerDay) requisições hoje")
    }
    
    /// Retorna quantas requisições restam hoje
    func getRemainingRequests() -> Int {
        let today = getTodayString()
        let data = loadData()
        
        if data.date != today {
            return maxRequestsPerDay
        }
        
        return max(0, maxRequestsPerDay - data.requestCount)
    }
    
    /// Retorna informações de uso para mostrar ao usuário
    func getUsageInfo() -> (used: Int, total: Int, remaining: Int) {
        let today = getTodayString()
        let data = loadData()
        
        if data.date != today {
            return (0, maxRequestsPerDay, maxRequestsPerDay)
        }
        
        let remaining = max(0, maxRequestsPerDay - data.requestCount)
        return (data.requestCount, maxRequestsPerDay, remaining)
    }
    
    // MARK: - Private Methods
    
    private func getTodayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    private func loadData() -> RateLimitData {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(RateLimitData.self, from: savedData) {
            return decoded
        }
        
        // Dados padrão
        return RateLimitData(
            date: getTodayString(),
            requestCount: 0,
            firstRequestTime: nil
        )
    }
    
    private func saveData(_ data: RateLimitData) {
        if let encoded = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    /// Reseta o limite (para debug/teste)
    func resetLimit() {
        UserDefaults.standard.removeObject(forKey: storageKey)
        print("🔄 Rate limit resetado")
    }
}

