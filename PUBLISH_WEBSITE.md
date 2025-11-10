# 🌐 Como Publicar as Páginas (Privacy & Support)

## ✅ ARQUIVOS CRIADOS:

- `privacy.html` - Privacy Policy
- `support.html` - Support Page

---

## 🚀 OPÇÃO 1: GitHub Pages (GRÁTIS - RECOMENDADO)

### Passo 1: Criar Repositório no GitHub

1. Acesse: https://github.com/new
2. **Repository name:** `smarttext-ai-website`
3. **Public** (marque como público)
4. Clique em **"Create repository"**

### Passo 2: Upload dos Arquivos

```bash
cd /Users/diogo.costa/Dev/QuickTranslateAI

# Inicializa repo
git init website
cd website

# Copia os arquivos
cp ../privacy.html .
cp ../support.html .

# Cria index.html (página inicial)
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SmartText AI</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            text-align: center;
            padding: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
        }
        h1 { font-size: 48px; margin-bottom: 20px; }
        p { font-size: 20px; margin-bottom: 30px; }
        a { color: white; text-decoration: none; background: rgba(255,255,255,0.2); padding: 10px 20px; border-radius: 8px; margin: 0 10px; display: inline-block; }
        a:hover { background: rgba(255,255,255,0.3); }
    </style>
</head>
<body>
    <h1>SmartText AI</h1>
    <p>The smartest way to translate and improve text on Mac</p>
    <a href="privacy.html">Privacy Policy</a>
    <a href="support.html">Support</a>
</body>
</html>
EOF

# Commita
git add .
git commit -m "Initial commit - SmartText AI website"

# Adiciona remote (SUBSTITUA SEU-USERNAME pelo seu usuário do GitHub)
git remote add origin https://github.com/SEU-USERNAME/smarttext-ai-website.git

# Push
git branch -M main
git push -u origin main
```

### Passo 3: Ativar GitHub Pages

1. Vá em: https://github.com/SEU-USERNAME/smarttext-ai-website/settings/pages
2. **Source:** Deploy from a branch
3. **Branch:** main
4. **Folder:** / (root)
5. Clique em **Save**

### Passo 4: Aguardar Deploy (2-3 minutos)

Suas URLs serão:
```
https://SEU-USERNAME.github.io/smarttext-ai-website/privacy.html
https://SEU-USERNAME.github.io/smarttext-ai-website/support.html
```

---

## 🚀 OPÇÃO 2: Usar Seu Email (MAIS SIMPLES)

Se você não quiser criar website agora, use apenas seu email:

**Privacy Policy URL:**
```
mailto:seu@email.com?subject=SmartText%20AI%20Privacy%20Policy
```

**Support URL:**
```
mailto:seu@email.com?subject=SmartText%20AI%20Support
```

⚠️ **Menos profissional**, mas funciona para lançamento inicial.

---

## 🚀 OPÇÃO 3: Netlify Drop (SUPER RÁPIDO)

1. Acesse: https://app.netlify.com/drop
2. Arraste os arquivos `privacy.html` e `support.html`
3. **Pronto!** URLs geradas automaticamente

Exemplo:
```
https://random-name-123.netlify.app/privacy.html
https://random-name-123.netlify.app/support.html
```

---

## ✅ DEPOIS DE PUBLICAR:

### No App Store Connect, coloque:

**Privacy Policy URL:**
```
https://SEU-USERNAME.github.io/smarttext-ai-website/privacy.html
```

**Support URL:**
```
https://SEU-USERNAME.github.io/smarttext-ai-website/support.html
```

**Marketing URL (opcional):**
```
https://SEU-USERNAME.github.io/smarttext-ai-website/
```

---

## 💡 DICA:

Se você tiver um domínio próprio (ex: `smarttextai.app`), pode apontar para o GitHub Pages depois!

---

## 🎯 RESUMO:

1. ✅ Arquivos HTML criados
2. ⏳ Publicar no GitHub Pages (5 minutos)
3. ⏳ Copiar URLs para App Store Connect

---

**Escolha uma opção e me avise quando publicar!** 🚀

