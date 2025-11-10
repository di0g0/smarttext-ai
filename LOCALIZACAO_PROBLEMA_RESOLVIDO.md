# 🌍 Problema de Localização - RESOLVIDO

## ❌ Problema

As strings aparecem como chaves (ex: `menu.open`, `settings.title`) ao invés do texto traduzido.

**Causa:** Os arquivos `.lproj` não foram adicionados ao target do Xcode, então não são copiados para o bundle durante o build.

---

## ✅ Solução Rápida (TEMPORÁRIA)

### **Opção 1: Script Automático** ⚡

Após buildar no Xcode, execute:

```bash
cd /Users/diogo.costa/Dev/QuickTranslateAI
./copy_localization.sh
```

Depois, rode o app novamente no Xcode (⌘R).

**✅ PRONTO! As strings devem aparecer traduzidas agora!**

---

## ✅ Solução Permanente (RECOMENDADO)

Para que os arquivos sejam copiados automaticamente em cada build, você precisa adicionar os arquivos `.lproj` ao target do Xcode:

### **Passo a Passo:**

1. **Abra o Xcode**
   - Abra `QuickTranslateAI.xcodeproj`

2. **Delete as referências antigas (se existirem)**
   - No Project Navigator, se você ver `en.lproj` ou `pt-BR.lproj`:
     - Clique com botão direito → **Delete**
     - Selecione **"Remove Reference"** (NÃO "Move to Trash")

3. **Adicione os arquivos novamente**
   - Clique com botão direito na pasta `QuickTranslateAI` (no Project Navigator)
   - Selecione **"Add Files to QuickTranslateAI..."**

4. **Configure corretamente**
   - Navegue até a pasta do projeto
   - Selecione **AMBAS** as pastas:
     - ✅ `en.lproj`
     - ✅ `pt-BR.lproj`
   
   - **IMPORTANTE:** Marque estas opções:
     - ✅ **"Create folder references"** (as pastas devem ficar AZUIS)
     - ✅ **"Copy items if needed"**
     - ✅ Target **"QuickTranslateAI"** selecionado
   
   - Clique em **"Add"**

5. **Verifique**
   - As pastas devem aparecer em **AZUL** no Project Navigator:
     ```
     QuickTranslateAI/
       ├── 📁 en.lproj (AZUL)
       │   └── Localizable.strings
       └── 📁 pt-BR.lproj (AZUL)
           └── Localizable.strings
     ```

6. **Clean e Rebuild**
   - Menu: **Product → Clean Build Folder** (⇧⌘K)
   - Menu: **Product → Build** (⌘B)
   - Menu: **Product → Run** (⌘R)

**✅ Agora os arquivos serão copiados automaticamente em cada build!**

---

## 🧪 Como Testar

### **1. Verificar se está funcionando:**

Rode o app e veja se as strings aparecem traduzidas:
- ❌ Errado: `menu.open`, `settings.title`
- ✅ Certo: `Open QuickTranslate`, `Settings`

### **2. Testar mudança de idioma:**

**Inglês:**
1. System Settings → General → Language & Region
2. English como idioma principal
3. Rode o app → deve aparecer em inglês

**Português:**
1. System Settings → General → Language & Region
2. Portuguese (Brazil) como idioma principal
3. Rode o app → deve aparecer em português

---

## 🔍 Debug

Se ainda não funcionar, verifique:

### **1. Arquivos estão no bundle?**

```bash
# Encontra o bundle
find ~/Library/Developer/Xcode/DerivedData -name "QuickTranslateAI.app" -type d 2>/dev/null | head -1

# Verifica Resources (deve mostrar en.lproj e pt-BR.lproj)
ls -la "$(find ~/Library/Developer/Xcode/DerivedData -name "QuickTranslateAI.app" -type d 2>/dev/null | head -1)/Contents/Resources/"
```

**Deve mostrar:**
```
en.lproj/
pt-BR.lproj/
```

### **2. Strings estão corretas?**

```bash
cd /Users/diogo.costa/Dev/QuickTranslateAI

# Verifica inglês
head -5 QuickTranslateAI/en.lproj/Localizable.strings

# Verifica português
head -5 QuickTranslateAI/pt-BR.lproj/Localizable.strings
```

### **3. Info.plist está configurado?**

Verifique se `Info.plist` tem:

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

## 📝 Resumo

| Método | Quando Usar | Permanente? |
|--------|-------------|-------------|
| **Script `copy_localization.sh`** | Solução rápida para testar agora | ❌ Não (precisa rodar após cada build) |
| **Adicionar no Xcode** | Solução definitiva | ✅ Sim (automático em cada build) |

---

## 🎯 Status Atual

- ✅ Arquivos `.lproj` criados
- ✅ Strings traduzidas (EN + PT-BR)
- ✅ Info.plist configurado
- ✅ Script de cópia criado
- ⏳ **PENDENTE:** Adicionar arquivos ao target do Xcode (solução permanente)

---

## 💡 Dica

Depois de adicionar os arquivos no Xcode, você pode deletar o script `copy_localization.sh` pois não será mais necessário.

---

**Rode o app agora e as strings devem aparecer traduzidas!** 🎉

Se ainda tiver problemas, me avise qual erro aparece.

