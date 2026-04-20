# Localização e Sincronização 🌐

O **OmniNarrative** possui ferramentas integradas no menu superior do Godot para gerenciar a integridade e a tradução dos seus roteiros.

## 🛠️ Ferramentas de Menu

Acesse em: `Project -> Tools -> OmniNarrative`

### 1. Sync Translations
Escaneia todos os JSONs e gera/atualiza os arquivos de tradução.
- **`narrative.pot`**: Template mestre com comentários contendo o texto original para auxiliar tradutores.
- **`pt_BR.po`**: Arquivo de tradução pré-preenchido para Português do Brasil.
- **Segurança**: O processo é bloqueado se forem encontradas chaves (`id`) duplicadas com textos diferentes.

### 2. Validate All Scripts
Verifica a integridade lógica de todos os roteiros.
- **Links Quebrados**: Avisa se um nó aponta para um `next` que não existe.
- **Triggers**: Valida destinos de saltos condicionais.
- **Duplicatas**: Detecta IDs de tradução conflitantes entre múltiplos arquivos, indicando exatamente o arquivo e a linha do erro.

---

## ⚙️ Configurações
Configure os caminhos em `Project -> Project Settings -> Omni Narrative`:
- `paths/dialogues`: Pasta raiz dos seus arquivos JSON.
- `paths/translations`: Pasta onde os arquivos `.po` e `.pot` serão gerados.

---

## 📝 Padrão de Escrita
Para garantir que um texto seja traduzível, utilize sempre o formato de objeto:

```json
"messages": [
    {
        "id": "MSG_KEY_01",
        "text": "Texto original que servirá de fallback."
    }
]
```

> [!IMPORTANT]
> O sistema de tradução do Godot utiliza o arquivo `.po`. Após gerar os arquivos via sincronizador, o Godot importará automaticamente as chaves para uso global via `tr()`.
