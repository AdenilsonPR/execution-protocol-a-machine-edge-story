## 🌍 Localização (Tradução)

O OmniChat foi projetado para ser totalmente localizável. Ele utiliza a função `tr()` do Godot para processar todos os textos exibidos na interface.

### Chaves de Interface Internas
Para que a UI do chat não exiba códigos técnicos, você deve adicionar as seguintes chaves ao seu sistema de tradução (CSV/PO):

| Chave | Descrição | Exemplo (pt_BR) |
| :--- | :--- | :--- |
| `CHAT_UI_TITLE` | Título da lista de contatos. | "Mensagens" |
| `CHAT_UI_PLACEHOLDER` | Dica no campo de texto quando o chat está ocioso. | "Aguardando resposta..." |

### Tradução de Diálogos
Ao criar um `ChatDialogue` ou usar o sistema **OmniNarrative**, você pode usar chaves de tradução nos seguintes campos:
- `contact_name`
- `messages` (cada string do array)
- `choices` (os valores do dicionário)

O plugin chamará `tr()` automaticamente antes de renderizar qualquer um desses textos.

⬅️ Voltar para a [[Home]]
