# 💰 Guia Completo - Configurar In-App Purchase

## 📋 **PASSO 1: Criar Produtos no App Store Connect**

### **1.1 Acesse App Store Connect:**
1. https://appstoreconnect.apple.com
2. **My Apps** → **SmartText AI**
3. **Features** → **In-App Purchases**

### **1.2 Criar Produto 1 - Premium Mensal:**

Clique **"+"** → **Auto-Renewable Subscription**

**Informações Básicas:**
- **Reference Name:** `Premium Monthly`
- **Product ID:** `com.quicktranslate.ai.premium.monthly`
- **Subscription Group:** Crie novo: `Premium Access`

**Subscription Duration:**
- **Duration:** `1 Month`

**Preço:**
- **Price:** `$4.99` (Tier 5)
- Selecione todos os países

**Localização - English (U.S.):**
- **Display Name:** `Premium Monthly`
- **Description:** `Unlimited translations, full history, and priority support. Billed monthly.`

**Localização - Portuguese (Brazil):**
- **Display Name:** `Premium Mensal`
- **Description:** `Traduções ilimitadas, histórico completo e suporte prioritário. Cobrado mensalmente.`

**Review Information:**
- **Screenshot:** (Opcional - pode pular por agora)

Clique **Save**

---

### **1.3 Criar Produto 2 - Premium Anual:**

Clique **"+"** → **Auto-Renewable Subscription**

**Informações Básicas:**
- **Reference Name:** `Premium Yearly`
- **Product ID:** `com.quicktranslate.ai.premium.yearly`
- **Subscription Group:** Selecione: `Premium Access` (mesmo grupo)

**Subscription Duration:**
- **Duration:** `1 Year`

**Preço:**
- **Price:** `$39.99` (Tier 40)
- Selecione todos os países

**Localização - English (U.S.):**
- **Display Name:** `Premium Yearly`
- **Description:** `Unlimited translations, full history, and priority support. Billed yearly. Save 33%!`

**Localização - Portuguese (Brazil):**
- **Display Name:** `Premium Anual`
- **Description:** `Traduções ilimitadas, histórico completo e suporte prioritário. Cobrado anualmente. Economize 33%!`

Clique **Save**

---

### **1.4 Criar Produto 3 - Premium Lifetime (Opcional):**

Clique **"+"** → **Non-Consumable**

**Informações Básicas:**
- **Reference Name:** `Premium Lifetime`
- **Product ID:** `com.quicktranslate.ai.premium.lifetime`

**Preço:**
- **Price:** `$99.99` (Tier 100)
- Selecione todos os países

**Localização - English (U.S.):**
- **Display Name:** `Premium Lifetime`
- **Description:** `One-time payment for lifetime access to all premium features. Best value!`

**Localização - Portuguese (Brazil):**
- **Display Name:** `Premium Vitalício`
- **Description:** `Pagamento único para acesso vitalício a todos os recursos premium. Melhor custo-benefício!`

Clique **Save**

---

## 📋 **PASSO 2: Configurar Subscription Group**

1. Vá em **Subscription Groups** → **Premium Access**
2. **Subscription Group Display Name:**
   - **English:** `Premium Access`
   - **Portuguese:** `Acesso Premium`

3. **App Name:**
   - Use: `SmartText AI`

4. **Promotional Image:** (Opcional - pode pular)

5. Clique **Save**

---

## 📋 **PASSO 3: Configurar Ofertas Introdutórias (Opcional)**

Para cada produto (Monthly/Yearly):

1. Clique no produto
2. **Subscription Prices** → **Add Introductory Offer**
3. **Offer Type:** `Free Trial`
4. **Duration:** `7 Days`
5. **Countries:** Todos
6. Clique **Save**

---

## 📋 **PASSO 4: Testar IAP no Sandbox**

### **4.1 Criar Sandbox Tester:**

1. **App Store Connect** → **Users and Access**
2. **Sandbox Testers** → **"+"**
3. Preencha:
   - **First Name:** Test
   - **Last Name:** User
   - **Email:** `test+smarttext@seudominio.com` (use um email válido que você controla)
   - **Password:** Crie uma senha
   - **Country:** Brazil ou United States
4. Clique **Invite**
5. **Confirme o email** (verifique a caixa de entrada)

### **4.2 Configurar Mac para Sandbox:**

