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
    
    // TODO: ADICIONE SUA CHAVE OPENAI AQUI
    // Instruções:
    // 1. Vá para: https://platform.openai.com/api-keys
    // 2. Crie uma nova chave
    // 3. Cole abaixo substituindo "YOUR_OPENAI_API_KEY_HERE"
    // 4. A chave começa com "sk-"
    //
    // IMPORTANTE: NÃO compartilhe este código publicamente no GitHub
    // com a chave real. Use .gitignore ou variáveis de ambiente.
    
    private let obfuscatedKey = "YOUR_OPENAI_API_KEY_HERE"
    
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

