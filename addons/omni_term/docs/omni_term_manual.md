---

## 🛠️ Capítulo 0: Instalação como Plugin

O OmniTerm agora está estruturado como um **Plugin de Godot 4**. Para começar a usá-lo em qualquer projeto:

1. **Ative o Plugin**: Vá em `Project Settings > Plugins` e marque **Enable** no OmniTerm.
2. **Adicione o Nó**: Agora você pode adicionar o nó `Terminal` diretamente via o diálogo `Add Node` (Ctrl+A). Ele aparecerá com todas as configurações padrão prontas.
3. **Estrutura Interna e Project Settings**: Todos os arquivos nativos do motor vivem em `res://addons/omni_term/`. As configurações globais de Pastas (comandos, efeitos, etc.) deixaram de existir no Inspector e **agora são configuradas globalmente no Godot**! 
Vá em `Project > Project Settings...`, ative `Advanced Settings`, e localize a aba lateral **Omni Term** para alterar as pastas padrão do plugin.

---

## 🏁 Capítulo 1: O Fluxo de Inicialização (Boot)

O OmniTerm opera como uma máquina de estados que prioriza a narrativa antes de liberar o controle técnico para o jogador. É fundamental entender como ele "acorda":

1. **Estado IDLE**: O terminal inicia em silêncio.
2. **Execução da Intro**: Se você definiu uma **`Intro Sequence`** no Inspetor, o motor irá rodar todos os eventos dela (textos, prompts, escolhas) até o fim.
3. **Molda de Modo**: Somente após a última sequência terminar é que o terminal chama o método `create_new_line()`, mudando o modo para **`COMMAND`** e exibindo o prompt `user@local: >`.

> [!TIP]
> Para criar uma experiência puramente narrativa sem linha de comando, basta garantir que a última `StorySequence` da sua história não termine, ou que ela entre em um loop infinito de escolhas/prompts.

---

## 🛠️ Capítulo 1: O Nó "Terminal" e Suas Propriedades

O nó raiz que você arrasta para a sua tela no Godot se chama **Terminal**. O inspetor dessa cena gerencia a estrutura de pastas externa (Dual-Loading) e a inicialização. 

### Propriedades do Inspetor:

#### 🔐 Login Settings
- **`Username`** *(String)*: O nome do usuário exibido no prompt de comandos. Padrão: `user`. Altere para o nome do personagem no jogo (ex: `"hacker_404"`).
- **`Hostname`** *(String)*: O nome da máquina exibido no prompt. Padrão: `local`. Use para contextualizar a localização narrativa (ex: `"mainframe-09"`, `"Estação-B4"`).

#### 📖 Narrative Flow
- **`Intro Sequence`** (Opcional): Uma `StorySequence` que roda literalmente no instante que o jogo inicia, antes de qualquer interação do usuário (Antes mesmo da liberação de prompt de comando). Ótimo para cutscenes CLI ou inclusive injetar Custom Inputs contendo Formulários de Login elaborados por você!

#### 📂 Auto Loading Paths (Via Project Settings)
Diferente da narrativa, as modificações estruturais das suas rotinas ficam escondidas no motor da Engine (Vá em **Project Settings -> Omni Term** para alterar).
- **`Commands Path`**: Caminho exposto para o motor buscar extensões que herdem de `CommandBase`. Padrão é `res://addons/omni_term/src/terminal/commands/builtin/`.
- **`Effects Path`**: Pasta para importar `TextEffects`. Padrão é `res://addons/omni_term/src/scripts/effects/`.
- **`Inline Elements Path`**: Onde colocar cenas flutuantes embutidas no texto. Padrão é `res://addons/omni_term/src/terminal/components/inline/`.
- **`Custom Inputs Path`**: A pasta que guarda as telas isoladas chamadas por eventos narrativos (`PromptEvent`). Padrão é `res://addons/omni_term/src/terminal/components/inputs/`.

> [!NOTE]
> O motor possui **Dual-Loading**. Ele **sempre** carregará os recursos essenciais em `src/...` e DEPOIS tentará carregar os que achar nas pastas configuradas acima. Se os nomes coincidirem, o seu arquivo customizado sobrescreve o padrão.

### Alterando o Prompt em Tempo de Jogo

O `Username` e `Hostname` também podem ser trocados **dinamicamente durante a gameplay** via GDScript. Isso é especialmente útil se o jogador "invadir" outra máquina ou "trocar de identidade" na narrativa.

**Exemplo 1: Alterando via um Comando**
```gdscript
class_name ConnectCommand extends CommandBase

func _init() -> void:
	command_name = "conectar"
	description = "Conecta a um servidor remoto."

func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
	if args.is_empty():
		return CommandOutput.create("[p=RED]Erro:[/p] forneça um endereço. Ex: conectar mainframe-09")
	
	var servidor = args[0]
	# Troca o hostname para refletir a nova máquina
	context.terminal.hostname = servidor
	return CommandOutput.create("Conectando a [p=YELLOW]%s[/p]..." % servidor)
```
Após executar esse comando, o prompt passará a exibir `user@mainframe-09:` em todas as novas linhas.

**Exemplo 2: Alterando via a Narrativa (CommandOutput inline)**
Você pode criar um `CommandBase` que dispara uma sequência de história E altera o prompt ao mesmo tempo:
```gdscript
func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
	context.terminal.username = "root"
	context.terminal.hostname = "SISTEMA-CENTRAL"
	return CommandOutput.create("[p=RED]ACESSO ROOT CONCEDIDO[/p]")
```

*Nota Oculta: O motor possui Dual-Loading.*

---

## 💻 Capítulo 2: Passo a Passo para Novos Comandos

Você quer criar um comando executável como "conectar", "hack", "status" que responde dentro do prompt tradicional `user@local: >`.

**Passo 1: Criando Pastas (Recomendação)**
- Crie uma pasta para não sujar a base do motor: `res://meus_sistemas/meus_comandos/`
- Vá no menu de cima do Godot em **Project -> Project Settings -> General -> Omni Term** e insira esse caminho na variável `Commands Path`.

**Passo 2: Criando o Arquivo**
- Na sua pasta criada, faça clique-direito > Novo Script (GDScript). Dê um nome lógico como `status_command.gd`.

**Passo 3: Herança e Regras**
- O seu script **obrigatoriamente** deve possuir `class_name` não sobreposta e deve realizar `extends CommandBase`.
- Configure o comando em inicialização (`_init`).

