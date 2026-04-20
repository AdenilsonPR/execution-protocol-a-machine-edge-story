## 🛠️ Instalação e Configuração

O OmniTerm opera como um **Plugin de Godot 4** orientado a código (code-driven).

1. **Ative o Plugin**: Vá em `Project Settings > Plugins` e ative o **OmniTerm**.
2. **Adicione o Nó**: Adicione o nó `OmniTerm` na sua cena. 
3. **Configuração Global**: As configurações estruturais estão em `Project Settings > Omni Term`.

---

## ⚙️ Project Settings (Configurações Globais)

| Configuração | Descrição | Padrão |
| :--- | :--- | :--- |
| `omni_term/paths/commands` | Onde o motor busca novos comandos `.gd` | `res://omni_term_custom/commands/` |
| `omni_term/paths/effects` | Pasta para scripts de efeitos BBCode | `res://omni_term_custom/effects/` |
| `omni_term/paths/inline_elements` | Componentes UI injetáveis no log | `res://omni_term_custom/inline/` |
| `omni_term/paths/inputs` | Cenas de input customizadas (ex: senha) | `res://omni_term_custom/inputs/` |
| `omni_term/paths/sounds` | Pasta base para os assets de áudio | `res://omni_term_custom/sounds/` |
| `omni_system/theme/custom_theme` | Caminho para o arquivo `.theme` personalizado (Compartilhado) | `""` (usa o tema padrão do OmniTerm) |
| `omni_system/theme/color_palette` | Caminho da paleta de cores `.tres` (Compartilhado) | `res://addons/omni_term/assets/color_palettes/base_palette.tres` |

---

## 🎨 Customização Visual com Temas

O OmniTerm verifica na inicialização se a configuração `omni_system/theme/custom_theme` aponta para um arquivo `.theme` válido.

- **Se encontrado:** Ele aplica o tema ao nó principal. O Godot propaga automaticamente a fonte, tamanhos, cores e estilos de borda para todos os elementos internos. Você tem **controle total** via editor de tema.
- **Se não encontrado:** O OmniTerm constrói um tema padrão via código usando a paleta de cores (`omni_system/theme/color_palette`) e a fonte VT323 embutida.

Para criar o seu tema:
1. No Godot, vá em `Project > Tools > Theme Editor`.
2. Crie um novo tema e configure as propriedades abaixo para as classes listadas.
3. Salve como um arquivo `.theme` em `res://omni_term_custom/` (ou onde preferir).
4. Em `Project Settings`, defina `omni_system/theme/custom_theme` com o caminho desse arquivo.

### Propriedades reconhecidas pelo OmniTerm

| Tipo de Nó | Propriedade | Descrição |
| :--- | :--- | :--- |
| `RichTextLabel` | `normal_font` | Fonte usada em todo o texto do log |
| `RichTextLabel` | `normal_font_size` | Tamanho da fonte |
| `RichTextLabel` | `default_color` | Cor base do texto |
| `VScrollBar` | `grabber` | StyleBox do indicador de scroll (normal) |
| `VScrollBar` | `grabber_highlight` | StyleBox do indicador (hover) |
| `VScrollBar` | `grabber_pressed` | StyleBox do indicador (pressionado) |
| `VScrollBar` | `scroll` | StyleBox do trilho do scrollbar |
| `MarginContainer` | `margin_left/top/right/bottom` | Padding interno do terminal |
| `PanelContainer` | `panel` | Fundo do container (use `StyleBoxEmpty` para transparente) |
| `VBoxContainer` | `separation` | Espaço vertical entre as linhas do log |

> **Dica:** Você não precisa definir **todas** as propriedades. O Godot usa o fallback do tema padrão do OmniTerm para qualquer propriedade que não estiver no seu arquivo customizado.


---

## ⌨️ Efeitos de Texto e Máquina de Escrever (Novo)

O Terminal agora suporta efeitos de digitação nativos e sincronizados com áudio.

### Uso do `[typewriter]`
Toda saída enviada ao terminal pode conter a tag de efeito:
`[typewriter s=40 v="terminal_click"]INICIALIZANDO...[/typewriter]`

*   **`s` (Speed)**: Velocidade de digitação (chars/seg).
*   **`v` (Voice)**: Nome do som em `res://omni_term_custom/sounds/` (ex: `v="click"` busca `click.wav`).

O som padrão (`typewriter.wav`) será tocado automaticamente para qualquer texto dentro da tag, garantindo imersão sem código extra.

---

## 👨‍💻 API de Programação (GDScript)

### Métodos Principais
- **`set_username(name: String)`**: Altera o nome do usuário no prompt.
- **`set_hostname(host: String)`**: Altera o nome da máquina no prompt.
- **`render_output(data: CommandOutput)`**: Injeta uma resposta formatada no log.
- **`clear_terminal()`**: Limpa todo o histórico visual.
- **`inject_custom_input(input_node: Control)`**: Injeta um nó de input customizado no log. Internamente aguarda o reflow da UI (2 frames), rola o scroll até o final e dá foco ao nó. Use com `await` para garantir que o nó esteja visível antes de interagir.

### Sinais (Signals)
- **`output_rendered(text: String)`**: Emitido sempre que o terminal imprime algo.
- **`action_triggered(action_id: String)`**: Emitido quando um comando dispara uma ação especial.

---

⬅️ Voltar para a [[Home]]
