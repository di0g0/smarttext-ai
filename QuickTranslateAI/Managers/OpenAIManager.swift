//
//  OpenAIManager.swift
//  QuickTranslateAI
//
//  Gerencia comunicação com OpenAI API
//

import Foundation

enum AIAction: String, CaseIterable {
    case translate = "translate"
    case improve = "improve"
    case formal = "formal"
    case casual = "casual"
    case fix = "fix"
    case simplify = "simplify"
    case expand = "expand"
    
    var icon: String {
        switch self {
        case .translate: return "🌍"
        case .improve: return "✨"
        case .formal: return "🎩"
        case .casual: return "😊"
        case .fix: return "✓"
        case .simplify: return "📝"
        case .expand: return "📚"
        }
    }
    
    var localizedName: String {
        switch self {
        case .translate: return NSLocalizedString("action.translate", comment: "Translate")
        case .improve: return NSLocalizedString("action.improve", comment: "Improve Text")
        case .formal: return NSLocalizedString("action.formal", comment: "Make Formal")
        case .casual: return NSLocalizedString("action.casual", comment: "Make Casual")
        case .fix: return NSLocalizedString("action.fix", comment: "Fix Grammar")
        case .simplify: return NSLocalizedString("action.simplify", comment: "Simplify")
        case .expand: return NSLocalizedString("action.expand", comment: "Expand")
        }
    }
}

class OpenAIManager {
    static let shared = OpenAIManager()
    
    private var apiKey: String {
        APIKeyManager.shared.getAPIKey()
    }
    
    private let endpoint = "https://api.openai.com/v1/chat/completions"
    
    private init() {}
    
    func processText(_ text: String, action: AIAction, targetLanguage: String = "Portuguese", completion: @escaping (Result<String, Error>) -> Void) {
        // Verifica se a chave está configurada
        guard APIKeyManager.shared.isKeyConfigured() else {
            completion(.failure(NSError(domain: "OpenAI", code: 1, userInfo: [NSLocalizedDescriptionKey: "API Key não configurada. Por favor, configure a chave no código."])))
            return
        }
        
        // RATE LIMITING REMOVIDO - sem limites agora
        
        let prompt = generatePrompt(for: action, text: text, targetLanguage: targetLanguage)
        
        sendRequest(prompt: prompt, completion: completion)
    }
    
    private func generatePrompt(for action: AIAction, text: String, targetLanguage: String) -> String {
        let userPreferences = getUserPreferences()
        
        switch action {
        case .translate:
            return """
            Traduza o seguinte texto para \(targetLanguage). Mantenha o tom e o contexto original.
            \(userPreferences)
            
            Texto: \(text)
            
            Retorne APENAS a tradução, sem explicações ou comentários adicionais.
            """
            
        case .improve:
            return """
            Improve the following text keeping the same idea, but making it clearer, more fluent and better written.
            
            CRITICAL RULE: Keep the text in the EXACT SAME LANGUAGE as the original. DO NOT translate to any other language.
            
            If the text is in English, respond in English.
            If the text is in Portuguese, respond in Portuguese.
            If the text is in Spanish, respond in Spanish.
            And so on for any language.
            
            Text: \(text)
            
            Return ONLY the improved text, no explanations.
            """
            
        case .formal:
            return """
            Rewrite the following text in a formal and professional tone, suitable for corporate or academic contexts.
            
            CRITICAL RULE: Keep the text in the EXACT SAME LANGUAGE as the original. DO NOT translate to any other language.
            
            If the text is in English, respond in English.
            If the text is in Portuguese, respond in Portuguese.
            If the text is in Spanish, respond in Spanish.
            And so on for any language.
            
            Text: \(text)
            
            Return ONLY the rewritten text, no explanations.
            """
            
        case .casual:
            return """
            Rewrite the following text in a casual and friendly tone, suitable for informal conversations.
            
            CRITICAL RULE: Keep the text in the EXACT SAME LANGUAGE as the original. DO NOT translate to any other language.
            
            If the text is in English, respond in English.
            If the text is in Portuguese, respond in Portuguese.
            If the text is in Spanish, respond in Spanish.
            And so on for any language.
            
            Text: \(text)
            
            Return ONLY the rewritten text, no explanations.
            """
            
        case .fix:
            return """
            Fix all grammar, spelling, and punctuation errors in the following text. Keep the original tone and style.
            
            CRITICAL RULE: Keep the text in the EXACT SAME LANGUAGE as the original. DO NOT translate to any other language.
            
            If the text is in English, respond in English.
            If the text is in Portuguese, respond in Portuguese.
            If the text is in Spanish, respond in Spanish.
            And so on for any language.
            
            Text: \(text)
            
            Return ONLY the corrected text, no explanations.
            """
            
        case .simplify:
            return """
            Simplify the following text, making it easier to understand without losing the meaning.
            
            CRITICAL RULE: Keep the text in the EXACT SAME LANGUAGE as the original. DO NOT translate to any other language.
            
            If the text is in English, respond in English.
            If the text is in Portuguese, respond in Portuguese.
            If the text is in Spanish, respond in Spanish.
            And so on for any language.
            
            Text: \(text)
            
            Return ONLY the simplified text, no explanations.
            """
            
        case .expand:
            return """
            Expand the following text, adding more details, examples and context while keeping the main idea.
            
            CRITICAL RULE: Keep the text in the EXACT SAME LANGUAGE as the original. DO NOT translate to any other language.
            
            If the text is in English, respond in English.
            If the text is in Portuguese, respond in Portuguese.
            If the text is in Spanish, respond in Spanish.
            And so on for any language.
            
            Text: \(text)
            
            Return ONLY the expanded text, no explanations.
            """
        }
    }
    