**Exemplo Completo:**
```gdscript
class_name StatusCommand extends CommandBase

func _init() -> void:
	# O comando que o usuário tem que digitar! 
	# Sem espaços (ex: se "status", o jogo executará se o usuário digitar status)
	command_name = "status"
	
	# Texto de ajuda no menu "help"
	description = "Exibe o nível de conexão criptografada."

func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
	# O args[0] será a primeira palavra que suceder "status " (Ex: status admin)
	if args.size() > 0 and args[0] == "rede":
		return CommandOutput.create("[p=GREEN]Rede conectada via Proxy.[/p]")
	
	return CommandOutput.create("Digite: status rede")
```

---

## 🎨 Capítulo 3: Passo a Passo para Textos e Tags 

Um dos potenciais máximos do OmniTerm é enfeitar ou quebrar a barreira temporal através do envio direto de código por BBCode e Tags RegEx nas `StorySequence`.

**1. Usando a Formatação de Paleta Padrão:**
Envolva a frase vital com `[p=COR]texto[/p]`. As cores possíveis englobam `RED`, `YELLOW`, `GREEN`, `NEUTRAL`.
- Exemplo: `Processo de invasão do servidor [p=YELLOW]Omega[/p] foi [p=RED]Abortado[/p].`

**2. Inserindo Cenas Godot Literais no meio de Frases (Inline Elements):**
E se você quiser mostrar uma foto?
- Passo A: Crie uma pasta no projeto `res://elementos_flutuantes/` e mapeie em **Project Settings -> Omni Term -> Inline Elements Path**.
- Passo B: Crie uma cena de nome **`imagem_hacker.tscn`** sendo do tipo Control/TextureRect e posicione dentro uma foto.
- Passo C: Em qualquer `TextEvent`, coloque `{imagem_hacker}` (entre chaves, SEM extensão).
- Resultado: `Baixando log do suspeito: {imagem_hacker}` (A foto será literalmente parida dentro do HFlow da caixa temporal).

**3. Criando e Engatilhando Novos Efeitos (`[[efeito=X]]`):**
O motor escaneia dinamicamente os scripts que alteram o comportamento das letras, baseados em Tags delimitadas por colchetes duplos (Ex: `[[speed=50]]`).

**Passo A: Onde salvar**
Por conta do Dual-Loading, você pode criar a sua pasta `res://meus_sistemas/meus_efeitos/` e linká-la no campo `Effects Path` em **Project Settings -> Omni Term**. O sistema lerá essa pasta somada à orgânica.

**Passo B: Criando o Arquivo**
Crie um script nessa pasta. **Regra de Ouro:** O nome do arquivo *DEVE* terminar com `_effect.gd`. O prefixo determinará o nome da Tag!
- Se você criar `glitch_effect.gd`, a tag gerada automaticamente será `[[glitch=valor]]`.
- Se criar `terremoto_effect.gd`, a tag será `[[terremoto=valor]]`.

**Passo C: A Estrutura do Script de Efeito**
O seu script deve obrigatoriamente estender a classe `TextEffect`. Ele requer duas rotinas estáticas de construção e um método `apply` que sempre informe à engine quando terminou o show:

```gdscript
class_name GlitchEffect extends TextEffect

# Variável p/ guardar o número enjetado na tag [[glitch=2.5]]
@export var intensity: float = 1.0

# Obrigatório: Método construtor universal chamado pelo Parser do Terminal
static func create(val: float) -> GlitchEffect:
	var effect = GlitchEffect.new()
	effect.intensity = val
	return effect

# Obrigatório: Atualiza os dados se a mesma tag for repetida mais pra frente
func set_value(v: float) -> void:
	intensity = v

# A mágica visual onde o código mexe com O Nodo ativo.
func apply(label: RichTextLabel) -> void:
	# "label" é o trecho de texto atual sendo impresso!
	
	# Coloque sua lógica de sacudir tela, acionar sons ou shaders aqui
	# Ex: Congelando o tempo do jogo baseado na "intensidade" informada:
	await label.get_tree().create_timer(intensity).timeout
	
	# SINAL VITAL: O terminal só continua a digitar se você o libertar
	completed.emit() 
```

**Passo D: Invocando o Efeito na sua História**
Vá no Inspetor do Godot, abra seu recuso `TextEvent` (que contem o texto da história), e injete a tag no local desejado:

*Texto Original:* `Atenção. Invasão de sistema... [[glitch=2.5]] Reiniciando Matrix.`

---

## 📖 Capítulo 4: A Máquina Narrativa (`StorySequence` e Eventos)

O OmniTerm não é apenas um emulador de Bash; ele embute um sistema de fluxo narrativo (Uma Árvore de Diálogos/Eventos) guiada primariamente pelo painel de criação do **Godot Resources**. Todo esse sistema roda a partir do conceito de "Sequências".

### 1. O Contêiner Base: `StorySequence`
A `StorySequence` é simplesmente uma matriz linear. Ao criar esse recuso pelo painel (Botão Direito > Create Nova Resource > `StorySequence`), a única opção exposta é a listagem de **Events** (Eventos).
O motor vai rodar essa matriz index por index até o fim da lista.

### 2. Os 3 Tipos de Eventos (`StoryEvent`)
Quando você expande a Array de uma `StorySequence` no Inspetor, o Godot perguntará qual recurso você deseja injetar naquele slot. O OmniTerm suporta três grandes eventos. *(Lembre-se que todos os 3 herdam a propriedade base **Delay**, permitindo atrasar a injeção do evento x segundos)*:

#### 📝 A. `TextEvent` (Narrativa Estática)
O bloco de monólogo mais básico. Joga letras na tela.
- **`Text`** *(String)*: A frase literal a ser escrita. Aceita nativamente todas as Tags (p=Cor, Efeitos Customizados e Inline Elements delimitados por chaves `{}`).
- **`Speed`** *(Float)*: A velocidade base na qual essa sentança singular será impressa pelos motores de som do terminal. Padrão costuma ser 30.
- **`Color`** *(Color)*: A cor global de todo o bloco (pode ser sobrescrita localmente via tag BBCode).
- **`Delay`** *(Float)*: Os segundos que a engine congela, antes de cuspir todo o balão acima.

#### ⌨️ B. `TextPromptEvent` (Entrada de Dados Padrão)
Útil para quando você precisa de uma resposta direta do teclado (como um nome, senha ou comando específico) usando a interface de linha única padrão da engine.
- **`Label`** *(String)*: O texto que aparece fixo à esquerda do cursor (ex: `login:`, `codinome:`).
- **`Text`** *(String)*: Texto opcional que o terminal escreve no log ANTES de abrir o campo de input.
- **`Is Password`** *(Bool)*: Se ativado, oculta a digitação com asteriscos.
- **`Result Keys`** *(Array[String])*: Lista de respostas que você está monitorando (ex: `["admin", "1234"]`).
- **`Result Branches`** *(Array[StorySequence])*: Caminhos da história para cada chave.
- **`Default Branch`**: Onde cair se a pessoa digitar qualquer outra coisa.

