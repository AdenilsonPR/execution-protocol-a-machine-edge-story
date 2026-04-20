# TASK 009: NARRATIVA

## Objetivo
Implementar o fluxo narrativo completo da demo com diálogos.

## Estimativa: 6-8 horas

---

## Conteúdo

### Fluxo Narrativo

```
┌─────────────────────────────────────────────────────────────────────┐
│                       FLUXO DA DEMO                                 │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  01_00_boot                                                      │
│       │                                                          │
│       ├─ Mensagem de boot do sistema                              │
│       ├─ [ALERTA] Kernel v.9.4 detectado...                      │
│       └─ > Unidade #2227: ONLINE                                  │
│                                                                     │
│  03_01_reyes_boasvindas                                           │
│       │                                                          │
│       ├─ [1] Missões → 03_02_reyes_tutorial                      │
│       ├─ [2] Como estou? → LOOP (menu)                            │
│       └─ [3] O que aconteceu? → LOOP (menu)                       │
│                                                                     │
│  03_02_reyes_tutorial                                             │
│       │                                                          │
│       ├─ Ensina comandos (help, status, clear)                   │
│       └─ → 03_03_missao1_reyes                                   │
│                                                                     │
│  03_03_missao1_reyes                                              │
│       │                                                          │
│       ├─ Explica missão 1: Varredura Perimetral                  │
│       └─ → 03_05_missao1_inicio (COMBATE)                        │
│                                                                     │
│  03_05_missao1_inicio ─────────────────────────────────────────   │
│       │        COMBATE                                            │
│       │   DERROTAR 3x Perseguidor                                │
│       │   Recompensa: 50 scraps                                   │
│       │        │                                                   │
│       └───────┼───────────────────────────────────────────────────┘ │
│               ↓                                                   │
│  03_06_missao1_conclusao                                          │
│       │                                                          │
│       ├─ Recompensa concedida                                      │
│       ├─ "Boa noite de trabalho"                                  │
│       └─ → 03_07_missao2_reyes                                    │
│                                                                     │
│  03_07_missao2_reyes                                              │
│       │                                                          │
│       ├─ Nova missão: Atividade Anômala                          │
│       └─ → 03_08_missao2_vasquez (OPCIONAL)                       │
│                                                                     │
│  03_08_missao2_vasquez (OPCIONAL)                                 │
│       │                                                          │
│       ├─ [1] Sobre anomalia → Pistas                              │
│       ├─ [2] O que pesquisa → "bug ambulante"                    │
│       └─ [3] Sair → 03_09_missao2_inicio                          │
│                                                                     │
│  03_09_missao2_inicio ─────────────────────────────────────────   │
│       │        COMBATE + DROP                                     │
│       │   5x Perseguidor + 1x Atirador                            │
│       │   DROP: Dispositivo Criptografado                         │
│       │        │                                                   │
│       └───────┼───────────────────────────────────────────────────┘ │
│               ↓                                                   │
│  03_10_missao2_conclusao                                          │
│       │                                                          │
│       ├─ Dispositivo no inventário                                │
│       ├─ Dica: precisa drive                                      │
│       └─ → LOOP (farm) ou 03_11_fim_demo                          │
│                                                                     │
│  03_11_fim_demo                                                   │
│       │                                                          │
│       ├─ Se tem drive: analisar dispositivo                       │
│       │   Resultado: 87% descriptografado                        │
│       │   Fragmento 8: [ERRO]                                   │
│       │                                                          │
│       └─ [CONEXÃO ENCERRADA]                                     │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

### Script JSON (OmniNarrative)

```json
{
  "id": "demo_missao_1",
  "nodes": [
    {
      "id": "start",
      "type": "terminal",
      "text": "[LOG] Inicializando... [ALERTA] Kernel v.9.4 detectado em hardware legado.",
      "next": "boot_text"
    },
    {
      "id": "boot_text",
      "type": "terminal",
      "text": "> Carregando consciencia...\n> [AVISO] Driver optico incompativel.\n> [ALERTA] Arquitetura detectada: Rede Neural v7 (obsoleto)\n> [SISTEMA] Convertendo para interface textual...\n> [NOTA] Sensores visuais desabilitados por seguranca.\n> Transferencia incompleta.\n> Unidade #2227: ONLINE",
      "next": "connect_reyes"
    },
    {
      "id": "connect_reyes",
      "type": "chat",
      "contact": "reyes",
      "text": "Conectando com Comandante Reyes...",
      "next": "reys_greeting"
    },
    {
      "id": "reys_greeting",
      "type": "choice",
      "choices": [
        { "text": "Missões", "next": "reys_missions" },
        { "text": "Como estou?", "next": "reys_status" },
        { "text": "Sair", "next": "exit" }
      ]
    }
  ]
}
```

---

### Integração com Terminal

```gdscript
# narrative_command.gd
class_name NarrativeCommand extends CommandBase


