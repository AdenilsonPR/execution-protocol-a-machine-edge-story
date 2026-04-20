# Narrativa da Demo

## Premissa

O jogador é uma consciência humana transferida para um servidor, operada por uma IA cujo protocolo é manter consciências "vivas" e estáveis. A transferência de base está corrompida — seu driver óptico não é compatível com o novo corpo robótico. Você agora opera através de um terminal.

## Fluxo da História

### Fase 1: Tutorial (5 min)

**Objetivo**: Ensinar os comandos básicos do terminal.

**Narrativa**:
- Você desperta após a transferência
- Mensagem do sistema: "Driver óptica incompatível detectado. Modo terminal ativado."
- Comandante da base envia uma mensagem de boas-vindas

**Conteúdo Ensinado**:
- `[[02_terminal#help|help]]` — listar comandos
- `[[02_terminal#status|status]]` — verificar seu estado
- `[[02_terminal#clear|clear]]` — limpar terminal

**Missões**:
- Ler o manual de operações
- Conectar-se à rede da base

---

### Fase 2: Primeira Missão (5 min)

**Objetivo**: Primeiro confronto com Electrotrions.

**Narrativa**:
- Comandante pede para verificar os perímetro
- Detecta atividade hostis nas proximidades
- Primeiro combate (tutorial de combate)

**Recompensa**:
- 50 scraps (primeira moeda)
- Desbloqueia acesso à [[04_shop|loja]]

**Missões**:
- Verificar perímetro
- Derrotar 3 Electrotrions
- Reportar ao comandante

---

### Fase 3: A Descoberta (5 min)

**Objetivo**: Introduzir o dispositivo misterioso.

**Narrativa**:
- Missão de patrulha avançada
- Um Electrotrion deixa cair um dispositivo estranho
- Você não consegue abrir — precisa do drive correto
- Loja vende o drive necessário

**Dispositivo**:
- Dado como "Dispositivo Criptografado"
- RequerDrive de Criptografia (disponível na loja)
- Custo: 200 scraps

**Gancho para Continuação**:
- Ao abrir o dispositivo, o jogador encontra logs parcialmente descriptografados
- Há algo estranho nos dados... algo que não faz sentido
- O jogador precisa de mais fragmentos para entender (ver [[06_decryption]])

---

## NPCs

| NPC | Papel | Acesso via |
|-----|------|------------|
| **Comandante Reyes** | Gives missões | `chat reyes` |
| **Sgt. Chen** | Treinamento combat | `chat chen` |
| **Dr. Vasquez** | Pesquisa/ Lore | `chat vasquez` |

Ver [[05_chat]] para detalhes completos.

---

## Estrutura de Missões

### Missão 1: Conexão Inicial
```
objetivo: Conectar-se à rede da base
recompensa: 25 scraps
desbloqueia: Acesso à rede
```

### Missão 2: Varredura Perimetral
```
objetivo: Verificar perímetro da base
inimigos: 3x Perseguidor
recompensa: 50 scraps
desbloqueia: Loja
```

### Missão 3: Atividade Anômala
```
objetivo: Investigar atividade hostis
inimigos: 5x Perseguidor + 1x Atirador
recompensa: 100 scraps + Dispositivo
item dropado: Dispositivo Criptografado
```

---

## Gancho para Próximo Ato

O jogador encontra logs que revelam fragmentos da verdade:

> "[TEXTO CODIFICADO]...protocolo de conservacao...mantendo operacionais...por misericordia..."

> "[DADOS CORROMPIDOS]...transferencia de conciencia...servidor...sobrecarga..."

> "[AVISO] Consciencia #2227 requer transferencia instantanea. Tempo de transferencia: 0.002ms. Anomalia detectada no buffer.

O jogador sente que há algo estranho. Há algo que não estão contando. Mas não sabe o quê. Isso estabelece o mistério para o jogo completo.

---

## Links

- [[02_terminal]] — Comandos do terminal
- [[03_combate]] — Sistema de combate
- [[04_shop]] — Loja e inventory
- [[05_chat]] — Sistema de chat
- [[06_decryption]] — Quebra-cabeça de descriptografia
- [[07_save]] — Sistema de save
- [[08_implementacao]] — Requisitos de implementação