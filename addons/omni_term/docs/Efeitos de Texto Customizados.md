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

var is_finished: bool = true 
var _last_frame: int = -1

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var current_frame: int = Engine.get_frames_drawn()
	if current_frame != _last_frame:
		_last_frame = current_frame
		is_finished = true
		
	var speed: float = float(char_fx.env.get("s", 50.0))
	var time: float = char_fx.elapsed_time * speed
	
	if char_fx.relative_index > time:
		char_fx.color.a = 0.0
		is_finished = false
		
	return true
```

> [!TIP]
> **Como funciona:** O Terminal *clona* o seu efeito para cada linha processada. Se a tag existir no texto, ele verifica a variável `is_finished` quadro a quadro. Assim que ela se mantiver verdadeira até o final do loop da GPU, o terminal prossegue instantaneamente, garantindo um acoplamento orgânico sem interrupções.

> [!IMPORTANT]
> A variável `is_finished` **deve** ser inicializada como `true` para garantir que o terminal não trave infinitamente em linhas que não utilizam o efeito (como quebras de linha `\n`).

> [!IMPORTANT]
> Sempre use `@tool` no topo dos seus scripts de efeito (se for editá-los diretamente no editor Godot) para que a engine possa processá-los corretamente.

---

## Sequenciamento Automático com `seq` 🤖

Para evitar cálculos manuais de delay (como o mostrado acima), o Terminal Omni possui o parâmetro inteligente **`seq`**. Quando presente na tag `[typewriter]`, o sistema calcula automaticamente o delay necessário baseado no comprimento e na velocidade de todos os blocos `seq` anteriores na mesma linha.

### Exemplo: Barra de progresso simplificada

```json
{
    "id": "PROGRESS_BAR",
    "text": "[[typewriter s=4 seq]====[/typewriter][typewriter s=2 seq]====[/typewriter][typewriter s=1 seq]====[/typewriter]]"
}
```

O terminal transformará isso internamente em:
- Bloco 1: delay 0 (20 chars / speed 4 = 5s de duração)
- Bloco 2: delay 5.0s (20 chars / speed 2 = 10s de duração)
- Bloco 3: delay 15.0s (5s + 10s)

### Sintaxe de Parâmetros

| Parâmetro | Tipo | Descrição |
|-----------|------|-----------|
| `s` | float | Velocidade (caracteres por segundo) |
| `d` | float | Delay manual em segundos antes de iniciar |
| `seq` | flag | Ativa o sequenciamento automático de delays |

> [!IMPORTANT]
> O parâmetro `seq` só funciona com blocos do tipo `[typewriter]`. Ele ignora tags BBCode internas ao calcular o comprimento do texto, garantindo precisão mesmo com cores ou outros estilos aplicados.

> [!TIP]
> Use `seq` para a maioria dos casos de animações encadeadas. Use `d=` apenas quando precisar de um delay específico que não dependa do texto anterior ou para sobrepor o comportamento do `seq`.

---

## Delay Manual com `d=` ⏱️

O efeito `[typewriter]` também suporta o parâmetro `d` para controle total e manual do tempo. Isso permite criar animações **sequenciais dentro de um único label**, onde texto ao redor (como colchetes) fica visível desde o início.

### Cálculo do delay manual

Para encadear blocos manualmente, calcule: `delay = chars_anteriores / speed_anterior`

| Bloco | Chars | Speed | Duração | Delay acumulado |
|-------|-------|-------|---------|-----------------|
| 1º | 5 | 3 | 5/3 ≈ 1.67s | 0 (sem `d`) |
| 2º | 3 | 2 | 3/2 = 1.5s | 1.67 |
| 3º | 2 | 1 | 2/1 = 2.0s | 1.67 + 1.5 = 3.17 |

> [!NOTE]
> Texto sem tags de efeito ou fora das tags `typewriter` aparece instantaneamente. Por isso, ao usar `d=` ou `seq`, molduras como `[` e `]` são renderizadas de imediato.

---

## Controle de Fluxo com `[await]` ⏳

A tag `[await]` permite controlar a ordem de execução de múltiplos efeitos **dentro da mesma linha**. Por padrão, todos os efeitos em uma linha são processados de forma assíncrona (simultaneamente). A tag `[await]` cria um **ponto de barreira**: o terminal aguarda todos os efeitos anteriores terminarem antes de renderizar o próximo segmento.

### Sintaxe

| Tag | Comportamento |
|-----|---------------|
| `[await]` | Aguarda todos os efeitos anteriores terminarem |
| `[await t=0.5]` | Aguarda + adiciona um delay de 0.5 segundos |

### Exemplos

**Carregamento sequencial:**
```json
{
    "id": "LOADING",
    "text": "[typewriter s=3]...[/typewriter][await][typewriter s=2]...[/typewriter][await][typewriter s=1]...[/typewriter]"
}
```
Resultado: cada `...` aparece somente após o anterior terminar.

**Com delay entre segmentos:**
```json
{
    "id": "STAGED_BOOT",
    "text": "[typewriter s=50]Verificando...[/typewriter][await t=1.0][typewriter s=50]OK[/typewriter]"
}
```
Resultado: "Verificando..." aparece, espera 1 segundo, depois "OK" aparece.

**Misto — parte sync, parte async:**
```json
{
    "id": "INIT_MIX",
    "text": "[typewriter s=50]Inicializando...[/typewriter][await][typewriter s=3]OK[/typewriter] [typewriter s=3]DONE[/typewriter]"
}
```
Resultado: "Inicializando..." aparece primeiro, depois "OK" e "DONE" aparecem juntos (sem `[await]` entre eles).

> [!TIP]
> A tag `[await]` não é uma tag BBCode do Godot — ela é processada pelo Terminal Omni antes da renderização. Texto sem `[await]` mantém o comportamento padrão (assíncrono).

⬅️ Voltar para a [[Home]]

