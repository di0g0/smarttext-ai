# 🔐 Solução para Problema de Acessibilidade

## Problema

O QuickTranslateAI precisa de permissões de **Acessibilidade** para:
- Capturar texto selecionado (Cmd+C automático)
- Simular comandos de teclado

Às vezes, o macOS "trava" essas permissões durante desenvolvimento.

---

## ✅ Solução Rápida (Script Automático)

No Terminal, dentro da pasta do projeto:

```bash
./reset_accessibility.sh
```

Depois rode o app novamente.

---

## 🔧 Solução Manual

### Opção 1: Remover e Adicionar Novamente

1. Vá em: **Configurações do Sistema** → **Privacidade e Segurança** → **Acessibilidade**
2. **Remova** QuickTranslateAI da lista (clique no `-`)
3. **Feche completamente** o app (`⌘ + Q`)
4. **Rode o app novamente** no Xcode
5. Quando pedir permissão, **aceite**

### Opção 2: Reset via Terminal

```bash
# Reset todas as permissões de Acessibilidade
tccutil reset Accessibility

# Depois rode o app novamente
```

### Opção 3: Verificar Manualmente

1. Vá em: **Configurações do Sistema** → **Privacidade e Segurança** → **Acessibilidade**
2. Procure por **QuickTranslateAI** na lista
3. Certifique-se que o **toggle está LIGADO** (azul)
4. Se não estiver na lista, **adicione manualmente**:
   - Clique no `+`
   - Navegue até o app compilado (geralmente em `~/Library/Developer/Xcode/DerivedData/...`)
   - Adicione

---

## 🎯 Como Confirmar que Está Funcionando

1. **Rode o app**
2. **Selecione texto** em qualquer lugar (Safari, Notes, etc.)
3. **Pressione** `⌘⇧T`
4. **Observe os logs** no Xcode Console:
   - `✅ Accessibility permissions granted` = Funcionando!
   - `⚠️ Accessibility NOT granted` = Problema ainda existe

5. **O texto selecionado deve aparecer** no campo da janela overlay
   - Se aparecer vazio = permissões ainda não concedidas
   - Se aparecer o texto = SUCESSO! 🎉

---

## 🔍 Debug Adicional

Se mesmo depois de todas as tentativas não funcionar:

### Verifique no Console do Xcode:

```
🔍 Starting text capture...
📋 Previous clipboard count: 123
📋 New clipboard count: 124  ← Deve MUDAR!
✂️ Captured text length: 15  ← Deve ter conteúdo
```

Se o `clipboard count` não mudar:
- ❌ Permissões não estão funcionando
- Tente reinstalar o app (limpe build: `⌘⇧K`)

---

## 💡 Dica para Desenvolvimento

Durante desenvolvimento, se as permissões continuam dando problema:

1. **Limpe o build**: `⌘⇧K` no Xcode
2. **Delete DerivedData**: 
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData/QuickTranslateAI-*
   ```
3. **Compile novamente**: `⌘ + B`
4. **Rode**: `⌘ + R`

---

## 🚀 Workaround Temporário

Se precisar testar SEM permissões de acessibilidade:

1. **Pressione** `⌘⇧T`
2. Janela abre vazia (sem texto capturado)
3. **Digite ou cole** o texto manualmente
4. App funciona normalmente!

---

## 📞 Ainda Não Funciona?

Se nada disso resolver, pode ser um problema do macOS. Tente:

1. **Reinicie o Mac** (às vezes resolve!)
2. **Atualize o macOS** para última versão
3. Verifique se outros apps também têm problema com Acessibilidade

---

**Última atualização**: 2025-11-08

