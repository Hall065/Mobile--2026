class Chamado {
  final int? id;
  final String titulo;
  final String local;
  final String status;
  final String tipo;
  final String prioridade;
  final String? descricao;
  final String? responsavel;
  final String dataAbertura;
  final String dataAtualizacao;

  Chamado({
    this.id,
    required this.titulo,
    required this.local,
    required this.status,
    required this.tipo,
    required this.prioridade,
    this.descricao,
    this.responsavel,
    required this.dataAbertura,
    required this.dataAtualizacao,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'titulo': titulo,
        'local': local,
        'status': status,
        'tipo': tipo,
        'prioridade': prioridade,
        'descricao': descricao,
        'responsavel': responsavel,
        'data_abertura': dataAbertura,
        'data_atualizacao': dataAtualizacao,
      };

  factory Chamado.fromMap(Map<String, dynamic> m) => Chamado(
        id: m['id'] as int?,
        titulo: m['titulo'] as String,
        local: m['local'] as String,
        status: m['status'] as String,
        tipo: m['tipo'] as String,
        prioridade: m['prioridade'] as String,
        descricao: m['descricao'] as String?,
        responsavel: m['responsavel'] as String?,
        dataAbertura: m['data_abertura'] as String,
        dataAtualizacao: m['data_atualizacao'] as String,
      );

  Chamado copyWith({
    int? id,
    String? titulo,
    String? local,
    String? status,
    String? tipo,
    String? prioridade,
    String? descricao,
    String? responsavel,
    String? dataAbertura,
    String? dataAtualizacao,
  }) =>
      Chamado(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        local: local ?? this.local,
        status: status ?? this.status,
        tipo: tipo ?? this.tipo,
        prioridade: prioridade ?? this.prioridade,
        descricao: descricao ?? this.descricao,
        responsavel: responsavel ?? this.responsavel,
        dataAbertura: dataAbertura ?? this.dataAbertura,
        dataAtualizacao: dataAtualizacao ?? this.dataAtualizacao,
      );
}
