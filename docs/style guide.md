# Guia de Estilo - GDScript + Godot 4.x

Este documento segue as boas práticas oficiais da documentação Godot.

---

## Nomenclatura de Arquivos e Pastas

| Tipo | Regra | Exemplo |
|------|-------|---------|
| **Pastas** | `snake_case` | `src/core/parser/` |
| **Arquivos .gd** | `snake_case` | `player_controller.gd` |
| **Arquivos de cena** | `snake_case` | `player.tscn` |
| **Recursos** | `snake_case` | `player_data.tres` |

> **Nota**: `snake_case` evita problemas de sensibilidade a maiúsculas/minúsculas no Windows.

---

## Nomenclatura de Nós

| Tipo | Regra | Exemplo |
|------|-------|---------|
| **Nós** | `PascalCase` | `PlayerController` |
| **Cenas** | PascalCase (seguem o nó principal) | `MainMenu.tscn` → nó `MainMenu` |

---

## Nomenclatura de Código GDScript

| Tipo | Regra | Exemplo |
|------|-------|---------|
| **Variáveis** | `snake_case` | `var player_name: String` |
| **Funções** | `snake_case` | `func calculate_damage():` |
| **Classes** | `PascalCase` | `class_name Parser` |
| **Constantes** | `SCREAMING_SNAKE_CASE` | `const MAX_HEALTH: int = 100` |
| **Enums** | `PascalCase` (valores em UPPER) | `enum State { IDLE, RUNNING }` |

---

## Declaração de Classes

**Formato obrigatório** - `extends` na mesma linha do `class_name`:

```gdscript
class_name RunAllTests extends RefCounted


class_name Player extends Node


class_name CombatSystem extends Node
```

---

## Espaçamento

**Duas linhas em branco** entre:
- Declaração de classe e primeira variável/função
- Variáveis e funções
- Funções entre si
- Blocos de código logicamente diferentes

```gdscript
class_name RunAllTests extends RefCounted


var test_parser: Ref


var _internal_var: int;


static func run() -> void:
	print("test")


static func get_suites() -> Array:
	return []
```

---

## Type Hints

- **Sempre usar** em APIs públicas
- **Opcional** em funções internas privadas

```gdscript
# Bom (com type hint)
func take_damage(amount: int) -> void:
	pass

# Bom (sem hint, variável local)
var damage = 10
```

---

## Type Hints

- **Sempre usar** em APIs públicas
- **Opcional** em funções internas privadas
- **OBRIGATÓRIO** em todas as declarações de variáveis locais

```gdscript
# Bom (com type hint)
func take_damage(amount: int) -> void:
	pass

# Bom (com type hint explícito)
var damage: int = 10

# Bom (com type hint explícito)
var result: bool = check_condition()

# RUIM - NÃO USAR (tipo inferido com :=)
var keys_loaded := _load_keys()
var result := parser.parse("atacar")

# SEMPRE USAR - tipo explícito
var keys_loaded: bool = _load_keys()
var result: CommandParser.ParseResult = parser.parse("atacar")
```

> **Nota**: O uso de `:=` (inferência de tipo) causa problemas de compilação no Godot 4.x em alguns contextos. Sempre declare o tipo explicitamente.

---

## Preload vs Load

| Método | Quando usar |
|--------|-------------|
| `preload()` | Recursos conhecidos em tempo de compilação |
| `load()` | Recursos dinâmicos/carregados em runtime |

```gdscript
# Recursos fixos (preload)
const PlayerScene := preload("res://player.tscn")

# Recursos dinâmicos (load)
var enemy_scene = load("res://enemies/" + enemy_type + ".tscn")
```

---

## Nós e Cena

| Regra | Descrição |
|-------|-----------|
| **Definir valores antes de adicionar à árvore** | Alterar propriedades antes do `add_child()` para evitar cálculos desnecessários |
| **Encapsulamento** | Usar métodos públicos, não acessar variáveis diretamente |
| **Sinais** | Comunicação entre nós via signals, não referência direta |

```gdscript
# ERRADO - referência direta
other_node.health = 0

# CORRETO - via método/ sinal
other_node.take_damage(10)
other_node.damage_taken.connect(_on_damage_taken)
```

---

## Organização do Projeto (Addon)

```
project.godot
addons/
  omni_term/          # Pasta principal do plugin
    assets/           # Recursos internos (ícones, fontes, cores)
    src/              # Código-fonte organizado por domínio
      scripts/
        constants/
        effects/
        resources/
      terminal/
        commands/     # Built-in e Processador
        components/   # Cenas de UI (Input, Choice, etc)
docs/                 # Documentação e Manuais
main.tscn             # Cena de exemplo/entrada
```

---

## Regras Gerais

| Regra | Descrição |
|-------|-----------|
| **@export** | Configuração via editor |
| **Docstrings** | Em APIs públicas |
| **Getter/Setter** | Usar `get:` e `set:` para validação |
| **Limite de linha** | ~100 caracteres (recomendado) |
| **snake_case pastas/arquivos** | Evitar problemas de case sensitivity |
| **PascalCase nós** | Combina com editor Godot |
| **Sem comentários no código** | O código deve ser autoexplicativo. Nomes de funções e variáveis tornam comentários desnecessários. Comentários de linha (`#`) são **proibidos** |

---

## Referência

Este guia segue a documentação oficial: https://docs.godotengine.org/pt-br/4.x/tutorials/best_practices/index.html

---

_Última atualização: 2026-04-17_
_Tech Lead: Guia de Estilo GDScript_
