//
//  SettingsView.swift
//  QuickTranslateAI
//
//  Interface de configurações com suporte a múltiplos idiomas
//

import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @AppStorage("preferred_language") private var preferredLanguage: String = "English"
    @AppStorage("auto_copy_result") private var autoCopyResult: Bool = false
    @AppStorage("launch_at_login") private var launchAtLogin: Bool = false
    @AppStorage("close_after_replace") private var closeAfterReplace: Bool = true
    @AppStorage("show_menu_bar_icon") private var showMenuBarIcon: Bool = true
    @AppStorage("keep_history") private var keepHistory: Bool = true
    
    @State private var usageInfo: (used: Int, total: Int, remaining: Int) = (0, 50, 50)
    @State private var showPaywall = false
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var showCloseButton: Bool = false // Para saber se foi aberto via sheet
    
    var body: some View {
        VStack(spacing: 0) {
            // Header customizado (só aparece quando aberto via sheet)
            if showCloseButton {
                HStack {
                    Text(NSLocalizedString("settings.title", comment: "Settings"))
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color(NSColor.windowBackgroundColor))
                
                Divider()
            }
            
            TabView {
                generalSettingsView
                    .tabItem {
                        Label(NSLocalizedString("settings.general", comment: ""), systemImage: "gearshape")
                    }
                
                usageView
                    .tabItem {
                        Label(NSLocalizedString("settings.usage", comment: "Usage"), systemImage: "chart.bar")
                    }
                
                aboutView
                    .tabItem {
                        Label(NSLocalizedString("settings.about", comment: ""), systemImage: "info.circle")
                    }
            }
            .padding(.top, showCloseButton ? 0 : 0)
        }
        .frame(width: 550, height: showCloseButton ? 490 : 450)
        .onAppear {
            updateUsageInfo()
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(source: .settings)
        }
    }
    
    // MARK: - General Settings
    
    private var generalSettingsView: some View {
        Form {
            if showCloseButton {
                Spacer().frame(height: 1)
            }
            
            Section {
                Picker(NSLocalizedString("settings.default_language.title", comment: ""), selection: $preferredLanguage) {
                    ForEach([
                        "English", "Portuguese", "Spanish", "French", "German",
                        "Italian", "Japanese", "Chinese", "Korean", "Arabic",
                        "Russian", "Dutch", "Swedish", "Polish", "Turkish",
                        "Hindi", "Thai", "Vietnamese", "Indonesian", "Hebrew"
                    ], id: \.self) { lang in
                        Text(lang).tag(lang)
                    }
                }
                .help(NSLocalizedString("settings.default_language.description", comment: ""))
                
                Toggle(NSLocalizedString("settings.auto_copy", comment: "Auto copy result"), isOn: $autoCopyResult)
                    .help(NSLocalizedString("settings.auto_copy.description", comment: "Auto copy after translation"))
                
                Toggle(NSLocalizedString("settings.close_after_replace", comment: "Close after replace"), isOn: $closeAfterReplace)
                    .help(NSLocalizedString("settings.close_after_replace.description", comment: "Close window after replace"))
                
            } header: {
                Text(NSLocalizedString("settings.translation_preferences", comment: "Translation Preferences"))
                    .font(.headline)
            }
            
            Section {
                Toggle(NSLocalizedString("settings.launch_at_login", comment: "Launch at login"), isOn: $launchAtLogin)
                    .help(NSLocalizedString("settings.launch_at_login.description", comment: "Start app automatically"))
                    .onChange(of: launchAtLogin) { newValue in
                        setLaunchAtLogin(enabled: newValue)
                    }
                
                Toggle(NSLocalizedString("settings.show_menu_icon", comment: "Show menu bar icon"), isOn: $showMenuBarIcon)
                    .help(NSLocalizedString("settings.show_menu_icon.description", comment: "Display icon in menu bar"))
                
            } header: {
                Text(NSLocalizedString("settings.system", comment: "System"))
                    .font(.headline)
            }
            
            Section {
                HStack {
                    Text(NSLocalizedString("settings.hotkey.title", comment: ""))
                    Spacer()
                    Text("⌘⇧T")
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(6)
                }
                
                Text(NSLocalizedString("settings.hotkey.description", comment: ""))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
            } header: {
                Text(NSLocalizedString("settings.shortcuts", comment: "Shortcuts"))
                    .font(.headline)
            }
            
            Section {
                Toggle(NSLocalizedString("settings.history.keep", comment: ""), isOn: $keepHistory)
                
                if keepHistory {
                    HStack {
                        Text(NSLocalizedString("settings.history.total", comment: "Total Translations"))
                        Spacer()
                        Text("\(HistoryManager.shared.entries.count)")
                            .fontWeight(.semibold)
                    }
                    
                    Button(NSLocalizedString("settings.history.clear", comment: "")) {
                        HistoryManager.shared.clearHistory()
                    }
                    .buttonStyle(.bordered)
                }
                
            } header: {
                Text(NSLocalizedString("settings.history.title", comment: ""))
                    .font(.headline)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    // MARK: - Usage View
    
    private var usageView: some View {
        Form {
            if showCloseButton {
                Spacer().frame(height: 1)
            }
            
            // Premium Status Banner
            if subscriptionManager.isPremium {
                Section {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(NSLocalizedString("status.premium", comment: "Premium Active"))
                                .font(.headline)
                            Text(NSLocalizedString("settings.usage.unlimited", comment: "Unlimited translations"))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "infinity")
                            .font(.largeTitle)
                            .foregroundColor(.accentColor)
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.yellow.opacity(0.1), Color.accentColor.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(12)
                }
            } else {
                Section {
                    VStack(spacing: 20) {
                        // Progress circle
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                                .frame(width: 120, height: 120)
                            
                            Circle()
                                .trim(from: 0, to: usageInfo.total > 0 ? CGFloat(usageInfo.used) / CGFloat(usageInfo.total) : 0)
                                .stroke(
                                    usageInfo.remaining > 3 ? Color.accentColor : Color.orange,
                                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                                )
                                .frame(width: 120, height: 120)
                                .rotationEffect(.degrees(-90))
                                .animation(.easeInOut, value: usageInfo.used)
                            
                            VStack(spacing: 4) {
                                Text("\(usageInfo.remaining)")
                                    .font(.system(size: 36, weight: .bold))
                                Text(NSLocalizedString("settings.usage.remaining", comment: "remaining"))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        
                        // Stats
                        VStack(spacing: 12) {
                            HStack {
                                Text(NSLocalizedString("settings.usage.used_today", comment: "Used today"))
                                Spacer()
                                Text("\(usageInfo.used)")
                                    .fontWeight(.semibold)
                            }
                            
                            HStack {
                                Text(NSLocalizedString("settings.usage.daily_limit", comment: "Daily limit"))
                                Spacer()
                                Text("\(usageInfo.total)")
                                    .fontWeight(.semibold)
                            }
                            
                            Divider()
                            
                            if usageInfo.remaining == 0 {
                                VStack(spacing: 8) {
                                    Text(NSLocalizedString("settings.usage.limit_reached", comment: "Limit reached"))
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                        .multilineTextAlignment(.center)
                                    
                                    Button(NSLocalizedString("button.upgrade_premium", comment: "Upgrade to Premium")) {
                                        showPaywall = true
                                    }
                                    .buttonStyle(.borderedProminent)
                                }
                            } else if usageInfo.remaining < 3 {
                                Text(NSLocalizedString("settings.usage.few_remaining", comment: "Few remaining"))
                                    .font(.caption)
                                    .foregroundColor(.orange)
                            } else {
                                Text(NSLocalizedString("settings.usage.all_good", comment: "All good"))
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .frame(maxWidth: .infinity)
                    
                } header: {
                    Text(NSLocalizedString("settings.usage.daily", comment: "Daily Usage"))
                        .font(.headline)
                } footer: {
                    Text(NSLocalizedString("settings.usage.footer", comment: "Daily limit helps maintain service"))
                        .font(.caption)
                }
            }
            
            Section {
                Button(NSLocalizedString("settings.usage.refresh", comment: "Refresh Information")) {
                    updateUsageInfo()
                }
                .buttonStyle(.bordered)
                
            } header: {
                Text(NSLocalizedString("settings.actions", comment: "Actions"))
                    .font(.headline)
            }
        }
        .formStyle(.grouped)
        .padding()
    }
    
    // MARK: - About
    
    private var aboutView: some View {
        VStack(spacing: 20) {
            if showCloseButton {
                Spacer().frame(height: 10)
            }
            
            Image(systemName: "character.bubble.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            
            Text("SmartText AI")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    Text(NSLocalizedString("settings.version", comment: ""))
                    Text("1.0.0")
                        .fontWeight(.semibold)
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                HStack(spacing: 8) {
                    Text(NSLocalizedString("settings.build", comment: ""))
                    Text("2025.1")
                        .fontWeight(.semibold)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
            
            Text(NSLocalizedString("settings.about.description", comment: "App description"))
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.top, 4)
            
            // Premium Status / Upgrade Button
            if subscriptionManager.isPremium {
                HStack(spacing: 8) {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.yellow)
                    Text(NSLocalizedString("status.premium", comment: "Premium Active"))
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.yellow.opacity(0.15))
                .cornerRadius(10)
            } else {
                Button(action: {
                    showPaywall = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                        Text(NSLocalizedString("button.upgrade_premium", comment: "Upgrade to Premium"))
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: 200)
                    .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            
            Divider()
                .padding(.horizontal, 60)
            
            VStack(spacing: 12) {
                Text(NSLocalizedString("settings.about.tagline", comment: "Developed with love"))
                    .font(.caption)
                
                Text("© 2025 SmartText AI")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // DEBUG: Botão para resetar premium (apenas para testes)
            #if DEBUG
            Button(action: {
                StoreKitManager.shared.debugResetPremium()
                SubscriptionManager.shared.resetDailyUsage()
                
                // Força atualização da UI
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    updateUsageInfo()
                }
            }) {
                Text("🔧 DEBUG: Reset Premium")
                    .font(.caption2)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
            .padding(.top, 8)
            #endif
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Methods
    
    private func updateUsageInfo() {
        usageInfo = subscriptionManager.getUsageInfo()
    }
    
    private func setLaunchAtLogin(enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                    print("✅ Launch at login enabled")
                } else {
                    try SMAppService.mainApp.unregister()
                    print("❌ Launch at login disabled")
                }
            } catch {
                print("⚠️ Failed to set launch at login: \(error)")
            }
        } else {
            print("⚠️ Launch at login requires macOS 13+")
        }
    }
}

#Preview {
    SettingsView()
}
