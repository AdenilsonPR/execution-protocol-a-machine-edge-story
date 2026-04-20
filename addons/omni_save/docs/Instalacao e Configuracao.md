# Instalação e Configuração

O OmniSave usa a pasta `user://saves/` por padrão para armazenar os arquivos de salvamento.

## Configuração via project.godot

O sistema é configurado como Autoload no projeto:

```godot
[autoload]
OmniSave="*uid://dv5wkhv5cldpf"
```

## Sinais Emitidos

| Sinal | Descrição |
|-------|-----------|
| `saved(slot_name: String)` | Emitido após salvamento bem-sucedido |
| `loaded(slot_name: String)` | Emitido após carregamento bem-sucedido |
| `error_occurred(message: String)` | Emitido em caso de erro |

## Uso Básico

```gdscript
func _on_save_button_pressed() -> void:
	OmniSave.save_game("slot1")


func _on_load_button_pressed() -> void:
	OmniSave.load_game("slot1")


func _on_slots_requested() -> void:
	var slots: Array[String] = OmniSave.get_available_slots()
	for slot in slots:
		print("Slot: " + slot)
```