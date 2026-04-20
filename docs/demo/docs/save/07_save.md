# Sistema de Save e Load

Esta página documenta o sistema de save/load do jogo.

## Visão Geral

O jogo utiliza o sistema **OmniSave** para persistência de dados. Saves são armazenados em formato JSON.

---

## Slots de Save

O jogo possui 4 slots de save:

| Slot | Tipo | Descrição |
|------|------|------------|
| 1 | Automático | Auto-save após missões |
| 2 | Batalha | Save manual durante combate |
| 3 | Livre | Slot vazio |
| 4 | Livre | Slot vazio |

---

## Comandos

### save [slot]

Salva o jogo no slot especificado.

```
> save

╔══════════════════════════════════════╗
║            SAVE GAME                 ║
╠══════════════════════════════════════╣
║ Slot 1: [AUTO]    2026-04-20 19:42 ║
║ Slot 2: [BATTLE]  2026-04-20 19:30 ║
║ Slot 3: [---VAZIO---]               ║
║ Slot 4: [---VAZIO---]               ║
╠══════════════════════════════════════╣
║ USE: save [slot]                     ║
║ QUICK: save quick                   ║
╚══════════════════════════════════════╝

> save 3

╔══════════════════════════════════════╗
║ SALVANDO...                          ║
╠══════════════════════════════════════╣
║ ✓ Status salvo                      ║
║ ✓ Posição narrativa salva         ║
║ ✓ Inventário salvo                ║
║ ✓ MISSÃO SALVA                     ║
╚══════════════════════════════════════╝
```

### save quick

Quick save no Slot 2 (substitui o anterior).

```
> save quick

╔══════════════════════════════════════╗
║ QUICK SAVE                           ║
╠══════════════════════════════════════╣
║ ✓ Jogo salvo no Slot 2              ║
║ ════════════════════════════════     ║
║ Use 'load 2' para carregar          ║
╚══════════════════════════════════════╝
```

### load [slot]

Carrega um save existente.

```
> load

╔══════════════════════════════════════╗
║           LOAD GAME                   ║
╠══════════════════════════════════════╣
║ Slot 1: [AUTO]    2026-04-20 19:42 ║
║ Slot 2: [BATTLE]  2026-04-20 19:30 ║
║ Slot 3: Missão 2    2026-04-20 18:15║
║ Slot 4: [---VAZIO---]               ║
╠══════════════════════════════════════╣
║ USE: load [slot]                      ║
╚══════════════════════════════════════╝

> load 3

╔══════════════════════════════════════╗
║ CARREGANDO...                        ║
╠══════════════════════════════════════╣
║ Carregando Missão 2...            ║
║ ✓-status carregado                ║
║ ✓Inventário carregado             ║
║ ✓Posição restaurada               ║
║ ════════════════════════════════     ║
║ Bem-vindo de volta, soldado!       ║
╚══════════════════════════════════════╝
```

---

## Auto-Save

O jogo faz auto-save automaticamente nos seguintes momentos:

| Momento | Slot | Notificação |
|--------|------|-------------|
| Após completar missão | 1 | "[AUTO-SAVE]" |
| Antes de combate difícil | 1 | "[CHECKPOINT]" |
| Ao adquirir item especial | 1 | "[AUTO-SAVE]" |
| Ao descriptografar dispositivo | 1 | "[save completo]" |

---

## Dados Salvos

### Estrutura do Save