#### 🔀 C. `ChoiceEvent` (Árvores de Opções Tradicionais)
Cria botões minimalistas embutidos abaixo do texto, forçando o jogador a seguir raízes prévias.
- **`Text`** *(String)*: Texto questionador impresso na tela instantaneamente antes das opções (ex: "Para onde correr?").
- **`Speed`** *(Float)*: A velocidade desse texto pergunta.
- **`Options`** *(Array de Strings)*: Uma lista com os textos literais a serem clicados (ex: Index 0 - "Correr", Index 1 - "Atirar").
- **`Branches`** *(Array de StorySequences)*: O segredo da ramificação! O motor cruza as duas matrizes. Se o jogador clicar na opção do Index 0, a Sequence associada a essa matriz do Index 0 é engatilhada, criando uma aranha narrativa gigantesca.

#### 🕹️ D. `PromptEvent` (Inputs de Minigames Customizados)
O evento supremo do framework. Em vez de botões ou monólogos, ele chama do disco *Interface User UIs* complexas completas construídas pela sua equipe (Teclados Numéricos, Biometria, Caixas Drag&Drop) e desvia caminhos dependendo do "Resultado" (`submitted`).
- **`Input Name`** *(String)*: O nome literal do seu componente salvo na pasta `Custom Inputs Path` (sem extensão `.tscn`).
- **`Text`** *(String)*: Textualidade descrita antes da placa da UI.
- **`Speed`** *(Float)*: Velocidade dessa string textual.
- **`Params`** *(Dictionary)*: Parâmetros silenciosos repassados nativamente pelo setup do seu formulário caso ele precise se moldar as circunstâncias.
- **`Result Keys`** *(Array de Strings)*: A tabela da verdade! Se a UI devolver as estripulias do jogador usando `submitted.emit("1234")`, aqui se armazena os espelhos esperados (Ex: Índice 0 = "1234").
- **`Result Branches`** *(Array de StorySequences)*: Array emparelhada matematicamente. Se a UI submeteu a String gravada no Índice 0 ali em Cima, essa Sequence de mesmo Indice dispara o arco do triunfo.
- **`Default Branch`** *(StorySequence)*: A Ramificação Escape! Útil para repetições de senhas. Se o jogador submitiu "000" e a sua Keys ali não tem nenhuma chave idêntica descrita, ele falha todas as aprovações e invoca essa sequence.

*Ao criar e preencher todas essas peças soltas encadeadas uma dentro das outras usando unicamente o Inspector do Godot, basta plugar a Primeira História Matriz na variável `Intro Sequence` do seu Master Terminal e tudo ocorrerá sozinho.*

---

## 📝 Capítulo 4.5: Sistema de Diálogos em Arquivo de Texto (`.omni`)

Como alternativa à criação manual de Resources no Inspector, o OmniTerm inclui um **Parser de Diálogos** que lê arquivos de texto simples (`.omni`) e os converte em `StorySequence` automaticamente em runtime. Isso torna a escrita de diálogos muito mais rápida e acessível — especialmente para roteiristas que não trabalham diretamente com o Godot.

### 1. Configurando o Terminal

Selecione o nó **Terminal** na sua cena. No Inspector, dentro do grupo **"Narrative Flow"**, você encontrará dois campos:

- **`Intro Sequence`**: Resources criados manualmente (forma clássica).
- **`Dialogue File`**: Caminho para um arquivo `.omni` (forma nova). Se preenchido, tem **prioridade** sobre o `Intro Sequence`.

### 2. Estrutura do Arquivo `.omni`

Os arquivos são organizados em **blocos** identificados por `[nome_do_bloco]`. O motor inicia sempre pelo bloco chamado `inicio`. Se não existir, usa o primeiro bloco do arquivo.

```ini
; Linhas começando com ; são comentários e são ignoradas

[inicio]
Guarda: Alto lá! Qual o seu nome?
- Sou um mercador -> rota_mercador
- (Atacar) -> combate

[rota_mercador]
Guarda: Mostre suas credenciais.
=> solicitar_credenciais
Guarda: Pode passar.
-> END

[combate]
Guarda: Mãos para o alto!!
-> inicio
```

### 3. Referência Completa da Sintaxe

| Sintaxe | Tipo de Evento | Descrição |
|---|---|---|
| `Texto livre` | `TextEvent` | Linha de fala ou narração |
| `- Opção -> bloco` | `ChoiceEvent` | Cria uma escolha que leva a outro bloco |
| `=> action_id` | `SignalEvent` | Emite `action_triggered` com o ID fornecido |
| `-> END` | — | Encerra o bloco (retorna o controle ao jogador) |
| `-> bloco` | — | Salta para outro bloco e encadeia seus eventos |
| `[nome]` | — | Declaração de um bloco |
| `; comentário` | — | Linha ignorada pelo parser |

### 4. Tags Inline de Texto

Adicione tags ao final de qualquer linha de texto para configurar propriedades do evento:

| Tag | Propriedade | Exemplo |
|---|---|---|
| `[color=red]` | Cor do texto | `Alerta! [color=red]` |
| `[speed=15.0]` | Velocidade de digitação | `Digitando devagar... [speed=8.0]` |
| `[delay=1.5]` | Pausa antes do evento | `Aguarde. [delay=2.0]` |
| `[sound=alarme]` | ID de som no SoundBank | `Beep! [sound=beep]` |

> [!NOTE]
> As tags `[p=COR]texto[/p]` do BBCode e os Inline Elements `{nome_cena}` funcionam normalmente dentro das linhas de texto do `.omni`, pois o texto é processado pelo mesmo motor do `TextEvent`.

### 5. Interagindo com o Jogo via `=>`

O operador `=>` emite o sinal `action_triggered` do Terminal com o ID que você definir. Conecte esse sinal no seu GameManager para reagir:

```gdscript
# No arquivo .omni:
# => iniciar_batalha

# No seu script de jogo:
func _ready() -> void:
	$Terminal.action_triggered.connect(_on_terminal_action)

func _on_terminal_action(action_id: String) -> void:
	if action_id == "iniciar_batalha":
		BattleManager.start_battle({"name": "Goblin", "hp": 30})
```

### 6. Múltiplos Arquivos

O sistema suporta qualquer quantidade de arquivos `.omni`. Organize por personagem, fase ou cena:

```
res://
└── dialogos/
	├── tutorial.omni
	├── npc_guarda.omni
	├── npc_mercador.omni
	└── chefe_fase_1.omni
```

