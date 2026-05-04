class EstoqueItem {
  final int? id;
  final String nome;
  final String categoria;
  final double quantidade;
  final String unidade;
  final double quantidadeMinima;
  final String? localizacao;
  final String updatedAt;

  EstoqueItem({
    this.id,
    required this.nome,
    required this.categoria,
    required this.quantidade,
    required this.unidade,
    required this.quantidadeMinima,
    this.localizacao,
    required this.updatedAt,
  });

  bool get estoqueBaixo => quantidade <= quantidadeMinima;

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'nome': nome,
        'categoria': categoria,
        'quantidade': quantidade,
        'unidade': unidade,
        'quantidade_minima': quantidadeMinima,
        'localizacao': localizacao,
        'updated_at': updatedAt,
      };

  factory EstoqueItem.fromMap(Map<String, dynamic> m) => EstoqueItem(
        id: m['id'] as int?,
        nome: m['nome'] as String,
        categoria: m['categoria'] as String,
        quantidade: (m['quantidade'] as num).toDouble(),
        unidade: m['unidade'] as String,
        quantidadeMinima: (m['quantidade_minima'] as num).toDouble(),
        localizacao: m['localizacao'] as String?,
        updatedAt: m['updated_at'] as String,
      );

  EstoqueItem copyWith({
    int? id,
    String? nome,
    String? categoria,
    double? quantidade,
    String? unidade,
    double? quantidadeMinima,
    String? localizacao,
    String? updatedAt,
  }) =>
      EstoqueItem(
        id: id ?? this.id,
        nome: nome ?? this.nome,
        categoria: categoria ?? this.categoria,
        quantidade: quantidade ?? this.quantidade,
        unidade: unidade ?? this.unidade,
        quantidadeMinima: quantidadeMinima ?? this.quantidadeMinima,
        localizacao: localizacao ?? this.localizacao,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
