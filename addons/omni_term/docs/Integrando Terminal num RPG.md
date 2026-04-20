## ⚔️ Arquitetura para um Terminal Modding (RPG/Hacking)

O OmniTerm é a camada de **interface e interação**. Para construir um RPG completo (batalhas, inventário, status, saves) rodando dentro de um terminal CUI, você precisa de uma camada de **lógica de jogo** separada (um Autoload de GameManager).

```
┌─────────────────────────────────────────┐
│          LÓGICA DO JOGO                 │
│  GameState · BattleManager · SaveSystem │
│           (Autoloads/Singletons)        │
└──────────────┬──────────────────────────┘
			   │  Comandos  (a ponte)
┌──────────────▼──────────────────────────┐
│              OMNITERM                   │
│  Exibe texto · Captura input            │
└─────────────────────────────────────────┘
```

Mantenha o OmniTerm **sempre ignorante** da lógica do jogo. Ele só exibe BBCode formatado textual e captura arrays de input. Toda decisão sobre HP, senhas seguras e arquivos locais invadidos deve ser mantida longe dos Commands e repassadas por métodos isolados nos seus Managers para que você mantenha seu jogo desacoplado do Terminal!

⬅️ Voltar para a [[Home]]