Para acionar um diálogo via código (por exemplo, ao se aproximar de um NPC), você pode usar o parser diretamente:

```gdscript
var sequencia: StorySequence = OmniDialogueParser.parse_file("res://dialogos/npc_guarda.omni")
await $Terminal.play_sequence(sequencia)
$Terminal.create_new_line()
```

### 7. Fluxo de Localização Profissional (Line Tags)

Para projetos que precisam de tradução para outras línguas, o OmniTerm utiliza o sistema de **Line Tags**. Isso permite que você mude o texto original sem perder as traduções já feitas.

#### A. Assinando as Linhas (`OmniSigner`)
O roteirista escreve o texto puro. Antes de enviar para tradução, abra o script `omni_signer.gd` no Editor do Godot e execute-o (**File → Run**). O script percorrerá seus arquivos e adicionará um ID único ao final de cada frase:

```ini
[inicio]
Olá mundo! #id:a1b2c3d4
```

#### B. Gerando o Template (`OmniPOTExtractor`)
Execute o script `omni_pot_extractor.gd`. Ele gerará um arquivo `res://dialogos/messages.pot`. Este é o arquivo "mestre" que você enviará para tradutores ou abrirá em ferramentas como o **Poedit**.

#### C. Integrando no Godot
1. Use o Poedit para criar arquivos `.po` (ex: `en.po`, `es.po`) a partir do `.pot`.
2. No Godot, vá em **Project → Project Settings → Localization** e adicione os arquivos `.po`.
3. O Terminal detectará o `localization_key` automaticamente e exibirá o texto traduzido.

> [!IMPORTANT]
> Ao exportar o jogo, adicione `*.omni` e `*.pot` nos filtros de exportação em **Project → Export → Resources → Filters to export non-resource files/folders** para garantir que os arquivos de diálogo e localização sejam incluídos.

---

## 📡 Capítulo 5: Interceptando Ações do Terminal no seu Jogo

O OmniTerm é uma máquina fechada de texto, mas ele expõe um portal vital para o restante dos sistemas do seu jogo escutarem (Ex: Destrancar uma porta 3D no cenário quando o jogador hackear no terminal).

### 1. Interceptando Cliques Textuais (`action_triggered`)
Aquele `RichTextLabel` que você vê na tela suporta BBCode interativo. Se você usar a tag padrão do Godot `[url]` nas suas histórias, o motor redirecionará o clique diretamente para fora!

**Passo A:** Escreva no seu Menu ou Evento de Texto:
`Identamos um arquivo letal. [p=RED][url=apagar_sistema]CLIQUE AQUI PARA APAGAR[/url][/p]`

**Passo B:** No seu script do seu Jogo (ex: GameManager, Porta, Câmera), conecte-se ao sinal oficial exposto pelo terminal:
```gdscript
@onready var terminal = $UI/Terminal

func _ready():
	# O terminal avisa o mundo exterior toda vez que um [url] é clicado!
	terminal.action_triggered.connect(_on_terminal_action)

func _on_terminal_action(action_id: String) -> void:
	if action_id == "apagar_sistema":
		print("Apertou o botão vermelho! Fechando o jogo!")
		get_tree().quit()
```

### 2. A Comunicação dos Custom Inputs e Inlines
- **Eventos de Prompt (`Custom Inputs`):** Quando você preenche o `PromptEvent` e a UI surge, *não* é esperado que as outras peças do seu jogo precisem escutá-la. A UI emite internamente o sinal `submitted.emit()`, e o OmniTerm *captura essa submissão em background* para desviar sua Árvore de Eventos automaticamente (Baseado na array de Keys que você desenhou no Inspector). Toda a lógica permanece contida na História.
- **Acionando o exterior a partir de Componentes (`Inline Elements` ou Custom UI):**
Caso seu botão dentro de um Minigame inserido via Inlines `{minigame}` queira disparar luzes da vida real no seu Game Manager, você pode invocar o próprio signal global do Terminal já que seu componente vive dentro do contêiner dele:

```gdscript
extends Control
# Script atrelado ao seu minigame_inline.tscn

func _on_meu_botao_pressed():
	var terminal = get_parent().get_parent().get_parent() 
	# (Dica: Caminhe pelos HFlowContainers e VBox até atingir o raiz Terminal, 
	# ou jogue o Terminal num grupo do Godot e chame por get_first_node_in_group)
	
	if terminal.has_signal("action_triggered"):
		# Transmita do seu componente isolado para o Universo!
		terminal.action_triggered.emit("minigame_vencido")
```

---

## 🎓 Tutorial: Recriando o Sistema de Login (Narrativo)

Veja como criar um fluxo de acesso customizado que pede usuário e senha logo no boot:

### 1. Preparando as Sequências (Resources)
Crie três arquivos `.tres` do tipo `StorySequence`:
- `seq_login_sucesso.tres`: Contém um `TextEvent` dizendo "[p=GREEN]Acesso Permitido[/p]".
- `seq_login_falha.tres`: Contém um `TextEvent` dizendo "[p=RED]Credenciais Inválidas![/p]". No final da lista de eventos desta sequência, adicione um link de volta para a sequência principal (loop).
- `seq_login_principal.tres`: A sequência mestre que orquestra o desafio.

### 2. Configurando o Fluxo Mestre
Abra a `seq_login_principal.tres` no Inspetor:
1. Adicione um **`TextPromptEvent`**:
   - `Label`: login:
   - `Result Keys`: admin
   - `Result Branches`: (Crie uma nova `StorySequence` interna ou aponte para um arquivo de "Senha").
2. No evento de **Senha** (dentro do branch de sucesso do login):
   - `Label`: password:
   - `Is Password`: True
   - `Result Keys`: 1234
   - `Result Branches`: `seq_login_sucesso.tres`
   - `Default Branch`: `seq_login_falha.tres`

### 3. Ativando o Boot
- Selecione o nó **Terminal** na sua cena principal.
- Arraste a `seq_login_principal.tres` para o campo **`Intro Sequence`**.

**Resultado**: O jogo iniciará travado no login. O Shell (`user@local`) só aparecerá após o jogador passar por todos os seus desafios de segurança narrativos!

---

## 🔄 Utilidades de Sistema

### O Comando `reboot()`
Caso você queira "resetar" o terminal via script (por exemplo, após um Game Over ou quando o jogador digita um comando de logout), você pode chamar:
```gdscript
terminal.reboot()
```
Isso irá limpar todo o log da tela e reiniciar a `Intro Sequence`.

### O Comando `create_new_line()`
Este método é o responsável por mudar o modo do terminal para **`COMMAND`** (Shell). Se você quiser forçar a abertura da linha de comando no meio de uma sequência narrative, chame isso pelo contexto do terminal.

