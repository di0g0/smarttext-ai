# 🚀 Build de Release - QuickTranslate AI

## ✅ Pré-requisitos

Antes de gerar a build de release:

- [x] Ícone configurado (Assets.xcassets)
- [x] Onboarding implementado
- [x] Info.plist configurado
- [x] Versão: 1.0.0 (Build 1)

---

## 📦 Gerar Build de Release (Archive)

### Opção 1: Via Xcode (Recomendado para testar)

1. **Abra o Xcode**
   ```bash
   open QuickTranslateAI.xcodeproj
   ```

2. **Configure o Scheme**
   - Product → Scheme → Edit Scheme
   - Run → Info → Build Configuration: **Release**

3. **Selecione o destino**
   - Toolbar: Selecione "Any Mac (Apple Silicon, Intel)"

4. **Archive**
   - Product → Archive
   - Aguarde o build completar
   - O Organizer vai abrir automaticamente

5. **Exportar o App**
   - Clique em "Distribute App"
   - Selecione: **"Copy App"** (para testar localmente)
   - Escolha o local para salvar
   - Pronto! Você terá um `.app` pronto para testar

### Opção 2: Via Terminal (Mais rápido)

```bash
# Build Release direto
xcodebuild \
  -project QuickTranslateAI.xcodeproj \
  -scheme QuickTranslateAI \
  -configuration Release \
  -derivedDataPath ./build \
  clean build

# O app estará em:
# ./build/Build/Products/Release/QuickTranslateAI.app
```

---

## 🧪 Testar a Build (Como se fosse da App Store)

### Passo 1: Fechar qualquer instância do app
```bash
pkill -9 QuickTranslate
```

### Passo 2: Copiar o app para /Applications
```bash
# Se fez via Xcode (Copy App), apenas arraste para /Applications
# Se fez via terminal:
cp -R ./build/Build/Products/Release/QuickTranslateAI.app /Applications/
```

### Passo 3: Limpar UserDefaults (simular primeira execução)
```bash
defaults delete com.yourname.QuickTranslateAI 2>/dev/null || true
```

### Passo 4: Abrir o app
```bash
open /Applications/QuickTranslateAI.app
```

### Passo 5: Testar
- ✅ Onboarding deve aparecer
- ✅ Ícone na barra de menu
- ✅ Permissão de acessibilidade
- ✅ ⌘⇧T funciona
- ✅ Tradução funciona
- ✅ Histórico funciona
- ✅ Settings funciona

---

## 🔐 Code Signing (Para distribuição)

### Verificar assinatura atual
```bash
codesign -dvv /Applications/QuickTranslateAI.app
```

### Para App Store (futuro)

1. **Configure o Bundle ID único**
   - No Xcode: Target → Signing & Capabilities
   - Bundle Identifier: `com.seudominio.QuickTranslateAI`

2. **Selecione seu Team**
   - Team: Sua conta Apple Developer

3. **Habilite Hardened Runtime**
   - Signing & Capabilities → + Capability → Hardened Runtime

4. **Archive e Upload**
   - Product → Archive
   - Distribute App → App Store Connect
   - Siga o wizard

---

## 📋 Checklist de Teste da Build

### Primeira Execução
- [ ] Onboarding aparece automaticamente
- [ ] 6 passos do onboarding funcionam
- [ ] Indicadores de página fixos
- [ ] Botão de acessibilidade abre Preferências do Sistema
- [ ] Tela final mostra ícone correto (character.bubble.fill)

### Funcionalidades
- [ ] Ícone aparece na barra de menu
- [ ] Menu bar tem todas as opções
- [ ] ⌘⇧T abre a janela
- [ ] Captura texto selecionado
- [ ] Tradução funciona (com API key configurada)
- [ ] Dropdown de ações funciona (Traduzir, Melhorar, etc)
- [ ] 20 idiomas disponíveis
- [ ] Botão "Substituir" funciona
- [ ] Botão "Copiar" funciona
- [ ] Janela posiciona perto do cursor

### Persistência
- [ ] Settings salvam (idioma, toggles)
- [ ] Histórico persiste
- [ ] "Ver Tutorial de Novo" funciona

### Performance
- [ ] App inicia rápido
- [ ] Tradução é fluida (debounce 1.5s)
- [ ] Sem crashes
- [ ] Sem vazamentos de memória

---

## 🐛 Troubleshooting

### "QuickTranslate não pode ser aberto porque é de desenvolvedor não identificado"

**Solução:**
```bash
xattr -cr /Applications/QuickTranslateAI.app
```

### Build muito grande

**Otimizar:**
1. Xcode → Build Settings
2. Optimization Level → `-Os` (Optimize for Size)
3. Strip Debug Symbols During Copy → Yes
4. Strip Swift Symbols → Yes

### Ícone não aparece

**Verificar:**
1. Info.plist tem `CFBundleIconFile` configurado
2. Assets.xcassets tem AppIcon completo
3. Rebuild: `xcodebuild clean build`

---

## 📊 Tamanho Esperado

- **Debug Build:** ~15-20 MB
- **Release Build:** ~8-12 MB (otimizado)
- **Compressed DMG:** ~5-8 MB

---

## 🎯 Próximos Passos

Após testar a build de release:

1. [ ] Implementar IAP (In-App Purchase)
2. [ ] Criar paywall
3. [ ] Screenshots para App Store
4. [ ] Preparar descrição e metadata
5. [ ] Submeter para review

---

## 📞 Comandos Úteis

```bash
# Ver versão atual
defaults read /Applications/QuickTranslateAI.app/Contents/Info.plist CFBundleShortVersionString

# Ver build number
defaults read /Applications/QuickTranslateAI.app/Contents/Info.plist CFBundleVersion

# Ver bundle ID
defaults read /Applications/QuickTranslateAI.app/Contents/Info.plist CFBundleIdentifier

# Limpar cache do Xcode
rm -rf ~/Library/Developer/Xcode/DerivedData/*

# Ver logs do app
log show --predicate 'process == "QuickTranslateAI"' --last 5m
```

---

**Pronto!** 🎉 Agora você pode testar o app exatamente como um usuário final receberia da App Store!