1. **System Settings** → **Media & Purchases**
2. **Sign Out** da sua conta principal
3. **NÃO faça login ainda** - deixe deslogado

### **4.3 Testar no App:**

1. Abra o **SmartText AI** via TestFlight
2. Atinja o limite de 10 traduções
3. Clique em **"Upgrade to Premium"**
4. Escolha um plano
5. Clique **"Subscribe Now"**
6. Vai pedir login → **Use o Sandbox Tester** que você criou
7. Confirme a compra (é grátis no sandbox!)
8. Verifique se o app reconhece como Premium ✅

---

## 📋 **PASSO 5: Verificar Status no Código**

O código já está pronto! Veja como funciona:

### **StoreKitManager.swift:**
- Carrega produtos do App Store Connect
- Processa compras
- Valida transações
- Atualiza status de Premium

### **SubscriptionManager.swift:**
- Verifica se é Premium
- Conta uso diário (10 traduções/dia para free)
- Reseta contador à meia-noite
- Gerencia limite

### **PaywallView.swift:**
- Mostra planos disponíveis
- Botão de compra
- Restore purchases
- Loading states

### **OverlayView.swift:**
- Verifica `canUseTranslation()` antes de traduzir
- Mostra paywall se atingir limite
- Incrementa contador após tradução

---

## 📋 **PASSO 6: Submeter para Revisão**

### **6.1 Preencher App Review Information:**

1. **App Store Connect** → **SmartText AI** → **App Review Information**
2. **Contact Information:**
   - Nome, email, telefone

3. **Notes:**
```
Thank you for reviewing SmartText AI!

HOW TO TEST:
1. Grant Accessibility permission when prompted
2. Select any text in any app
3. Press ⌘⇧T to translate
4. Free users have 10 translations/day
5. Premium users have unlimited translations

IAP TESTING:
- Free tier: 10 translations/day limit
- After limit: Paywall appears
- Premium unlocks unlimited usage

SANDBOX TESTER:
Email: [seu sandbox tester email]
Password: [senha do sandbox tester]

The app requires Accessibility permission to capture selected text.
This is clearly explained in the onboarding flow.
```

### **6.2 Submit:**

1. Selecione a build mais recente
2. Preencha todos os campos obrigatórios
3. **Submit for Review**
4. Aguarde 1-3 dias

---

## ✅ **CHECKLIST FINAL:**

Antes de submeter, verifique:

- [ ] 3 produtos IAP criados e aprovados
- [ ] Subscription Group configurado
- [ ] Free trial configurado (7 dias)
- [ ] Sandbox tester criado e confirmado
- [ ] Testado compra no sandbox
- [ ] App reconhece status Premium
- [ ] Limite de 10/dia funciona para free
- [ ] Paywall aparece ao atingir limite
- [ ] Restore purchases funciona
- [ ] Screenshots atualizados
- [ ] Descrição menciona Premium
- [ ] Privacy Policy atualizada
- [ ] Support URL funcionando

---

## 🎯 **RESUMO - O QUE FAZER AMANHÃ:**

1. ✅ **10 min:** Criar 3 produtos IAP no App Store Connect
2. ✅ **5 min:** Configurar Subscription Group
3. ✅ **5 min:** Adicionar Free Trial (7 dias)
4. ✅ **5 min:** Criar Sandbox Tester
5. ✅ **10 min:** Testar compra no sandbox
6. ✅ **5 min:** Verificar que tudo funciona
7. ✅ **10 min:** Preencher App Review Information
8. ✅ **1 min:** Submit for Review! 🚀

**Total:** ~50 minutos

---

## 🆘 **TROUBLESHOOTING:**

### **"Products not found":**
- Aguarde 2-4 horas após criar produtos
- Verifique Bundle ID está correto
- Confirme que produtos estão "Ready to Submit"

### **"Cannot connect to iTunes Store":**
- Faça logout da conta principal
- Use apenas Sandbox Tester
- Reinicie o Mac se necessário

### **"Purchase failed":**
- Verifique se Sandbox Tester está confirmado
- Tente outro Sandbox Tester
- Verifique conexão com internet

---

## 📞 **SUPORTE:**

Se tiver qualquer dúvida amanhã, me chame! Vou estar aqui para ajudar. 🚀

**Boa sorte com o lançamento!** 🎉

