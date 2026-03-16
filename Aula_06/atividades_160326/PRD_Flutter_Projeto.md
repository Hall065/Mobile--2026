# PRD — Projeto Flutter
## Semáforo + Temperatura + Mini Game

> **Product Requirements Document** | Versão 1.0 — Março 2026

---

## 1. Visão Geral do Produto

Este documento define os requisitos para um aplicativo Flutter educacional composto por três módulos interativos em um único projeto. O app é voltado para o aprendizado prático de conceitos fundamentais do desenvolvimento Flutter, como `StatefulWidget`, `setState()`, `Random` e lógica condicional.

Cada módulo funciona como uma tela independente, acessível a partir de uma tela inicial de navegação (Home).

---

## 2. Objetivo

Consolidar os seguintes conceitos de Flutter em um único projeto coeso:

- Gerenciamento de estado com `StatefulWidget` e `setState()`
- Navegação entre telas com `Navigator`
- Lógica condicional para atualização dinâmica da interface
- Uso da biblioteca `dart:math` (`Random`)
- Componentização e reutilização de widgets

---

## 3. Escopo do Projeto

### 3.1 Telas do Aplicativo

O projeto contém quatro telas no total:

| Tela | Nome | Descrição |
|------|------|-----------|
| 0 | Home | Tela de entrada com botões de navegação para cada módulo |
| 1 | Semáforo | Simulação visual de semáforo de trânsito com semáforo de pedestre |
| 2 | Temperatura | Termômetro interativo com feedback visual de cor e ícone |
| 3 | Mini Game | Jogo Pedra, Papel e Tesoura contra o computador com placar |

---

## 4. Requisitos Funcionais

### 4.1 Tela Home

A tela inicial é o ponto de entrada do aplicativo. Ela não possui estado próprio e serve apenas como hub de navegação.

**Requisitos:**
- Exibir o nome do projeto no `AppBar`
- Apresentar três botões (ou cards) de navegação, um para cada módulo
- Navegar para a tela correspondente ao pressionar cada botão usando `Navigator.push()`
- Cada botão deve exibir ícone representativo e nome do módulo

---

### 4.2 Tela — Semáforo Realista

Simula um semáforo de trânsito com indicação paralela para pedestre. O estado do semáforo é controlado manualmente pelo usuário.

**Variáveis de Estado:**

| Variável | Tipo | Descrição |
|----------|------|-----------|
| `estado` | `int` | Valor de 0 a 2 indicando a fase do semáforo (0=Verde, 1=Amarelo, 2=Vermelho) |

**Lógica de Negócio:**
- `estado == 0`: luz verde acesa, pedestre aguarda
- `estado == 1`: luz amarela acesa, pedestre aguarda
- `estado == 2`: luz vermelha acesa, pedestre pode atravessar
- Ao pressionar o botão, `estado` incrementa; ao chegar em 2, reinicia para 0

**Interface:**
- `Container` preto com borda arredondada contendo 3 círculos (vermelho, amarelo, verde)
- O círculo correspondente ao estado atual acende com a cor real; os demais ficam cinzas
- Ícone de pedestre: `Icons.directions_walk` (verde) quando `estado == 2`, `Icons.pan_tool` (vermelho) caso contrário
- Texto de instrução ao pedestre: `"PEDESTRE: ATRAVESSE"` ou `"PEDESTRE: AGUARDE"`
- Botão `"Mudar Semáforo"` centralizado na parte inferior

---

### 4.3 Tela — Controle de Temperatura

Simula um termômetro interativo. O usuário aumenta ou diminui a temperatura e a interface responde com cor de fundo, ícone e texto de status correspondentes.

**Variáveis de Estado:**

| Variável | Tipo | Descrição |
|----------|------|-----------|
| `temperatura` | `int` | Temperatura atual em graus Celsius, iniciando em 20 |

**Lógica de Negócio:**

| Condição | Cor de Fundo | Ícone | Status |
|----------|-------------|-------|--------|
| `temperatura < 15` | `Colors.blue` | `Icons.ac_unit` | Frio |
| `15 ≤ temperatura < 30` | `Colors.green` | `Icons.wb_sunny` | Agradável |
| `temperatura ≥ 30` | `Colors.red` | `Icons.local_fire_department` | Quente |

**Interface:**
- Exibir temperatura atual em texto grande (`fontSize: 40`)
- Ícone de 100px de tamanho
- Texto de status em `fontSize: 28`
- Dois botões: `"+"` (aumentar) e `"-"` (diminuir) lado a lado
- `Scaffold` com `backgroundColor` dinâmico conforme tabela acima

---

### 4.4 Tela — Mini Game: Pedra, Papel e Tesoura

Jogo completo contra o computador com placar e campeonato automático. O computador escolhe aleatoriamente usando `Random().nextInt(3)`.

**Variáveis de Estado:**

| Variável | Tipo | Descrição |
|----------|------|-----------|
| `iconeComputador` | `IconData` | Ícone exibindo a escolha atual do computador |
| `resultado` | `String` | Mensagem de resultado da rodada atual |
| `pontosJogador` | `int` | Pontuação acumulada do jogador |
| `pontosComputador` | `int` | Pontuação acumulada do computador |
| `opcoes` | `List<String>` | Lista `['pedra', 'papel', 'tesoura']` para sorteio |

