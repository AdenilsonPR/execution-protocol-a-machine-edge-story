# Sistema de Salvamento e Persistência

O ecossistema Omni System possui pontes integradas para facilitar o salvamento do estado do jogo.

## OmniNarrative

Para salvar o estado da narrativa, armazene:
1. `script_path`: Caminho do JSON atual.
2. `current_node_id`: ID do nó onde o jogador parou.
3. `variables`: O dicionário completo de variáveis globais.

### Carregando
```gdscript
OmniNarrative.set_state(saved_path, saved_node_id, saved_vars)
```

## OmniChat

O histórico de mensagens e contatos desbloqueados pode ser persistido.

### Salvando
```gdscript
var chat_data = OmniChat.get_save_data()
```

### Carregando
```gdscript
OmniChat.set_save_data(chat_data)
```

## OmniTerm

O estado do terminal (histórico de comandos) geralmente não é salvo, mas o progresso (comandos aprendidos) deve ser gerenciado via `OmniNarrative.variables`.
