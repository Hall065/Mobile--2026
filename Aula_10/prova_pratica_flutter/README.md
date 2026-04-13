# Cadastro Inteligente — Flutter + SQLite

App de cadastro com persistencia local usando SQLite. Permite criar, editar, listar e remover itens, com dados salvos entre sessoes.

## Estrutura do Projeto

```
lib/
├── main.dart                   # Entry point + inicializacao FFI (desktop)
├── helpers/
│   └── database_helper.dart    # Singleton SQLite — CRUD completo
├── models/
│   └── item.dart               # Model + toMap / fromMap / copyWith
└── screens/
    ├── home_screen.dart        # Lista de itens (Read + Delete)
    └── form_screen.dart        # Cadastro e edicao (Create + Update)
```

## Como Rodar

```bash
flutter pub get
flutter run -d windows
```

## Dependencias

```yaml
dependencies:
  sqflite: ^2.3.0
  sqflite_common_ffi: ^2.3.0   # necessario para rodar em Windows/Linux/macOS
  path: ^1.9.0
```

## Banco de Dados

Tabela `dados`:

```sql
CREATE TABLE dados (
  id        INTEGER PRIMARY KEY AUTOINCREMENT,
  titulo    TEXT    NOT NULL,
  descricao TEXT,
  data      TEXT
);
```

## Funcionalidades

- Listar todos os itens ordenados por titulo
- Cadastrar novo item com titulo, descricao e data de criacao automatica
- Editar item existente (data de criacao preservada)
- Remover item com dialogo de confirmacao
- Estado vazio com mensagem quando nao ha itens cadastrados