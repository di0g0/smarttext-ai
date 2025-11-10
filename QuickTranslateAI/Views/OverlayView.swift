//
//  OverlayWindow.swift
//  QuickTranslateAI
//
//  Janela overlay estilo Spotlight/Alfred
//

import SwiftUI
import AppKit

class OverlayWindow: NSPanel {
    private var hostingView: NSHostingView<OverlayView>?
    private var viewModel: OverlayViewModel
    private var previousApp: NSRunningApplication? // Armazena app anterior
    
    init() {
        self.viewModel = OverlayViewModel()
        
        // Janela compacta com altura adequada para o conteúdo
        let windowWidth: CGFloat = 450
        let windowHeight: CGFloat = 310 // Reduzida (campos menores)
        
        // Posiciona próximo ao cursor do mouse
        let mouseLocation = NSEvent.mouseLocation
        let screenRect = NSScreen.main?.frame ?? .zero
        
        print("🖱️ Mouse location: x=\(mouseLocation.x), y=\(mouseLocation.y)")
        print("📺 Screen: \(screenRect.width)x\(screenRect.height)")
        
        // Calcula posição: COLADO ao texto selecionado
        var windowX = mouseLocation.x + 10 // 10px à direita do cursor
        var windowY = mouseLocation.y + 10 // Logo acima do cursor (invertido no macOS)
        
        // Ajusta para não sair da tela (direita)
        if windowX + windowWidth > screenRect.maxX {
            windowX = mouseLocation.x - windowWidth - 10 // Põe à esquerda
            print("⬅️ Adjusted: too far right")
        }
        
        // Ajusta para não sair da tela (em baixo)
        if windowY < screenRect.minY {
            windowY = mouseLocation.y + 10 // Põe acima do cursor
            print("⬆️ Adjusted: too far down")
        }
        
        // Ajusta para não sair da tela (em cima)
        if windowY + windowHeight > screenRect.maxY {
            windowY = screenRect.maxY - windowHeight - 10
            print("⬇️ Adjusted: too far up")
        }
        
        // Margem de segurança esquerda
        if windowX < screenRect.minX {
            windowX = screenRect.minX + 10
            print("➡️ Adjusted: too far left")
        }
        
        let windowRect = NSRect(
            x: windowX,
            y: windowY,
            width: windowWidth,
            height: windowHeight
        )
        
        super.init(
            contentRect: windowRect,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        // Configurações da window
        self.level = .floating
        self.isOpaque = false
        self.backgroundColor = .clear
        self.hasShadow = true
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        // Permite arrastar a janela
        self.isMovableByWindowBackground = true
        
        // Fecha ao clicar fora
        self.hidesOnDeactivate = true
        
        // Setup SwiftUI view
        let overlayView = OverlayView(viewModel: viewModel, window: self)
        hostingView = NSHostingView(rootView: overlayView)
        self.contentView = hostingView
        
        // Fecha ao pressionar ESC
        setupKeyboardShortcuts()
        
        print("🎯 Window positioned at: x=\(windowX), y=\(windowY), near cursor at x=\(mouseLocation.x), y=\(mouseLocation.y)")
    }
    
    func showWithText(_ text: String) {
        // IMPORTANTE: Captura qual app estava ativo ANTES
        previousApp = NSWorkspace.shared.frontmostApplication
        if let appName = previousApp?.localizedName {
            print("💾 Saved previous app: \(appName)")
        }
        
        // REPOSICIONA a janela próximo ao cursor TODA VEZ
        repositionNearCursor()
        
        viewModel.inputText = text
        viewModel.resetState()
        
        // Se veio com texto, dispara auto-tradução automaticamente
        if !text.isEmpty {
            print("🚀 Auto-starting translation for pre-filled text")
            viewModel.scheduleAutoTranslationPublic()
        }
        
        // Mostra a window
        self.makeKeyAndOrderFront(nil)
        self.orderFrontRegardless()
        
        // Ativa o app temporariamente para receber input
        NSApp.activate(ignoringOtherApps: true)
        
        // Anima a entrada
        self.animator().alphaValue = 1.0
    }
    
    private func repositionNearCursor() {
        let mouseLocation = NSEvent.mouseLocation
        let screenRect = NSScreen.main?.frame ?? .zero
        let windowSize = self.frame.size
        
        print("🖱️ Repositioning - Mouse: x=\(mouseLocation.x), y=\(mouseLocation.y)")
        
        // Calcula posição: MUITO próximo ao cursor
        // No macOS, Y cresce para cima, então para aparecer ABAIXO do cursor, subtraímos
        var windowX = mouseLocation.x + 15
        var windowY = mouseLocation.y - windowSize.height - 20 // 20px abaixo do cursor
        
        // Ajusta para não sair da tela (direita)
        if windowX + windowSize.width > screenRect.maxX {
            windowX = mouseLocation.x - windowSize.width - 15 // Põe à esquerda
            print("⬅️ Adjusted: too far right")
        }
        
        // Ajusta para não sair da tela (embaixo)
        if windowY < screenRect.minY {
            windowY = mouseLocation.y + 20 // Põe acima do cursor
            print("⬆️ Adjusted: too far down")
        }
        
        // Ajusta para não sair da tela (em cima)
        if windowY + windowSize.height > screenRect.maxY {
            windowY = screenRect.maxY - windowSize.height - 20
            print("⬇️ Adjusted: too far up")
        }
        
        // Margem de segurança esquerda
        if windowX < screenRect.minX {
            windowX = screenRect.minX + 20
            print("➡️ Adjusted: too far left")
        }
        
        // Define a nova posição
        self.setFrameOrigin(NSPoint(x: windowX, y: windowY))
        print("🎯 Window repositioned to: x=\(windowX), y=\(windowY)")
    }
    
    func hideWindow(andReturnFocus: Bool = false) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.2
            self.animator().alphaValue = 0.0
        }, completionHandler: {
            self.orderOut(nil)
            self.alphaValue = 1.0
            
            // Se solicitado, retorna foco para app anterior
            if andReturnFocus, let previousApp = self.previousApp {
                print("🔙 Returning focus to: \(previousApp.localizedName ?? "previous app")")
                previousApp.activate(options: [.activateIgnoringOtherApps])
            }
        })
    }
    
    func getPreviousApp() -> NSRunningApplication? {
        return previousApp
    }
    
    private func setupKeyboardShortcuts() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 53 { // ESC
                self?.hideWindow(andReturnFocus: false)
                return nil
            }
            return event
        }
    }
    
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}

