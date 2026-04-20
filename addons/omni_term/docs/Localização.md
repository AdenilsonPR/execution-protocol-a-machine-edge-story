## 🌍 Localização (Tradução)

O OmniTerm utiliza o sistema de tradução nativo do Godot para garantir que o terminal possa ser adaptado para qualquer idioma.

### Chaves de Sistema (Internas do Plugin)
Estas mensagens são disparadas automaticamente pelo motor do OmniTerm e devem ser traduzidas no seu arquivo `.po`/CSV:

| Chave | Descrição | Localização |
| :--- | :--- | :--- |
| `CMD_ERR_NOT_FOUND` | Prefixo de erro para comandos inexistentes. | `CommandProcessor.gd` |

### Localização de Comandos Customizados
Ao criar novos comandos herdando de `CommandBase`, você deve usar chaves de tradução no campo `description`:

```gdscript
func _init():
    command_name = "hack"
    description = "CMD_HACK_DESC" # Esta chave deve estar no seu CSV
```

### Renderização de Output
Sempre que você usar `CommandOutput.create("texto")`, o terminal chamará `tr()` internamente. Isso permite que você envie chaves de tradução ou texto puro (caso a tradução não seja encontrada).

⬅️ Voltar para a [[Home]]
