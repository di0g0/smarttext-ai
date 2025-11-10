# 📋 App Store Submission Checklist

## ✅ Fase 1: Assets e Branding (AGORA)

### 1. Ícone do App
- [ ] Design do ícone (1024x1024 PNG)
- [ ] Adicionar ao Assets.xcassets
- [ ] Testar em diferentes tamanhos
- [ ] Validar no Xcode

**Tamanhos necessários para macOS:**
- 16x16 (@1x e @2x)
- 32x32 (@1x e @2x)
- 128x128 (@1x e @2x)
- 256x256 (@1x e @2x)
- 512x512 (@1x e @2x)
- 1024x1024 (App Store)

### 2. Screenshots (5-8 imagens)
- [ ] Screenshot 1: Janela principal com tradução
- [ ] Screenshot 2: Menu bar e atalho
- [ ] Screenshot 3: Configurações
- [ ] Screenshot 4: Histórico
- [ ] Screenshot 5: Diferentes idiomas
- [ ] Screenshot 6: Ações (melhorar, resumir)
- [ ] Screenshot 7: Onboarding (opcional)
- [ ] Screenshot 8: Premium features (se houver)

**Tamanhos para App Store:**
- 1280x800 (mínimo)
- 1440x900 (recomendado)
- 2880x1800 (Retina)

## ✅ Fase 2: Funcionalidades Essenciais

### 3. Onboarding (Welcome Screen)
- [ ] Tela de boas-vindas
- [ ] Tutorial rápido (3-4 steps)
- [ ] Solicitar permissões (Accessibility)
- [ ] Configurar API key (ou oferecer trial sem chave)
- [ ] Mostrar atalho de teclado
- [ ] Opção "Don't show again"

### 4. Settings Melhoradas
- [ ] UI mais visual (ícones, cores)
- [ ] Seções bem organizadas
- [ ] Preview ao vivo
- [ ] Help tooltips
- [ ] Links úteis (suporte, site)

### 5. Versioning
- [ ] Version: 1.0.0 (Marketing Version)
- [ ] Build: 1 (CFBundleVersion)
- [ ] Atualizar Info.plist

## ✅ Fase 3: Monetização (IAP)

### 6. In-App Purchase Setup
- [ ] Criar produtos IAP no App Store Connect
- [ ] Implementar StoreKit 2
- [ ] Paywall screen (bonito e convincente)
- [ ] Restore purchases
- [ ] Subscription management
- [ ] Receipt validation

**Produtos sugeridos:**
- `com.quicktranslate.premium.monthly` - $4.99/mês
- `com.quicktranslate.premium.yearly` - $39.99/ano (33% desconto)
- `com.quicktranslate.lifetime` - $99.99 (pagamento único)

### 7. Trial & Limits
- [ ] 7 dias trial grátis
- [ ] Após trial: 10 traduções/dia (free tier)
- [ ] Premium: ilimitado
- [ ] Banner de upgrade
- [ ] Analytics de conversão

## ✅ Fase 4: Build & Archive

### 8. Configurar Signing
- [ ] Team selecionado
- [ ] Automatic signing ON
- [ ] Bundle ID único: `com.seuteam.quicktranslate`
- [ ] Certificates válidos
- [ ] Provisioning profiles

### 9. Preparar Info.plist
- [ ] CFBundleName
- [ ] CFBundleDisplayName
- [ ] CFBundleIdentifier
- [ ] CFBundleShortVersionString (1.0.0)
- [ ] CFBundleVersion (1)
- [ ] LSMinimumSystemVersion (13.0)
- [ ] NSAppleEventsUsageDescription
- [ ] Privacy descriptions

### 10. Archive & Upload
- [ ] Clean build folder
- [ ] Archive do projeto
- [ ] Validate app
- [ ] Upload to App Store Connect
- [ ] Esperar processamento

## ✅ Fase 5: App Store Connect

### 11. App Store Listing
- [ ] Nome do app (30 chars max)
- [ ] Subtitle (30 chars)
- [ ] Descrição (4000 chars)
- [ ] Keywords (100 chars)
- [ ] Promotional text (170 chars)
- [ ] Support URL
- [ ] Marketing URL (opcional)
- [ ] Privacy Policy URL

### 12. Metadata
- [ ] Categoria: Productivity
- [ ] Subcategoria: Utilities ou Languages
- [ ] Classificação etária: 4+
- [ ] Copyright
- [ ] Idiomas suportados

### 13. Pricing
- [ ] Preço base (Free com IAP)
- [ ] Disponibilidade (todos os países)
- [ ] Pre-orders (opcional)

### 14. Recursos e Permissões
- [ ] Permissões usadas (Accessibility)
- [ ] Usa API de terceiros (OpenAI)
- [ ] Coleta dados? (Não)
- [ ] Ads? (Não)

### 15. Review Information
- [ ] Contact info
- [ ] Notes para review
- [ ] Demo account (se necessário)
- [ ] Como testar IAP

