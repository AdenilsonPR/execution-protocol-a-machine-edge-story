# TASK 010: TESTES

## Objetivo
Testar e validar todos os sistemas implementados.

---

## Estimativa: 8-10 horas

---

## Conteúdo

### Testes Unitários

#### Teste: GameManager

```gdscript
func test_start_new_game() -> void:
    GameManager.start_new_game()
    assert_eq(GameManager.player_data.unit_id, "2227")
    assert_eq(GameManager.player_data.level, 1)
    assert_eq(GameManager.player_data.hp, 100)


func test_add_scraps() -> void:
    var initial: int = GameManager.get_scraps()
    GameManager.add_scraps(50)
    assert_eq(GameManager.get_scraps(), initial + 50)


func test_spend_scraps() -> void:
    GameManager.add_scraps(100)
    assert_true(GameManager.spend_scraps(50))
    assert_eq(GameManager.get_scraps(), 50)
    assert_false(GameManager.spend_scraps(100))


func test_take_damage() -> void:
    GameManager.player_data.escudo = 80
    GameManager.player_data.hp = 100
    GameManager.take_damage(50)
    assert_eq(GameManager.player_data.escudo, 30)
    assert_eq(GameManager.player_data.hp, 100)


func test_take_damage_excess() -> void:
    GameManager.player_data.escudo = 0
    GameManager.player_data.hp = 100
    GameManager.take_damage(50)
    assert_eq(GameManager.player_data.escudo, 0)
    assert_eq(GameManager.player_data.hp, 50)
```

---

#### Teste: InventoryManager

```gdscript
func test_add_item() -> void:
    InventoryManager.add_item("kit_medico", 3)
    assert_eq(InventoryManager.get_count("kit_medico"), 3)


func test_remove_item() -> void:
    InventoryManager.add_item("kit_medico", 5)
    InventoryManager.remove_item("kit_medico", 2)
    assert_eq(InventoryManager.get_count("kit_medico"), 3)


func test_equip_item() -> void:
    var chip: Equipment = Equipment.new({
        "id": "chip_potencia",
        "name": "Chip de Potência",
        "type": Item.ItemType.EQUIPAMENTO,
        "slot": Equipment.EquipmentSlot.ACESSORIO,
        "stats": { "potencia": 5 }
    })
    InventoryManager.equip(0, chip)
    assert_not_null(InventoryManager.get_equipped(0))


func test_calculate_bonus() -> void:
    var chip: Equipment = Equipment.new({
        "id": "chip_potencia",
        "name": "Chip de Potência",
        "type": Item.ItemType.EQUIPAMENTO,
        "slot": Equipment.EquipmentSlot.ACESSORIO,
        "stats": { "potencia": 5 }
    })
    InventoryManager.equip(0, chip)
    assert_eq(InventoryManager.calculate_bonus("potencia"), 5)
```

---

#### Teste: BattleManager

```gdscript
func test_start_battle() -> void:
    var enemies: Array = [
        { "type": Enemy.EnemyType.PERSEGUIDOR, "count": 3 }
    ]
    BattleManager.start_battle(enemies)
    assert_eq(BattleManager.current_state, BattleManager.BattleState.PLAYER_TURN)
    assert_eq(BattleManager.current_enemies.size(), 3)


func test_player_attack() -> void:
    var enemies: Array = [
        { "type": Enemy.EnemyType.PERSEGUIDOR, "count": 1 }
    ]
    BattleManager.start_battle(enemies)
    var initial_hp: int = BattleManager.current_enemies[0].hp
    BattleManager.player_attack(0)
    assert_lt(BattleManager.current_enemies[0].hp, initial_hp)


func test_calculate_damage() -> void:
    GameManager.player_data.atributos["potencia"] = 15
    GameManager.player_data.atributos["precisao"] = 10
    var damage: int = BattleManager._calculate_player_damage()
    assert_ge(damage, 15)
    assert_le(damage, 25)
```

---

#### Teste: MissionManager

```gdscript
func test_start_mission() -> void:
    MissionManager.start_mission("m1_conexao")
    assert_not_null(MissionManager.current_mission)
    assert_eq(MissionManager.current_mission.id, "m1_conexao")


func test_update_progress() -> void:
    MissionManager.start_mission("m2_varredura")
    MissionManager.update_enemy_kills(1)
    assert_eq(MissionManager.current_mission.progress, 1)


func test_complete_mission() -> void:
    MissionManager.start_mission("m1_conexao")
    MissionManager.update_progress("conectar", 1)
    assert_true(MissionManager.current_mission.is_complete())
    assert_true(MissionManager.is_mission_completed("m1_conexao"))
```

---

### Testes de Integração

#### Teste: Novo Jogo Completo

