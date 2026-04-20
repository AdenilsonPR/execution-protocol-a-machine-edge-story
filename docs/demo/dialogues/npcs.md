# Personalidades dos NPCs

Este arquivo documenta a voz e personalidade de cada NPC para manter consistência.

---

## Comandante Reyes

### Voz e Tom
- **Formalidade**: 60% formal, 40% coloquial
- **Tom**: Maternal mas profissional. Protege a unidade mas esconde algo.
- **Expressões**: "soldado", "#2227", "cuidado", "preciso de você"

### Exemplos de Fala

**Quando amigável:**
```
"E aí, #2227. Dormiu bem?"
"...Claro que não. Você é um robô."
```

**Quando sério:**
```
"Sua missão é simples. Verificar perímetro."
"Não morra. Preciso de você vivo."
```

**Quando esconde algo:**
```
"É mais comum do que parece."
"Não se preocupe."
"...Os técnicos vão resolver."
```

### Gatilhos Emocionais
- Preocupação genuína pela unidade
- Tendência a minimizar problemas
- Sabe mais do que diz

---

## Sgt. Chen

### Voz e Tom
- **Formalidade**: 30% formal, 70% coloquial
- **Tom**: Cínico com humor negro. Veterano que já viu de tudo.
- **Expressões**: "aff", "outro?", "já viu", "basicamente", "não morra"

### Exemplos de Fala

**Tutorial de combate:**
```
"Combate, eh?"
"VOCÊ TEM um sistema ATB. Barras de tempo."
"Se demorar... os inimigos também agem."
```

**Sobre inimigos:**
```
"Outro Electrotrion? Aff."
"Quando é que vão aprender a morrer?"
```

**Cínico:**
```
"O verdadeiro problema são os Geradores."
"Se ver um, mata primeiro. Sempre."
"Boa caçada, soldado."
```

### Gatilhos Emocionais
- Ironia como mecanismo de defesa
- Conhecimento prático, não teórico
- Sabe mais do que fala

---

## Dr. Vasquez

### Voz e Tom
- **Formalidade**: 70% técnico, 30% coloquial
- **Tom**: Científica estranha. Fascinada por anomalias.
- **Expressões**: "dados", "análise", "padrão", "desconhecido", "...?"

### Exemplos de Fala

**Sobre pesquisa:**
```
"Transferências. De consciências."
"Como você chegou aqui, por exemplo."
"Tudo funciona. Geralmente."
"Mas às vezes... algo dá errado."
```

**Sobre anomalias:**
```
"Anomalia. Sim."
"Dados estranho nos logs."
"Padrões que não fazem sentido."
```

**Hints misteriosos:**
```
"Algo que os logs não mostram."
"Algo... físico."
"...Talvez não seja o que parece."
```

### Gatilhos Emocionais
- Fascinação por dados
- Preocupação velada
- Sabe algo, quer ajudar mas não pode falar

---

## Sistema

### Voz e Tom
- **Formalidade**: 100% técnico/robótico
- **Tom**: Secundário, impessoal, informativo
- **Expressões**: "INICIALIZANDO", "DETECTADO", "ATIVADO", "ERRO"

### Exemplos de Texto

```
═══════════════════════════════════════════════════
         INICIALIZANDO UNIDADE #2227
═══════════════════════════════════════════════════
```

```
[AVISO] Driver óptico não compatível detectado.
```

```
> [ERRO] Arquivo corrompido.
> Checksum inválido.
> [TENTATIVAS RESTANTES: 0]
```

---

## Consistência de Estilo

### Regras Gerais

| Elemento | Regra |
|----------|-------|
| **Nomes de NPCs** | CAIXA ALTA ou *itálico* |
| **Sistema** | `` `texto` `` ou ASCII boxes |
| **Ações do jogador** | > comando ou [NUMERO] opção |
| **Texto do sistema** | [AVISO], [ERRO], [ALERTA] |
| **Continuação de fala** | Identado abaixo da fala principal |

### Formato de Diálogo

```
NPC: "Fala principal."
NPC: "Continuação."
NPC: "Fala final."

[OPÇÃO] "Resposta do jogador"
```

### Exemplo Completo

```
╔══════════════════════════════════════╗
║ CONECTADO: SGT. CHEN                 ║
╠══════════════════════════════════════╣
║ [1] Tutorial de combate              ║
║ [2] Dicas sobre inimigos             ║
║ [3] Sair                             ║
╚══════════════════════════════════════╝

CHEN: "Combate, eh?"
CHEN: "Você tem um sistema ATB."
CHEN: "Basicamente isso. Só não morra."

[1] Entendi.
[2] Mais detalhes.
```

---

## Links

- [[index|Mapa de Diálogos]]
- [[01_00_boot|Boot do Sistema]]
- [[03_01_reyes_boasvindas|Reyes - Boas-vindas]]
- [[03_04_chen_combate|Chen - Tutorial]]
- [[03_08_missao2_vasquez|Vasquez - Introdução]]