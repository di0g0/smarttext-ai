# 🛒 Configuração de Produtos no App Store Connect

## 📋 Produtos a Criar

Você precisa criar **3 produtos** no App Store Connect com os IDs exatos:

### **1. Premium Mensal**
- **Product ID**: `com.quicktranslate.premium.monthly`
- **Type**: Auto-Renewable Subscription
- **Subscription Group**: `Premium`
- **Duration**: 1 Month
- **Price**: $4.99 USD

### **2. Premium Anual** ⭐ (Melhor Valor)
- **Product ID**: `com.quicktranslate.premium.yearly`
- **Type**: Auto-Renewable Subscription
- **Subscription Group**: `Premium`
- **Duration**: 1 Year
- **Price**: $39.99 USD (economiza 33%)

### **3. Premium Vitalício**
- **Product ID**: `com.quicktranslate.premium.lifetime`
- **Type**: Non-Consumable
- **Price**: $79.99 USD

---

## 🔧 Passo a Passo

### **Passo 1: Acessar App Store Connect**

1. Acesse: https://appstoreconnect.apple.com
2. Faça login com sua Apple ID de desenvolvedor
3. Clique em **"My Apps"**
4. Selecione seu app **QuickTranslate AI** (ou crie se ainda não existe)

---

### **Passo 2: Criar Subscription Group**

1. No menu lateral, clique em **"Subscriptions"**
2. Clique em **"+"** para criar um novo grupo
3. **Reference Name**: `Premium`
4. **App Name**: `QuickTranslate AI Premium`
5. Clique em **"Create"**

---

### **Passo 3: Criar Assinatura Mensal**

1. Dentro do grupo **Premium**, clique em **"+"**
2. **Product ID**: `com.quicktranslate.premium.monthly`
3. **Reference Name**: `Premium Monthly`
4. **Subscription Duration**: `1 Month`

#### **Pricing:**
- Clique em **"Add Pricing"**
- **Price**: `$4.99 USD`
- Selecione todos os territórios ou apenas os que deseja

#### **Localization (PT-BR):**
- **Subscription Display Name**: `Premium Mensal`
- **Description**: `Traduções ilimitadas, histórico completo e suporte prioritário. Renova automaticamente a cada mês.`

#### **Localization (EN):**
- **Subscription Display Name**: `Premium Monthly`
- **Description**: `Unlimited translations, full history and priority support. Renews automatically every month.`

#### **Review Information:**
- **Screenshot**: (Opcional) Screenshot do app mostrando features premium
- **Review Notes**: `Monthly subscription for unlimited access to all premium features.`

5. Clique em **"Save"**

---

### **Passo 4: Criar Assinatura Anual**

1. No grupo **Premium**, clique em **"+"** novamente
2. **Product ID**: `com.quicktranslate.premium.yearly`
3. **Reference Name**: `Premium Yearly`
4. **Subscription Duration**: `1 Year`

#### **Pricing:**
- **Price**: `$39.99 USD`
- Selecione territórios

#### **Localization (PT-BR):**
- **Subscription Display Name**: `Premium Anual`
- **Description**: `Traduções ilimitadas, histórico completo e suporte prioritário. Economize 33% com o plano anual!`

#### **Localization (EN):**
- **Subscription Display Name**: `Premium Yearly`
- **Description**: `Unlimited translations, full history and priority support. Save 33% with the yearly plan!`

5. Clique em **"Save"**

---

### **Passo 5: Criar Compra Vitalícia (Non-Consumable)**

1. No menu lateral, clique em **"In-App Purchases"**
2. Clique em **"+"** para criar novo
3. Selecione **"Non-Consumable"**
4. **Product ID**: `com.quicktranslate.premium.lifetime`
5. **Reference Name**: `Premium Lifetime`

#### **Pricing:**
- **Price**: `$79.99 USD`
- Selecione territórios

#### **Localization (PT-BR):**
- **Display Name**: `Premium Vitalício`
- **Description**: `Acesso vitalício a todas as features premium. Pagamento único, sem mensalidades!`

#### **Localization (EN):**
- **Display Name**: `Premium Lifetime`
- **Description**: `Lifetime access to all premium features. One-time payment, no subscriptions!`

#### **Review Information:**
- **Screenshot**: Screenshot do app
- **Review Notes**: `One-time purchase for lifetime premium access.`

6. Clique em **"Save"**

---

### **Passo 6: Configurar Subscription Group Settings**

1. Volte para **Subscriptions** > **Premium**
2. Clique em **"Subscription Group Settings"**

#### **Promotional Offers (Opcional):**
- Você pode criar ofertas promocionais (ex: 1 mês grátis)
- Recomendo adicionar depois do lançamento

#### **Subscription Status URL:**
- Se quiser receber notificações de mudanças de status
- Pode deixar em branco por enquanto

3. Clique em **"Save"**

---

### **Passo 7: Configurar App Information**

1. Vá em **"App Information"**
2. Em **"In-App Purchases"**, marque:
   - ✅ **"This app offers in-app purchases"**

---

### **Passo 8: Testar no Sandbox**

Antes de publicar, teste com usuários sandbox:

1. Vá em **"Users and Access"** > **"Sandbox Testers"**
2. Crie um usuário de teste:
   - **Email**: (crie um email de teste)
   - **Password**: (senha forte)
   - **Country/Region**: Brazil ou US
3. No seu Mac de teste:
   - Deslogue da App Store
   - Rode o app
   - Tente comprar
   - Quando pedir login, use o email sandbox
4. Teste todas as 3 opções de compra

---

## ✅ Checklist Final

Antes de submeter para review:

- [ ] 3 produtos criados com IDs corretos
- [ ] Pricing configurado ($4.99, $39.99, $79.99)
- [ ] Localizações em PT-BR e EN
- [ ] Screenshots adicionados
- [ ] Testado no Sandbox
- [ ] Subscription Group configurado
- [ ] App Information atualizado

---

## 🚨 Importante

### **IDs Devem Ser Exatos:**

```swift
// No código (StoreKitManager.swift):
case monthlySubscription = "com.quicktranslate.premium.monthly"
case yearlySubscription = "com.quicktranslate.premium.yearly"
case lifetime = "com.quicktranslate.premium.lifetime"
```

**Se os IDs não baterem exatamente, o StoreKit não vai encontrar os produtos!**

---

## 📝 Notas

### **Aprovação da Apple:**
- Assinaturas levam ~24-48h para serem aprovadas
- Você pode testar no Sandbox antes da aprovação
- Produtos precisam estar "Ready to Submit" antes de submeter o app

### **Pricing em Outros Países:**
- A Apple converte automaticamente para outras moedas
- Você pode ajustar preços específicos por país se quiser

### **Trial Grátis:**
- Se quiser adicionar 7 dias grátis:
  - Vá em cada assinatura
  - Em "Subscription Prices"
  - Adicione "Introductory Offer"
  - Selecione "Free Trial" - 7 days

---

## 🎯 Próximos Passos

Depois de configurar os produtos:

1. ✅ Compile o app
2. ✅ Teste no Sandbox
3. ✅ Crie screenshots
4. ✅ Submeta para review

---

## 💡 Dicas

- **Comece simples**: Não precisa de ofertas promocionais no início
- **Teste muito**: Use Sandbox para testar todos os fluxos
- **Monitore**: Depois do lançamento, veja no Analytics qual plano vende mais
- **Ajuste**: Você pode mudar preços depois (mas usuários ativos mantêm o preço antigo)

---

**Qualquer dúvida, consulte a documentação oficial:**
https://developer.apple.com/app-store-connect/