## ✅ Fase 6: Submissão

### 16. Final Checks
- [ ] Testado em múltiplos Macs
- [ ] Todas as features funcionando
- [ ] Sem crashes
- [ ] IAP funcionando no Sandbox
- [ ] Screenshots bonitos
- [ ] Descrição atraente
- [ ] Video preview (opcional)

### 17. Submit for Review
- [ ] Clicar "Submit for Review"
- [ ] Esperar review (1-3 dias)
- [ ] Responder a qualquer questão
- [ ] Approved! 🎉

---

## 📝 Exemplo de Descrição para App Store

### Nome
**QuickTranslate AI**

### Subtitle
**Traduza instantaneamente com IA**

### Descrição
```
Traduza qualquer texto instantaneamente com o poder da IA! 

⚡ RÁPIDO E SIMPLES
Selecione qualquer texto, pressione ⌘⇧T, e veja a tradução aparecer. Sem copiar, colar ou trocar de janela.

🌍 20 IDIOMAS
Inglês, Português, Espanhol, Francês, Alemão, Italiano, Japonês, Chinês, Coreano, Árabe, Russo, Holandês, Sueco, Polonês, Turco, Hindi, Tailandês, Vietnamita, Indonésio, Hebraico.

✨ AÇÕES INTELIGENTES
• Traduzir - Tradução instantânea e precisa
• Melhorar - Torne seu texto mais claro
• Resumir - Resuma textos longos
• Simplificar - Linguagem mais simples
• Formalizar - Tom profissional
• Expandir - Adicione detalhes

📋 RECURSOS
• Atalho de teclado global (⌘⇧T)
• Substitua o texto original com um clique
• Histórico completo de traduções
• Funciona em qualquer app
• Menu bar sempre disponível
• Suporta textos longos

🚀 PRODUTIVIDADE
Perfeito para:
• Profissionais que trabalham com múltiplos idiomas
• Estudantes aprendendo idiomas
• Escritores e criadores de conteúdo
• Desenvolvedores lendo documentação
• Qualquer um que precisa traduzir rapidamente

💎 PREMIUM
• Traduções ilimitadas
• Todos os idiomas
• Todas as ações
• Histórico sem limites
• Suporte prioritário

Experimente grátis por 7 dias!

---

Requer: macOS 13.0 ou posterior
Usa: OpenAI GPT para traduções de alta qualidade
```

### Keywords
```
tradução,tradutor,translate,idiomas,línguas,AI,IA,GPT,productivity,produtividade,multilíngue,bilíngue
```

### Promotional Text
```
🎁 OFERTA DE LANÇAMENTO! 40% OFF no plano anual. Traduza qualquer coisa com IA. Experimente grátis por 7 dias!
```

---

## 🎯 Notas para Review

```
Olá equipe de review!

QuickTranslate AI é um app de tradução que usa OpenAI GPT.

COMO TESTAR:
1. Permita acesso de Acessibilidade quando solicitado
2. Pressione ⌘⇧T em qualquer lugar
3. O app captura texto selecionado e traduz

IAP:
• Sandbox account: [fornecer email de teste]
• O trial de 7 dias pode ser ativado
• Após trial, limite de 10 traduções/dia
• Premium: ilimitado

PERMISSÕES:
• Acessibilidade: Para capturar texto selecionado
• Internet: Para API OpenAI

O app não coleta dados pessoais.

Obrigado!
```

---

## ⏱️ Timeline Estimado

| Fase | Tempo | Total |
|------|-------|-------|
| Ícone | 2-4h | 4h |
| Onboarding | 4-6h | 10h |
| Settings UI | 2-3h | 13h |
| IAP Básico | 6-8h | 21h |
| Paywall | 3-4h | 25h |
| Screenshots | 1-2h | 27h |
| Build & Archive | 1h | 28h |
| App Store listing | 2h | 30h |

**Total: ~30 horas (4-5 dias de trabalho)**

---

## 💡 Dicas para Aprovação Rápida

1. **Descrição clara** do que o app faz
2. **Screenshots de qualidade** mostrando funcionalidades
3. **Demo account** para review (se necessário)
4. **Testar tudo** antes de submeter
5. **Responder rápido** a qualquer questão
6. **Política de privacidade** (mesmo se não coleta dados)
7. **Instruções claras** de como usar

## 🚨 Coisas que Podem Rejeitar

- ❌ Sem explicar uso de Accessibility
- ❌ Screenshots ruins/genéricas
- ❌ IAP não funcionando
- ❌ Crash durante review
- ❌ Descrição enganosa
- ❌ UI muito similar a outro app
- ❌ Sem privacidade policy (se coleta dados)

---

## 📞 Recursos Úteis

- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [Mac App Store Guidelines](https://developer.apple.com/macos/submit/)
- [StoreKit 2 Documentation](https://developer.apple.com/documentation/storekit)
- [App Store Connect Help](https://help.apple.com/app-store-connect/)