**Regras do Jogo:**
- Pedra vence Tesoura
- Papel vence Pedra
- Tesoura vence Papel
- Resultado igual = Empate (sem alteração de pontos)

**Regras do Campeonato:**
- O primeiro a atingir 5 pontos vence o campeonato
- Ao vencer, os pontos são resetados automaticamente e o resultado exibe mensagem de campeão

**Mapeamento de Ícones:**

| Escolha | Ícone Flutter |
|---------|--------------|
| Pedra | `Icons.landscape` |
| Papel | `Icons.pan_tool` |
| Tesoura | `Icons.content_cut` |

**Interface:**
- Texto `"Computador"` com ícone de 100px exibindo a escolha do PC
- Texto de resultado em `fontSize: 26`
- Placar `"Você: X | PC: Y"` em texto
- Três `IconButton`s para o jogador escolher (pedra, papel, tesoura)
- Botão `"Resetar Placar"` com ícone `Icons.refresh`

---

## 5. Arquitetura e Estrutura de Arquivos

O projeto deve ser organizado com uma pasta `screens/` contendo um arquivo por tela, mantendo o `main.dart` limpo e responsável apenas pela inicialização e configuração do app.

```
lib/
├── main.dart
└── screens/
    ├── home_screen.dart
    ├── semaforo_screen.dart
    ├── temperatura_screen.dart
    └── game_screen.dart
```

| Arquivo | Responsabilidade |
|---------|-----------------|
| `lib/main.dart` | Inicialização do app e definição de rotas |
| `lib/screens/home_screen.dart` | Tela de navegação principal |
| `lib/screens/semaforo_screen.dart` | Lógica e interface do semáforo |
| `lib/screens/temperatura_screen.dart` | Lógica e interface do termômetro |
| `lib/screens/game_screen.dart` | Lógica e interface do mini game |

### 5.1 Dependências

O projeto não requer dependências externas além do SDK do Flutter. A única biblioteca adicional de Dart é:

- `dart:math` — para geração de número aleatório no Mini Game

```dart
import 'dart:math';
```

### 5.2 Navegação

Utilizar `Navigator.push()` com `MaterialPageRoute` para navegar da Home para cada tela. As telas filhas devem ter botão de voltar padrão via `AppBar`.

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => SemaforoScreen()),
);
```

---

## 6. Requisitos Não-Funcionais

| Requisito | Descrição |
|-----------|-----------|
| Plataforma | Android e iOS (suporte nativo Flutter) |
| Versão do Flutter | Compatível com Flutter 3.x ou superior |
| Idioma | Português Brasileiro (interface e textos) |
| Debug Banner | `debugShowCheckedModeBanner: false` em todos os `MaterialApp` |
| Performance | Sem animações complexas; resposta imediata ao toque |
| Legibilidade | Cada tela em arquivo separado; funções nomeadas descritivamente |

---

## 7. Critérios de Aceite

### 7.1 Semáforo
- [ ] Pressionar o botão cicla corretamente: verde → amarelo → vermelho → verde
- [ ] Apenas uma luz acende por vez; as demais ficam cinzas
- [ ] O semáforo de pedestre exibe ícone e texto corretos conforme o estado

### 7.2 Temperatura
- [ ] Os botões `+` e `−` incrementam e decrementam a temperatura corretamente
- [ ] Cor de fundo, ícone e texto mudam conforme os limites definidos na seção 4.3
- [ ] A interface atualiza imediatamente após cada toque

### 7.3 Mini Game
- [ ] O computador sorteia aleatoriamente a cada rodada
- [ ] O ícone do computador muda conforme a escolha sorteada
- [ ] O placar incrementa corretamente; empate não altera pontos
- [ ] Ao atingir 5 pontos, o campeonato encerra, exibe mensagem e reseta automaticamente
- [ ] O botão `"Resetar Placar"` zera os pontos de ambos

### 7.4 Navegação
- [ ] A Home exibe três opções de navegação funcionais
- [ ] Cada tela possui `AppBar` com título correto e botão de voltar
- [ ] Não há crash ao navegar entre telas ou ao pressionar voltar

---

## 8. Fora do Escopo

- Persistência de dados (banco de dados local ou remoto)
- Autenticação ou perfil de usuário
- Animações complexas ou transições customizadas
- Som ou vibração
- Suporte a web ou desktop
- Testes automatizados (não obrigatórios nesta fase)

---

## 9. Cronograma Sugerido (Aula)

| Etapa | Atividade | Entregável |
|-------|-----------|------------|
| 1 | Criar projeto e estrutura de pastas | Projeto Flutter inicializado com pasta `screens/` |
| 2 | Implementar Home Screen | Tela de navegação funcional |
| 3 | Implementar Semáforo | Semáforo e pedestre funcionando |
| 4 | Implementar Temperatura | Termômetro com feedback visual |
| 5 | Implementar Mini Game | Jogo completo com placar e campeonato |
| 6 | Integração e testes | App completo navegável sem erros |

---

*PRD — Projeto Flutter Educacional | v1.0 | Março 2026*
