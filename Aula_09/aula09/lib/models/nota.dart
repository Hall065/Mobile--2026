class Nota {
  final int? id;
  final String titulo;
  final String corpo;
  final int cor;      // Cor salva como ARGB int
  final String criado; // ISO 8601

  const Nota({
    this.id,
    required this.titulo,
    required this.corpo,
    this.cor = 0xFF6C63FF,
    required this.criado,
  });

  // ─── Serialização ────────────────────────────────────────────────────────────

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'corpo': corpo,
      'cor': cor,
      'criado': criado,
    };
  }

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      corpo: map['corpo'] as String,
      cor: map['cor'] as int,
      criado: map['criado'] as String,
    );
  }

  // ─── Cópia com alterações ────────────────────────────────────────────────────

  Nota copyWith({
    int? id,
    String? titulo,
    String? corpo,
    int? cor,
    String? criado,
  }) {
    return Nota(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      corpo: corpo ?? this.corpo,
      cor: cor ?? this.cor,
      criado: criado ?? this.criado,
    );
  }

  @override
  String toString() =>
      'Nota(id: $id, titulo: $titulo, criado: $criado)';
}