// MARK: - ViewModel

class OverlayViewModel: ObservableObject {
    private static var settingsWindow: NSWindow? // Mantém referência à janela
    
    @Published var inputText: String = "" {
        didSet {
            // Cancela qualquer auto-tradução pendente
            debounceWorkItem?.cancel()
            
            // Se o texto não está vazio, agenda nova auto-tradução
            if !inputText.isEmpty && inputText != oldValue {
                scheduleAutoTranslation()
            }
        }
    }
    @Published var outputText: String = ""
    @Published var isProcessing: Bool = false // Único indicador: está processando OU esperando
    @Published var selectedAction: AIAction = .translate
    @Published var selectedLanguage: String = "English" {
        didSet {
            // Re-traduz automaticamente quando mudar o idioma
            if !inputText.isEmpty && !outputText.isEmpty && selectedLanguage != oldValue {
                Task { @MainActor in
                    processText(action: selectedAction)
                }
            }
            // Salva como idioma preferido (mesma chave usada em Settings)
            UserDefaults.standard.set(selectedLanguage, forKey: "preferred_language")
        }
    }
    @Published var errorMessage: String?
    @Published var showHistorySheet: Bool = false // Nova propriedade para controlar o sheet
    
    private static var paywallWindow: NSWindow? // Mantém referência à janela do paywall
    