---

## 🌐 Capítulo 7: Sistema de Tradução (i18n)

O OmniTerm integra automaticamente com o sistema nativo de internacionalização do Godot. Todos os textos exibidos nos eventos narrativos são passados por `tr()` antes de serem renderizados, o que significa que **você pode usar chaves de tradução diretamente nos campos de texto dos seus Resources**.

> [!IMPORTANT]
> Retrocompatibilidade garantida: se você colocar texto direto (ex: `"Acesso negado"`), o `tr()` simplesmente devolve o mesmo texto sem modificação. Nada quebra.

### 1. Estrutura de Pastas Recomendada

Organize os arquivos de tradução em uma pasta dedicada no projeto:
```
res://
└── locales/
	├── pt_BR.po
	└── en.po
```

### 2. Configurando o Projeto no Godot

**Passo A: Registre os arquivos `.po`**
Vá em **Project Settings > Localization > Translations** e clique em **Add** para adicionar cada arquivo `.po`.

**Passo B: Defina o idioma inicial**
No script do seu `GameManager` ou autoload:
```gdscript
func _ready() -> void:
	TranslationServer.set_locale("pt_BR") # Ou "en", "es", etc.
```

### 3. Estrutura dos Arquivos `.po`

Cada idioma tem seu próprio arquivo. O `msgid` é a chave neutra que você coloca nos Resources. O `msgstr` é o texto completo traduzido — **incluindo todas as tags do OmniTerm**.

**`locales/pt_BR.po`:**
```po
# OmniTerm — Português do Brasil
msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"

msgid "MSG_BEM_VINDO"
msgstr "[p=GREEN]Bem vindo ao sistema.[/p]"

msgid "MSG_ACESSO_NEGADO"
msgstr "[p=RED]Acesso negado.[/p] Credenciais inválidas. [[wait=1.0]]"

msgid "MSG_ACESSO_OK"
msgstr "[p=GREEN]Autenticação bem-sucedida.[/p] {icone_check}"

msgid "MSG_DOWNLOAD"
msgstr ""
"Baixando arquivo... [[wait=1.5]]\n"
"{barra_progresso}\n"
"Download [p=GREEN]completo[/p]!"

msgid "MSG_ALERTA"
msgstr "[p=RED]ALERTA:[/p] Intruso detectado no setor [[speed=5]] B-4."

msgid "MSG_LOGIN_LABEL"
msgstr "login:"

msgid "MSG_SENHA_LABEL"
msgstr "senha:"
```

**`locales/en.po`:**
```po
# OmniTerm — English
msgid ""
msgstr ""
"Content-Type: text/plain; charset=UTF-8\n"
"Content-Transfer-Encoding: 8bit\n"

msgid "MSG_BEM_VINDO"
msgstr "[p=GREEN]Welcome to the system.[/p]"

msgid "MSG_ACESSO_NEGADO"
msgstr "[p=RED]Access denied.[/p] Invalid credentials. [[wait=1.0]]"

msgid "MSG_ACESSO_OK"
msgstr "[p=GREEN]Authentication successful.[/p] {icone_check}"

msgid "MSG_DOWNLOAD"
msgstr ""
"Downloading file... [[wait=1.5]]\n"
"{progress_bar}\n"
"Download [p=GREEN]complete[/p]!"

msgid "MSG_ALERTA"
msgstr "[p=RED]ALERT:[/p] Intruder detected in sector [[speed=5]] B-4."

msgid "MSG_LOGIN_LABEL"
msgstr "login:"

msgid "MSG_SENHA_LABEL"
msgstr "password:"
```

A ordem de processamento é sempre:
```
tr("MSG_CHAVE") → "[p=RED]Texto[/p] {icone} [[wait=1.0]]" → Parser do OmniTerm
```

> [!NOTE]
> **Inline Elements** (`{nome_cena}`) usam o nome do arquivo `.tscn`. Use nomes neutros como `{barra_progresso}` ou `{icone_check}` para que o mesmo nome funcione em todos os idiomas sem precisar criar cenas duplicadas.

### 4. Chaves de Sistema Obrigatórias

Para que o núcleo do OmniTerm (comandos integrados e erros) seja totalmente traduzido, você deve incluir estas chaves padrão nos seus arquivos `.po`:

| Chave | Uso | Valor Sugerido (PT-BR) |
|---|---|---|
| `CMD_CLEAR_DESC` | Descrição do comando `clear` | "Limpa o log do terminal." |
| `CMD_HELP_DESC` | Descrição do comando `help` | "Exibe a lista de comandos disponíveis." |
| `CMD_ERR_NOT_FOUND` | Erro de comando inexistente | "[p=RED]Comando não encontrado:[/p] %s" |
| `CMD_HELP_HEADER` | Cabeçalho do comando help | "[p=NEUTRAL]══════ COMANDOS ══════[/p]" |

### 5. Usando Chaves nos Resources

Ao invés de escrever o texto diretamente no campo `Text` do `TextEvent`, escreva a **chave de tradução**:

| Campo no Inspetor | Sem Tradução | Com Tradução |
|---|---|---|
| `TextEvent.text` | `"Bem vindo ao sistema."` | `"MSG_BEM_VINDO"` |
| `PromptEvent.text` | `"Aguardando identificação..."` | `"MSG_AGUARDANDO"` |
| `TextPromptEvent.label` | `"login:"` | `"MSG_LOGIN_LABEL"` |

O motor irá resolver a chave automaticamente no idioma ativo.

### 5. Trocando o Idioma em Runtime

Você pode criar um **comando de sistema** para trocar o idioma dentro do próprio terminal:

```gdscript
class_name LangCommand extends CommandBase

func _init() -> void:
	command_name = "lang"
	description = "Troca o idioma do sistema. Ex: lang en"

func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
	if args.is_empty():
		var locale = TranslationServer.get_locale()
		return CommandOutput.create("Idioma atual: [p=YELLOW]%s[/p]" % locale)

	var new_locale = args[0]
	var available = TranslationServer.get_loaded_locales()
	
	if new_locale not in available:
		return CommandOutput.create("[p=RED]Idioma não disponível:[/p] %s" % new_locale)
	
	TranslationServer.set_locale(new_locale)
	return CommandOutput.create("[p=GREEN]Idioma alterado para:[/p] %s" % new_locale)
```

### 6. Traduzindo Labels de Custom Inputs

Se você criou uma `Custom UI`, os textos internos dela **não** são processados automaticamente pelo OmniTerm. Para integrá-los, chame `tr()` manualmente no método `setup()`:

