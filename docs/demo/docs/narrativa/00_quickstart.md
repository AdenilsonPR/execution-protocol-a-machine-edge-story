# Quick Start - Demo

Guia rápido para entender a demo.

---

## O que é Execution Protocol?

Um spinoff de [[The Machine's Edge]] onde você é uma consciência humana em um servidor, operando um robô através de terminal.

---

## Fluxo da Demo

```
TUTORIAL (5 min)
  help, status, clear
    ↓
MISSÃO 1 (5 min)
  Verificar perímetro
  Derrotar 3 Electrotrions
  Recompensa: 50 scraps
    ↓
MISSÃO 2 (5 min)
  Investigar atividade anômala
  Derrotar 5 Perseguidor + 1 Atirador
  Drop: Dispositivo Criptografado
    ↓
DECRYPTION
  Comprar Drive (200 scraps)
  Resolver 8 blocos
  Revelação final
    ↓
FIM
```

---

## Comandos Essenciais

| Comando | Função |
|---------|--------|
| `help` | Ver comandos |
| `status` | Ver stats |
| `mission` | Ver missão atual |
| `shop` | Abrir loja |
| `chat [npc]` | Falar com NPC |
| `attack` | Atacar (combate) |
| `defend` | Defender (combate) |
| `save quick` | Quick save |

---

## NPCs

| NPC | Função | Comando |
|-----|--------|---------|
| Reyes | Missões | `chat reyes` |
| Chen | Dicas | `chat chen` |
| Vasquez | Lore | `chat vasquez` |

---

## Atributos

| Atributo | Efeito |
|----------|--------|
| Potência | Dano |
| Precisão | Crítico + Acurácia |
| Núcleo | Escudo + Energia |
| Manobra | Velocidade + Fuga |
| Densidade | Dano crítico |

---

## Inimigos

| Inimigo | HP | Dano | Notas |
|---------|-----|------|-------|
| Perseguidor | 50-60 | 10-15 | Rápido, melee |
| Atirador | 30-40 | 15-20 | distance |
| Granada | 40-50 | 25-35 | Área |
| Gerador | 60-70 | - | Spawna minions |

---

## Dicas

1. **Derrote Geradores primeiro** — spawna mais inimigos
2. **Guarde scraps** — precise de 200 para Drive
3. **Fale com Chen** — dicas de combate
4. **Fale com Vasquez** — ganha chave para puzzle

---

## Para Desenvolvedores

Ver [[08_implementacao]] para requisitos técnicos.

---

## Links

- [[01_narrativa|Narrativa completa]]
- [[02_terminal|Todos os comandos]]
- [[03_combate|Combat spec]]
- [[04_shop|Shop]]
- [[05_chat|Chat]]
- [[06_decryption|Puzzle]]
- [[07_save|Save]]
- [[08_implementacao|Tech specs]]