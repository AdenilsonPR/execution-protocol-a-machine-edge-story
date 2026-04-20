# Sistema de Salvamento 💾

O **OmniSave** é um sistema centralizado que gerencia o estado da narrativa, do chat e de qualquer outro sistema customizado do seu jogo.

## 🚀 Como Salvar

Para salvar o estado atual, utilize o método `save_game`:

```gdscript
# Salva no slot padrão "auto"
OmniSave.save_game()

# Salva em um slot específico
OmniSave.save_game("checkpoint_01")
```

---

## 🧩 Salvando Dados Customizados (Extensibilidade)

O OmniSave é modular. Você pode salvar dados de qualquer objeto (como HP do jogador ou Inventário) usando o sinal `before_save`.

### Exemplo:
```gdscript
func _ready():
    OmniSave.before_save.connect(_on_before_save)

func _on_before_save(custom_data: Dictionary):
    custom_data["player_hp"] = 100
    custom_data["inventory"] = ["chave_mestra", "cartao_acesso"]
```

Os dados injetados via sinal serão armazenados automaticamente dentro da chave `custom` no arquivo JSON.

---

## 🛡️ Segurança e Backups

O sistema implementa uma camada de segurança simples contra corrupção de arquivos:
- **Backup Automático**: Antes de sobrescrever um save, o sistema cria uma cópia `.bak` do arquivo original.
- **Formato Humano**: Os arquivos são salvos em `.json` formatado, facilitando o debug durante o desenvolvimento.

---

## 📂 Localização dos Arquivos

Os arquivos são salvos na pasta de usuário do Godot:
`user://saves/`

Você pode verificar os slots disponíveis usando:
```gdscript
var slots: Array[String] = OmniSave.get_available_slots()
```