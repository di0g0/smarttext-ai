# 🌍 Teste de Localização (EN + PT-BR)

## ✅ O Que Foi Feito

Implementamos localização completa do app em **Inglês** e **Português Brasileiro**.

### Arquivos Modificados
- `QuickTranslateAIApp.swift` - Menu bar
- `OnboardingView.swift` - Telas de boas-vindas
- `OverlayView.swift` - Interface principal
- `SettingsView.swift` - Todas as configurações
- `HistoryView.swift` - Janela de histórico

### Arquivos de Localização
- `en.lproj/Localizable.strings` - 128 chaves em inglês
- `pt-BR.lproj/Localizable.strings` - 128 chaves em português

---

## 🧪 Como Testar

### 1️⃣ Testar em Português

```bash
# O app já deve estar em português se seu macOS está em português
open /Applications/QuickTranslateAI.app
```

**Verifique:**
- [ ] Menu bar: "Abrir QuickTranslate", "Preferências...", "Histórico", "Sair"
- [ ] Onboarding: "Bem-vindo ao QuickTranslate AI"
- [ ] Overlay: "Original", "Resultado", "Copiar", "Substituir"
- [ ] Settings: "Geral", "Uso", "Sobre"
- [ ] History: "Histórico", "Buscar no histórico..."

### 2️⃣ Testar em Inglês

**Opção A: Mudar idioma do sistema**
```bash
# 1. System Settings > General > Language & Region
# 2. Add English to preferred languages
# 3. Drag English to the top
# 4. Restart Mac (ou reabra o app)
```

**Opção B: Forçar inglês no app**
```bash
# Feche o app primeiro
killall QuickTranslateAI

# Force English
defaults write com.yourname.QuickTranslateAI AppleLanguages -array "en"
open /Applications/QuickTranslateAI.app

# Restore system default
defaults delete com.yourname.QuickTranslateAI AppleLanguages
```

**Verifique:**
- [ ] Menu bar: "Open QuickTranslate", "Preferences...", "History", "Quit"
- [ ] Onboarding: "Welcome to QuickTranslate AI"
- [ ] Overlay: "Original", "Result", "Copy", "Replace"
- [ ] Settings: "General", "Usage", "About"
- [ ] History: "History", "Search in history..."

---

## 📋 Checklist Completo

### Menu Bar (6 itens)
- [ ] Abrir QuickTranslate / Open QuickTranslate
- [ ] Preferências... / Preferences...
- [ ] Histórico / History
- [ ] Ver Tutorial de Novo / Show Tutorial Again
- [ ] Sobre / About
- [ ] Sair / Quit

### Onboarding (6 telas)
- [ ] Tela 1: Bem-vindo / Welcome
- [ ] Tela 2: Atalho de Teclado / Keyboard Shortcut
- [ ] Tela 3: Mais que Tradução / More than Translation
- [ ] Tela 4: 20 Idiomas / 20 Languages
- [ ] Tela 5: Permissão / Permission
- [ ] Tela 6: Tudo Pronto! / All Set!

### Overlay
- [ ] Header: "QuickTranslate"
- [ ] Input: "Original"
- [ ] Output: "Resultado" / "Result"
- [ ] Botões: "Histórico", "Copiar", "Substituir", "Fechar" / "History", "Copy", "Replace", "Close"

### Settings - Tab Geral
- [ ] "Idioma do App" / "App Language"
- [ ] "Idioma Padrão de Tradução" / "Default Translation Language"
- [ ] "Copiar resultado automaticamente" / "Auto copy result"
- [ ] "Fechar após substituir" / "Close after replace"
- [ ] "Abrir ao iniciar" / "Launch at login"
- [ ] "Atalho Global" / "Global Shortcut"

### Settings - Tab Uso
- [ ] "Uso Diário" / "Daily Usage"
- [ ] "restantes" / "remaining"
- [ ] "Usadas hoje:" / "Used today:"
- [ ] "Limite diário:" / "Daily limit:"
- [ ] Mensagens de status (3 variações)

### Settings - Tab Sobre
- [ ] "Versão:" / "Version:"
- [ ] "Build:" / "Build:"
- [ ] Descrição do app
- [ ] "Desenvolvido com ❤️" / "Built with ❤️"

### History
- [ ] "Histórico" / "History"
- [ ] "Buscar no histórico..." / "Search in history..."
- [ ] "Nenhum histórico ainda" / "No history yet"
- [ ] "Copiar Original" / "Copy Original"
- [ ] "Limpar Tudo" / "Clear All"
- [ ] Time: "1 min atrás" / "1 min ago"

---

## 🎯 Resultado Esperado

✅ **Português**: Todas as strings em português correto  
✅ **Inglês**: Todas as strings em inglês correto  
✅ **Auto-detecção**: App detecta idioma do sistema automaticamente  
✅ **Consistência**: Mesma tradução para mesmos termos  
✅ **Plurais**: Formatação correta (1 min / 2 mins)

---

## 🐛 Se Algo Não Funcionar

### Strings aparecem como chaves (ex: "settings.language.title")

```bash
# Rebuild com script de localização
cd /Users/diogo.costa/Dev/QuickTranslateAI
./build_with_localization.sh

# Reinstalar
rm -rf /Applications/QuickTranslateAI.app
cp -R build/Build/Products/Release/QuickTranslateAI.app /Applications/
xattr -cr /Applications/QuickTranslateAI.app
open /Applications/QuickTranslateAI.app
```

### App não muda de idioma

1. Verifique o idioma em Settings > "Idioma do App"
2. Feche o app completamente: `killall QuickTranslateAI`
3. Reabra o app

### Idioma errado

```bash
# Limpar preferências
defaults delete com.yourname.QuickTranslateAI app_language

# Reabrir app - vai detectar idioma do sistema
open /Applications/QuickTranslateAI.app
```

---

## 📊 Estatísticas

- **Total de Strings**: 128 únicas
- **Idiomas**: 2 (EN + PT-BR)
- **Cobertura**: 100%
- **Arquivos Localizados**: 5 views + 1 app
- **Componentes**: Menu, Onboarding, Overlay, Settings, History

---

## 🚀 Próximos Passos

- [ ] Testar com usuários falantes de inglês
- [ ] Adicionar mais idiomas (ES, FR, DE)?
- [ ] Localizar mensagens de erro da API
- [ ] Localizar notificações do sistema