```json
{
  "version": "1.0",
  "timestamp": "2026-04-20T19:42:00Z",
  "player": {
    "unit_id": "2227",
    "level": 3,
    "hp": 85,
    "max_hp": 100,
    "energia": 80,
    "max_energia": 100,
    "escudo": 45,
    "max_escudo": 80,
    "scraps": 350,
    "atributos": {
      "potencia": 15,
      "precisao": 10,
      "nucleo": 18,
      "manobra": 22,
      "densidade": 12
    }
  },
  "inventory": {
    "equipamentos": [
      {
        "tipo": "chip_potencia",
        "nivel": 1,
        "equipado": true
      },
      {
        "tipo": "chip_escudo",
        "nivel": 1,
        "equipado": true
      },
      null
    ],
    "consumiveis": {
      "kit_medico": 2,
      "granada_fragmentacao": 3,
      "granada_fumaca": 1
    },
    "especiais": [
      "dispositivo_criptografado"
    ]
  },
  "narrative": {
    "script_path": "res://scripts/missao_2.json",
    "current_node_id": "m2_combate_init",
    "variables": {
      "electrotrions_derrotados": 2,
      "dispositivo_obtido": true,
      "conversa_vasquez": true
    }
  },
  "chat": {
    "contacts_descobertos": [
      "reyes",
      "chen",
      "vasquez"
    ],
    "mensagens_lidas": [
      "reyes_bemvinda",
      "chen_tutorial",
      "vasquez_pista"
    ]
  },
  "missoes": {
    "ativa": "m2_varredura",
    "progresso": {
      "m1_conexao": "completa",
      "m2_varredura": 2,
      "m3_anomalia": "disponivel"
    }
  },
  "localizacao": "base_delta_7"
}
```

---

## Validação de Save

Ao carregar, o sistema verifica:

### Verificações Automáticas

| Verificação | Ação se Falhar |
|------------|--------------|
| Versão do save | "Save incompatível" |
| Integridade JSON | "Save corrompido" |
| Recursos do player | Reset parcial |
| Posição narrativa | Retorna ao último checkpoint |

---

## Mensagens de Erro

### Save

| Erro | Significado |
|------|-------------|
| "Slot ocupado" | Escolher outro slot |
| "Erro ao salvar" | Tentar novamente |
| "Armazenamento cheio" | Apagar saves antigos |

### Load

| Erro | Significado |
|------|-------------|
| "Slot vazio" | Não há save neste slot |
| "Save corrompido" | Tentar outro slot |
| "Versão incompatível" | Update necessário |

---

## Gerenciamento de Saves

### Deletar Save

```
> save delete 3

╔══════��═══════════════════════════════╗
║ DELETAR SAVE                        ║
╠══════════════════════════════════════╣
║ Confirmar exclusão do Slot 3? (s/n)   ║
╚══════════════════════════════════════╝
```

---

## Limites

| Limite | Valor |
|--------|-------|
| Slots disponíveis | 4 |
| Saves por slot | 1 (sobrescreve) |
| Tamanho máximo | ~50KB |
| Histórico de saves | Apenas último |

---

## Dicas

1. **Sempre faça manual save** antes de missões importantes
2. **Quick save** é útil antes de combate
3. **Slots 3 e 4** são melhores para saves de exploração
4. **Auto-save** não substitui manual save

---

## Testes de Save

Durante o combate, apenas estes dados são salvos:

```
> save

╔══════════════════════════════════════╗
║ AVISO: MODO COMBATE                  ║
╠══════════════════════════════════════╦╣
║ Alguns dados não serão salvos:      ║
║   - HP/Energia atuais               ║
║   - Posição no combate              ║
║   - Estado de inimigo              ║
║                                     ║
║ Recomenda-se salvar após o combate   ║
╚══════════════════════════════════════╝
```

---

## Integração

O sistema de save integra com:

- **[[02_terminal]]**: Estado do terminal
- **[[03_combate]]**: Estado de combate
- **[[04_shop]]**: Inventário
- **[[05_chat]]**: Mensagens lidas
- **[[06_decryption]]**: Progresso de descriptografia
- **[[01_narrativa]]**: Posição narrativa

---

## Links

- [[01_narrativa]] — Fluxo narrativo
- [[02_terminal]] — Comandos do terminal
- [[03_combate]] — Sistema de combate
- [[04_shop]] — Loja e inventory
- [[05_chat]] — NPCs
- [[06_decryption]] — Quebra-cabeça
- [[08_implementacao]] — Implementação