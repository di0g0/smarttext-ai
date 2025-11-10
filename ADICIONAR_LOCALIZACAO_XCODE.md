# 🌍 Como Adicionar Arquivos de Localização no Xcode

## ❌ Problema

As strings aparecem como chaves (ex: `menu.open`) ao invés do texto traduzido.

**Causa:** Os arquivos `.lproj` não foram adicionados ao target do Xcode.

---

## ✅ Solução

### **Método 1: Adicionar Manualmente no Xcode** (RECOMENDADO)

1. **Abra o Xcode**
   - Abra o projeto `QuickTranslateAI.xcodeproj`

2. **Adicione os arquivos `.lproj`**
   - No **Project Navigator** (painel esquerdo), clique com botão direito na pasta `QuickTranslateAI`
   - Selecione **"Add Files to QuickTranslateAI..."**

3. **Selecione as pastas de localização**
   - Navegue até a pasta do projeto
   - Selecione **AMBAS** as pastas:
     - `en.lproj`
     - `pt-BR.lproj`
   - ✅ Marque **"Create folder references"** (NÃO "Create groups")
   - ✅ Marque **"Copy items if needed"**
   - ✅ Certifique-se que o target **"QuickTranslateAI"** está selecionado

4. **Verifique se foi adicionado**
   - No Project Navigator, você deve ver:
     ```
     QuickTranslateAI/
       ├── en.lproj/
       │   └── Localizable.strings
       └── pt-BR.lproj/
           └── Localizable.strings
     ```
   - As pastas devem aparecer em **AZUL** (folder references)

5. **Verifique o Target**
   - Clique em cada arquivo `Localizable.strings`
   - No **File Inspector** (painel direito), verifique se o target **"QuickTranslateAI"** está marcado

6. **Clean e Rebuild**
   - Menu: **Product → Clean Build Folder** (⇧⌘K)
   - Menu: **Product → Build** (⌘B)
   - Menu: **Product → Run** (⌘R)

---

### **Método 2: Via Terminal** (Alternativo)

Se o Método 1 não funcionar, tente este:

```bash
cd /Users/diogo.costa/Dev/QuickTranslateAI

# Remove os arquivos do Xcode (se existirem)
rm -rf DerivedData

# Limpa o build
xcodebuild clean -scheme QuickTranslateAI

# Rebuild
xcodebuild -scheme QuickTranslateAI -configuration Debug build
```

---

### **Método 3: Verificar Info.plist**

Certifique-se que o `Info.plist` tem estas chaves:

```xml
<key>CFBundleDevelopmentRegion</key>
<string>en</string>
<key>CFBundleLocalizations</key>
<array>
    <string>en</string>
    <string>pt-BR</string>
</array>
```

---

## 🧪 Como Testar

### **Testar em Inglês:**
1. Abra **System Settings → General → Language & Region**
2. Certifique-se que **English** está como idioma principal
3. Rode o app
4. Você deve ver: "Open QuickTranslate", "Preferences...", etc.

### **Testar em Português:**
1. Abra **System Settings → General → Language & Region**
2. Adicione **Portuguese (Brazil)** e coloque como idioma principal
3. Rode o app
4. Você deve ver: "Abrir QuickTranslate", "Preferências...", etc.

---

## 🔍 Debug

Se ainda não funcionar, verifique:

### **1. Arquivos estão no bundle?**
```bash
# Após buildar, verifique o bundle
cd ~/Library/Developer/Xcode/DerivedData/QuickTranslateAI-*/Build/Products/Debug/QuickTranslateAI.app/Contents/Resources

# Deve listar en.lproj e pt-BR.lproj
ls -la
```

### **2. Strings estão corretas?**
```bash
# Verifique o conteúdo
cat en.lproj/Localizable.strings | head -5
cat pt-BR.lproj/Localizable.strings | head -5
```

### **3. Teste no código**
Adicione este código temporário em `QuickTranslateAIApp.swift` (dentro do `init()`):

```swift
// DEBUG: Teste de localização
print("🌍 Current locale: \(Locale.current.identifier)")
print("🌍 Preferred languages: \(Locale.preferredLanguages)")
print("🌍 Test string: \(NSLocalizedString("menu.open", comment: ""))")
```

Isso deve imprimir no console:
- Idioma atual
- Idiomas preferidos
- String traduzida (ou a chave se não encontrar)

---

## 📝 Checklist

- [ ] Arquivos `.lproj` adicionados ao Xcode
- [ ] Target "QuickTranslateAI" marcado nos arquivos
- [ ] Pastas aparecem em AZUL no Project Navigator
- [ ] Clean Build Folder executado
- [ ] App rebuilded
- [ ] Strings aparecem traduzidas (não mais as chaves)

---

## 💡 Dica

Se você deletar e readicionar os arquivos, certifique-se de:
1. **Deletar as referências** no Xcode (botão direito → Delete → "Remove Reference")
2. **Não deletar os arquivos físicos** do disco
3. **Adicionar novamente** seguindo o Método 1

---

**Depois de seguir estes passos, as strings devem aparecer traduzidas!** 🎉