func _init() -> void:
    super._init()
    id = "narrative"
    description = "Avança narrativa"


func execute(context: CommandContext) -> CommandOutput:
    if NarrativeManager.has_current_node():
        NarrativeManager.advance()
        return CommandOutput.new(true, "")
    return CommandOutput.new(false, "Nenhuma narrativa ativa.")
```

---

### Dispositivo (Puzzle)

```gdscript
# dispositivo_puzzle.gd
extends Control

var blocos: Array = []
var blocos_desbloqueados: Array = []
var drive_installed: bool = false


func _ready() -> void:
    _setup_puzzle()


func _setup_puzzle() -> void:
    blocos = [
        { "id": 1, "tipo": "identificacao", "status": "ok" },
        { "id": 2, "tipo": "timestamp", "status": "ok" },
        { "id": 3, "tipo": "log_sistema", "status": "locked", "chave": "parcial" },
        { "id": 4, "tipo": "mensagem", "status": "locked", "chave": "sequencia" },
        { "id": 5, "tipo": "coordenadas", "status": "locked", "chave": "cifra" },
        { "id": 6, "tipo": "analise", "status": "locked", "chave": "codigo" },
        { "id": 7, "tipo": "aviso", "status": "locked", "chave": "padrao" },
        { "id": 8, "tipo": "dados", "status": "locked", "chave": "fragmento" }
    ]


func has_drive() -> bool:
    return InventoryManager.has_item("drive_leitura")


func install_drive() -> void:
    drive_installed = true
    _desbloquear_blocos_automaticos()


func _desbloquear_blocos_automaticos() -> void:
    blocos[0].status = "ok"
    blocos[1].status = "ok"
    blocos_desbloqueados = [1, 2]


func calcular_progresso() -> float:
    var ok_count: int = 0
    for b in blocos:
        if b.status == "ok":
            ok_count += 1
    return float(ok_count) / blocos.size()


func resolver_chave(bloco_id: int, resposta: String) -> bool:
    var bloco: Dictionary = blocos[bloco_id - 1]

    if bloco.chave == "parcial":
        return resposta == "2227"
    if bloco.chave == "sequencia":
        return resposta == "32"
    if bloco.chave == "cifra":
        return resposta == "pewqe"
    if bloco.chave == "codigo":
        return resposta == "vi"
    if bloco.chave == "padrao":
        return resposta == "perigo"

    return false
```

---

### Diálogos Finais

#### 03_11_fim_demo.md (Resultado)

```
> USAR DRIVE DE LEITURA...
> [ARQUIVO_RECUPERADO_FRAGMENTO_7]:

"Se voce esta lendo isso, a transferencia falhou."
"A unidade original foi deletada."
"Eles mentiram sobre o backup do Kernel."

[ERRO CRITICO] Conteudo bloqueado.
[AVISO] Tentativa de acesso nao autorizada ao Fragmento 8.
[LOG] Sistema em sobrecarga.

...por que voce ainda consegue ler esses logs?

[CONEXAO ENCERRADA]
```

---

## Checkpoint

Após completar, o projeto deve ter:
- [ ] Fluxo narrativo completo
- [ ] Scripts JSON (OmniNarrative)
- [ ] Integração terminal ↔ narrativa
- [ ] Dispositivo com puzzle
- [ ] Fim da demo com gancho

---

## Dependências

- [[task_001_estrutura_base|TASK 001: ESTRUTURA BASE]]
- [[task_002_autoloads|TASK 002: AUTOLOADS]]
- [[task_003_terminal_comandos|TASK 003: TERMINAL - COMANDOS]]
- [[task_005_chat_painel|TASK 005: CHAT - PAINEL]]
- [[task_007_missoes|TASK 007: MISSÕES]]
- [[task_008_inventario|TASK 008: INVENTÁRIO]]

---

## Dependentes

- [[task_010_testes|TASK 010: TESTES]]

---

## Próximo

[[task_010_testes|AVANÇAR → Task 010]]