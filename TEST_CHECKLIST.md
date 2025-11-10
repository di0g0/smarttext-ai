# ✅ Checklist de Testes - QuickTranslate AI v1.0.0

## 🎯 Informações da Build

- **Versão:** 1.0.0
- **Build:** 1
- **Tamanho:** 1.4 MB
- **Data:** 08/11/2025
- **Localização:** `/Applications/QuickTranslateAI.app`

---

## 🧪 Testes de Primeira Execução

### Onboarding
- [ ] **Passo 1:** Bem-vindo - ícone 💬, título, descrição
- [ ] **Passo 2:** Atalho ⌘⇧T - ícone ⌨️
- [ ] **Passo 3:** Mais que Tradução - ícone ✨ (traduzir, melhorar, resumir...)
- [ ] **Passo 4:** 20 Idiomas - ícone 🌍
- [ ] **Passo 5:** Acessibilidade - ícone 🔓, botão "Abrir Configurações"
- [ ] **Passo 6:** Tudo Pronto! - ícone 💬 com A, texto com ícone inline

### Navegação
- [ ] 6 indicadores de página (●●●●●●) visíveis e FIXOS
- [ ] Botão "Voltar" aparece após passo 1
- [ ] Botão muda: "Continuar" → "Já Configurei" → "Começar a Usar!"
- [ ] Botão X no canto fecha onboarding
- [ ] Layout não "pula" entre telas

### Botão Acessibilidade
- [ ] Aparece APENAS no passo 5
- [ ] Abre Preferências do Sistema → Privacidade → Acessibilidade
- [ ] Não afeta layout (espaço reservado em outras telas)

---

## 🎨 Interface

### Barra de Menu
- [ ] Ícone 💬 com "A" aparece na barra de menu
- [ ] Menu contém:
  - [ ] "Abrir QuickTranslate" (⌘T)
  - [ ] "Preferências..." (⌘,)
  - [ ] "Histórico" (⌘H)
  - [ ] "Ver Tutorial de Novo"
  - [ ] "Sobre"
  - [ ] "Sair" (⌘Q)

### Janela Principal (Overlay)
- [ ] Aparece ao pressionar ⌘⇧T
- [ ] Posiciona-se **próxima ao cursor** (15px direita, 20px abaixo)
- [ ] Tamanho: 450x310px
- [ ] Draggável (pode mover a janela)
- [ ] Fecha ao clicar fora (hidesOnDeactivate)
- [ ] Fecha ao pressionar ESC

### Layout da Janela
- [ ] Header: "QuickTranslate AI" (título grande, peso bold)
- [ ] Dropdown de ações (Traduzir, Melhorar, Resumir, Simplificar, Formalizar)
- [ ] Picker de idioma (20 idiomas)
- [ ] Campo de entrada (60px altura, cresce dinamicamente)
- [ ] Campo de saída (60px altura)
- [ ] Activity indicator aparece DENTRO do campo de saída
- [ ] Botões no rodapé: "Copiar", "Substituir", "Fechar"

---

## ⚙️ Funcionalidades

### Captura de Texto
- [ ] Seleciona texto em qualquer app
- [ ] Pressiona ⌘⇧T
- [ ] Janela abre com texto pré-preenchido
- [ ] Auto-tradução inicia após 1.5s (se texto não vazio)

### Tradução
- [ ] Debounce de 1.5s funciona (não envia a cada tecla)
- [ ] Activity indicator aparece durante tradução
- [ ] Resultado aparece no campo de saída
- [ ] Tradução automática ao mudar idioma

### Ações
- [ ] **Traduzir:** Traduz para idioma selecionado
- [ ] **Melhorar:** Melhora o texto
- [ ] **Resumir:** Resume o texto
- [ ] **Simplificar:** Simplifica o texto
- [ ] **Formalizar:** Formaliza o texto

### Botões
- [ ] **Copiar:** Copia resultado para clipboard
- [ ] **Substituir:** 
  - [ ] Copia resultado para clipboard
  - [ ] Fecha janela
  - [ ] Retorna foco para app anterior
  - [ ] Simula Cmd+V (cola no lugar do texto selecionado)