```gdscript
extends VBoxContainer

signal submitted(data)

func setup(params: Dictionary) -> void:
	$TituloLabel.text = tr("MSG_DIGITAR_CODIGO")
	$BotaoConfirmar.text = tr("MSG_CONFIRMAR")

func disable() -> void:
	set_process_input(false)
```

### 7. Exemplo Completo: Login Multilíngue

Com os arquivos `.po` configurados, o fluxo de login do Tutorial anterior fica automaticamente multilíngue:

- `seq_login_principal.tres` → `TextPromptEvent.label = "MSG_LOGIN_LABEL"`
- `seq_login_falha.tres` → `TextEvent.text = "MSG_ACESSO_NEGADO"`
- `seq_login_sucesso.tres` → `TextEvent.text = "MSG_ACESSO_OK"`

Ao chamar `TranslationServer.set_locale("en")`, o terminal exibirá tudo em inglês automaticamente na próxima vez que as sequências forem executadas.

> [!TIP]
> Use o editor **Poedit** (gratuito) para editar os arquivos `.po` com uma interface visual, verificação de erros e suporte a plurais. É a ferramenta padrão usada por tradutores profissionais.

---

## ⚔️ Capítulo 8: Arquitetura para um Terminal RPG

O OmniTerm é a camada de **interface e interação**. Para construir um RPG completo (batalhas, inventário, status, saves), você precisa de uma camada de **lógica de jogo** separada. Este capítulo define os padrões de arquitetura recomendados.

```
┌─────────────────────────────────────────┐
│          LÓGICA DO JOGO                 │
│  GameState · BattleManager · SaveSystem │
│           (Autoloads/Singletons)        │
└──────────────┬──────────────────────────┘
			   │  Comandos & Sinais (a ponte)
┌──────────────▼──────────────────────────┐
│              OMNITERM                   │
│  Exibe texto · Captura input · Narra    │
└─────────────────────────────────────────┘
```

### 1. O GameState (Autoload)

Crie um **Autoload** chamado `GameState` em **Project Settings > Autoload**. Ele guarda todo o estado persistente do jogo:

```gdscript
# res://autoloads/game_state.gd
extends Node

var player = {
	"name": "Sem Nome",
	"hp": 100,
	"max_hp": 100,
	"mp": 50,
	"max_mp": 50,
	"level": 1,
	"exp": 0,
	"gold": 0,
	"attack": 10,
	"defense": 5,
}

var inventory: Array[Dictionary] = []
var current_location: String = "Cidade Inicial"

func add_item(item: Dictionary) -> void:
	inventory.append(item)

func remove_item(item_name: String) -> bool:
	for i in range(inventory.size()):
		if inventory[i]["name"] == item_name:
			inventory.remove_at(i)
			return true
	return false

func save() -> void:
	var data = {"player": player, "inventory": inventory, "location": current_location}
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load_save() -> bool:
	if not FileAccess.file_exists("user://save.json"):
		return false
	var file = FileAccess.open("user://save.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	player = data["player"]
	inventory = data["inventory"]
	current_location = data["location"]
	return true
```

### 2. Comandos Como a Ponte

Cada sistema do RPG (status, inventário, loja) vira um **Comando** do OmniTerm que lê e escreve no `GameState`:

#### 📊 Comando `status`
```gdscript
class_name StatusCommand extends CommandBase

func _init() -> void:
	command_name = "status"
	description = "Exibe atributos do personagem."

func execute(_args: PackedStringArray, _ctx: CommandContext) -> CommandOutput:
	var p = GameState.player
	var hp_color = "GREEN" if p.hp > p.max_hp * 0.5 else ("YELLOW" if p.hp > p.max_hp * 0.25 else "RED")
	
	var text = "[p=NEUTRAL]══════ STATUS ══════[/p]\n"
	text += "Nome:   [p=YELLOW]%s[/p]  (Nível [p=GREEN]%d[/p])\n" % [p.name, p.level]
	text += "HP:     [p=%s]%d / %d[/p]\n" % [hp_color, p.hp, p.max_hp]
	text += "MP:     [p=NEUTRAL]%d / %d[/p]\n" % [p.mp, p.max_mp]
	text += "ATK:    [p=RED]%d[/p]  DEF: [p=NEUTRAL]%d[/p]\n" % [p.attack, p.defense]
	text += "Gold:   [p=YELLOW]%d[/p]  EXP: [p=NEUTRAL]%d[/p]" % [p.gold, p.exp]
	return CommandOutput.create(text)
```

#### 🎒 Comando `inv`
```gdscript
class_name InventoryCommand extends CommandBase

func _init() -> void:
	command_name = "inv"
	description = "Lista o inventário. Use: inv usar [item]"

func execute(args: PackedStringArray, _ctx: CommandContext) -> CommandOutput:
	if args.size() >= 2 and args[0] == "usar":
		return _use_item(args[1])
	
	if GameState.inventory.is_empty():
		return CommandOutput.create("[p=NEUTRAL]Inventário vazio.[/p]")
	
	var text = "[p=NEUTRAL]══════ INVENTÁRIO ══════[/p]\n"
	for item in GameState.inventory:
		text += "• [p=YELLOW]%s[/p] — %s\n" % [item.name, item.description]
	return CommandOutput.create(text)
```

### 3. Sinalização e Eventos Globais (Integração)

Para que o OmniTerm não seja apenas uma interface isolada, incluímos o sistema de **`SignalEvent`**. Ele permite que a sua história "fale" com o resto do jogo sem precisar de comandos.

#### 🎼 Exemplo: Mudando a Música via Sequência
Se você tiver um `MusicManager` (Autoload), pode inserir um `SignalEvent` no meio de um diálogo:
- `Action Id`: `"play_danger_theme"`

**No seu script do Gerenciador de Áudio:**
```gdscript
func _ready():
	# Conecta o sinal do seu Terminal
	terminal.action_triggered.connect(_on_terminal_action)

func _on_terminal_action(action_id: String):
	if action_id == "play_danger_theme":
		MusicManager.play("danger.ogg")
```

Essa separação garante que o OmniTerm cuide da **narrativa** enquanto seus outros sistemas cuidam da **lógica e atmosfera**.

func _use_item(item_name: String) -> CommandOutput:
	for item in GameState.inventory:
		if item.name.to_lower() == item_name.to_lower():
			if item.has("hp_restore"):
				GameState.player.hp = min(
					GameState.player.hp + item.hp_restore,
					GameState.player.max_hp
				)
				GameState.remove_item(item.name)
				return CommandOutput.create("[p=GREEN]%s usado![/p] +%d HP." % [item.name, item.hp_restore])
	return CommandOutput.create("[p=RED]Item não encontrado:[/p] %s" % item_name)
