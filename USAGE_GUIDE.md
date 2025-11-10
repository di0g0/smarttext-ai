# QuickTranslate AI - Guia de Uso 🚀

## 📋 Índice
- [Instalação](#instalação)
- [Configuração Inicial](#configuração-inicial)
- [Como Usar](#como-usar)
- [Funcionalidades](#funcionalidades)
- [Perguntas Frequentes](#perguntas-frequentes)

## 🛠 Instalação

### Requisitos
- macOS 13.0 (Ventura) ou superior
- Xcode 15.0+ (para compilar)
- Conta OpenAI com créditos disponíveis

### Passo a Passo

1. **Clone o repositório:**
```bash
git clone https://github.com/seu-usuario/QuickTranslateAI.git
cd QuickTranslateAI
```

2. **Abra o projeto no Xcode:**
```bash
open QuickTranslateAI.xcodeproj
```

3. **Configure o Bundle Identifier:**
   - No Xcode, selecione o projeto
   - Em "Signing & Capabilities"
   - Altere o Bundle Identifier para algo único (ex: `com.seunome.QuickTranslateAI`)
   - Selecione sua equipe de desenvolvimento

4. **Build e Execute:**
   - Pressione `Cmd + R` ou clique em "Play"
   - O app irá compilar e iniciar

5. **Permissões Necessárias:**
   - Quando solicitado, autorize as permissões de Acessibilidade
   - Vá em: Sistema → Privacidade e Segurança → Acessibilidade
   - Habilite "QuickTranslateAI"

## ⚙️ Configuração Inicial

### 1. Obter API Key da OpenAI

1. Acesse [platform.openai.com](https://platform.openai.com)
2. Faça login ou crie uma conta
3. Vá para "API Keys"
4. Clique em "Create new secret key"
5. Copie a chave (ela só aparece uma vez!)

### 2. Configurar no App

1. Clique no ícone do QuickTranslate na barra de menus
2. Selecione "Preferências..."
3. Vá para a aba "API"
4. Cole sua chave no campo "OpenAI API Key"
5. Clique em "Testar Conexão" para verificar

### 3. Ajustar Preferências

Na aba "Geral" das Preferências:
- **Idioma Padrão**: Escolha para qual idioma traduzir por padrão
- **Tom Preferido**: Selecione o tom dos textos (neutral, formal, casual)
- **Copiar automaticamente**: Se ativado, copia o resultado automaticamente

## 🎯 Como Usar

### Método 1: Atalho de Teclado (Recomendado)

1. **Selecione qualquer texto** em qualquer aplicativo:
   - Notas
   - Google Docs
   - WhatsApp Web
   - Slack
   - E-mail
   - Etc.

2. **Pressione `Cmd + Shift + T`**

3. **A janela do QuickTranslate aparece** com seu texto já carregado!

4. **Escolha uma ação:**
   - 🌍 **Traduzir**: Traduz para o idioma selecionado
   - ✨ **Melhorar Texto**: Melhora clareza e fluência
   - 🎩 **Tornar Formal**: Tom profissional
   - 😊 **Tornar Casual**: Tom informal e amigável
   - ✓ **Corrigir Gramática**: Corrige erros
   - 📝 **Simplificar**: Torna mais simples
   - 📚 **Expandir**: Adiciona mais detalhes

5. **Aguarde o resultado** (geralmente 2-5 segundos)

6. **Use o resultado:**
   - **Copiar**: Copia para usar em outro lugar
   - **Substituir**: Substitui o texto original
   - **Fechar**: Fecha a janela

### Método 2: Menu Bar

1. Clique no ícone do QuickTranslate na barra de menus
2. Selecione "Abrir QuickTranslate"
3. Cole ou digite seu texto manualmente

## ✨ Funcionalidades

### 🌍 Tradução Inteligente
- Suporta 9 idiomas principais
- Mantém contexto e nuances
- Detecta automaticamente o idioma de origem

### ✍️ Melhoria de Texto
- Corrige gramática e ortografia
- Melhora clareza e fluência
- Ajusta tom (formal/casual)
- Simplifica ou expande conforme necessário

### 📊 Histórico Inteligente
- Salva automaticamente todas as traduções
- Busca rápida no histórico
- Aprende suas preferências
- Acesso rápido via menu "Histórico"

### ⚡ Produtividade
- Interface rápida tipo Spotlight
- Não interrompe seu fluxo de trabalho
- Atalhos de teclado customizáveis
- Funciona em qualquer aplicativo

## 🔧 Atalhos de Teclado

| Atalho | Ação |
|--------|------|
| `Cmd + Shift + T` | Abrir QuickTranslate |
| `ESC` | Fechar janela |
| `Cmd + C` | Copiar resultado |
| `Cmd + ,` | Abrir preferências |

## 💡 Dicas de Uso

### 1. Escrevendo em Idioma Não-Nativo
- Escreva primeiro em português
- Use "Traduzir" para inglês
- Depois use "Melhorar Texto" para refinar

### 2. E-mails Profissionais
- Escreva naturalmente
- Use "Tornar Formal"
- Ajuste se necessário com "Melhorar Texto"

### 3. Textos Acadêmicos
- Use "Expandir" para adicionar detalhes
- Use "Tornar Formal" para tom acadêmico
- Use "Corrigir Gramática" antes de enviar

### 4. Mensagens Casuais
- Use "Simplificar" para ser mais direto
- Use "Tornar Casual" para tom amigável

## ❓ Perguntas Frequentes

### O app funciona offline?
Não, o QuickTranslate requer conexão com internet para usar a API da OpenAI.

### Quanto custa usar?
O app é gratuito, mas você precisa de uma conta OpenAI com créditos. A OpenAI cobra por uso (geralmente centavos por tradução).

### Meus dados são privados?
Sim! O texto é processado pela OpenAI seguindo as políticas de privacidade deles. Seu histórico fica armazenado localmente no seu Mac.

### Posso usar outros modelos de IA?
Atualmente suporta apenas OpenAI GPT-4. Suporte para modelos locais está no roadmap!

### O app não está capturando meu texto selecionado
Certifique-se de que:
1. Concedeu permissões de Acessibilidade
2. O texto está realmente selecionado (destacado)
3. Aguarde 1 segundo após selecionar antes de pressionar o atalho

### Como atualizar o app?
```bash
cd QuickTranslateAI
git pull origin main
# Reabra no Xcode e compile novamente
```

### Posso contribuir?
Sim! O projeto é open source. Veja CONTRIBUTING.md para mais detalhes.

## 🐛 Problemas Conhecidos

- Em alguns apps (como Terminal), a captura automática pode não funcionar
  - **Solução**: Use o menu bar para abrir e cole manualmente
  
- Primeira execução pode ser lenta
  - **Solução**: Normal, o sistema está carregando os recursos

## 📞 Suporte

- 🐛 **Bugs**: Abra uma issue no GitHub
- 💡 **Sugestões**: Discussões no GitHub
- 📧 **Contato**: seu-email@exemplo.com

## 📈 Roadmap

- [ ] Suporte para modelos locais (Llama, etc.)
- [ ] Mais idiomas e dialetos
- [ ] Sincronização via iCloud
- [ ] Extensões para browsers
- [ ] App para iOS/iPadOS
- [ ] Comandos de voz

## 🎉 Aproveite!

O QuickTranslate AI foi criado para aumentar sua produtividade. Use-o diariamente e veja a diferença!

Se gostou, considere:
- ⭐ Dar uma estrela no GitHub
- 📢 Compartilhar com amigos
- 💝 Contribuir com o projeto

---

**Desenvolvido com ❤️ para a comunidade**