- [ ] **Fechar:** Fecha janela (ou ESC)

---

## 💾 Persistência

### Settings
- [ ] Preferências → Idioma padrão (salva e carrega)
- [ ] Preferências → Copiar resultado automaticamente
- [ ] Preferências → Fechar após substituir texto
- [ ] Preferências → Mostrar ícone na barra de menu
- [ ] Preferências → Abrir ao iniciar o sistema (macOS 13+)

### Histórico
- [ ] Tradução salva no histórico
- [ ] Histórico → Lista de entradas
- [ ] Timestamp SEM segundos ("5 min atrás", "2 horas atrás")
- [ ] Botão de copiar rápido (ícone clipboard) → feedback visual
- [ ] Expandir/colapsar entradas
- [ ] Botões: "Copiar Original", "Copiar Resultado"
- [ ] Limpar histórico

### Onboarding
- [ ] "Ver Tutorial de Novo" no menu funciona
- [ ] Reseta flag `has_completed_onboarding`
- [ ] Abre onboarding novamente
- [ ] Funciona QUANTAS VEZES quiser (não trava após primeira vez)

---

## 🔐 Permissões

### Acessibilidade
- [ ] App verifica permissão (sem popup irritante)
- [ ] Logs no console: "✅ Accessibility: Granted" ou "❌ Not granted"
- [ ] Se não tem permissão: captura falha mas janela abre
- [ ] Usuário pode digitar manualmente se captura falhar

---

## 🚀 Performance

### Startup
- [ ] App inicia em < 2 segundos
- [ ] Ícone aparece na barra de menu rapidamente
- [ ] Onboarding (primeira vez) aparece em < 1 segundo

### Uso
- [ ] ⌘⇧T abre janela instantaneamente
- [ ] Tradução completa em < 3 segundos (depende da OpenAI)
- [ ] Sem travamentos
- [ ] Sem memory leaks
- [ ] CPU baixa quando idle

---

## 🐛 Casos de Erro

### API
- [ ] Sem API key: erro amigável
- [ ] Quota excedida: mensagem específica com link
- [ ] Timeout: mensagem de erro
- [ ] Resposta inválida: "Formato de resposta inválido"

### Captura
- [ ] Sem acessibilidade: janela abre vazia (pode digitar)
- [ ] Nenhum texto selecionado: janela abre vazia
- [ ] Texto muito longo: aceita e processa

---

## 📊 Métricas

### Tamanho
- [ ] App: ~1.4 MB (Release)
- [ ] Memória em uso: < 50 MB
- [ ] CPU idle: < 1%

### Compatibilidade
- [ ] macOS 13.0+ (Ventura, Sonoma, Sequoia)
- [ ] Apple Silicon (ARM64) ✅
- [ ] Intel (x86_64) ✅

---

## ✨ Extras

### Polimento
- [ ] Todos os ícones corretos (SF Symbols)
- [ ] Cores consistentes (accent color azul)
- [ ] Animações suaves (fade in/out, scale)
- [ ] Tipografia bonita (SF Pro)
- [ ] Sem elementos cortados ou sobrepostos

### UX
- [ ] Atalhos de teclado funcionam
- [ ] Tab order correto
- [ ] VoiceOver friendly (accessibility labels)
- [ ] Dark Mode funciona

---

## 🎯 Resultado Final

### ✅ Aprovado
- [ ] Todos os testes passaram
- [ ] Pronto para adicionar IAP
- [ ] Pronto para screenshots
- [ ] Pronto para App Store (após IAP)

### ❌ Issues Encontrados
(Liste aqui qualquer bug ou problema encontrado)

1. 
2. 
3. 

---

## 📝 Notas

(Adicione observações gerais sobre a build)

---

**Testador:** _______________________  
**Data:** ____/____/________  
**Aprovado?** ☐ Sim   ☐ Não (ver issues)