```gdscript
func test_new_game_flow() -> void:
    GameManager.start_new_game()

    assert_eq(GameManager.player_data.unit_id, "2227")
    assert_eq(GameManager.get_scraps(), 0)
    assert_eq(GameManager.player_data.hp, 100)

    assert_null(MissionManager.current_mission)

    GameManager.add_scraps(50)
    assert_eq(GameManager.get_scraps(), 50)
```

#### Teste: Missão Completa

```gdscript
func test_missao_1_completa() -> void:
    GameManager.start_new_game()
    MissionManager.start_mission("m2_varredura")

    while not MissionManager.current_mission.is_complete():
        MissionManager.update_enemy_kills(1)

    assert_true(MissionManager.is_mission_completed("m2_varredura"))
    assert_eq(GameManager.get_scraps(), 50)
```

#### Teste: Compra na Loja

```gdscript
func test_comprar_item() -> void:
    GameManager.add_scraps(100)
    var initial: int = GameManager.get_scraps()

    Shop.buy("kit_medico")

    assert_eq(GameManager.get_scraps(), initial - 25)
    assert_true(InventoryManager.has_item("kit_medico"))


func test_comprar_item_sem_scraps() -> void:
    GameManager.spend_scraps(GameManager.get_scraps())

    var result: bool = Shop.buy("kit_medico")

    assert_false(result)
```

---

### Testes de UI

#### Teste: Terminal

```gdscript
func test_help_command() -> void:
    var context: CommandContext = CommandContext.new("help", [], GameManager.player_data)
    var result: CommandOutput = HelpCommand.new().execute(context)

    assert_true(result.success)
    assert_true(result.message.contains("help"))
    assert_true(result.message.contains("status"))


func test_status_command() -> void:
    var context: CommandContext = CommandContext.new("status", [], GameManager.player_data)
    var result: CommandOutput = StatusCommand.new().execute(context)

    assert_true(result.success)
    assert_true(result.message.contains("2227"))
    assert_true(result.message.contains("HP:"))
```

---

### Checklist de Testes

| Sistema | Testes | Status |
|---------|--------|--------|
| GameManager | 5 | [ ] |
| InventoryManager | 4 | [ ] |
| BattleManager | 3 | [ ] |
| MissionManager | 3 | [ ] |
| Comandos | 2 | [ ] |
| Integração | 3 | [ ] |
| **Total** | **20** | [ ] /20 |

---

### Testes Manuais

| # | Teste | Esperado | OK |
|----|------|--------|---|
| 1 | Executar > boot | Mensagem de boot aparece | [ ] |
| 2 | Digitar help | Lista de comandos | [ ] |
| 3 | Digitar status | Status do jogador | [ ] |
| 4 | Digitar chat reyes | Abre conversa | [ ] |
| 5 | Selecionar opção 1 | Vai para missão | [ ] |
| 6 | Iniciar combate | Menu de combate abre | [ ] |
| 7 | Derrotar inimigo | Recompensa dada | [ ] |
| 8 | Completar missão | Recompensa + próxima | [ ] |
| 9 | Digitar shop | Loja abre | [ ] |
| 10 | Comprar item | Item no inventário | [ ] |
| 11 | Usar kit médico | HP restaurado | [ ] |
| 12 | Digitar mapa | Mapa aparece | [ ] |
| 13 | Ver aba combate | Durante combate, aba ativa | [ ] |
| 14 | Ver status inimigos | HP dos inimigos | [ ] |
| 15 | Melhorar atributo | Atributo aumenta | [ ] |
| 16 | Salvar jogo | Save confirma | [ ] |
| 17 | Carregar jogo | Load confirma | [ ] |
| 18 | Obter dispositivo | Item no inventário | [ ] |
| 19 | Usar drive | Dispositivo desbloqueia | [ ] |

---

## Checkpoint

Após completar, o projeto deve ter:
- [ ] Testes unitários passando
- [ ] Testes de integração passando
- [ ] Testes manuais passando
- [ ] Demo jogável do início ao fim

---

## Dependências

- [[task_001_estrutura_base|TASK 001: ESTRUTURA BASE]]
- [[task_002_autoloads|TASK 002: AUTOLOADS]]
- [[task_003_terminal_comandos|TASK 003: TERMINAL - COMANDOS]]
- [[task_004_terminal_layout|TASK 004: TERMINAL - LAYOUT]]
- [[task_005_chat_painel|TASK 005: CHAT - PAINEL]]
- [[task_006_combate|TASK 006: COMBATE - SISTEMA]]
- [[task_007_missoes|TASK 007: MISSÕES]]
- [[task_008_inventario|TASK 008: INVENTÁRIO]]
- [[task_009_narrativa|TASK 009: NARRATIVA]]

---

## FIM

**Todas as tasks completas!**

A demo está pronta para implementação.

---

## Próximo

Iniciar implementação seguindo a ordem das tasks.