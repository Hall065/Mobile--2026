class Usuario {
  final int? id;
  final String nome;
  final String emailCpf;
  final String senha;
  final String createdAt;

  Usuario({
    this.id,
    required this.nome,
    required this.emailCpf,
    required this.senha,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'nome': nome,
        'email_cpf': emailCpf,
        'senha': senha,
        'created_at': createdAt,
      };

  factory Usuario.fromMap(Map<String, dynamic> m) => Usuario(
        id: m['id'] as int?,
        nome: m['nome'] as String,
        emailCpf: m['email_cpf'] as String,
        senha: m['senha'] as String,
        createdAt: m['created_at'] as String,
      );
}
