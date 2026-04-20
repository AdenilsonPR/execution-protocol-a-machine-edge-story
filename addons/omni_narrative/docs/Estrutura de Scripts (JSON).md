# Estrutura de Scripts (JSON) 📄

A narrativa é definida em arquivos JSON compostos por um dicionário de `nodes`. Cada nó possui um `type` que define seu comportamento.

## 🌍 Localização e Tradução

Todos os campos de texto podem ser uma `String` simples ou um `Dictionary` para suportar chaves de tradução. O sistema prioriza o campo `id`.

**Formato Recomendado:**
```json
"text": {
    "id": "KEY_NAME",
    "text": "Texto original em Português"
}
```

---

## Tipos de Nós

### 💬 Chat Node (`"type": "chat"`)
Exibe diálogos no sistema OmniChat.

```json
"node_id": {
    "type": "chat",
    "contact": { "id": "MASTER_NAME", "text": "Mestre" },
    "messages": [
        { "id": "MSG_1", "text": "Finalmente voce conseguiu..." },
        { "id": "MSG_2", "text": "Eu sou o Mestre." }
    ],
    "choices": {
        "ok": {
            "id": "CHOICE_OK",
            "text": "Entendido.",
            "next": "next_node"
        }
    }
}
```

### 💻 Terminal Node (`"type": "terminal"`)
Envia texto para o terminal OmniTerm. Suporta uma linha simples ou múltiplas linhas.

```json
"terminal_log": {
    "type": "terminal",
    "id": "TERM_INIT",
    "text": "[omni_color=BLUE]Iniciando sistema...[/omni_color]",
    "next": "next_node",
    "delay": 1.0
}
```

**Múltiplas linhas:**
```json
"multi_line_intro": {
    "type": "terminal",
    "lines": [
        { "id": "L1", "text": "Conectando...", "delay": 0.8 },
        { "id": "L2", "text": "Autenticando...", "delay": 1.2 }
    ],
    "next": "next_node"
}
```

### ⌨️ Terminal Input (`"type": "terminal_input"`)
Prepara o terminal para receber um comando do jogador.

```json
"wait_cmd": {
    "type": "terminal_input",
    "id": "TERM_WAIT",
    "text": "Aguardando comando..."
}
```

### ⚡ Event Node (`"type": "event"`)
Nó lógico para transições puras ou troca de arquivos.

```json
"go_to_act2": {
    "type": "event",
    "next_file": "res://narrative/act2.json",
    "next_node": "start"
}
```

> [!TIP]
> Use `{variavel}` nos campos de texto para substituição dinâmica baseada no estado do `NarrativeDirector`.
