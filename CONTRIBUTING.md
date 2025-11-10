# Contribuindo para QuickTranslate AI 🚀

Obrigado por considerar contribuir! Este documento fornece diretrizes para contribuir com o projeto.

## 📋 Índice
- [Como Contribuir](#como-contribuir)
- [Reportando Bugs](#reportando-bugs)
- [Sugerindo Funcionalidades](#sugerindo-funcionalidades)
- [Desenvolvendo](#desenvolvendo)
- [Pull Requests](#pull-requests)
- [Estilo de Código](#estilo-de-código)

## 🤝 Como Contribuir

Existem várias formas de contribuir:

1. **Reportar bugs** - Encontrou um problema? Nos avise!
2. **Sugerir funcionalidades** - Tem uma ideia legal? Compartilhe!
3. **Melhorar documentação** - Documentação clara é essencial
4. **Escrever código** - Implemente novas funcionalidades ou corrija bugs
5. **Testar** - Use o app e nos dê feedback

## 🐛 Reportando Bugs

Antes de reportar um bug, verifique se ele já não foi reportado nas [Issues](https://github.com/seu-usuario/QuickTranslateAI/issues).

### Como Reportar

Crie uma nova issue incluindo:

- **Título claro e descritivo**
- **Descrição detalhada** do problema
- **Passos para reproduzir**:
  1. Passo 1
  2. Passo 2
  3. ...
- **Comportamento esperado** vs **Comportamento atual**
- **Screenshots** (se aplicável)
- **Informações do sistema**:
  - Versão do macOS
  - Versão do QuickTranslate AI
  - Versão do Xcode (se compilou localmente)

### Exemplo

```markdown
**Descrição**: O app trava ao traduzir textos muito longos

**Passos para reproduzir**:
1. Selecione um texto com mais de 5000 caracteres
2. Pressione Cmd+Shift+T
3. Clique em "Traduzir"

**Esperado**: Tradução ser processada
**Atual**: App trava e precisa ser reiniciado

**Sistema**: macOS 14.0, QuickTranslate AI 1.0.0
```

## 💡 Sugerindo Funcionalidades

Adoramos novas ideias! Para sugerir uma funcionalidade:

1. Verifique se já não foi sugerida
2. Crie uma issue com a tag `enhancement`
3. Descreva:
   - **O problema** que a funcionalidade resolve
   - **Como** você imagina a solução
   - **Casos de uso** específicos
   - **Alternativas** que considerou

## 🛠 Desenvolvendo

### Setup do Ambiente

1. **Fork o repositório**
2. **Clone seu fork**:
```bash
git clone https://github.com/seu-usuario/QuickTranslateAI.git
cd QuickTranslateAI
```

3. **Crie uma branch**:
```bash
git checkout -b feature/minha-funcionalidade
# ou
git checkout -b fix/meu-bug
```

4. **Abra no Xcode**:
```bash
open QuickTranslateAI.xcodeproj
```

### Estrutura do Projeto

```
QuickTranslateAI/
├── QuickTranslateAI/
│   ├── QuickTranslateAIApp.swift  # Entry point
│   ├── Managers/
│   │   ├── HotKeyManager.swift    # Gerencia atalhos
│   │   ├── ClipboardManager.swift # Captura texto
│   │   ├── OpenAIManager.swift    # API OpenAI
│   │   └── HistoryManager.swift   # Histórico
│   └── Views/
│       ├── OverlayView.swift      # Interface principal
│       ├── SettingsView.swift     # Preferências
│       └── HistoryView.swift      # Histórico
├── README.md
├── USAGE_GUIDE.md
└── CONTRIBUTING.md
```

### Trabalhando no Código

1. **Implemente suas mudanças**
2. **Teste localmente** (Cmd+R)
3. **Verifique erros de lint**
4. **Commit suas mudanças**:
```bash
git add .
git commit -m "feat: adiciona suporte para novo idioma"
```

## 📤 Pull Requests

### Antes de Submeter

- ✅ Código compila sem erros
- ✅ Testado no macOS 13.0+
- ✅ Documentação atualizada (se necessário)
- ✅ Commits seguem convenção (veja abaixo)

### Criando o PR

1. **Push para seu fork**:
```bash
git push origin feature/minha-funcionalidade
```

2. **Abra um Pull Request** no GitHub

3. **Preencha o template**:
   - Descrição das mudanças
   - Issue relacionada (se houver)
   - Checklist de verificação
   - Screenshots (se UI)

### Processo de Review

1. Mantenedores irão revisar
2. Podem pedir mudanças
3. Faça as alterações solicitadas
4. Após aprovação, será merged!

## 📝 Estilo de Código

### Swift

- Use **4 espaços** para indentação
- Siga [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use comentários para código complexo
- Prefira nomes descritivos

### Exemplo

```swift
// ✅ Bom
func processSelectedText(with action: AIAction, targetLanguage: String) {
    guard !text.isEmpty else { return }
    // Implementação...
}

// ❌ Ruim
func pst(a: AIAction, l: String) {
    // Implementação...
}
```

### Commits

Use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Nova funcionalidade
- `fix:` Correção de bug
- `docs:` Mudanças na documentação
- `style:` Formatação, ponto e vírgula, etc
- `refactor:` Refatoração de código
- `test:` Adiciona testes
- `chore:` Tarefas de manutenção

**Exemplos**:
```
feat: adiciona suporte para italiano
fix: corrige crash ao traduzir textos longos
docs: atualiza guia de instalação
```

## 🎨 UI/UX

Se estiver trabalhando na interface:

- Mantenha consistência visual
- Use componentes nativos do SwiftUI quando possível
- Teste em temas claro e escuro
- Considere acessibilidade

## 🧪 Testes

(Por enquanto testes manuais, mas em breve teremos testes automatizados)

Ao adicionar funcionalidade, teste:

- ✅ Caso normal de uso
- ✅ Casos extremos (texto vazio, muito longo, etc)
- ✅ Erros (sem internet, API key inválida, etc)

## 📜 Licença

Ao contribuir, você concorda que suas contribuições serão licenciadas sob a mesma licença do projeto (MIT).

## 💬 Comunidade

- **GitHub Discussions**: Para perguntas e discussões gerais
- **Issues**: Para bugs e funcionalidades
- **Discord**: [Link] (se houver)

## 🙏 Agradecimentos

Obrigado por contribuir! Cada contribuição, grande ou pequena, faz diferença.

### Contributors

- [Lista de contribuidores](https://github.com/seu-usuario/QuickTranslateAI/graphs/contributors)

---

**Dúvidas?** Abra uma issue ou entre em contato!