    let availableLanguages = [
        "English",
        "Portuguese", 
        "Spanish",
        "French",
        "German",
        "Italian",
        "Japanese",
        "Chinese",
        "Korean",
        "Arabic",
        "Russian",
        "Dutch",
        "Swedish",
        "Polish",
        "Turkish",
        "Hindi",
        "Thai",
        "Vietnamese",
        "Indonesian",
        "Hebrew"
    ]
    
    private var debounceWorkItem: DispatchWorkItem?
    private let debounceDelay: TimeInterval = 0.8 // 0.8 segundos (mais rápido)
    
    init() {
        // Carrega idioma preferido (mesma chave usada em Settings)
        if let preferredLang = UserDefaults.standard.string(forKey: "preferred_language"),
           availableLanguages.contains(preferredLang) {
            self.selectedLanguage = preferredLang
            print("📝 Restored preferred language: \(preferredLang)")
        }
        
        // Observa mudanças no idioma preferido (quando muda nas Settings)
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            if let newLang = UserDefaults.standard.string(forKey: "preferred_language"),
               self.availableLanguages.contains(newLang),
               newLang != self.selectedLanguage {
                print("📝 Language changed in Settings: \(newLang)")
                self.selectedLanguage = newLang
            }
        }
    }
    
    func resetState() {
        outputText = ""
        isProcessing = false
        errorMessage = nil
        debounceWorkItem?.cancel()
    }
    
    private func scheduleAutoTranslation() {
        // Marca que está processando (mostra spinner)
        isProcessing = true
        
        // Cria uma nova tarefa com delay
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            print("🤖 Auto-translating after debounce...")
            Task { @MainActor in
                self.processText(action: self.selectedAction)
            }
        }
        
        debounceWorkItem = workItem
        
        // Executa após o delay
        DispatchQueue.main.asyncAfter(deadline: .now() + debounceDelay, execute: workItem)
    }
    
    // Versão pública para chamar de fora
    func scheduleAutoTranslationPublic() {
        scheduleAutoTranslation()
    }
    
    @MainActor
    func processText(action: AIAction? = nil) {
        let actionToUse = action ?? selectedAction
        
        guard !inputText.isEmpty else { return }
        
        // Verifica limite de uso (Free tier)
        if !SubscriptionManager.shared.canUseTranslation() {
            openPaywall()
            return
        }
        
        // Cancela qualquer debounce pendente
        debounceWorkItem?.cancel()
        
        isProcessing = true
        errorMessage = nil
        outputText = ""
        
        OpenAIManager.shared.processText(inputText, action: actionToUse, targetLanguage: selectedLanguage) { [weak self] result in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.isProcessing = false
                
                switch result {
                case .success(let text):
                    self.outputText = text
                    
                    // Incrementa contador de uso
                    SubscriptionManager.shared.incrementUsage()
                    
                    // Salva no histórico
                    HistoryManager.shared.addEntry(input: self.inputText, output: text, action: actionToUse, language: self.selectedLanguage)
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func copyOutput() {
        ClipboardManager.shared.copyToClipboard(outputText)
    }
    
    func replaceOriginal(window: OverlayWindow?) {
        print("🔄 Starting replace operation...")
        
        guard let window = window else {
            print("❌ No window reference")
            return
        }
        
        // 1. Pega referência do app anterior
        guard let previousApp = window.getPreviousApp() else {
            print("❌ No previous app saved")
            return
        }
        
        print("📱 Previous app: \(previousApp.localizedName ?? "unknown")")
        
        // 2. Copia o texto traduzido
        ClipboardManager.shared.copyToClipboard(outputText)
        print("📋 Copied to clipboard: \(outputText.prefix(50))...")
        
        // 3. Fecha a janela
        window.orderOut(nil)
        
        // 4. Aguarda um frame
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // 5. Ativa o app anterior explicitamente
            print("🔙 Activating previous app...")
            previousApp.activate(options: [.activateIgnoringOtherApps])
            
            // 6. Aguarda o app estar ativo
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                print("⌨️ Pasting to replace selected text...")
                
                // 7. Apenas cola - vai substituir o texto que estava selecionado!
                // Não precisa de Cmd+A porque o texto original já está selecionado
                ClipboardManager.shared.simulatePasteCommand()
                print("✅ Replace operation completed")
            }
        }
    }
    
    func openHistory() {
        NSLog("🕐 [ViewModel] Opening history sheet...")
        showHistorySheet = true
    }
    
    func openSettings() {
        // Cria uma janela NSWindow para Settings (igual ao menu)
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            
            // Se a janela já existe, traz pra frente
            if let window = OverlayViewModel.settingsWindow, window.isVisible {
                window.makeKeyAndOrderFront(nil)
                return
            }
            
            let settingsView = SettingsView()
            let hostingController = NSHostingController(rootView: settingsView)
            
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 550, height: 450),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            
            window.title = NSLocalizedString("settings.title", comment: "Settings")
            window.contentViewController = hostingController
            window.level = .floating // Aparece na frente do overlay
            window.center()
            window.isReleasedWhenClosed = false // IMPORTANTE: não libera ao fechar
            window.makeKeyAndOrderFront(nil)
            
            // Mantém referência
            OverlayViewModel.settingsWindow = window
            
            print("✅ Settings window opened from overlay")
        }
    }
    
    func openPaywall() {
        // Cria uma janela NSWindow para Paywall (igual ao Settings)
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)
            
            // Se a janela já existe, traz pra frente
            if let window = OverlayViewModel.paywallWindow, window.isVisible {
                window.makeKeyAndOrderFront(nil)
                return
            }
            
            let paywallView = PaywallView(source: .limitReached)
            let hostingController = NSHostingController(rootView: paywallView)
            
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 600, height: 700),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered,
                defer: false
            )
            
            window.title = NSLocalizedString("paywall.title", comment: "Upgrade to Premium")
            window.contentViewController = hostingController
            window.level = .floating // Aparece na frente do overlay
            window.center()
            window.isReleasedWhenClosed = false // IMPORTANTE: não libera ao fechar
            window.makeKeyAndOrderFront(nil)
            
            // Mantém referência
            OverlayViewModel.paywallWindow = window
            
            print("✅ Paywall window opened from overlay")
        }
    }
}

