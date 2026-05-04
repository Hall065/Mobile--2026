class Agendamento {
  final int? id;
  final String titulo;
  final String local;
  final String horario;
  final String data;
  final String? tipo;

  Agendamento({
    this.id,
    required this.titulo,
    required this.local,
    required this.horario,
    required this.data,
    this.tipo,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'titulo': titulo,
        'local': local,
        'horario': horario,
        'data': data,
        'tipo': tipo,
      };

  factory Agendamento.fromMap(Map<String, dynamic> m) => Agendamento(
        id: m['id'] as int?,
        titulo: m['titulo'] as String,
        local: m['local'] as String,
        horario: m['horario'] as String,
        data: m['data'] as String,
        tipo: m['tipo'] as String?,
      );
}
