# Meu Bolso - App de Controle de Gastos Pessoais

## 📱 Visão Geral
Aplicativo Flutter para gerenciamento de despesas pessoais com interface moderna, recursos avançados de visualização e análise de gastos.

## ⚙️ Funcionalidades Principais

### 1. Cadastro de Despesas
- Inserção de valor monetário
- Seleção de categorias predefinidas:
  - Alimentação
  - Transporte
  - Lazer
  - Entre outras
- Seleção de data
- Campo de observações (opcional)

### 2. Listagem de Despesas
- Visualização em ordem decrescente por data
- Funcionalidades de:
  - Edição de despesas existentes
  - Exclusão de registros
- Sistema de busca por categoria

### 3. Dashboard Financeiro
- **Visualizações Gráficas:**
  - Gráfico de pizza: distribuição percentual por categoria
  - Gráfico de barras: evolução temporal (semanal/mensal)
- **Indicadores:**
  - Total de gastos diários
  - Total de gastos semanais
  - Total de gastos mensais
  
### 4. Filtros de Visualização
- Últimos 7 dias
- Último mês
- Seleção personalizada de período

## 🔧 Especificações Técnicas

### Armazenamento
- Persistência local utilizando:
  - Hive ou SQLite
- Funcionalidade de exportação para CSV

### Interface do Usuário
- Design minimalista e moderno
- Suporte a Dark Mode
- Animações fluidas para:
  - Transições entre telas
  - Inserção de novos registros
  - Exclusão de registros

### Arquitetura e Padrões
- **Gerenciamento de Estado:** Riverpod
- **Padrão Arquitetural:** MVVM
  - Models: Entidades e regras de negócio
  - ViewModels: Lógica de apresentação
  - Views: Interface do usuário

### Testes
- Testes unitários cobrindo:
  - Lógica de cadastro
  - Sistema de filtros
  - Cálculos de totais

### Responsividade
- Layout adaptativo para diferentes tamanhos de tela
- Otimizado para:
  - Smartphones
  - Tablets

## 📅 Próximos Passos
1. Configuração do ambiente de desenvolvimento
2. Criação da estrutura base do projeto
3. Implementação das funcionalidades core
4. Desenvolvimento da interface do usuário
5. Implementação dos testes
6. Testes de usabilidade
7. Refinamentos e otimizações
