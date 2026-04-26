# Efeitos de Texto Customizados 🎨

O Terminal Omni permite a criação de efeitos dinâmicos para o texto usando o sistema de `RichTextEffect` do Godot.

## Criando um Efeito

Para criar um novo efeito, crie um script `.gd` que estenda `RichTextEffect`.

### Estrutura Base (Snake Case & Typed)
```gdscript
@tool
class_name MeuEfeito extends RichTextEffect

# O nome da tag BBCode que será usada no JSON
func _init() -> void:
	bbcode = "meu_efeito"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	# Lógica do efeito aqui
	return true
```

## Configuração do Caminho

Para que o terminal reconheça seus efeitos, você deve registrar a pasta onde os scripts estão localizados:

1.  Vá em **Project Settings > Omni Term > Paths**.
2.  No campo **Effects**, coloque o caminho da sua pasta (ex: `res://src/scripts/effects/`).

## Uso no JSON

Uma vez registrado, você pode usar a tag diretamente no campo `text` dos seus roteiros narrativa:

```json
{
    "id": "MSG_01",
    "text": "[meu_efeito]Este texto terá o efeito aplicado.[/meu_efeito]"
}
```

## Logs de Desenvolvedor

Se houver algum erro no carregamento do seu script, o terminal emitirá mensagens de erro no console em inglês para facilitar a depuração:

- `OmniTerm: Failed to load effect script at: [path]`
- `OmniTerm: Script is not a valid RichTextEffect at: [path]`

## Sincronização de Tempo (Sequential Waiting)

Se o seu efeito manipula a visibilidade do texto ao longo do tempo (como um efeito de digitação *typewriter*), o Terminal Omni possui um sistema de *polling* inteligente que aguarda o término da animação nativamente sem usar timers arbitrários.

Para que o Terminal saiba quando a sua animação terminou e libere a próxima linha, basta adicionar uma propriedade **`is_finished: bool`** ao seu efeito e atualizá-la usando o quadro atual da Engine:

```gdscript
class_name TypewriterEffect extends RichTextEffect

var bbcode = "typewriter"

# Flag lida nativamente pelo Terminal Omni
var is_finished: bool = true 
var _last_frame: int = -1

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var current_frame: int = Engine.get_frames_drawn()
	# No início de cada frame de renderização, assumimos que o efeito já terminou.
	if current_frame != _last_frame:
		_last_frame = current_frame
		is_finished = true
		
	var speed: float = float(char_fx.env.get("s", 50.0))
	var time: float = char_fx.elapsed_time * speed
	
	if char_fx.relative_index > time:
		char_fx.color.a = 0.0
		# Se houver qualquer caractere não visível, invalidamos o término.
		is_finished = false
		
	return true
```

> [!TIP]
> **Como funciona:** O Terminal *clona* o seu efeito para cada linha processada. Se a tag existir no texto, ele verifica a variável `is_finished` quadro a quadro. Assim que ela se mantiver verdadeira até o final do loop da GPU, o terminal prossegue instantaneamente, garantindo um acoplamento orgânico sem interrupções.

> [!IMPORTANT]
> A variável `is_finished` **deve** ser inicializada como `true` para garantir que o terminal não trave infinitamente em linhas que não utilizam o efeito (como quebras de linha `\n`).

> [!IMPORTANT]
> Sempre use `@tool` no topo dos seus scripts de efeito (se for editá-los diretamente no editor Godot) para que a engine possa processá-los corretamente.