// MARK: - SwiftUI View

struct OverlayView: View {
    @ObservedObject var viewModel: OverlayViewModel
    weak var window: OverlayWindow?
    
    var body: some View {
        ZStack {
            // Background with blur
            VisualEffectBlur(material: .hudWindow, blendingMode: .behindWindow)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.3), radius: 30, x: 0, y: 10)
            
            if viewModel.showHistorySheet {
                // Modo Histórico (inline)
                historyMode
            } else {
                // Modo Normal (tradução)
                normalMode
            }
        }
        .frame(width: 450, height: 310) // Altura reduzida
    }
    
    // MARK: - Modo Normal (Tradução)
    
    private var normalMode: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            Divider()
                .padding(.horizontal, 10)
            
            // Content (scroll externo removido - cada seção tem scroll interno)
            VStack(spacing: 10) {
                // Input section
                inputSection
                
                // Output section (sempre mostra, mas vazio se não houver resultado)
                outputSection
                
                // Error message
                if let error = viewModel.errorMessage {
                    errorView(error)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            
            // Footer with actions (sempre visível)
            Divider()
                .padding(.horizontal, 10)
            footerActions
        }
    }
    
    // MARK: - Modo Histórico
    
    private var historyMode: some View {
        VStack(spacing: 0) {
            // Header - meio termo entre muito grande e muito pequeno
            HStack {
                Button(action: {
                    viewModel.showHistorySheet = false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.subheadline)
                        Text(NSLocalizedString("button.back", comment: "Back"))
                            .font(.subheadline)
                    }
                }
                .buttonStyle(.plain)
                
                Spacer()
                
                Text(NSLocalizedString("overlay.history.title", comment: "History"))
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                // Espaço invisível para balancear
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.subheadline)
                    Text(NSLocalizedString("button.back", comment: "Back"))
                        .font(.subheadline)
                }
                .hidden()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            
            Divider()
                .padding(.horizontal, 10)
            
            // Histórico compacto
            ScrollView {
                LazyVStack(spacing: 6) {
                    ForEach(HistoryManager.shared.entries.prefix(10)) { entry in
                        CompactHistoryRow(entry: entry, onSelect: {
                            // Preenche o input com a entrada selecionada
                            viewModel.inputText = entry.inputText
                            viewModel.outputText = entry.outputText
                            viewModel.showHistorySheet = false
                        })
                    }
                    
                    if HistoryManager.shared.entries.isEmpty {
                        Text(NSLocalizedString("overlay.history.empty", comment: "No translation in history"))
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Image(systemName: "character.bubble.fill")
                .font(.body)
                .foregroundColor(.accentColor)
            
            Text("SmartText AI")
                .font(.headline) // Aumentado de .subheadline para .headline
                .fontWeight(.semibold) // Aumentado de .medium para .semibold
            
            Spacer()
            
            // Dropdown de Ação (só texto, sem emoji)
            Menu {
                ForEach(AIAction.allCases, id: \.self) { action in
                    Button {
                        viewModel.selectedAction = action
                        if !viewModel.inputText.isEmpty && !viewModel.outputText.isEmpty {
                            viewModel.processText(action: action)
                        }
                    } label: {
                        HStack {
                            Text(action.localizedName)
                            if viewModel.selectedAction == action {
                                Spacer()
                                Image(systemName: "checkmark")
                                    .font(.caption)
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(viewModel.selectedAction.localizedName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Image(systemName: "chevron.down")
                        .font(.caption2)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.accentColor.opacity(0.15))
                .cornerRadius(8)
            }
            .menuStyle(.borderlessButton)
            
            // Language selector (for translate)
            if viewModel.selectedAction == .translate {
                Menu {
                    ForEach(viewModel.availableLanguages, id: \.self) { lang in
                        Button(lang) {
                            viewModel.selectedLanguage = lang
                        }
                    }
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "globe")
                            .font(.caption)
                        Text(viewModel.selectedLanguage)
                            .font(.caption)
                            .fontWeight(.medium)
                        Image(systemName: "chevron.down")
                            .font(.caption2)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.secondary.opacity(0.12))
                    .cornerRadius(7)
                }
                .menuStyle(.borderlessButton)
            }
            
            // Botão de Settings
            Button(action: { viewModel.openSettings() }) {
                Image(systemName: "gearshape.fill")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            
            Button(action: { window?.hideWindow(andReturnFocus: false) }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(NSLocalizedString("overlay.input.title", comment: "Original"))
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            TextEditor(text: $viewModel.inputText)
                .font(.system(.body))
                .frame(height: 60) // Reduzido de 70 para 60
                .padding(8)
                .background(Color.gray.opacity(0.08))
                .cornerRadius(6)
                .scrollContentBackground(.hidden)
        }
    }
    
    private var actionButtons: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(AIAction.allCases, id: \.self) { action in
                    ActionButton(
                        action: action,
                        isSelected: viewModel.selectedAction == action
                    ) {
                        viewModel.selectedAction = action
                        // Traduz imediatamente quando clicar no botão
                        viewModel.processText(action: action)
                    }
                }
            }
            .padding(.horizontal, 2)
        }
    }
    
    private var outputSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(NSLocalizedString("overlay.output.title", comment: "Result"))
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            if viewModel.outputText.isEmpty && !viewModel.isProcessing {
                // Placeholder quando não há resultado
                HStack(spacing: 10) {
                    Image(systemName: "doc.text")
                        .font(.title3)
                        .foregroundColor(.secondary.opacity(0.25))
                    Text(NSLocalizedString("overlay.output.waiting", comment: "Waiting for translation"))
                        .font(.system(.body))
                        .foregroundColor(.secondary.opacity(0.5))
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60) // Reduzido de 70 para 60
                .padding(10)
                .background(Color.gray.opacity(0.04))
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 1)
                )
            } else if viewModel.isProcessing {
                // Durante processamento, mostra spinner DENTRO da área (sem texto)
                VStack {
                    ProgressView()
                        .scaleEffect(1.0)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60) // Reduzido de 70 para 60
                .background(Color.accentColor.opacity(0.06))
                .cornerRadius(6)
            } else {
                // Resultado real - com scroll interno
                ScrollView {
                    Text(viewModel.outputText)
                        .font(.system(.body))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }
                .frame(height: 60) // Reduzido de 70 para 60
                .padding(8)
                .background(Color.accentColor.opacity(0.08))
                .cornerRadius(6)
            }
        }
    }
    
    private func errorView(_ message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption)
                .foregroundColor(.orange)
            Text(message)
                .font(.caption2)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(Color.orange.opacity(0.1))
        .cornerRadius(6)
    }
    
    private var footerActions: some View {
        HStack(spacing: 10) {
            // Botão de Histórico
            Button(action: {
                NSLog("🔘 [Footer] History button clicked!")
                viewModel.openHistory()
            }) {
                Label(NSLocalizedString("button.history", comment: "History"), systemImage: "clock.arrow.circlepath")
                    .font(.caption)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            
            Button(action: { viewModel.copyOutput() }) {
                Label(NSLocalizedString("button.copy", comment: "Copy"), systemImage: "doc.on.doc")
                    .font(.caption)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .disabled(viewModel.outputText.isEmpty) // Desabilita se não há resultado
            
            Button(action: {
                viewModel.replaceOriginal(window: window)
            }) {
                Label(NSLocalizedString("button.replace", comment: "Replace"), systemImage: "arrow.left.arrow.right")
                    .font(.caption)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
            .disabled(viewModel.outputText.isEmpty) // Desabilita se não há resultado
            
            Spacer()
            
            Button(NSLocalizedString("button.close", comment: "Close")) {
                window?.hideWindow(andReturnFocus: false)
            }
            .buttonStyle(.bordered)
            .controlSize(.small)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
}

// MARK: - Action Button

struct ActionButton: View {
    let action: AIAction
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Text(action.icon)
                Text(action.localizedName)
                    .font(.caption)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(isSelected ? Color.accentColor : Color.gray.opacity(0.2))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Compact History Row

struct CompactHistoryRow: View {
    let entry: HistoryEntry
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.action)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.accentColor.opacity(0.2))
                        .cornerRadius(4)
                    
                    Spacer()
                    
                    Text(timeAgoString(from: entry.date))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Text(entry.inputText)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                Text(entry.outputText)
                    .font(.caption)
                    .lineLimit(1)
                    .foregroundColor(.accentColor)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(6)
        }
        .buttonStyle(.plain)
    }
    
    private func timeAgoString(from date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 ? "1 dia atrás" : "\(day) dias atrás"
        } else if let hour = components.hour, hour > 0 {
            return hour == 1 ? "1 hora atrás" : "\(hour) horas atrás"
        } else if let minute = components.minute, minute > 0 {
            return minute == 1 ? "1 min atrás" : "\(minute) min atrás"
        } else {
            return "agora"
        }
    }
}

// MARK: - Visual Effect Blur

struct VisualEffectBlur: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

