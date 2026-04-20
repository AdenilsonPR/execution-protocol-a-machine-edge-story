## 🛠️ Instalação e Configuração

O OmniChat é um plugin orientado a código e recursos, projetado para ser integrado sem a necessidade de configurações manuais no Inspector.

### Passo 1: Ativação
1. Vá em `Project Settings > Plugins`.
2. Marque **Enable** no plugin **OmniChat**.

### Passo 2: Project Settings
As pastas de recursos globais devem ser configuradas em `Project > Project Settings > Omni Chat`:

| Configuração | Descrição | Padrão |
| :--- | :--- | :--- |
| `omni_chat/paths/effects` | Caminho para seus RichTextEffects customizados. | `res://omni_chat_custom/effects/` |

### Passo 3: Adicionando à Cena
Adicione o nó `OmniChat` em qualquer lugar da sua UI. Por padrão, ele ocupará todo o espaço disponível do seu container e iniciará na **Visão de Lista**.

---

## 🖋️ Sistema de Efeitos e Escrita (Novo)

O OmniChat agora utiliza um sistema de escrita 100% nativo baseado em BBCode.

### A Tag `[typewriter]`
Utilize esta tag em seus diálogos (JSON ou Resources) para ativar a animação de máquina de escrever:
`[typewriter s=20 v="beep"]Sua mensagem aqui[/typewriter]`

*   **`s` (Speed)**: Caracteres por segundo.
*   **`v` (Voice)**: Nome do arquivo `.wav` em `res://omni_chat_custom/sounds/`.

### Áudio Sincronizado
O som de digitação é disparado automaticamente para cada caractere. 
- O arquivo padrão deve ser `res://omni_chat_custom/sounds/typewriter.wav`.
- A lista de contatos (sidebar) remove automaticamente as tags BBCode para manter um preview limpo.

---

## 👨‍💻 API de Programação

O OmniChat é controlado via script para máxima flexibilidade:

### Métodos Principais
- **`start_dialogue(resource: ChatDialogue, immediate: bool)`**: Inicia uma nova conversa baseada em um Resource.
- **`render_text(text: String, speed: float, contact: String)`**: Envia uma mensagem manualmente para o chat.
- **`select_choice(choice_id: String)`**: Seleciona uma opção de diálogo via código (útil para controle externo).

### Propriedades (Exports)
- **`interactive: bool`**: Se `false`, o chat oculta a barra de escolhas e ignora interações de mouse.

### Sinais Principais
- **`new_message_received(contact_name)`**: Emitido quando uma nova mensagem chega.
- **`choice_selected(choice_id)`**: Emitido quando o jogador clica em uma opção.
- **`choices_offered(choices: Dictionary)`**: Emitido quando novas opções de diálogo estão disponíveis para o jogador.
- **`reminder_triggered(contact_name)`**: Emitido após inatividade do jogador.


---

⬅️ Voltar para a [[Home]]
