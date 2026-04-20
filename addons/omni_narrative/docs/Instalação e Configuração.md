# Instalação e Configuração ⚙️

O **OmniNarrative** funciona como um mediador central. Para que ele possa enviar comandos para o chat e para o terminal, ele precisa saber onde esses nós estão na sua cena.

## 1. Ativação do Plugin
Certifique-se de que o plugin está ativado em `Project -> Project Settings -> Plugins`. O singleton `OmniNarrative` será registrado automaticamente.

## 2. Registro de Componentes
No script da sua cena principal (ex: `main.gd`), você deve registrar as instâncias do **OmniChat** e **OmniTerm**:

```gdscript
func _ready() -> void:
    # Registra os nós para o diretor narrativo
    OmniNarrative.register_chat($OmniChat)
    OmniNarrative.register_terminal($OmniTerm)
```

## 3. Carregando um Script
Após o registro, você pode carregar seu arquivo JSON de narrativa e saltar para o ponto de entrada:

```gdscript
func _start_game() -> void:
    if OmniNarrative.load_script("res://narrative/my_story.json"):
        OmniNarrative.jump_to("entry_point")
```

> [!IMPORTANT]
> O registro deve ser feito **antes** de chamar `load_script` ou `jump_to`, caso contrário o diretor não terá onde exibir as mensagens.
