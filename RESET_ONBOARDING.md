# 🔄 Como Ver o Onboarding de Novo

## Método 1: Pelo Menu do App (Mais Fácil)

1. Clique no ícone do app na barra de menu
2. Clique em **"Ver Tutorial de Novo"**
3. Pronto! O onboarding vai abrir

## Método 2: Terminal (Resetar manualmente)

```bash
# Deleta a flag de onboarding completo
defaults delete com.quicktranslate.ai has_completed_onboarding

# Ou, se o Bundle ID for diferente:
defaults delete $(defaults read com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers | grep -A 1 QuickTranslateAI | grep LSHandlerRoleAll | awk -F'"' '{print $2}') has_completed_onboarding

# Ou resetar TODOS os defaults do app:
defaults delete com.quicktranslate.ai
```

Depois, basta abrir o app de novo e o onboarding vai aparecer!

## Método 3: Excluir Preferences (Reset total)

```bash
rm ~/Library/Preferences/com.quicktranslate.ai.plist
```

⚠️ **Atenção**: Isso vai resetar TODAS as configurações do app!

---

## 🐛 Durante Desenvolvimento

Se estiver testando constantemente, você pode:

1. **No código**, comentar a verificação:
```swift
// Em QuickTranslateAIApp.swift
func showOnboardingIfNeeded() {
    // Sempre mostra (para teste)
    showOnboarding()
    
    // Versão original (comentada):
    // let hasCompleted = UserDefaults.standard.bool(forKey: "has_completed_onboarding")
    // if !hasCompleted {
    //     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
    //         self?.showOnboarding()
    //     }
    // }
}
```

2. **Ou** adicionar um atalho de teclado temporário para abrir

---

## ✅ Agora Implementado!

O menu do app agora tem a opção **"Ver Tutorial de Novo"** que:
- Reseta a flag de onboarding
- Mostra o tutorial imediatamente
- Perfeito para testar!

