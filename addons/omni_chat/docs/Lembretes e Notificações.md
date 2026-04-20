## 🔔 Lembretes e Notificações

O OmniChat possui um sistema inteligente de engajamento para garantir que o jogador não esqueça de responder aos NPCs importantes.

### Lógica de Funcionamento
O sistema monitora o tempo desde a última interação e age sob as seguintes condições:

1. **Inatividade**: O jogador recebeu uma mensagem que exige resposta (choices exibidas) mas não interagiu por **5 minutos** (valor padrão).
2. **Contexto**: O lembrete **só dispara** se o jogador não estiver com o chat daquele NPC aberto. Se ele estiver lendo a conversa, o sistema não o interrompe.
3. **Não Acumulativo**: Se o NPC já tem uma notificação pendente (indicador visual "1"), o sistema não enviará novos alertas até que a notificação atual seja visualizada.

### Indicações Visuais
- **Badges**: Uma "bolinha" azul com o número de mensagens pendentes aparecerá no topo superior direito do contato na lista de conversas.
- **Destaque**: O nome do NPC com notificações pendentes ficará com a cor principal (Azul) para chamar a atenção.

### Usando Fora do Chat
Você pode usar o sinal `new_message_received` para disparar eventos em outros lugares do seu jogo, como tocar um som de "notificação de celular" ou mostrar um ícone na HUD principal:

```gdscript
func _ready():
    chat.new_message_received.connect(_on_chat_notification)

func _on_chat_notification(contact_name):
    # Tocar som de notificação global
    $NotificationSound.play()
```

---

⬅️ Voltar para a [[Home]]