    private func getUserPreferences() -> String {
        let targetLang = UserDefaults.standard.string(forKey: "preferred_language") ?? "Portuguese"
        let tone = UserDefaults.standard.string(forKey: "preferred_tone") ?? "neutral"
        
        return "Preferências do usuário: idioma preferido \(targetLang), tom \(tone)."
    }
    
    private func sendRequest(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NSError(domain: "OpenAI", code: 2, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-4o-mini",
            "messages": [
                ["role": "system", "content": "Você é um assistente especializado em tradução e melhoria de textos. Seja conciso e retorne apenas o resultado solicitado."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 2000
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "OpenAI", code: 3, userInfo: [NSLocalizedDescriptionKey: "Sem dados na resposta"])))
                }
                return
            }
            
            // Debug: imprime a resposta bruta
            if let responseString = String(data: data, encoding: .utf8) {
                print("📥 OpenAI Response: \(responseString)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    // Verifica se há erro na resposta
                    if let error = json["error"] as? [String: Any],
                       let message = error["message"] as? String,
                       let code = error["code"] as? String {
                        
                        // Mensagem específica para quota
                        var userMessage = "API Error: \(message)"
                        if code == "insufficient_quota" {
                            userMessage = """
                            ⚠️ Sem créditos na OpenAI!
                            
                            Sua API Key não tem créditos disponíveis.
                            
                            Para resolver:
                            1. Acesse: platform.openai.com/settings/organization/billing
                            2. Adicione um método de pagamento
                            3. Configure um limite de gastos (ex: $5)
                            4. Aguarde alguns minutos
                            
                            Detalhes: \(message)
                            """
                        }
                        
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "OpenAI", code: 5, userInfo: [NSLocalizedDescriptionKey: userMessage])))
                        }
                        return
                    }
                    
                    // Parse da resposta normal
                    if let choices = json["choices"] as? [[String: Any]],
                       let firstChoice = choices.first,
                       let message = firstChoice["message"] as? [String: Any],
                       let content = message["content"] as? String {
                        
                        DispatchQueue.main.async {
                            completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                        }
                    } else {
                        print("❌ JSON structure unexpected: \(json)")
                        DispatchQueue.main.async {
                            completion(.failure(NSError(domain: "OpenAI", code: 4, userInfo: [NSLocalizedDescriptionKey: "Formato de resposta inválido. Verifique sua API key e os logs do Xcode."])))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "OpenAI", code: 4, userInfo: [NSLocalizedDescriptionKey: "Resposta não é JSON válido"])))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

