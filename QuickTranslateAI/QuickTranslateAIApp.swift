//
//  QuickTranslateAIApp.swift
//  QuickTranslateAI
//
//  Created on 2025-11-08
//

import SwiftUI
import AppKit
import Combine

@main
struct QuickTranslateAIApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var hotKeyManager: HotKeyManager?
    var overlayWindow: OverlayWindow?
    var onboardingWindow: OnboardingWindow?
    var settingsWindow: NSWindow?
    var paywallWindow: NSWindow?
    private var cancellables = Set<AnyCancellable>()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Esconder o dock icon (app roda só na barra de menus)
        NSApp.setActivationPolicy(.accessory)
        
        // Setup menu bar icon
        setupMenuBarIcon()
        
        // Setup global hotkey (Cmd+Shift+T)
        setupHotKey()
        
        // Check accessibility permissions (sem popup irritante)
        checkAccessibilityPermissions()
        
        // Show onboarding if first launch
        showOnboardingIfNeeded()
        
        // Observa mudanças no status premium para atualizar o menu
        observePremiumStatus()
    }
    
    func observePremiumStatus() {
        // Observa mudanças nos produtos comprados
        Task { @MainActor in
            StoreKitManager.shared.$purchasedProductIDs
                .sink { [weak self] _ in
                    // Força atualização do menu
                    self?.setupMenu()
                }
                .store(in: &cancellables)
        }
    }
    
    func checkAccessibilityPermissions() {
        // Verifica SEM mostrar prompt
        let hasPermissions = AXIsProcessTrusted()
        
        if hasPermissions {
            print("✅ Accessibility permissions granted")
        } else {
            print("⚠️ Accessibility NOT granted - text capture may not work")
            print("💡 Enable in: System Settings > Privacy & Security > Accessibility")
        }
    }
    
    func setupMenuBarIcon() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            // Tenta usar SF Symbol, se falhar usa texto emoji
            if let image = NSImage(systemSymbolName: "character.bubble", accessibilityDescription: "SmartText AI") {
                button.image = image
                print("✅ Menu bar icon set with SF Symbol")
            } else {
                // Fallback: usa texto emoji
                button.title = "🌍"
                print("✅ Menu bar icon set with emoji fallback")
            }
            button.action = #selector(togglePopover)
            button.target = self
        } else {
            print("❌ Failed to create status bar button")
        }
        
        setupMenu()
        print("✅ Menu bar setup completed")
    }
    
    func setupMenu() {
        let menu = NSMenu()
        menu.delegate = self // Para atualizar dinamicamente
        
        menu.addItem(NSMenuItem(title: NSLocalizedString("menu.open", comment: "Open SmartText AI"), action: #selector(showOverlay), keyEquivalent: "t"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: NSLocalizedString("menu.preferences", comment: "Preferences"), action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem(title: NSLocalizedString("menu.history", comment: "History"), action: #selector(openHistory), keyEquivalent: "h"))
        
        // Placeholder para "Upgrade to Premium" (será adicionado dinamicamente)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: NSLocalizedString("menu.show_tutorial", comment: "Show Tutorial Again"), action: #selector(resetOnboarding), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: NSLocalizedString("menu.about", comment: "About"), action: #selector(showAbout), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: NSLocalizedString("menu.quit", comment: "Quit"), action: #selector(quit), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    func setupHotKey() {
        hotKeyManager = HotKeyManager()
        hotKeyManager?.registerHotKey { [weak self] in
            self?.showOverlay()
        }
    }
    
    func requestAccessibilityPermissions() {
        let checkOptPrompt = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        
        // Primeiro verifica sem prompt
        let accessEnabled = AXIsProcessTrusted()
        
        if !accessEnabled {
            print("⚠️ Accessibility permissions needed - requesting...")
            // Só mostra o prompt se não estiver habilitado
            let options: NSDictionary = [checkOptPrompt: true]
            AXIsProcessTrustedWithOptions(options)
        } else {
            print("✅ Accessibility permissions already granted")
        }
    }
    
    @objc func togglePopover() {
        if statusItem?.button != nil {
            if popover?.isShown ?? false {
                popover?.performClose(nil)
            } else {
                showOverlay()
            }
        }
    }
    
    @objc func showOverlay() {
        // Captura texto selecionado
        let selectedText = ClipboardManager.shared.captureSelectedText()
        print("📋 Captured text: '\(selectedText)' (length: \(selectedText.count))")
        
        // Cria ou atualiza a overlay window
        if overlayWindow == nil {
            overlayWindow = OverlayWindow()
        }
        
        // Sempre mostra a janela (mesmo se não capturou texto)
        // Usuário pode digitar manualmente se necessário
        overlayWindow?.showWithText(selectedText)
    }
    
    @objc func openSettings() {
        NSApp.activate(ignoringOtherApps: true)
        
        // Se a janela já existe, traz pra frente
        if let window = settingsWindow, window.isVisible {
            window.makeKeyAndOrderFront(nil)
            return
        }
        
        // Cria a janela de settings
        let settingsView = SettingsView()
        let hostingController = NSHostingController(rootView: settingsView)
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 550, height: 450),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = NSLocalizedString("settings.title", comment: "")
        window.contentViewController = hostingController
        window.center()
        window.isReleasedWhenClosed = false
        window.makeKeyAndOrderFront(nil)
        
        settingsWindow = window
        
        print("✅ Settings window opened")
    }
    
    @objc func openHistory() {
        HistoryWindowManager.shared.showHistory()
    }
    
    @objc func showAbout() {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil)
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(nil)
    }
    
    // MARK: - Onboarding
    
    func showOnboardingIfNeeded() {
        let hasCompleted = UserDefaults.standard.bool(forKey: "has_completed_onboarding")
        
        if !hasCompleted {
            // Aguarda um pouco para o app terminar de inicializar
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.showOnboarding()
            }
        }
    }
    
    func showOnboarding() {
        if onboardingWindow == nil {
            onboardingWindow = OnboardingWindow()
        }
        
        onboardingWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func openUpgrade() {
        // Se já existe uma janela, traz para frente
        if let existingWindow = paywallWindow, existingWindow.isVisible {
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        
        // Cria nova janela de paywall
        let paywallView = PaywallView(source: .menu)
        let hostingController = NSHostingController(rootView: paywallView)
        
        let newWindow = NSWindow(contentViewController: hostingController)
        newWindow.title = NSLocalizedString("window.upgrade.title", comment: "Upgrade to Premium")
        newWindow.styleMask = [.titled, .closable, .miniaturizable]
        newWindow.setContentSize(NSSize(width: 600, height: 700))
        newWindow.center()
        newWindow.isReleasedWhenClosed = false
        
        paywallWindow = newWindow
        newWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "has_completed_onboarding")
        
        // Fecha a janela anterior se existir
        onboardingWindow?.close()
        onboardingWindow = nil
        
        // Cria uma nova janela
        showOnboarding()
    }
    
    // MARK: - NSMenuDelegate
    
    func menuNeedsUpdate(_ menu: NSMenu) {
        // Usa SubscriptionManager que tem lógica própria de premium
        let isPremium = SubscriptionManager.shared.isPremium
        print("🔄 Menu updating... isPremium: \(isPremium) (from SubscriptionManager)")
        
        // Remove TODOS os items "Upgrade to Premium" e seus separators
        while let upgradeIndex = menu.items.firstIndex(where: { $0.action == #selector(openUpgrade) }) {
            print("  ➖ Removing upgrade item at index \(upgradeIndex)")
            
            // Remove o separator antes se existir e for logo antes
            if upgradeIndex > 0 && menu.items[upgradeIndex - 1].isSeparatorItem {
                // Verifica se não é um separator importante (antes de "Show Tutorial")
                if upgradeIndex > 1 && menu.items[upgradeIndex + 1].isSeparatorItem {
                    menu.removeItem(at: upgradeIndex - 1)
                }
            }
            menu.removeItem(at: upgradeIndex)
        }
        
        // Adiciona "Upgrade to Premium" se não for premium
        if !isPremium {
            print("  ➕ Adding upgrade item (user is FREE)")
            // Adiciona após "History" (índice 4)
            menu.insertItem(NSMenuItem.separator(), at: 4)
            let upgradeItem = NSMenuItem(title: NSLocalizedString("menu.upgrade", comment: "Upgrade to Premium"), action: #selector(openUpgrade), keyEquivalent: "u")
            upgradeItem.target = self
            menu.insertItem(upgradeItem, at: 5)
        } else {
            print("  ✅ User is PREMIUM, not adding upgrade item")
        }
    }
}

