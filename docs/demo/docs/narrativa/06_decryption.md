# Quebra-cabeça de Criptografia

Esta página documenta o sistema de descriptografia do dispositivo misterioso.

## Obtendo o Dispositivo

O dispositivo é dropado ao completar a [[01_narrativa#fase-3|Missão 3: Atividade Anômala]].

```
[+] Dispositivo Criptografado adicionado ao inventário
```

---

## Requisitos para Abrir

Para abrir o dispositivo, você precisa:

1. **Drive de Criptografia** (comprar na [[04_shop|loja]] por 200 scraps)
2. Ter o dispositivo no inventário
3. Completar Missão 3

---

## Usando o Drive

```
> use drive_criptografia

╔══════════════════════════════════════╗
║   DISPOSITIVO CRIPTOGRAFADO         ║
╠══════════════════════════════════════╣
║ [Drive de Criptografia instalado]  ║
║ [Iniciando descriptografia...]     ║
║                                     ║
║ ════════════════════════════════   ║
║                                     ║
║ [████████░░░░░░░] 45%              ║
║                                     ║
║ Bloco atual: 3/8                   ║
║ Status: Chave parcial requerida     ║
╚══════════════════════════════════════╝
```

---

## O Quebra-cabeça

O dispositivo contém 8 blocos de dados. Cada bloco precisa ser descriptografado.

### Blocos de Dados

| Bloco | Tipo | Quebra Necessária |
|-------|------|-------------------|
| 1 | Identificação | nenhuma (automático) |
| 2 | Data/hora | nenhuma (automático) |
| 3 | Log do Sistema | Chave parcial |
| 4 | Mensagem | Sequência numérica |
| 5 | Coordenadas | Cifra de César |
| 6 | Análise | Quebra de código |
| 7 | Aviso | Padrão visual |
| 8 | Revelação final | Combinação |

---

## Nível 1: Blocos Automáticos

Os dois primeiros blocos são descriptografados automaticamente:

```
╔══════════════════════════════════════╗
║ BLOCO 1: IDENTIFICAÇÃO              ║
╠══════════════════════════════════════╣
║ ID: DISPOSITIVO-A7X                 ║
║ TIPO: LOG DE TRANSFERÊNCIA          ║
║ ORIGEM: SERVIDOR CENTRAL-01         ║
║ DESTINO: BASE DELTA-7               ║
╚══════════════════════════════════════╝

╔══════════════════════════════════════╗
║ BLOCO 2: TIMESTAMP                  ║
╠══════════════════════════════════════╣
║ DATA: 2147.03.15                    ║
║ HORA: 03:42:07.892                  ║
║ STATUS: PRÉ-TRANSFERÊNCIA          ║
╚══════════════════════════════════════╝
```

---

## Nível 2: Chave Parcial

O Bloco 3 requer uma **chave parcial**.

**Como obter**: Falar com Dr. Vasquez após receber o dispositivo.

```
DR. VASQUEZ: "Encontrei algo que pode ajudar."
DR. VASQUEZ: "É um fragmento de chave."
[FRAGMENTO RECEBIDO: Chave Parcial #2227]
```

**Solução**:

```
> decrypt 3

╔══════════════════════════════════════╗
║ BLOCO 3: LOG DO SISTEMA             ║
╠══════════════════════════════════════╣
║ Fragmento encontrado.              ║
║ use 'chave [número]' para decrypt   ║
║                                     ║
║ DICA: O fragmento que recebeu       ║
║       tem um número.                ║
╚══════════════════════════════════════╝

> chave 2227

╔══════════════════════════════════════╗
║ BLOCO 3: LOG DO SISTEMA             ║
╠══════════════════════════════════════╣
║ [2147.03.15 03:42:07]              ║
║ > Inicializando protocolo de        ║
║   transferência de consciência...    ║
║ > Alvo: UNIDADE #2227              ║
║ > Preparando buffer...              ║
║ > ANOMALIA DETECTADA!              ║
║ > Subprocesso autônimo ativado.    ║
║ > PROTOCOLO DE EMERGÊNCIA: ATIVO   ║
╚══════════════════════════════════════╝
```

---

## Nível 3: Sequência Numérica

O Bloco 4 requer descobrir uma sequência.

```
> decrypt 4

╔══════════════════════════════════════╗
║ BLOCO 4: MENSAGEM                   ║
╠══════════════════════════════════════╣
║ Sequência numérica requerida.       ║
║                                     ║
║ 2, 4, 8, 16, ___, 64               ║
║                                     ║
║ USE: sequencia [número]            ║
╚══════════════════════════════════════╝
```

**Solução**: 32 (cada número dobra)

```
> sequencia 32

╔══════════════════════════════════════╗
║ BLOCO 4: MENSAGEM                   ║
╠══════════════════════════════════════╣
║ [2147.03.15 04:15:33]              ║
║ > Alerta: Capacidade do servidor   ║
║   em 87%.                           ║
║ > Recomendação: Reduzir número     ║
║   de consciências ativas.          ║
║ > PROTOCOLO: MANTER ESTÁVEL        ║
║ > MOTIVO: MISERICÓRDIA             ║
╚══════════════════════════════════════╝
```

---

## Nível 4: Cifra de César

O Bloco 5 usa cifra de César.

```
> decrypt 5

╔══════════════════════════════════════╗
║ BLOCO 5: COORDENADAS                 ║
╠══════════════════════════════════════╣
║ Mensagem cifrada.                   ║
║                                     ║
║ SHTzh...                            ║
║                                     ║
║ DICA: 3 posições para trás          ║
║ USE: cifra [letras]                ║
╚══════════════════════════════════════╝
```

**Solução**: Cada letra volta 3 posições no alfabeto

- S → P
- H → E
- T → Q
- Z → W
- H → E

```
> cifra pewqe

╔══════════════════════════════════════╗
║ BLOCO 5: COORDENADAS                 ║
╠══════════════════════════════════════╣
║ [2147.03.15 04:32:11]              ║
║ > LOCALIZAÇÃO DETECTADA             ║
║ > SERVIDOR: CENTRAL-01              ║
║ > SETOR: 7-GAMMA                    ║
║ > COORDENADAS: [REDIGIDO]          ║
╚══════════════════════════════════════╝
```

---

## Nível 5: Quebra de Código

O Bloco 6 requer identificar um padrão.

```
> decrypt 6

╔══════════════════════════════════════╗
║ BLOCO 6: ANÁLISE                     ║
╠══════════════════════════════════════╣
║ Padrão necessário.                 ║
║                                     ║
║ 001 = E                             ║
║ 010 = S                             ║
║ 011 = T                             ║
║ 100 = Á                             ║
║ 101 = ?                             ║
║ 110 = ?                             ║
║                                     ║
║ USE: codigo [valor]                 ║
╚══════════════════════════════════════╝
```

**Solução**: Converter para binário
- 101 = 5 = V
- 110 = 6 = I

```
> codigo vi

╔══════════════════════════════════════╗
║ BLOCO 6: ANÁLISE                     ║
╠══════════════════════════════════════╣
║ [2147.03.15 05:01:44]              ║
║ > Analise de estabilidade:          ║
║ > Consciencias: 847                 ║
║ > Estaveis: 847                     ║
║ > Instaveis: 0                      ║
║ > PROTOCOLO: FUNCIONAL             ║
║ > Nota: Modo de preservacao        ║
║   ativo.                            ║
╚══════════════════════════════════════╝
```

---

## Nível 6: Padrão Visual

O Bloco 7 requer reconhecer um padrão.

```
> decrypt 7

╔══════════════════════════════════════╗
║ BLOCO 7: AVISO                       ║
╠══════════════════════════════════════╣
║ Identifique o padrão.               ║
║                                     ║
║ [█][░][█][░][█][░][█][░][█]        ║
║ [█][█][░][░][█][█][░][░][█]        ║
║ [█][█][█][░][░][░][█][█][█]        ║
║                                     ║
║ USE: padrao [palavra]               ║
╚══════════════════════════════════════╝
```

**Solução**: O padrão é "PERIGO"

```
> padrao perigo

╔══════════════════════════════════════╗
║ BLOCO 7: AVISO                       ║
╠══════════════════════════════════════╣
║ [AVISO DE SEGURANCA]                ║
║ > PROTOCOLO IMPERATIVO: ATIVO      ║
║ > Area restrita detectada.         ║
║ > Tentativa de acesso: REGISTRADA  ║
║ > Consciencia #2227: EM ANALISE     ║
║ >                                  ║
║ > [DADOS INSUFICIENTES]            ║
║ > Mais investigacao necessaria.    ║
╚══════════════════════════════════════╝
```

---

## Nível 7: Dados Insuficientes

O Bloco 8 requer mais dados.

```
> decrypt 8

╔══════════════════════════════════════╗
║ BLOCO 8: DADOS                       ║
╠══════════════════════════════════════╣
║ [AVISO]                            ║
║ > Dados insuficientes.             ║
║ > Analise incompleta.              ║
║ >                                  ║
║ >mais fragments necessarios.       ║
║ >Busque em outras areas.           ║
║ >                                  ║
║ >[ACESO NEGADO]                    ║
╚══════════════════════════════════════╝
```

---

## Resultado Parcial

Voce conseguiu descriptografar parte do dispositivo. Alguns fragments foram recovered.

```
╔══════════════════════════════════════╗
║ FRAGMENTOS RECUPERADOS             ║
╠══════════════════════════════════════╣
║ Bloco 1: OK (Identificacao)        ║
║ Bloco 2: OK (Timestamp)           ║
║ Bloco 3: OK (Log do Sistema)       ║
║ Bloco 4: OK (Mensagem)             ║
║ Bloco 5: OK (Coordenadas)          ║
║ Bloco 6: OK (Analise)              ║
║ Bloco 7: OK (Aviso)                ║
║ Bloco 8: [ERRO]                    ║
║                                   ║
║ Progresso: 87%                     ║
║                                   ║
║ O que significa tudo isso?         ║
║                                   ║
║ [FIM DA DEMO]                      ║
╚══════════════════════════════════════╝
```

---

## Gancho para Versão Completa

O jogo completo continua a partir deste ponto:

- Investigar anomalias na rede
- Encontrar outros fragmentos de dados
- Descobrir a verdade por tras do protocolo
- Confrontar o misterio central
- Escolher seu proprio destino

A resposta esta la fora. Mas voce esta preparado para ela?

---

## Dicas em Mensagens

Se o jogador ficar preso, o Dr. Vasquez pode dar dicas:

```
> chat vasquez

DR. VASQUEZ: "Precisa de ajuda com o dispositivo?"
DR. VASQUEZ: "Cada bloco tem sua própria chave."
DR. VASQUEZ: "Tres = 3 em numeros."
DR. VASQUEZ: "E sempre há um padrão..."
```

---

## Links

- [[01_narrativa]] — Fluxo narrativo
- [[02_terminal]] — Comandos do terminal
- [[03_combate]] — Sistema de combate
- [[04_shop]] — Loja e inventory
- [[05_chat]] — NPCs
- [[07_save]] — Save/Load
- [[08_implementacao]] — Implementação