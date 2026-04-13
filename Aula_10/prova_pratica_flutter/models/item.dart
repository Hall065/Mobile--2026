// lib/models/item.dart

class Item {
  final int? id;
  final String titulo;
  final String descricao;
  final String data; // bônus: campo data de criação

  Item({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.data,
  });

  // Converte Map (banco) → Item
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int?,
      titulo: map['titulo'] as String,
      descricao: map['descricao'] as String? ?? '',
      data: map['data'] as String? ?? '',
    );
  }

  // Converte Item → Map (banco)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'data': data,
    };
  }

  // Cria uma cópia com campos alterados (usado na edição)
  Item copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? data,
  }) {
    return Item(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
    );
  }
}