```

### 3. O Sistema de Batalha

A batalha vive em um **BattleManager** externo. Um comando `batalha` ou `atacar` aciona e relata os resultados:

```gdscript
# res://autoloads/battle_manager.gd
extends Node

var in_battle: bool = false
var current_enemy: Dictionary = {}

func start_battle(enemy: Dictionary) -> String:
	in_battle = true
	current_enemy = enemy.duplicate()
	return "[p=RED]%s[/p] apareceu!\nHP: [p=RED]%d[/p]" % [enemy.name, enemy.hp]

func player_attack() -> String:
	var dmg = max(1, GameState.player.attack - current_enemy.get("defense", 0) + randi_range(-2, 2))
	current_enemy.hp -= dmg
	var result = "Você atacou [p=RED]%s[/p] causando [p=YELLOW]%d[/p] de dano!\n" % [current_enemy.name, dmg]
	
	if current_enemy.hp <= 0:
		in_battle = false
		var exp = current_enemy.get("exp", 10)
		var gold = current_enemy.get("gold", 5)
		GameState.player.exp += exp
		GameState.player.gold += gold
		result += "[p=GREEN]%s foi derrotado![/p] +%d EXP, +%d Gold." % [current_enemy.name, exp, gold]
	else:
		# Contra-ataque do inimigo
		var enemy_dmg = max(1, current_enemy.get("attack", 5) - GameState.player.defense + randi_range(-1, 1))
		GameState.player.hp -= enemy_dmg
		result += "[p=RED]%s contra-atacou! -%d HP[/p]" % [current_enemy.name, enemy_dmg]
	
	return result
```

```gdscript
class_name AttackCommand extends CommandBase

func _init() -> void:
	command_name = "atacar"
	description = "Ataca o inimigo atual na batalha."

func execute(_args: PackedStringArray, _ctx: CommandContext) -> CommandOutput:
	if not BattleManager.in_battle:
		return CommandOutput.create("[p=RED]Você não está em batalha.[/p]")
	return CommandOutput.create(BattleManager.player_attack())
```

### 4. Narrativa Dinâmica (Textos com Variáveis)

Para exibir textos que mudam com base no estado do jogo (ex: *"Você tem 30 HP"*), crie um comando que **gera e toca uma StorySequence em tempo real**:

```gdscript
class_name ExploreCommand extends CommandBase

func _init() -> void:
	command_name = "explorar"
	description = "Explora a área atual."

func execute(_args: PackedStringArray, ctx: CommandContext) -> CommandOutput:
	var terminal = ctx.terminal
	terminal._mode = terminal.InputMode.IDLE
	
	_run_explore(terminal)
	return CommandOutput.create("Explorando [p=YELLOW]%s[/p]..." % GameState.current_location)

func _run_explore(terminal) -> void:
	# Gera texto dinâmico com o estado atual
	var intro = TextEvent.new()
	intro.text = "Você caminha por [p=YELLOW]%s[/p]. HP: [p=RED]%d/%d[/p]." % [
		GameState.current_location,
		GameState.player.hp,
		GameState.player.max_hp
	]
	
	var encontro = ChoiceEvent.new()
	encontro.text = "Você avista algo à frente..."
	encontro.options.assign(["Investigar", "Ignorar e descansar"])
	
	var seq_investigar = StorySequence.new()
	var txt_investigar = TextEvent.new()
	txt_investigar.text = "[p=RED]Um inimigo surge![/p]\n" + BattleManager.start_battle({
		"name": "Goblin", "hp": 30, "attack": 6, "defense": 2, "exp": 15, "gold": 8
	})
	seq_investigar.events.append(txt_investigar)
	
	var seq_descansar = StorySequence.new()
	var txt_descansar = TextEvent.new()
	var restore = mini(20, GameState.player.max_hp - GameState.player.hp)
	GameState.player.hp += restore
	txt_descansar.text = "Você descansa. [p=GREEN]+%d HP[/p] recuperado." % restore
	seq_descansar.events.append(txt_descansar)
	
	encontro.branches.assign([seq_investigar, seq_descansar])
	
	var seq = StorySequence.new()
	seq.events.append(intro)
	seq.events.append(encontro)
	
	await terminal.play_sequence(seq)
	terminal.create_new_line()
