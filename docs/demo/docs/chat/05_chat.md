# Sistema de Chat e NPCs

Esta página documenta as interações com NPCs.

## Layout do Chat

O chat aparece em dois lugares:

### 1. Painel Lateral (Tempo Real)

Sempre visível no canto inferior esquerdo:

```
┌──────────────────┐
│ CHAT             │
├──────────────────┤
│ [Reyes] ●       │ ← Indicador de novas msg
│ [Chen]          │
│ [Vasquez]       │
├──────────────────┤
│ Reyes:          │
│ "Precisamos    │
│  conversar..."  │ ← Preview da última msg
│                  │
└──────────────────┘
```

- Atualiza em tempo real
- ● = novas mensagens não lidas
- Clique no NPC abre conversa completa

### 2. Terminal (Conversa Detalhada)

Usando comando `chat [npc]`:

```
> chat reyes

Conectando com Comandante Reyes...
[19:42] COMANDANTE REYES: Olá, soldado!
```

---

## Acessando o Chat

```
> chat [npc]

Exemplos:
  chat reyes    # Comandante Reyes
  chat chen     # Sgt. Chen
  chat vasquez  # Dr. Vasquez
```

### Navegação com Setas

As opções de diálogo são navegadas com **setas + Enter**:

```
╔══════════════════════════════════════╗
║ CONECTADO: COMANDANTE REYES         ║
╠══════════════════════════════════════╣
║   > [1] Missoes                     ║  ← Selecionado
║     [2] Como estou?                  ║
║     [3] Sair                          ║
╚══════════════════════════════════════╝

 [↑/↓] navegar   [ENTER] selecionar
```

| Tecla | Função |
|-------|--------|
| ↑ | Selecionar opção anterior |
| ↓ | Selecionar próxima opção |
| Enter | Confirmar seleção |
| Escape | Sair da conversa |

---

## NPCs Disponíveis

### Comandante Reyes

**Papel**: Comandante da base, fornece missões

**Disponibilidade**: Sempre disponível

**Menu de Opções**:
```
╔══════════════════════════════════════╗
║ CONECTADO: COMANDANTE REYES         ║
╠══════════════════════════════════════╣
║   > [1] Missoes                     ║
║     [2] Como estou?                  ║
║     [3] O que aconteceu?              ║
║     [4] Sair                          ║
╚══════════════════════════════════════╝

 [↑/↓] navegar   [ENTER] selecionar
```

**Exemplo de Dialogo**:

```
╔══════════════════════════════════════╗
║   > [1] Missoes                     ║
║     [2] Como estou?                  ║
║     [3] O que aconteceu?              ║
║     [4] Sair                          ║
╚══════════════════════════════════════╝

 [↑/↓] navegar   [ENTER] selecionar
```

Selecionando Missões:

```
╔══════════════════════════════════════╗
║ MISSOES DISPONIVEIS                   ║
╠══════════════════════════════════════╣
║   > [1] Varredura Perimetral         ║
║     [2] Atividade Anomala            ║
╚══════════════════════════════════════╝
```

---

### Sgt. Chen

**Papel**: Treinamento de combate, tips

**Disponibilidade**: Após completar Missão 1

**Funções**:
- Dicas de combate
- Explicação de atributos
- Tutorial de estratégia

**Menu de Opções**:
```
╔══════════════════════════════════════╗
║ CONECTADO: SGT. CHEN                 ║
╠══════════════════════════════════════╣
║   > [1] Tutorial de combate         ║
║     [2] Dicas sobre inimigos          ║
║     [3] Apenas dar oi                 ║
╚══════════════════════════════════════╝

 [↑/↓] navegar   [ENTER] selecionar
```

**Exemplo de Tutorial**:

```
╔══════════════════════════════════════╗
║   > [1] Tutorial de combate         ║
║     [2] Dicas sobre inimigos          ║
║     [3] Apenas dar oi                 ║
╚══════════════════════════════════════╝

 [↑/↓] navegar   [ENTER] selecionar
```

Selecionando Tutorial:

```
CHEN: "Combate, eh?"
CHEN: "Voce tem um sistema ATB. Barras de tempo."
CHEN: "Quando sua barra encher, voce age."
CHEN: "Se demorar... os inimigos tambem agem."
```

```
╔═════════════════════════════════���════╗
║ CONTROLES DE COMBATE               ║
╠══════════════════════════════════════╣
║ [UP/DOWN] - Selecionar acao         ║
║ [ENTER] - Confirmar                  ║
║ [ESC] - Cancelar                    ║
╠══════════════════════════════════════╣
║ ACÕES:                              ║
║ ATACAR - Ataca o inimigo            ║
║ DEFENDER - 50% menos dano           ║
║ USAR ITEM - Usa um item             ║
║ FUGIR - Tenta escapar               ║
╚══════════════════════════════════════╝
```

```
CHEN: "Entendeu? E basicamente isso. So nao morra."
```

---

### Dr. Vasquez

**Papel**: Pesquisa, lore, pistas misteriosas

**Disponibilidade**: Após completar Missão 2

**Importante**: Este NPC fornece fragmentos de lore que ajudam no [[06_decryption|quebra-cabeça de criptografia]].

