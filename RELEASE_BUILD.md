# 🚀 Como Gerar Build Release

## 📦 Build para Desenvolvimento (Debug)

1. Abra o projeto no Xcode
2. Selecione **Product > Build** (⌘B)
3. O app será compilado em modo Debug

## 🎯 Build para Distribuição (Release)

### Opção 1: Archive no Xcode (Recomendado)

1. **Selecione o scheme** "QuickTranslateAI" no topo do Xcode
2. **Selecione "Any Mac"** como destino (não seu Mac específico)
3. **Product > Archive** (ou ⌘⇧B)
4. Aguarde o build completar
5. A janela do **Organizer** abrirá automaticamente
6. Selecione o archive mais recente
7. Clique em **"Distribute App"**
8. Escolha uma opção:
   - **"Copy App"** - Para distribuir manualmente (melhor para testes)
   - **"Developer ID"** - Para distribuir fora da App Store (precisa conta Developer)
   - **"App Store Connect"** - Para enviar à App Store

### Opção 2: Build Release Manual

```bash
cd /Users/diogo.costa/Dev/QuickTranslateAI

# Build em modo Release
xcodebuild -project QuickTranslateAI.xcodeproj \
           -scheme QuickTranslateAI \
           -configuration Release \
           -derivedDataPath ./build \
           clean build

# O app estará em:
# ./build/Build/Products/Release/QuickTranslateAI.app
```

### Opção 3: Export do Xcode (Mais Simples)

1. **Product > Scheme > Edit Scheme...**
2. Selecione **"Run"** no lado esquerdo
3. Mude **"Build Configuration"** de **Debug** para **Release**
4. Clique **"Close"**
5. **Product > Build** (⌘B)
6. **Product > Show Build Folder in Finder**
7. Navegue até `Products/Release/`
8. O arquivo `QuickTranslateAI.app` estará lá

## 📍 Encontrar o App Compilado

### No Xcode:

1. **Product > Show Build Folder in Finder**
2. Navegue até:
   - **Debug**: `Products/Debug/QuickTranslateAI.app`
   - **Release**: `Products/Release/QuickTranslateAI.app`

### Copiar para Applications:

```bash
# Copia o app para a pasta de Aplicativos
cp -r ./build/Build/Products/Release/QuickTranslateAI.app /Applications/
```

## 🔍 Testar o App Release

1. Localize `QuickTranslateAI.app` no Finder
2. **Arraste para /Applications** ou **clique duplo** para abrir
3. Se aparecer "não pode ser aberto porque é de um desenvolvedor não identificado":
   - Abra **Preferências do Sistema > Privacidade e Segurança**
   - Clique em **"Abrir Assim Mesmo"**
   - Ou: `xattr -cr /Applications/QuickTranslateAI.app` no Terminal

## 🛠️ Assinatura de Código (Code Signing)

Para distribuir fora do seu Mac, você precisa:

### 1. Conta Apple Developer ($99/ano)

- [https://developer.apple.com/programs/](https://developer.apple.com/programs/)

### 2. Certificado de Desenvolvedor

1. Abra **Xcode > Settings > Accounts**
2. Adicione sua Apple ID
3. Clique em **"Manage Certificates..."**
4. Clique no **"+"** e selecione **"Apple Development"** e **"Developer ID Application"**

### 3. Configurar no Projeto

1. Selecione o projeto no navegador
2. Selecione o target **"QuickTranslateAI"**
3. Aba **"Signing & Capabilities"**
4. Marque **"Automatically manage signing"**
5. Selecione seu **Team**

### 4. Notarização (Opcional, mas recomendado)

Para evitar o aviso de "desenvolvedor não identificado":

```bash
# Exporta o app
xcodebuild -exportArchive \
           -archivePath ./QuickTranslateAI.xcarchive \
           -exportPath ./Export \
           -exportOptionsPlist ExportOptions.plist

# Notariza (substitua com suas credenciais)
xcrun notarytool submit QuickTranslateAI.app.zip \
                        --apple-id "seu@email.com" \
                        --team-id "TEAM_ID" \
                        --password "app-specific-password"
```

## 📱 Distribuição

### Para Você Mesmo (Testes):
- Apenas copie o `.app` para `/Applications`

### Para Outros Usuários:
- **ZIP**: Comprima o `.app` e distribua
- **DMG**: Crie uma imagem de disco (mais profissional)
- **App Store**: Processo completo de submissão

## 🎁 Criar DMG (Instalador Bonito)

```bash
# Cria um DMG para distribuição
hdiutil create -volname "QuickTranslate AI" \
               -srcfolder ./QuickTranslateAI.app \
               -ov -format UDZO \
               QuickTranslateAI-v1.0.dmg
```

## ✅ Checklist de Release

- [ ] Testado em modo Release
- [ ] Versão atualizada em `Info.plist` (`CFBundleShortVersionString`)
- [ ] Todos os recursos funcionando
- [ ] Assinado com certificado de desenvolvedor
- [ ] Ícone do app configurado
- [ ] Notarizado (se distribuir para outros)
- [ ] README e documentação atualizados
- [ ] Tag de versão no Git (`git tag v1.0.0`)

## 🐛 Problemas Comuns

### "App pode ter sido danificado"
```bash
xattr -cr /Applications/QuickTranslateAI.app
```

### "Precisa de permissões de acessibilidade"
- Normal! O app pede isso na primeira execução

### "Não aparece no sistema"
- Verifique se `LSUIElement` está em `true` no `Info.plist`
- O app roda apenas na barra de menu (menu bar app)
- Procure o ícone 🌍 ou "character.bubble" na barra de menu

## 📚 Recursos

- [Xcode Documentation](https://developer.apple.com/documentation/xcode)
- [Distributing Your App](https://developer.apple.com/documentation/xcode/distributing-your-app-for-beta-testing-and-releases)
- [Notarizing macOS Software](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)