```

### 5. Padrões de Design Recomendados

| Padrão | Recomendação |
|---|---|
| **Estado do Jogo** | Sempre num Autoload. Nunca dentro de comandos. |
| **Lógica de RPG** | BattleManager, ShopManager, QuestManager — todos Autoloads separados. |
| **Narrativa Fixa** | Use `.tres` criados no Inspetor do Godot. |
| **Narrativa Dinâmica** | Gere `StorySequence` por código dentro de comandos. |
| **Saves** | `GameState.save()` chamado no final de cada comando importante. |
| **Notificações Externas** | Use `terminal.action_triggered` para avisar outros sistemas (ex: abrir mapa). |

> [!IMPORTANT]
> Mantenha o OmniTerm **sempre ignorante** da lógica do jogo. Ele só exibe e captura. Toda decisão sobre HP, dano e inventário deve estar nos Autoloads. Isso garante que você pode trocar a interface no futuro sem reescrever o jogo.





---

## 📑 Capítulo 9: Referência Técnica e Utilitários

Este capítulo serve como uma referência técnica profunda para desenvolvedores que desejam estender as funcionalidades do OmniTerm ou criar sistemas de jogo complexos.

### 1. Paleta de Cores do System (`[p=COR]` ou `[p=COR:INTENSIDADE]`)

O OmniTerm utiliza uma paleta de cores curada para garantir acessibilidade e harmonia visual. A tag possui dois modos de uso:

- **Básico**: `[p=GREEN]` — Usa a intensidade padrão (3).
- **Avançado**: `[p=GREEN:6]` — Define o nível de brilho manualmente.

| Parâmetro | Valores | Descrição |
|---|---|---|
| **COR** | `RED`, `BLUE`, `GREEN`, etc. | O nome da constante da paleta (veja tabela abaixo). |
| **INTENSIDADE** | `0` a `6` | O nível de brilho. `0` é o tom mais escuro, `3` é o padrão, e `6` é o mais brilhante. |

| Nome da Cor | Descrição / Uso Sugerido |
|---|---|
| `RED` | Erros, perigo, alertas críticos, HP baixo. |
| `BLUE` | Informações de sistema, links, nomes de máquinas. |
| `GREEN` | Sucesso, logs positivos, regeneração, mensagens de boot. |
| `YELLOW` | Atenção, itens importantes, ouros/moedas, avisos. |
| `ORANGE` | Avisos secundários, status alterados. |
| `TEAL_GREEN` | Terminal retrô, consoles de segurança. |
| `PINK` | Comandos especiais, interações de IA. |
| `NEUTRAL` | Texto padrão, separadores, bordas. |

> [!TIP]
> Use intensidades baixas (0-2) para textos de fundo ou "ruído de sistema" e intensidades altas (5-6) para mensagens que precisam de destaque imediato ou cabeçalhos.

> [!TIP]
> Você ainda pode usar cores hexadecimais padrão do BBCode (ex: `[color=#ffffff]`), mas o uso das tags de paleta (`[p=...]`) garante que seu jogo mantenha a identidade visual mesmo se a paleta base for alterada.

### 2. Anatomia de um Comando (`args` e `Context`)

Ao criar um comando injetando `CommandBase`, você recebe dois parâmetros vitais no método `execute`:

#### O Array `args` (Argumentos)
O motor divide automaticamente o que o usuário digita nos espaços.
- **Input**: `hackear sistema 09`
- **`args[0]`**: `"sistema"`
- **`args[1]`**: `"09"`

#### O `CommandContext`
Atualmente, o context expõe o objeto `terminal`. Isso permite que o comando manipule o estado direto do motor:
```gdscript
func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
	var terminal = context.terminal
	# Agora você tem acesso a tudo do terminal...
```

### 3. Limpando a Tela (`clear_terminal`)

Você pode limpar todo o histórico visual do terminal a qualquer momento. Isso é útil para comandos "clear" ou transições de atos na história.

**De dentro de um Comando:**
```gdscript
func execute(args: PackedStringArray, context: CommandContext) -> CommandOutput:
	context.terminal.clear_terminal()
	return CommandOutput.create("") # Retorna vazio pois a tela sumiu
```

### 4. Congelamento de Histórico (Auto-Freeze)

O OmniTerm implementa uma política de **"Segurança de Estado"**. Toda vez que uma nova linha de comando (`COMMAND` mode) é criada através de `create_new_line()`, o motor executa o `_freeze_history()`.

**O que isso faz?**
- Desabilita todos os botões e inputs anteriores.
- Define `mouse_filter = IGNORE` em todos os elementos passados.
- Impede que o jogador clique em opções de uma conversa que já terminou ou tente digitar em um formulário antigo.

> [!IMPORTANT]
> Se você criar um **Custom Input** complexo, certifique-se de implementar uma função `func disable() -> void:` nele. O OmniTerm a chamará automaticamente quando o componente "morrer" no histórico.

### 5. Cadência Narrativa com `delay`

A propriedade `delay` em recursos de `TextEvent` ou `PromptEvent` define quantos segundos o motor deve "esperar em silêncio" antes de imprimir o bloco de texto.

**Exemplo de uso prático:**
1. Evento 1: "Iniciando quebra de segurança..."
2. Evento 2: "Processando... (Delay: 2.0)"
3. Evento 3: "[p=GREEN]Sucesso![/p]"

Isso cria uma tensão dramática muito superior a despejar todos os textos de uma vez.

### 6. Executando Sequências via Código

Você não precisa depender apenas da `Intro Sequence`. Você pode disparar qualquer sequência de qualquer lugar do seu jogo:

```gdscript
@onready var terminal = $Terminal

func _on_player_died():
	var seq = preload("res://sequences/game_over.tres")
	terminal.play_sequence(seq)
```

O método `play_sequence(sequence: StorySequence)` é assíncrono (`await`), permitindo que você espere a história acabar para tomar uma ação na sua lógica de jogo.

---

---

## 💎 Capítulo 10: Polimento Final e UI Inteligente

Este capítulo cobre as funcionalidades de "Qualidade de Vida" (QoL) que transformam o OmniTerm em uma ferramenta profissional e imersiva.

### 1. Histórico de Comandos (UX)

O terminal agora armazena automaticamente todos os comandos que você digita com sucesso.
- **Seta para Cima**: Navega para o comando anterior.
- **Seta para Baixo**: Volta para o comando mais recente ou limpa o input se estiver no fim do histórico.

> [!NOTE]
> O histórico é resetado toda vez que o jogo é fechado, a menos que você estenda o `Terminal.gd` para salvar o array `_command_history` em um arquivo de save.

### 2. Autocomplete e Ghost Text (Sugestões)

Inspirado no *Fish Shell*, o OmniTerm oferece sugestões em tempo real conforme você digita.
- **Visual**: Um texto cinza semitransparente aparece atrás do seu cursor sugerindo o comando correspondente.
- **Interação**: Pressione **Tab** para aceitar a sugestão e preencher a linha instantaneamente.

### 3. Sistema de Áudio Avançado (Data-Driven)

O OmniTerm possui uma "Engine de Áudio" própria para sons de digitação (typewriter), tornando a experiência tátil e imersiva.

#### Configurando o Banco de Sons
1. Crie um novo Resource do tipo `TerminalSoundBank`.
2. No dicionário **Sounds**, adicione entradas (ex: Key: "default", Value: Seu arquivo .wav).
3. Arraste esse resource para a propriedade **Sound Bank** no inspetor do nó Terminal.

#### Propriedades do SoundBank
- **Default Pitch Range**: Define a oscilação aleatória do tom do som (ex: 0.9 a 1.1). Isso evita que o som de "clique" pareça irritante e robótico.
- **Default Volume DB**: Controle de volume global para os sons de interface.

#### Customização por Evento
No Inspetor de qualquer `TextEvent`, você encontrará o campo `Sound Id`. Se você preencher com um ID que exista no seu SoundBank, o terminal usará esse som específico para aquele bloco de texto.

#### Múltiplos Sons por Frase (Tags)
Assim como a velocidade e as cores, você pode mudar o som da digitação **no meio de uma frase** usando a tag de ação:
- `[[sound=ID]]` ou `[[audio=ID]]`

**Exemplo de uso:**
`"O sistema diz: [[sound=robot]]BIP BUP. [[sound=whisper]]Mas eu digo... olá."`

Isso permite criar diálogos dinâmicos onde a "voz" do terminal muda conforme a narrativa exige.

### 4. Comando Utilitário Embutido: `clear`

O motor agora vem com o comando `clear` já configurado na pasta de comandos internos (builtin). Ele limpa todo o histórico visual, mantendo apenas a linha de comando atual.

---

Este conclui o Manual do Desenvolvedor OmniTerm. Com este sistema, você tem em mãos um motor narrativo completo, performático e extremamente polido para criar o seu próximo Terminal RPG ou aventura de hacking.

**Boa sorte, Operador.** 👨‍💻
