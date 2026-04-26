# Estrutura de Scripts (JSON) 📄

A narrativa é definida em arquivos JSON compostos por um dicionário de `nodes`. Cada nó possui um `type` que define seu comportamento.

## 🌍 Localização e Tradução

Todos os campos de texto suportam o formato de **Array de Objetos**. Isso é recomendado para textos longos, pois evita o uso de `\n` e permite que cada linha tenha seu próprio ID de tradução.

**Formato Recomendado:**
```json
"text": [
    { "id": "INTRO_L1", "text": "Bem-vindo ao Sistema Omni." },
    { "id": "INTRO_L2", "text": "Acesso concedido ao terminal central." }
]
```

O sistema prioriza o campo `id`. Se a tradução não for encontrada, o campo `text` será usado como fallback.

---

## Tipos de Nós

### 💻 Terminal Node (`"type": "terminal"`)
Envia texto para o terminal OmniTerm.

```json
"terminal_log": {
    "type": "terminal",
    "text": [
        { "id": "LOG_INIT", "text": "[omni_color=BLUE]Iniciando sistema...[/omni_color]" },
        { "id": "LOG_AUTH", "text": "Autenticando credenciais..." }
    ],
    "next": "next_node",
    "delay": 1.0
}
```

### ⌨️ Terminal Input (`"type": "terminal_input"`)
Prepara o terminal para receber um comando do jogador.

```json
"wait_cmd": {
    "type": "terminal_input",
    "text": [
        { "id": "CMD_PROMPT", "text": "Aguardando entrada do usuário..." }
    ]
}
```

### 💬 Chat Node (`"type": "chat"`)
Exibe diálogos no sistema OmniChat.

```json
"node_id": {
    "type": "chat",
    "contact": { "id": "NPC_NAME", "text": "Mestre" },
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

> [!TIP]
> Use `{variavel}` nos campos de texto para substituição dinâmica baseada no estado do `NarrativeDirector`.
