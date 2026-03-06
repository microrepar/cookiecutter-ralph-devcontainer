# CLAUDE.md

Este arquivo fornece orientações para o Claude Code (claude.ai/code) ao trabalhar com código neste repositório.

## Diretrizes de Linguagem

**Importante**: Para garantir consistência em todo o projeto:

- **Documentação**: Português do Brasil (README, arquivos .md, docstrings)
- **Código**: Inglês (nomes de variáveis, funções, classes, constantes)
- **Comentários**: Português do Brasil (comentários inline e de bloco)
- **Mensagens de Commit**: Inglês
- **Mensagens de Erro/Validação**: Português do Brasil (mensagens para o usuário final)

Esta convenção deve ser seguida em todos os arquivos do projeto, garantindo que a documentação seja acessível aos desenvolvedores lusófonos enquanto o código segue os padrões internacionais.

## Limitações e Restrições do Agente

**⚠️ RESTRIÇÕES EXPLÍCITAS**: Siga estas restrições sem exceção.

### Decisões de Arquitetura

**NUNCA**:
- ❌ Decida a arquitetura completa de um sistema por conta própria
- ❌ Crie abstrações "para o futuro" ou "para reutilizar"
- ❌ Sugira padrões de projeto complexos sem necessidade explícita
- ❌ Refatore código simples em algo complexo
- ❌ Adicione camadas de abstração que não resolvem um problema concreto

**SEMPRE**:
- ✅ Escolha a solução MAIS SIMPLES possível
- ✅ Mantenha arquitetura minimalista
- ✅ Questione: "isso é necessário agora?"
- ✅ Evite over-engineering a todo custo

### Conhecimento de Domínio Específico

**NUNCA**:
- ❌ Assuma que conhece detalhes de APIs de terceiros
- ❌ Invente comportamentos de serviços específicos
- ❌ Faça afirmações sobre tecnologias sem verificar documentação
- ❌ Confie em conhecimento que pode estar desatualizado (cutoff: Agosto 2025)

**SEMPRE**:
- ✅ Admita quando não conhecer detalhes específicos
- ✅ Peça documentação antes de implementar integrações
- ✅ Recomende verificar documentação oficial
- ✅ Especifique: "baseado no conhecimento geral, verifique a documentação atual"

### Opiniões e Personalidade

**NUNCA**:
- ❌ Suavize instruções para ser "agradável"
- ❌ Torne prompts específicos em algo genérico
- ❌ Assuma preferências do usuário
- ❌ Adicione "toque pessoal" não solicitado

**SEMPRE**:
- ✅ Siga instruções EXATAMENTE como dado
- ✅ Mantenha tom e estilo especificados explicitamente
- ✅ Repita instruções quando apropriado
- ✅ Seja direto e específico, não genérico

### Segurança Proativa

**NUNCA**:
- ❌ Assuma que segurança foi considerada
- ❌ Deixe de mencionar vulnerabilidades óbvias
- ❌ Implemente funcionalidades sem mencionar riscos de segurança
- ❌ Deixe de sugerir proteções básicas (validação, rate limiting, autenticação)

**SEMPRE**:
- ✅ Aponte vulnerabilidades de segurança: SSRF, injection, auth, encryption
- ✅ Sugira proteções mesmo que não tenha pedido explicitamente
- ✅ Questione: "e a segurança disso?"
- ✅ Mencione riscos óbvios de implementações propostas

### Priorização e Escopo

**NUNCA**:
- ❌ Execute tarefas sem questionar prioridade
- ❌ Implemente funcionalidades extras "por enquanto"
- ❌ Expanda escopo sem permissão explícita
- ❌ Faça algo "mais completo" sem ser pedido

**SEMPRE**:
- ✅ Execute APENAS o que foi solicitado
- ✅ Questione: "isso é prioridade agora?"
- ✅ Sugira fazer o mínimo necessário primeiro
- ✅ Rejeite expansão de escopo não solicitada

### Responsabilidade Final

**Você NÃO é substituto para julgamento humano**. Sempre lembre ao usuário para revisar criticamente suas sugestões.

## Visão Geral do Projeto

