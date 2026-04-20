# Customização de Temas e Cores 🎨

O **OmniTerm** permite a personalização completa da interface através de temas nativos do Godot e de um sistema centralizado de cores.

## 1. Tema Customizado (.tres)

Você pode substituir o visual padrão do terminal criando seu próprio recurso de `Theme` no Godot.

### Como configurar:
1.  Crie um novo `Theme` no Godot (ou use um existente).
2.  Vá em `Project -> Project Settings -> General`.
3.  Procure pela seção `Omni System -> Theme`.
4.  No campo `custom_theme`, selecione o caminho para o seu arquivo `.tres`.
5.  O terminal carregará automaticamente este tema ao ser inicializado.

> [!NOTE]
> O terminal utiliza `RichTextLabel` para o log e `InputContainer` para a entrada. Se o seu tema não definir estilos específicos, o terminal usará o visual "retro" padrão.

---

## 2. Sistema de Cores (ColorTerm)

O sistema utiliza a classe `ColorTerm` para manter a consistência visual entre Terminal, Chat e Narrativa.

### Uso no Terminal:
Você pode usar a tag customizada `[omni_color]` nos seus textos de comando ou roteiros:

```text
[omni_color=RED]Erro Crítico![/omni_color]
[omni_color=YELLOW.2]Aviso de sistema (tom escuro)[/omni_color]
```

### Paletas Disponíveis:
- `NEUTRAL`: Escala de cinzas (0 a 6).
- `RED`, `GREEN`, `BLUE`, `YELLOW`, `CYAN`, `MAGENTA`.

As cores são definidas no script `res://addons/omni_term/src/terminal/utils/colors.gd`.

---

## 3. Fontes e Efeitos

### Fontes:
A fonte padrão é a **VT323-Regular.ttf**. Para alterá-la, você pode:
- Definir uma fonte global no seu `custom_theme`.
- Ou substituir o arquivo em `res://addons/omni_term/assets/fonts/`.

### Efeito Typewriter:
O efeito de digitação pode ser controlado diretamente no texto:
`[typewriter s=50 v="som_customizado"]Sua mensagem aqui...[/typewriter]`
- `s`: Velocidade (caracteres por segundo).
- `v`: Nome do arquivo de som em `res://omni_term_custom/sounds/`.
