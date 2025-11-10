//
//  HistoryManager.swift
//  QuickTranslateAI
//
//  Gerencia histórico de traduções e melhorias
//

import Foundation
import AppKit
import SwiftUI

struct HistoryEntry: Codable, Identifiable {
    let id: UUID
    let date: Date
    let inputText: String
    let outputText: String
    let action: String
    let language: String?
    
    init(id: UUID = UUID(), date: Date = Date(), inputText: String, outputText: String, action: AIAction, language: String? = nil) {
        self.id = id
        self.date = date
        self.inputText = inputText
        self.outputText = outputText
        self.action = action.rawValue
        self.language = language
    }
    
    // Computed property para obter o nome localizado da ação
    var localizedAction: String {
        if let aiAction = AIAction(rawValue: action) {
            return aiAction.localizedName
        }
        return action // Fallback para o valor bruto se não encontrar
    }
}

class HistoryManager: ObservableObject {
    static let shared = HistoryManager()
    
    @Published var entries: [HistoryEntry] = []
    
    private let maxEntries = 100
    private let storageKey = "translation_history"
    
    private init() {
        loadHistory()
    }
    
    func addEntry(input: String, output: String, action: AIAction, language: String? = nil) {
        let entry = HistoryEntry(
            inputText: input,
            outputText: output,
            action: action,
            language: language
        )
        
        entries.insert(entry, at: 0)
        
        // Limita o histórico
        if entries.count > maxEntries {
            entries = Array(entries.prefix(maxEntries))
        }
        
        saveHistory()
        
        // Aprende com as preferências do usuário
        updateUserPreferences(action: action, language: language)
    }
    
    func clearHistory() {
        entries.removeAll()
        saveHistory()
    }
    
    func deleteEntry(_ entry: HistoryEntry) {
        entries.removeAll { $0.id == entry.id }
        saveHistory()
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }
    
    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([HistoryEntry].self, from: data) {
            entries = decoded
        }
    }
    
    private func updateUserPreferences(action: AIAction, language: String?) {
        // Conta as ações mais usadas
        let actionCounts = entries.reduce(into: [String: Int]()) { counts, entry in
            counts[entry.action, default: 0] += 1
        }
        
        // Atualiza preferências
        if let mostUsedAction = actionCounts.max(by: { $0.value < $1.value })?.key {
            UserDefaults.standard.set(mostUsedAction, forKey: "most_used_action")
        }
        
        if let language = language {
            UserDefaults.standard.set(language, forKey: "preferred_language")
        }
    }
    
    // Estatísticas
    func getStats() -> [String: Any] {
        let totalTranslations = entries.count
        let actionCounts = entries.reduce(into: [String: Int]()) { counts, entry in
            counts[entry.action, default: 0] += 1
        }
        
        return [
            "total": totalTranslations,
            "actions": actionCounts,
            "lastUsed": entries.first?.date ?? Date()
        ]
    }
}

// MARK: - History Window Manager

class HistoryWindowManager: NSObject, NSWindowDelegate {
    static let shared = HistoryWindowManager()
    
    private var window: NSWindow?
    
    override private init() {
        super.init()
    }
    
    func showHistory() {
        print("🕐 HistoryWindowManager: showHistory() called")
        print("🔍 Current window state: \(window != nil ? "exists" : "nil")")
        
        // Se a janela já existe e está válida, só mostra
        if let existingWindow = window {
            print("✅ Window exists, checking if visible...")
            if existingWindow.isVisible {
                print("✅ Window already visible, bringing to front")
                existingWindow.makeKeyAndOrderFront(nil)
                NSApp.activate(ignoringOtherApps: true)
                return
            } else {
                print("⚠️ Window exists but not visible, recreating...")
                window = nil
            }
        }
        
        // Cria nova janela
        print("🆕 Creating new history window")
        let contentView = HistoryView()
        
        let newWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        newWindow.title = NSLocalizedString("window.history.title", comment: "Translation History")
        newWindow.contentView = NSHostingView(rootView: contentView)
        newWindow.center()
        newWindow.delegate = self
        newWindow.isReleasedWhenClosed = false // IMPORTANTE: Não release automático
        
        self.window = newWindow
        
        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        
        print("✅ History window created and shown")
    }
    
    // Delegate: Limpa referência quando a janela for fechada
    func windowWillClose(_ notification: Notification) {
        print("🔴 History window will close")
        // Não limpa aqui, deixa a janela existir
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        print("🔑 History window became key")
    }
}

