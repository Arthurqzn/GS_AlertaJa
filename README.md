# AlertaJá — Flutter 3.1.0

Aplicativo demonstrativo para registrar ocorrências urbanas. Tema escuro, painel, radar, insights, favoritos, filtros, edição de ocorrências, categorias e consulta meteorológica com localização do aparelho.

## Execução no Windows

1. Instale o Flutter SDK e o Android Studio (com Android SDK e emulador).
2. Extraia o ZIP, abra a pasta `AlertaJa_Flutter` e execute `INICIAR_WINDOWS.bat`.
3. O script gera a pasta `android/` no seu computador, caso ainda não exista, instala dependências, executa análise e testes e inicia o app.

Ou use os comandos manualmente:

```bash
flutter create --platforms=android --project-name alerta_ja .
flutter pub get
flutter analyze
flutter test
flutter run
```

**Importante:** a estrutura Android é gerada localmente pelo Flutter SDK para assegurar compatibilidade com a versão instalada. Este ZIP contém todo o código-fonte Flutter, testes e script de inicialização, mas **não** contém a pasta Android gerada nem um APK compilado. Não foi possível executar Flutter neste ambiente; os testes e a compilação devem ser verificados no seu computador.

## Funcionalidades

- Ocorrências locais com gravidades Baixa, Moderada e Alta, status Pendente, Validada e Rejeitada.
- Categorias: alagamento, enchente, bueiro, árvore, deslizamento, buraco, iluminação, descarte irregular e outro.
- Edição, exclusão, favoritos, detalhes, radar e insights.
- Consulta do clima por localização, mediante permissão, usando Open-Meteo.

## Limitações e privacidade

Dados armazenados somente no dispositivo, sem sincronização ou backup em nuvem. O radar apresenta os registros locais e não é um serviço oficial de emergência. A consulta meteorológica requer internet e localização.
