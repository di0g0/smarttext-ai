# 🔑 Como Configurar a API Key do OpenAI

## Passo a Passo

### 1. Obter sua API Key da OpenAI

1. Acesse: https://platform.openai.com/api-keys
2. Faça login (ou crie uma conta se necessário)
3. Clique em **"Create new secret key"**
4. Dê um nome (ex: "QuickTranslate Production")
5. **COPIE a chave** (começa com `sk-`)
   - ⚠️ **IMPORTANTE**: A chave só aparece UMA VEZ!

### 2. Adicionar a Chave no Código

1. Abra o arquivo: `QuickTranslateAI/Managers/APIKeyManager.swift`
2. Encontre a linha:
   ```swift
   private let obfuscatedKey = "YOUR_OPENAI_API_KEY_HERE"
   ```
3. Substitua `YOUR_OPENAI_API_KEY_HERE` pela sua chave real
4. Exemplo:
   ```swift
   private let obfuscatedKey = "sk-proj-abc123xyz..."
   ```

### 3. Compile e Teste

1. No Xcode, pressione `⌘ + B` para compilar
2. Rode o app (`⌘ + R`)
3. Selecione algum texto em qualquer app
4. Pressione `⌘⇧T`
5. Escolha uma ação (Traduzir, Melhorar, etc.)
6. ✅ Deve funcionar!

---

## 💰 Gerenciamento de Custos

### Rate Limiting Implementado

O app já tem **proteção de custos** implementada:

- ✅ **Limite: 50 requisições por dia** por instalação
- ✅ Contador reseta automaticamente à meia-noite
- ✅ Usuário vê quantas requisições restam nas Preferências
- ✅ Mensagem clara quando atingir o limite

### Monitoramento

Acompanhe seus gastos em:
- https://platform.openai.com/usage

Configure alertas de gasto:
- https://platform.openai.com/account/billing/limits

### Custos Estimados (gpt-4o-mini)

- **Input**: $0.150 por 1M tokens
- **Output**: $0.600 por 1M tokens
- **Média por tradução**: ~$0.001 (1 centavo de dólar)
- **50 traduções/dia**: ~$0.05/dia = **$1.50/mês por usuário**

---

## 🔒 Segurança

### ⚠️ IMPORTANTE - NÃO compartilhe o código com a chave!

Se for subir no GitHub:

1. **Opção A**: Use variáveis de ambiente (requer build script)
2. **Opção B**: Adicione o arquivo ao `.gitignore`:
   ```
   **/APIKeyManager.swift
   ```
3. **Opção C**: Use um arquivo de configuração separado (não versionado)

### Se a Chave Vazar

1. Vá imediatamente para https://platform.openai.com/api-keys
2. **Delete a chave comprometida**
3. Crie uma nova chave
4. Atualize o código
5. Configure limites de gastos na OpenAI

---

## 📊 Visualizando Uso

Os usuários podem ver o uso deles em:
- **Menu Bar** → QuickTranslate → **Preferências** → Aba **"Uso"**

Você pode monitorar logs no Console do Xcode:
```
📊 Rate Limit: 5/50 requisições hoje
```

---

## 🚀 Próximos Passos (Opcional)

Quando seu app crescer, considere:

1. **Backend próprio** (Node.js/Python/Firebase)
   - Mais seguro
   - Melhor controle de custos
   - Caching de traduções comuns
   
2. **Sistema de autenticação**
   - Planos Free vs Pro
   - Limites por usuário
   - Estatísticas agregadas

3. **Ofuscação avançada**
   - XOR encryption
   - String obfuscation
   - Code obfuscation

---

## 💡 Dicas

- Comece distribuindo para poucos usuários (beta)
- Monitore custos diariamente no início
- Ajuste o limite (50 req/dia) conforme necessário
- Considere reduzir para 20-30 se o custo ficar alto

---

**Boa sorte com o QuickTranslate! 🌍✨**

