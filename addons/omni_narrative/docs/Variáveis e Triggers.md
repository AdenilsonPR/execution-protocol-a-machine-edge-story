# Variáveis e Triggers 🛠️

O **OmniNarrative** permite que o mundo reaja às ações do jogador e vice-versa.

## Variáveis Dinâmicas
Você pode definir variáveis no código que serão substituídas automaticamente em qualquer texto de nó usando `{nome_da_variavel}`.

```gdscript
OmniNarrative.set_var("player_name", "Adenilson")
OmniNarrative.set_var("server_id", "OMEGA-7")
```

No JSON:
`"text": "Bem-vindo, {player_name}. Conectado ao servidor {server_id}."`

---

## Triggers (Gatilhos)

### Disparo Automático (Auto-Fire)
Diferente de outros sistemas, o OmniNarrative verifica os triggers de um nó em dois momentos:
1.  **Imediatamente ao entrar no nó**: Se a condição já for verdadeira, o salto ocorre instantaneamente.
2.  **Sempre que uma variável muda**: O sistema reavalia as condições do nó atual.

### Terminal Triggers
Mapeiam IDs de ações do terminal para saltos na narrativa.

```json
"triggers": {
    "crack_success": "victory_node",
    "access_denied": "alarm_node"
}
```

### Chat Triggers
Disparam um nó narrativo quando o jogador abre a conversa com um contato específico.

```json
"chat_triggers": {
    "Ghost": "ghost_intro_node"
}
```

### Condições em Triggers de Nó (Node Triggers)
Triggers de nó são disparadas quando uma variável satisfaz uma condição.

```json
"triggers": [
    { "condition": "var:readme_read == true", "next_node": "next_chapter" },
    { "condition": "var:score >= 100", "next_node": "boss_fight" },
    { "condition": "var:attempts != 0", "next_node": "retry_node" }
]
```

**Operadores suportados:**

| Operador | Significado | Exemplo |
| :--- | :--- | :--- |
| `==` | Igual | `var:active == true` |
| `!=` | Diferente | `var:lives != 0` |
| `>` | Maior que | `var:score > 500` |
| `<` | Menor que | `var:health < 20` |
| `>=` | Maior ou igual | `var:level >= 5` |
| `<=` | Menor ou igual | `var:time <= 60` |

---

## Sinal de Fim de História

O `NarrativeDirector` emite o sinal `story_finished` quando a narrativa chega a um ponto sem continuação.

```gdscript
OmniNarrative.story_finished.connect(_on_story_ended)

func _on_story_ended() -> void:
    get_tree().change_scene_to_file("res://scenes/credits.tscn")
```
