//
//  HistoryView.swift
//  QuickTranslateAI
//
//  Interface para visualizar histórico
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var historyManager = HistoryManager.shared
    @State private var searchText = ""
    
    var filteredEntries: [HistoryEntry] {
        if searchText.isEmpty {
            return historyManager.entries
        } else {
            return historyManager.entries.filter {
                $0.inputText.localizedCaseInsensitiveContains(searchText) ||
                $0.outputText.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            Divider()
            
            // Content
            if filteredEntries.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(filteredEntries) { entry in
                        HistoryEntryRow(entry: entry)
                            .contextMenu {
                                Button(NSLocalizedString("button.copy_original", comment: "Copy Original")) {
                                    ClipboardManager.shared.copyToClipboard(entry.inputText)
                                }
                                Button(NSLocalizedString("button.copy_translation", comment: "Copy Translation")) {
                                    ClipboardManager.shared.copyToClipboard(entry.outputText)
                                }
                                Divider()
                                Button(NSLocalizedString("button.delete", comment: "Delete"), role: .destructive) {
                                    historyManager.deleteEntry(entry)
                                }
                            }
                    }
                }
                .listStyle(.inset)
            }
        }
        .frame(minWidth: 600, minHeight: 500)
    }
    
    private var headerView: some View {
        VStack(spacing: 12) {
            HStack {
                Text(NSLocalizedString("history.title", comment: "History"))
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if !historyManager.entries.isEmpty {
                    Button(NSLocalizedString("button.clear_all", comment: "Clear All"), role: .destructive) {
                        historyManager.clearHistory()
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField(NSLocalizedString("history.search.placeholder", comment: "Search in history"), text: $searchText)
                    .textFieldStyle(.plain)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
        .padding()
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            Text(NSLocalizedString("history.empty.title", comment: "No history yet"))
                .font(.title3)
                .fontWeight(.medium)
            
            Text(NSLocalizedString("history.empty.subtitle", comment: "Use QuickTranslate to start"))
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HistoryEntryRow: View {
    let entry: HistoryEntry
    @State private var isExpanded = false
    @State private var showCopiedFeedback = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Text(entry.localizedAction)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.accentColor.opacity(0.2))
                    .cornerRadius(6)
                
                if let language = entry.language {
                    Text("→ \(language)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Tempo relativo SEM segundos
                Text(timeAgoString(from: entry.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Botão copiar direto
                Button(action: {
                    ClipboardManager.shared.copyToClipboard(entry.outputText)
                    showCopiedFeedback = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        showCopiedFeedback = false
                    }
                }) {
                    Image(systemName: showCopiedFeedback ? "checkmark" : "doc.on.doc")
                        .font(.caption)
                        .foregroundColor(showCopiedFeedback ? .green : .accentColor)
                }
                .buttonStyle(.plain)
                .help("Copiar tradução")
                
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                }
                .buttonStyle(.plain)
            }
            
            // Preview
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.inputText)
                    .font(.body)
                    .lineLimit(isExpanded ? nil : 2)
                    .foregroundColor(.primary)
                
                if isExpanded {
                    Divider()
                        .padding(.vertical, 4)
                    
                    Text(entry.outputText)
                        .font(.body)
                        .foregroundColor(.accentColor)
                }
            }
            
            // Actions (when expanded)
            if isExpanded {
                HStack(spacing: 12) {
                    Button(action: {
                        ClipboardManager.shared.copyToClipboard(entry.inputText)
                    }) {
                        Label(NSLocalizedString("button.copy_original", comment: "Copy Original"), systemImage: "doc.on.doc")
                            .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    
                    Button(action: {
                        ClipboardManager.shared.copyToClipboard(entry.outputText)
                    }) {
                        Label(NSLocalizedString("button.copy_result", comment: "Copy Result"), systemImage: "doc.on.doc.fill")
                            .font(.caption)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 4)
    }
    
    // Função para formatar tempo SEM segundos
    private func timeAgoString(from date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents([.minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return day == 1 
                ? NSLocalizedString("time.day_singular", comment: "1 day ago")
                : String(format: NSLocalizedString("time.day_plural", comment: "X days ago"), day)
        } else if let hour = components.hour, hour > 0 {
            return hour == 1 
                ? NSLocalizedString("time.hour_singular", comment: "1 hour ago")
                : String(format: NSLocalizedString("time.hour_plural", comment: "X hours ago"), hour)
        } else if let minute = components.minute, minute > 0 {
            return minute == 1 
                ? NSLocalizedString("time.minute_singular", comment: "1 min ago")
                : String(format: NSLocalizedString("time.minute_plural", comment: "X min ago"), minute)
        } else {
            return NSLocalizedString("time.now", comment: "now")
        }
    }
}

