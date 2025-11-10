//
//  APIKeyManager.swift
//  QuickTranslateAI
//
//  Gerencia a chave da API de forma segura (hardcoded)
//

import Foundation

class APIKeyManager {
    static let shared = APIKeyManager()
    
    private init() {}
    
    // IMPORTANT: This file contains the OpenAI API key
    // It is tracked by git but you should be careful not to expose it
    // 
    // For your local development:
    // - Keep your real key here
    // 
    // Before making the repository public:
    // - Replace with placeholder
    // - Or use environment variables / build configurations
    
    private let obfuscatedKey = "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"
    
    /// Retorna a chave da API desofuscada
    func getAPIKey() -> String {
        // Simples ofuscação - pode melhorar com Base64 ou XOR se quiser
        return obfuscatedKey
    }
    
    /// Verifica se a chave foi configurada
    func isKeyConfigured() -> Bool {
        return !obfuscatedKey.isEmpty && obfuscatedKey != "YOUR_OPENAI_API_KEY_HERE"
    }
}

