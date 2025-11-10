# 📸 GUIA DE SCREENSHOTS PROFISSIONAIS

## ✅ TEMPLATES CRIADOS:

5 templates HTML prontos em `/screenshots/`:

| # | Arquivo | Tema | Gradiente |
|---|---------|------|-----------|
| 1 | `screenshot1-template.html` | Instant Translation | Roxo/Rosa |
| 2 | `screenshot2-template.html` | AI Actions | Pink/Vermelho |
| 3 | `screenshot3-template.html` | History | Azul claro |
| 4 | `screenshot4-template.html` | Premium/Paywall | Laranja/Pêssego |
| 5 | `screenshot5-template.html` | Settings/Usage | Verde água/Rosa |

---

## 🎯 COMO USAR:

### **Método 1: Screenshot Completo do Template** (MAIS FÁCIL)

1. **Abra cada HTML no navegador:**
```bash
cd /Users/diogo.costa/Dev/QuickTranslateAI/screenshots
open screenshot1-template.html
```

2. **Ponha em Full Screen:**
   - Pressione **F11** ou **⌃⌘F**
   - O template vai preencher a tela em 2880x1800

3. **Tire Screenshot:**
   - **Cmd+Shift+3** (captura tela inteira)
   - Ou **Cmd+Shift+4 → Espaço** (captura janela)

4. **Salve como:**
   - `screenshot1.png`, `screenshot2.png`, etc.

5. **Repita para os 5 templates**

✅ **PRONTO!** Screenshots já no tamanho certo (2880x1800)!

---

### **Método 2: Compor com Suas Capturas** (MAIS PROFISSIONAL)

1. **Tire screenshots do seu app:**
   - Overlay
   - AI Actions menu
   - History window
   - Paywall
   - Settings

2. **Abra cada template no navegador**

3. **Abra DevTools** (F12 ou ⌘⌥I)

4. **Cole sua captura:**
   - Edite o HTML
   - Substitua `.instruction` por uma `<img>` tag
   - Exemplo:
```html
<img src="sua-captura.png" style="max-width: 90%; max-height: 90%; border-radius: 16px; box-shadow: 0 20px 60px rgba(0,0,0,0.4);">
```

5. **Tire screenshot do template completo**

---

## 🚀 MÉTODO RÁPIDO (RECOMENDADO):

Execute este script:

```bash
cd /Users/diogo.costa/Dev/QuickTranslateAI
./capture_appstore_screenshots.sh
```

Ele vai:
1. Abrir cada template no navegador
2. Esperar 3 segundos
3. Tirar screenshot automaticamente
4. Salvar em `~/Desktop/app-store-screenshots/`

---

## 📝 CONTEÚDO DE CADA SCREENSHOT:

### **Screenshot 1 - Instant Translation**
**O que mostrar:**
- TextEdit com texto em inglês selecionado
- Overlay aparecendo ao lado com tradução em português
- Botões "Copy" e "Replace" visíveis

**Texto sugerido:**
```
"I need to translate this text to Portuguese for my client presentation tomorrow"
```

---

### **Screenshot 2 - AI Actions**
**O que mostrar:**
- Overlay aberta
- Menu de ações expandido mostrando:
  - Translate
  - Improve
  - Make Formal
  - Make Casual
  - Fix Grammar
  - Simplify
  - Expand

---

### **Screenshot 3 - History**
**O que mostrar:**
- Janela de History
- Várias entradas de traduções
- Diferentes idiomas e ações
- Barra de busca
- Data/hora visíveis

---

### **Screenshot 4 - Paywall**
**O que mostrar:**
- Janela de Upgrade to Premium
- 3 planos lado a lado:
  - Monthly ($4.99/mo)
  - Yearly ($39.99/yr) - com "Best Value"
  - Lifetime ($79.99)
- Lista de features
- Botão "Restore Purchases"

---

### **Screenshot 5 - Settings/Usage**
**O que mostrar:**
- Settings window
- Aba "Usage" selecionada
- Círculo de progresso mostrando 5-7/10
- Estatísticas de uso
- Botão "Refresh"

---

## 💡 DICAS:

### **Para Screenshots Perfeitos:**

1. **Limpe o Desktop**
```bash
defaults write com.apple.finder CreateDesktop false
killall Finder
```

2. **Use Wallpaper Neutro**
   - Cinza claro ou escuro
   - Nada distrativo

3. **Esconda a barra de menus** (opcional)
   - System Settings → Desktop & Dock → Automatically hide menu bar

4. **Posicione bem as janelas**
   - Centralize
   - Deixe espaço ao redor

---

## 🎨 ALTERNATIVA: USAR FIGMA/CANVA

Se preferir mais controle:

1. Crie canvas 2880x1800
2. Copie o gradiente do HTML
3. Cole suas capturas
4. Adicione textos/setas
5. Exporte como PNG

---

## ✅ CHECKLIST FINAL:

Antes de fazer upload, verifique:

- [ ] 5 screenshots criados
- [ ] Todos em 2880x1800px (ou proporção 16:10)
- [ ] Formato PNG
- [ ] Qualidade boa (sem blur)
- [ ] Texto legível
- [ ] Cada screenshot mostra uma feature diferente
- [ ] Visual consistente (cores, estilo)

---

## 🚀 EXECUTE AGORA:

```bash
# Abra o primeiro template
cd /Users/diogo.costa/Dev/QuickTranslateAI/screenshots
open screenshot1-template.html

# Deixe em full screen e tire screenshot!
```

---

**Depois de criar os 5 screenshots, me avisa para fazer upload!** 📸

