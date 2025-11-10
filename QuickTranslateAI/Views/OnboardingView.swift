//
//  OnboardingView.swift
//  QuickTranslateAI
//
//  Welcome screen na primeira execução
//

import SwiftUI
import AppKit
import ServiceManagement

struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentStep = 0
    @State private var enableLaunchAtLogin = true // Default: habilitado
    @AppStorage("has_completed_onboarding") private var hasCompletedOnboarding = false
    @AppStorage("launch_at_login") private var launchAtLogin: Bool = false
    
    let steps = [
        OnboardingStep(
            icon: "character.bubble.fill",
            title: NSLocalizedString("onboarding.welcome.title", comment: "Welcome to QuickTranslate AI"),
            description: NSLocalizedString("onboarding.welcome.description_full", comment: "Translate between 20 languages, improve and more"),
            color: .blue
        ),
        OnboardingStep(
            icon: "keyboard",
            title: NSLocalizedString("onboarding.keyboard.title", comment: "Keyboard Shortcut"),
            description: NSLocalizedString("onboarding.keyboard.description", comment: "Select text and press Command+Shift+T"),
            color: .purple
        ),
        OnboardingStep(
            icon: "accessibility",
            title: NSLocalizedString("onboarding.accessibility.title", comment: "Permission Required"),
            description: NSLocalizedString("onboarding.accessibility.description", comment: "We need Accessibility permission"),
            color: .orange
        ),
        OnboardingStep(
            icon: "arrow.clockwise",
            title: NSLocalizedString("onboarding.launch.title", comment: "Launch at Login"),
            description: NSLocalizedString("onboarding.launch.description", comment: "Start automatically"),
            color: .cyan
        ),
        OnboardingStep(
            icon: "character.bubble.fill",
            title: NSLocalizedString("onboarding.ready.title", comment: "All Set!"),
            description: "", // Texto será customizado inline
            color: .blue
        )
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color(nsColor: .systemBlue).opacity(0.1), Color(nsColor: .systemPurple).opacity(0.05)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Progress indicator (FIXO no topo)
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Circle()
                            .fill(index <= currentStep ? Color.accentColor : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut, value: currentStep)
                    }
                }
                .frame(height: 60) // Altura fixa
                .padding(.top, 40)
                
                Spacer()
                
                // Content (CENTRO)
                VStack(spacing: 24) {
                    // Icon
                    Image(systemName: steps[currentStep].icon)
                        .font(.system(size: 80))
                        .foregroundColor(steps[currentStep].color)
                        .symbolRenderingMode(.hierarchical)
                        .transition(.scale.combined(with: .opacity))
                        .id("icon-\(currentStep)")
                    
                    // Title
                    Text(steps[currentStep].title)
                        .font(.system(size: 28, weight: .bold))
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .id("title-\(currentStep)")
                    
                    // Description (com suporte para ícone inline no último step)
                    if currentStep == steps.count - 1 {
                        // Última tela - com ícone inline (usando VStack para wrap)
                        VStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Text(NSLocalizedString("onboarding.ready.line1", comment: "QuickTranslate is in menu bar"))
                            }
                            HStack(spacing: 4) {
                                Text(NSLocalizedString("onboarding.ready.line2", comment: "Look for"))
                                Image(systemName: "character.bubble.fill")
                                    .font(.system(size: 16))
                                    .foregroundColor(.accentColor)
                                Text(NSLocalizedString("onboarding.ready.line3", comment: "and use shortcut"))
                            }
                            Text(NSLocalizedString("onboarding.ready.line4", comment: "Have fun!"))
                        }
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 400)
                        .transition(.opacity)
                        .id("desc-\(currentStep)")
                    } else {
                        VStack(spacing: 12) {
                            Text(steps[currentStep].description)
                                .font(.system(size: 16))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(maxWidth: 400)
                                .lineLimit(nil)
                            
                            // Instruções extras para Accessibility
                            if currentStep == 2 { // Step de Accessibility
                                VStack(spacing: 8) {
                                    Text(NSLocalizedString("onboarding.accessibility.steps", comment: "Steps to enable"))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.orange)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Text("1.")
                                                .fontWeight(.bold)
                                            Text(NSLocalizedString("onboarding.accessibility.step1", comment: "Click Open Settings"))
                                        }
                                        HStack {
                                            Text("2.")
                                                .fontWeight(.bold)
                                            Text(NSLocalizedString("onboarding.accessibility.step2", comment: "Find SmartText AI"))
                                        }
                                        HStack {
                                            Text("3.")
                                                .fontWeight(.bold)
                                            Text(NSLocalizedString("onboarding.accessibility.step3", comment: "Toggle switch ON"))
                                        }
                                    }
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.orange.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                        .transition(.opacity)
                        .id("desc-\(currentStep)")
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: currentStep)
                .frame(height: 240) // Altura fixa para o conteúdo
                
                Spacer()
                
                // Buttons area (FIXO no rodapé) - altura fixa para acomodar 2 botões
                VStack(spacing: 10) {
                    // Layout especial para Launch at Login (botões na mesma linha)
                    if currentStep == 3 { // Step de Launch at Login (step 4 de 5)
                        HStack(spacing: 16) {
                            // Botão Voltar
                            if currentStep > 0 {
                                Button(action: {
                                    withAnimation {
                                        currentStep -= 1
                                    }
                                }) {
                                    Text(NSLocalizedString("button.back", comment: "Back"))
                                        .frame(minWidth: 100)
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                            }
                            
                            Spacer()
                            
                            // Botões Não/Sim
                            Button(action: {
                                enableLaunchAtLogin = false
                                withAnimation {
                                    currentStep += 1
                                }
                            }) {
                                Text(NSLocalizedString("button.no_thanks", comment: "No, Thanks"))
                                    .frame(minWidth: 100)
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.large)
                            
                            Button(action: {
                                enableLaunchAtLogin = true
                                setLaunchAtLogin(enabled: true)
                                withAnimation {
                                    currentStep += 1
                                }
                            }) {
                                Text(NSLocalizedString("button.yes_enable", comment: "Yes, Enable!"))
                                    .frame(minWidth: 100)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .padding(.horizontal, 60)
                        
                        // Espaço vazio para manter altura consistente
                        Color.clear
                            .frame(height: 44)
                    } else {
                        // Layout padrão para outros steps
                        HStack(spacing: 16) {
                            if currentStep > 0 {
                                Button(action: {
                                    withAnimation {
                                        currentStep -= 1
                                    }
                                }) {
                                    Text(NSLocalizedString("button.back", comment: "Back"))
                                        .frame(minWidth: 100)
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if currentStep < steps.count - 1 {
                                    withAnimation {
                                        currentStep += 1
                                    }
                                } else {
                                    // Último step - só completa
                                    completeOnboarding()
                                }
                            }) {
                                Text(getButtonText())
                                    .frame(minWidth: 140)
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .padding(.horizontal, 60)
                        
                        // Botão especial para Acessibilidade
                        Group {
                            if currentStep == 2 { // Step de Acessibilidade (step 3 de 5)
                                Button(action: {
                                    openAccessibilitySettings()
                                }) {
                                    Label(NSLocalizedString("button.open_accessibility", comment: "Open Accessibility Settings"), systemImage: "gear")
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                            } else {
                                // Espaço vazio para manter altura consistente
                                Color.clear
                                    .frame(height: 28)
                            }
                        }
                        .frame(height: 44) // Altura fixa (altura do botão)
                    }
                }
                .frame(height: 120) // Área fixa para botões
                .padding(.bottom, 40)
            }
        }
        .frame(width: 600, height: 500)
    }
    
    private func getButtonText() -> String {
        if currentStep == 2 {
            // Step de Acessibilidade (step 3 de 5)
            return NSLocalizedString("button.already_configured", comment: "I Already Configured")
        } else if currentStep == steps.count - 1 {
            // Último step (Tudo Pronto!)
            return NSLocalizedString("button.start_using", comment: "Start Using!")
        } else {
            // Steps normais
            return NSLocalizedString("button.continue", comment: "Continue")
        }
    }
    
    private func openAccessibilitySettings() {
        // Abre diretamente o painel de Acessibilidade nas Preferências do Sistema
        // No macOS 13+, usa a nova URL do System Settings
        if #available(macOS 13, *) {
            // Ventura e superior: System Settings
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.settings.PrivacySecurity.extension")!)
            
            // Aguarda um pouco e tenta abrir a seção específica de Accessibility
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
            }
        } else {
            // Monterey e anterior: System Preferences
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
        }
        
        print("🔓 Abrindo preferências de Acessibilidade...")
    }
    
    private func setLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                    launchAtLogin = true
                    print("✅ Launch at login enabled during onboarding")
                } else {
                    try SMAppService.mainApp.unregister()
                    launchAtLogin = false
                    print("❌ Launch at login disabled during onboarding")
                }
            } catch {
                print("⚠️ Failed to set launch at login: \(error)")
            }
        }
    }
    
    private func completeOnboarding() {
        hasCompletedOnboarding = true
        withAnimation {
            isPresented = false
        }
    }
}

struct OnboardingStep {
    let icon: String
    let title: String
    let description: String
    let color: Color
}

// MARK: - Onboarding Window

class OnboardingWindow: NSWindow {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        
        self.center()
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isMovableByWindowBackground = true
        self.level = .floating
        
        let showOnboarding = Binding<Bool>(
            get: { self.isVisible },
            set: { if !$0 { self.close() } }
        )
        
        let contentView = OnboardingView(isPresented: showOnboarding)
        self.contentView = NSHostingView(rootView: contentView)
    }
}

// MARK: - Preview

#Preview {
    OnboardingView(isPresented: .constant(true))
}

