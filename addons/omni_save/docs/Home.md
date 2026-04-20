# OmniSave - Home 💾

Bem-vindo à documentação do **OmniSave**, o sistema de salvamento e carregamento da suíte Omni-System.

Navegue pelos tópicos abaixo para entender como usar o sistema:

- [[Instalação e Configuração]]: Como inicializar o singleton e configurar caminhos de saves.
- [[Sistema de Salvamento]]: Details about how saving works and integration with OmniNarrative and OmniChat.
- [[Sistema de Carregamento]]: Como carregar jogos salvos e restaurar estado.

---

## Visão Geral

OmniSave é um singleton que gerencia:
- Salvamento de estado narrativo (script atual, node, variáveis)
- Salvamento de estado do chat (diálogos, progresso)
- Slots de salvamento múltiplos
- Arquivos JSON estruturados