# Autocomplete e Navegação

O OmniTerm possui um sistema de autocomplete avançado inspirado em shells modernos como Fish e Zsh.

## Funcionamento

### Sugestão Fantasma (Ghost Text)
Enquanto você digita, se houver apenas uma correspondência única (seja para um comando ou um argumento), o terminal exibirá o restante do texto em uma cor atenuada (`Neutral 2`). Você pode pressionar `Tab` ou `Seta para Direita` para aceitar a sugestão.

### Menu Visual (Grid)
Se houver múltiplas correspondências possíveis:
1. A lista visual não aparece automaticamente para evitar distrações.
2. Ao pressionar `Tab`, a lista em grade aparece abaixo do prompt.
3. Você pode navegar entre as opções usando as **4 setas** (`Cima`, `Baixo`, `Esquerda`, `Direita`) ou o próprio `Tab`.
4. O item selecionado é destacado com um cursor `> ` e a cor `Neutral 6`.

### Syntax Highlighting
O campo de entrada diferencia visualmente o comando de seus argumentos para facilitar a leitura de comandos complexos:
- **Comandos**: Cor `Neutral 6` (Brilhante).
- **Argumentos Alternados**: Os argumentos alternam entre `Neutral 4` (Ímpares) e `Neutral 3` (Pares), criando um contraste visual que separa cada parâmetro.

## Implementação em Comandos Customizados

Para adicionar suporte a autocomplete em um novo comando, implemente o método `get_suggestions` no seu script de comando:

```gdscript
func get_suggestions(_args: PackedStringArray, _context: CommandContext) -> PackedStringArray:
	var suggestions: PackedStringArray = PackedStringArray()
	# Sua lógica para retornar strings de sugestão
	return suggestions
```

## Controles
- **Tab / Setas**: Navegam na lista de sugestões.
- **Esc**: Fecha a lista de sugestões e cancela o ciclo.
- **Backspace**: Apaga caracteres e cancela o modo de sugestão visual.
