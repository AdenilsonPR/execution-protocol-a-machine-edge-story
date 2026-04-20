# Sistema de Carregamento 📥

O carregamento restaura automaticamente o estado de todos os plugins integrados e notifica outros sistemas para recuperarem seus dados customizados.

## 🔄 Como Carregar

Para carregar um jogo salvo, utilize o método `load_game`:

```gdscript
# Carrega do slot padrão "auto"
OmniSave.load_game()

# Carrega de um slot específico
OmniSave.load_game("checkpoint_01")
```

---

## 🧩 Recuperando Dados Customizados

Quando um jogo é carregado, o sinal `after_load` é emitido contendo o dicionário de dados customizados que foram salvos anteriormente.

### Exemplo:
```gdscript
func _ready():
    OmniSave.after_load.connect(_on_after_load)

func _on_after_load(custom_data: Dictionary):
    if custom_data.has("player_hp"):
        hp = custom_data["player_hp"]
```

---

## 🚦 Ordem de Carregamento

O OmniSave segue uma ordem estrita para garantir que as referências existam:
1.  **Narrativa**: Restaura o arquivo JSON, o nó atual e todas as variáveis.
2.  **Chat**: Restaura o histórico de mensagens e estados de conversas.
3.  **Custom**: Emite o sinal `after_load` para os demais sistemas do jogo.

---

## ⚠️ Tratamento de Erros

O sistema emite o sinal `error_occurred` se algo falhar (arquivo inexistente, JSON corrompido, etc). É recomendável conectar este sinal à sua UI de Menu Principal:

```gdscript
OmniSave.error_occurred.connect(func(msg): print("Erro ao carregar: ", msg))
```