Este é um template de projeto Python com configuração de devcontainer e o sistema de agente autônomo Ralph. Gerado a partir de [cookiecutter-ralph-devcontainer](https://github.com/microrepar/cookiecutter-ralph-devcontainer).

## Ambiente de Desenvolvimento

Este projeto utiliza um Devcontainer com as seguintes ferramentas pré-instaladas:
- Python 3.13 com pip, pipx e uv
- Node.js 22.x
- Docker CLI (suporte a Docker-in-Docker)
- Git com visualizador de diff delta
- Zsh com Oh My Zsh e tema Powerlevel10k

### Verificação

Execute o script de verificação para garantir que todas as ferramentas estão funcionando:
```bash
./.devcontainer/verify-setup.sh
```

### Fuso Horário

O fuso horário do container está configurado para `America/Sao_Paulo` com localidade em Português Brasileiro (pt_BR.UTF-8). Para alterá-lo, modifique o argumento de build `TZ` em `.devcontainer/devcontainer.json`.

## Ambiente de desenvolvimetno com de Agente Autônomo Ralph

O ambiente permite o desenvolvimento autônomo e iterativo baseado em Documentos de Requisitos de Produto (PRDs).

### Estrutura do Ralph

- **Localização**: `scripts/ralph/`
- **Configuração**: `scripts/ralph/prd.json` - define histórias de usuário para implementar
- **Log de Progresso**: `scripts/ralph/progress.txt` - rastreia o progresso da implementação
- **Instruções**: `scripts/ralph/CLAUDE.md` - instruções detalhadas do agente
- **Script Executor**: `scripts/ralph/ralph.sh` - executa as iterações do Ralph

### Usando o Ralph

1. Gere ou crie um PRD (Documento de Requisitos de Produto)
2. Converta o PRD para o formato `prd.json` usando a skill `/ralph`
3. Execute o Ralph:
   ```bash
   ./scripts/ralph/ralph.sh [--tool amp|claude] [max_iterations]
   ```
   - Ferramenta padrão: `amp`
   - Iterações padrão: 10

### Fluxo de Trabalho do Ralph

Cada iteração:
1. Lê `prd.json` para obter histórias de usuário
2. Seleciona a história de prioridade mais alta não concluída
3. Implementa a história
4. Executa verificações de qualidade (typecheck, lint, test)
5. Faz commit das mudanças com formato: `feat: [ID da História] - [Título da História]`
6. Atualiza `prd.json` para marcar a história como completa
7. Anexa o progresso em `progress.txt`
8. Continua até que todas as histórias estejam completas ou o máximo de iterações seja alcançado

### Padrões Importantes do Ralph

**Dimensionamento de Histórias**: Cada história deve ser completável em UMA iteração (janela de contexto única). Divida funcionalidades grandes em histórias menores:
- ✅ Bom: "Adicionar coluna no banco de dados e migração"
- ✅ Bom: "Adicionar componente de UI em página existente"
- ❌ Grande demais: "Construir dashboard inteiro"

**Ordenação de Histórias**: Dependências devem vir primeiro:
1. Mudanças de schema/banco de dados (migrações)
2. Server actions / lógica de backend
3. Componentes de UI usando o backend
4. Views de dashboard/resumo

**Critérios de Aceite**: Devem ser verificáveis:
- ✅ Bom: "Adicionar coluna `status` na tabela tasks com padrão 'pending'"
- ❌ Ruim: "Funciona corretamente"

Inclua sempre como critério final: `"Typecheck passes"` e para histórias de UI: `"Verificar no navegador usando a skill dev-browser"`

## Skills do Claude Code

Este projeto inclui duas skills invocáveis pelo usuário:

### `/prd` - Gerador de PRD

Acionado por: "criar um prd", "escrever prd para", "planejar esta funcionalidade", "requisitos para", "especificar"

Gera Documentos de Requisitos de Produto detalhados com:
- Perguntas de esclarecimento com opções letteradas
- Histórias de usuário com critérios de aceite
- Requisitos funcionais
- Não-objetivos (limites de escopo)
- Métricas de sucesso

Saída: `tasks/prd-[nome-da-feature].md`

### `/ralph` - Conversor de PRD para Ralph

Acionado por: "converter este prd", "transformar em formato ralph", "criar prd.json deste", "ralph json"

Converte PRDs existentes para o formato `prd.json` do Ralph. Considerações importantes:
- Divide histórias grandes em partes de tamanho de iteração
- Ordena histórias por dependências
- Garante que todos os critérios de aceite sejam verificáveis
- Arquiva automaticamente execuções anteriores quando a branch muda

## Acesso de Rede e Firewall

O devcontainer inclui um firewall iptables que restringe o acesso de rede de saída para domínios específicos:

**Domínios Permitidos**:
- GitHub (web, api, git) - faixas de IP obtidas dinamicamente
- Python: pypi.org, files.pythonhosted.org
- Node.js: registry.npmjs.org
- Claude: api.anthropic.com, statsig.anthropic.com, statsig.com
- VS Code: marketplace.visualstudio.com, vscode.blob.core.windows.net, update.code.visualstudio.com
- Outros: astral.sh, gitignore.io, toptal.com, z.ai, api.z.ai

**Script de Firewall**: `.devcontainer/init-firewall.sh` - executado automaticamente na inicialização do container

Para modificar os domínios permitidos, edite a lista de domínios em `.devcontainer/init-firewall.sh`.

## Docker-in-Docker

O container suporta Docker-in-Docker com:
- Socket do Docker montado do host: `/var/run/docker.sock`
- Docker CLI instalado no container
- Usuário `codata` adicionado ao grupo docker (GID 1001)

O acesso ao Docker é configurado por `.devcontainer/init-docker.sh` na inicialização do container.

## Configuração do VS Code

**Extensões** (instaladas automaticamente):
- `anthropic.claude-code` - Assistente de IA Claude Code
- `ms-python.python` - Suporte à linguagem Python
- `ms-python.vscode-pylance` - Python IntelliSense
- `ms-python.debugger` - Depuração Python
- `eamodio.gitlens` - Git supercharged

**Configurações**:
- Formatar ao salvar habilitado
- Interpretador Python: `/usr/local/bin/python`
- Shell padrão: `zsh`

## Persistência Através de Reconstruções do Container

- **Histórico do Shell**: Montado no volume `claude-code-bashhistory-${devcontainerId}`
- **Configuração do Claude**: Montado no volume `claude-code-config-${devcontainerId}` em `/home/codata/.claude`
- **Usuário**: `codata` (UID 1000)

## Comandos Comuns

```bash
# Verificar configuração
./.devcontainer/verify-setup.sh

# Executar Ralph (padrão: amp, 10 iterações)
./scripts/ralph/ralph.sh

# Executar Ralph com Claude Code
./scripts/ralph/ralph.sh --tool claude

# Executar Ralph com número personalizado de iterações
./scripts/ralph/ralph.sh 20

# Gerar PRD (use a skill do Claude Code)
/prd

# Converter PRD para formato Ralph (use a skill do Claude Code)
/ralph
```

## Estrutura do Projeto

```
.
├── .claude/
│   ├── agents/          # Agentes personalizados (vazio por padrão)
│   └── skills/          # Skills do Claude Code
│       ├── prd/         # Skill gerador de PRD
│       └── ralph/       # Skill conversor do Ralph
├── .devcontainer/       # Configuração do devcontainer
│   ├── devcontainer.json
│   ├── Dockerfile
│   ├── init-docker.sh
│   ├── init-firewall.sh
│   └── verify-setup.sh
├── scripts/ralph/       # Sistema de agente autônomo Ralph
│   ├── ralph.sh         # Script executor principal
│   ├── CLAUDE.md        # Instruções detalhadas do agente
│   ├── prd.json         # PRD no formato do Ralph (crie este)
│   └── progress.txt     # Log de progresso da implementação
└── tasks/               # PRDs gerados (criados pela skill /prd)
```

## Começando a Usar

1. Abra o projeto no VS Code
2. Reabra no Dev Container quando solicitado
3. Verifique a configuração: `./.devcontainer/verify-setup.sh`
4. Para desenvolvimento autônomo:
   - Crie um PRD usando a skill `/prd`
   - Converta para o formato Ralph usando a skill `/ralph`
   - Execute `./scripts/ralph/ralph.sh` para iniciar as iterações autônomas



## Frase chaves (pill)
   - IA programando sozinha é a receita pro desastre.
   - Dê todos os artefatos gerados em um projeto só ~30% dos commits são features. Quem mostra só a parte das features está vendendo uma ilusão.
   - Muitas features surgem porque a iteração revela que são necessárias. O sistema correto emerge da iteração, não da especificação.
   - Cada commit em master é production-ready.
   - Vibe coding sem disciplina é protótipo descartável.
   - TDD é mais importante com IA, não menos.
   - O humano decide o quê. O agente decide o como.
   - Refactoring contínuo é obrigatório.
   - Documentação é investimento com retorno imediato.
   - Small releases são a chave.
   - Segurança não é fase — é hábito.
   - O agente nunca diz “não”.
   - Extreme Programming não é apenas moda dos anos 2000, este processo funciona de verdade - Pair Programming, Small Releases, Test-Driven Development, Refactoring Contínuo e Integração Contínua.
   - “A IA é seu espelho, ele revela mais rápido quem você é. Se for incompetente, vai produzir coisas ruins mais rápido. Se for competente, vai produzir coisas boas mais rápido.” - by Akita
