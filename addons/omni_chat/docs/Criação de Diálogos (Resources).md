# Integração de Diálogos e Narrativa 💬

No ecossistema OmniSystem, o **OmniChat** serve como a interface visual para os diálogos processados pelo **OmniNarrative**.

## 🔗 Integração com OmniNarrative (Recomendado)

A forma mais poderosa de usar o chat é através do sistema de narrativa baseado em JSON. O `NarrativeDirector` gerencia as mensagens, nomes de contatos e escolhas automaticamente.

### Exemplo de Fluxo:
1.  O `NarrativeDirector` carrega um nó do tipo `chat`.
2.  Ele formata o texto (substituindo variáveis e traduzindo IDs).
3.  Ele chama `OmniChat.start_dialogue()` injetando os dados processados.

---

## 🛠️ Uso Manual (ChatDialogue Resource)

Se você precisar disparar um diálogo fora do sistema de narrativa (ex: um tutorial rápido ou sistema de ajuda), você pode usar o Resource `ChatDialogue`.

```gdscript
var dialogue: ChatDialogue = ChatDialogue.new()
dialogue.contact_name = "Sistema"
dialogue.messages = ["Esta é uma mensagem manual."]
dialogue.choices = {"ok": "Entendido"}

OmniChat.start_dialogue(dialogue)
```

---

## 💾 Persistência

O estado do chat (histórico de mensagens e conversas abertas) é capturado automaticamente pelo **OmniSave**. 

Ao carregar um jogo:
1.  As listas de contatos são reconstruídas.
2.  O histórico de mensagens de cada conversa é restaurado.
3.  As cores e estilos definidos na paleta `ColorChat` são mantidos.