**Menu de Opções**:
```
╔══════════════════════════════════════╗
║ CONECTADO: DR. VASQUEZ                ║
╠══════════════════════════════════════╣
║   > [1] Sobre a anomalia             ║
║     [2] O que voce pesquisa?          ║
║     [3] Apenas dar oi                 ║
╚══════════════════════════════════════╝

 [↑/↓] navegar   [ENTER] selecionar
```

**Fragmentos de Lore** (desbloqueados progressivamente):

```
[3] Teorias
> 3

DR. VASQUEZ: "Você encontrou algo estranho, não foi?"
DR. VASQUEZ: "Os logs... eu também vi algo."
DR. VASQUEZ: "Há algo que não nos contam sobre as transferências."
DR. VASQUEZ: "Você confia no que vê?"
DR. VASQUEZ: "Eu estou tentando decifrar. Mas preciso de mais dados."
[NOVA PISTA DESBLOQUEADA: Análise de Criptografia]

DR. VASQUEZ: "Use isso. Pode ajudar com o dispositivo que encontrou."
[ITEM RECEBIDO: Fragmento de Chave de Criptografia]
```

---

## Sistema de Mensagens

### Estrutura de Mensagem

```
[TIMESTAMP] REMETENTE: Mensagem...
```

Exemplo:
```
[14:32] COMANDANTE REYES: Boa sorte, soldado!
[14:32]         Estamos counting on you.
```

### Indicadores de Status

| Indicador | Significado |
|-----------|-------------|
| 🟢 Online | Disponível para chat |
| 🟡 Ausente | Temporariamente offline |
| 🔴 Offline | Não disponível |
| ⚠️ Anômalo | Comportamento estranho (story) |

---

## Respostas do Jogador

Em algumas conversas, você pode escolher respostas:

```
[14:32] COMANDANTE: "Você está pronto para a missão?"

[1] "Sim, estou pronto."
[2] "Preciso de mais informações."
[3] "Qual é a urgência?"

> 2

[14:32] VOCÊ: "Preciso de mais informações."
[14:32] COMANDANTE: "Entendo."
[14:32]         Os Electrotrions foram detectados"
[14:32]         a 500 metros da base."
[14:32]         Precisamos saber o que estão fazendo."
```

---

## Mensagens em Tempo Real

As mensagens chegam automaticamente no painel lateral:

```
┌──────────────────┐
│ CHAT             │
├──────────────────┤
│ [Reyes] ●       │ ← ● = nova mensagem
│ [Chen]          │
│ [Vasquez]       │
├──────────────────┤
│ Reyes:          │
│ "Precisamos    │
│  conversar..."  │
│                  │
└──────────────────┘

> 
[NOVA MENSAGEM] ← também aparece no terminal
```

### Indicadores

| Indicador | Significado |
|-----------|-------------|
| (vazio) | Sem novas mensagens |
| ● | Nova mensagem não lida |
| ... | NPC escrevendo |

---

## Lembretes

Se você ficar inativo por 5 minutos, recebe um lembrete no painel:

```
┌──────────────────┐
│ CHAT             │
├──────────────────┤
│ [Reyes]         │
│ [Chen] ●        │ ← Lembrete!
│ [Vasquez]       │
├──────────────────┤
│ Chen:           │
│ "Soldado! Onde  │
│  você está?"    │
└──────────────────┘
```

---

## Chat Offline

Mensagens podem ser deixadas quando o NPC está offline:

```
> chat chen

╔══════════════════════════════════════╗
║ SGT. CHEN está Offline               ║
╠══════════════════════════════════════╣
║ Deixar mensagem? (s/n)              ║
╚══════════════════════════════════════╝
```

---

## Integração com Missões

| NPC | Missão | Pré-requisito |
|-----|--------|---------------|
| Reyes | Conexão Inicial | Nenhum |
| Reyes | Varredura Perimetral | Missão 1 completa |
| Reyes | Atividade Anômala | Missão 2 completa |
| Chen | Tutorial | Nenhum |
| Vasquez | Lore | Missão 2 completa |

---

## Dicas do Sgt. Chen

### Sobre Atributos

```
SGT. CHEN: "Você quer saber sobre atributos?"
SGT. CHEN: "Aqui está o resumo:"

POTÊNCIA   -> Dano de ataque
PRECISÃO   -> Chance de crítico + Acurácia
NÚCLEO     -> Escudo + Capacidade de energia
MANOBRA    -> Velocidade + Fuga
DENSIDADE  -> Dano crítico + Redução de dano
```

### Sobre Inimigos

```
SGT. CHEN: "Os Electrotrions têm padrões."
SGT. CHEN: "Perseguidores: rápido, forte em close."
SGT. CHEN: "Atiradores: mantenha distância."
SGT. CHEN: "Geradores: mate rápido, spawna mais."
SGT. CHEN: "Explodidores: não deixe chegar perto!"
```

---

## Links

- [[01_narrativa]] — Fluxo narrativo
- [[02_terminal]] — Comandos do terminal
- [[03_combate]] — Sistema de combate
- [[04_shop]] — Loja e inventory
- [[06_decryption]] — Quebra-cabeça
- [[07_save]] — Save/Load
- [[08_implementacao]] — Implementação