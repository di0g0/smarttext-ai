//
//  ClipboardManager.swift
//  QuickTranslateAI
//
//  Gerencia captura de texto selecionado via clipboard
//

import Foundation
import AppKit

class ClipboardManager {
    static let shared = ClipboardManager()
    
    private init() {}
    
    /// Captura o texto atualmente selecionado
    /// Usa a técnica de: salvar clipboard atual → simular Cmd+C → pegar novo texto → restaurar clipboard
    func captureSelectedText() -> String {
        print("🔍 Starting text capture...")
        
        // Salva o clipboard atual
        let pasteboard = NSPasteboard.general
        let previousChangeCount = pasteboard.changeCount
        let previousContents = pasteboard.string(forType: .string)
        
        print("📋 Previous clipboard count: \(previousChangeCount)")
        
        // Limpa o pasteboard temporariamente
        pasteboard.clearContents()
        
        // Simula Cmd+C para copiar texto selecionado
        simulateCopyCommand()
        
        // Aguarda um pouco mais para o comando ser processado
        Thread.sleep(forTimeInterval: 0.2) // Aumentado de 0.1 para 0.2
        
        // Verifica se o clipboard mudou
        let newChangeCount = pasteboard.changeCount
        print("📋 New clipboard count: \(newChangeCount)")
        
        // Pega o texto copiado
        let selectedText = pasteboard.string(forType: .string) ?? ""
        
        print("✂️ Captured text length: \(selectedText.count)")
        
        // Restaura o clipboard anterior se nada foi capturado ou se não mudou
        if selectedText.isEmpty || newChangeCount == previousChangeCount {
            if let previousContents = previousContents {
                pasteboard.clearContents()
                pasteboard.setString(previousContents, forType: .string)
                print("♻️ Restored previous clipboard")
            }
        }
        
        return selectedText
    }
    
    /// Simula o comando Cmd+C
    private func simulateCopyCommand() {
        let source = CGEventSource(stateID: .hidSystemState)
        
        // Cmd+C
        let keyDownC = CGEvent(keyboardEventSource: source, virtualKey: 8, keyDown: true) // 8 = C key
        let keyUpC = CGEvent(keyboardEventSource: source, virtualKey: 8, keyDown: false)
        
        keyDownC?.flags = .maskCommand
        keyUpC?.flags = .maskCommand
        
        keyDownC?.post(tap: .cghidEventTap)
        keyUpC?.post(tap: .cghidEventTap)
    }
    
    /// Copia texto para o clipboard
    func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
    
    /// Substitui o texto selecionado com novo texto
    func replaceSelectedText(with newText: String) {
        // Copia o novo texto
        copyToClipboard(newText)
        
        // Aguarda um pouco
        Thread.sleep(forTimeInterval: 0.1)
        
        // Simula Cmd+V para colar
        simulatePasteCommand()
    }
    
    /// Simula o comando Cmd+A (Selecionar tudo)
    func simulateSelectAllCommand() {
        let source = CGEventSource(stateID: .hidSystemState)
        
        // Cmd+A
        let keyDownA = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: true) // 0 = A key
        let keyUpA = CGEvent(keyboardEventSource: source, virtualKey: 0, keyDown: false)
        
        keyDownA?.flags = .maskCommand
        keyUpA?.flags = .maskCommand
        
        keyDownA?.post(tap: .cghidEventTap)
        keyUpA?.post(tap: .cghidEventTap)
        
        print("📋 Simulated Cmd+A (select all)")
    }
    
    /// Simula o comando Cmd+V
    func simulatePasteCommand() {
        let source = CGEventSource(stateID: .hidSystemState)
        
        // Cmd+V
        let keyDownV = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: true) // 9 = V key
        let keyUpV = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: false)
        
        keyDownV?.flags = .maskCommand
        keyUpV?.flags = .maskCommand
        
        keyDownV?.post(tap: .cghidEventTap)
        keyUpV?.post(tap: .cghidEventTap)
        
        print("📋 Simulated Cmd+V paste")
    }
}

