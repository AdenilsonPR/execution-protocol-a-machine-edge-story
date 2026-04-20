# 03_10 MISSAO 2: RELATORIO E CHAVE

**Momento**: Missão 2 - Conclusão
**NPC**: Dr. Vasquez
**Tipo**: Pós-missão + Pista

---

## Mensagem Inicial

```
╔══════════════════════════════════════╗
║ NOVA MENSAGEM: DR. VASQUEZ          ║
╠══════════════════════════════════════╣
║ "Entao voce encontrou algo?"         ║
║ "Parece interessante..."            ║
║ "Venha ao laboratorio."              ║
╚══════════════════════════════════════╝
```

---

## Menu Vasquez

```
╔══════════════════════════════════════╗
║ CONECTADO: DR. VASQUEZ                ║
╠══════════════════════════════════════╣
║   > [1] Sobre o dispositivo          ║
║     [2] Analisar o dispositivo       ║
║     [3] O que voce espera encontrar? ║
║     [4] Sair                          ║
╚══════════════════════════════════════╝

 [↑/↓] navegar   [ENTER] selecionar
```

---

## Opções

### [1] Sobre o dispositivo

```
VASQUEZ: "Parece um dispositivo de transferencia."
VASQUEZ: "Fabricante... desconhecido."
VASQUEZ: "Codigo de serie: [CORROMPIDO]"
```

```
VASQUEZ: "E velho. Mais velho que a base."
VASQUEZ: "Isso nao deveria existir aqui."
VASQUEZ: "Os Electrotrions consomem metal..."
VASQUEZ: "Entao por que esse dispositivo ainda existe?"
```

**Próximo link**: [[03_10_missao2_conclusao|MENU VASQUEZ]]

---

### [2] Analisar o dispositivo

**Se jogador NÃO tem Drive de Leitura:**

```
VASQUEZ: "O dispositivo tem conteudo."
VASQUEZ: "Mas esta criptografado."
```

```
╔══════════════════════════════════════╗
║ [BLOQUEADO]                          ║
╠══════════════════════════════════════╣
║ Drive de leitura necessario.         ║
║                                     ║
║ Procure na loja.                    ║
║ Custo: 200 scraps                    ║
╚══════════════════════════════════════╝
```

```
VASQUEZ: "Vai ate a loja e compra um drive."
VASQUEZ: "Esse tipo de dispositivo usa criptografia padrao."
VASQUEZ: "Um drive generico deve funcionar."
```

**Próximo link**: [[03_10_missao2_conclusao|MENU VASQUEZ]]

---

**Se jogador TEM Drive de Leitura (inventory check):**

```
VASQUEZ: "Voce tem um drive!"
VASQUEZ: "Deixa eu ver isso..."
```

```
VASQUEZ: "Conectando drive ao dispositivo..."
VASQUEZ: "Iniciando leitura..."
```

```
╔══════════════════════════════════════╗
║ DRIVE DE LEITURA DETECTADO           ║
╠══════════════════════════════════════╣
║ [░░░░░░░░░░░░░░░░░░░░░░] 0%         ║
║                                     ║
║ Fragmento 1: Carregando...          ║
║ Fragmento 2: Carregando...          ║
║ Fragmento 3: Carregando...          ║
║ ...                                 ║
╚══════════════════════════════════════╝
```

---

**Iniciando Descriptografia (7 de 8 fragmentos):**

```
VASQUEZ: "Consegui acessar!"
VASQUEZ: "A maioria dos dados estao intactos."
```

```
╔══════════════════════════════════════╗
║ DESCRIPTOGRAFANDO...                 ║
╠══════════════════════════════════════╣
║ [████████████████░░░░] 87%           ║
║                                     ║
║ Fragmento 1: OK                     ║
║ Fragmento 2: OK                     ║
║ Fragmento 3: OK                      ║
║ Fragmento 4: OK                      ║
║ Fragmento 5: OK                     ║
║ Fragmento 6: OK                     ║
║ Fragmento 7: OK                      ║
║ Fragmento 8: [ERRO]                   ║
║                                     ║
║ Progresso: 87%                      ║
║                                     ║
║ [DADOS INSUFICIENTES]               ║
╚══════════════════════════════════════╝
```

```
VASQUEZ: "...87% dos dados."
VASQUEZ: "O ultimo fragmento esta corrompido."
VASQUEZ: "Ou foi apagado intencionalmente."
```

```
VASQUEZ: "O que voce encontrou..."
VASQUEZ: "...nao faz sentido."
VASQUEZ: "Ou faz?"
```

```
VASQUEZ: "Os logs que voce descriptografou..."
VASQUEZ: "...sao protocolos de servidor."
VASQUEZ: "Nossos protocolos."
```

```
VASQUEZ: "Isso e um dispositivo interno?"
VASQUEZ: "Ou veio de fora?"
```

```
VASQUEZ: "Preciso de mais tempo para analisar."
VASQUEZ: "Continue buscando."
VASQUEZ: "Talvez encontre mais dispositivos."
```

**Próximo link**: [[03_11_fim_demo|FIM DA DEMO]]

---

### [3] O que voce espera encontrar?

```
VASQUEZ: "Nao sei."
VASQUEZ: "Mas toda tecnologia antiga e uma caixa de surpresas."
VASQUEZ: "Pode ser nada."
VASQUEZ: "Pode mudar tudo."
```

**Próximo link**: [[03_10_missao2_conclusao|MENU VASQUEZ]]

---

## Fluxo Completo da Demo

```
MISSAO 2 CONCLUIDA
    ↓
VASQUEZ oferece analisar dispositivo
    ↓
[1] Ir a loja → comprar Drive (200 scraps)
    ↓
VOLTAR A VASQUEZ
    ↓
[2] Analisar dispositivo (com drive)
    ↓
DESCRIPTOGRAFACAO (87%)
    ↓
FIM DA DEMO
```

---

## Notas

- **Desbloqueia após**: [[03_09_missao2_inicio]]
- **Drive na loja**: Necessario para acessar conteudo
- **Gancho**: 87% recovered, fragmento 8 faltando
- **Próximo natural**: Jogo completo (buscar mais fragmentos)

---

## Inventario Check

O jogo deve verificar se o jogador tem `drive_leitura` no inventario:

```
if inventario.has("drive_leitura"):
    → mostrar fluxo "com drive"
else:
    → mostrar fluxo "sem drive"
```

---

## Links

- [[06_decryption|Sistema de Decrypt]] (futuro)
- [[03_11_fim_demo|Fim da Demo]]
- [[03_09_missao2_inicio|Missao 2 Combate]]