import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _db = DatabaseHelper.instance;
  final _nomeCtrl = TextEditingController();
  bool _carregando = true;
  bool _salvando = false;
  int _totalNotas = 0;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  @override
  void dispose() {
    _nomeCtrl.dispose();
    super.dispose();
  }

  Future<void> _carregarPerfil() async {
    final nome = await _db.lerConfig('nome_usuario') ?? 'Usuário';
    final total = await _db.contarNotas();
    setState(() {
      _nomeCtrl.text = nome;
      _totalNotas = total;
      _carregando = false;
    });
  }

  Future<void> _salvarNome() async {
    final nome = _nomeCtrl.text.trim();
    if (nome.isEmpty) return;

    setState(() => _salvando = true);
    await _db.salvarConfig('nome_usuario', nome);
    setState(() => _salvando = false);

    if (!mounted) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nome salvo com sucesso! ✅'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        title: const Text(
          'Meu Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // ── Avatar ──────────────────────────────────────────────────
                Center(
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6C63FF).withAlpha(30),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF6C63FF),
                        width: 2.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 52,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _nomeCtrl.text.isEmpty ? 'Usuário' : _nomeCtrl.text,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF37474F),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Estatísticas ─────────────────────────────────────────────
                _cardEstatistica(),
                const SizedBox(height: 24),

                // ── Campo de nome ────────────────────────────────────────────
                const Text(
                  'Seu nome',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF616161),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _nomeCtrl,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'Como você quer ser chamado?',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        color: Color(0xFF6C63FF),
                      ),
                    ),
                    style: const TextStyle(fontSize: 16),
                    maxLength: 50,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _salvarNome(),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Botão salvar ─────────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _salvando ? null : _salvarNome,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _salvando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _salvando ? 'Salvando…' : 'Salvar nome',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // ── Rodapé info ──────────────────────────────────────────────
                Center(
                  child: Text(
                    'Os dados são salvos localmente\nno seu dispositivo com SQLite',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _cardEstatistica() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF9C94FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withAlpha(80),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(
            icon: Icons.note_alt_outlined,
            valor: '$_totalNotas',
            label: 'Notas',
          ),
          Container(width: 1, height: 40, color: Colors.white38),
          _statItem(
            icon: Icons.storage_outlined,
            valor: 'SQLite',
            label: 'Armazenamento',
          ),
          Container(width: 1, height: 40, color: Colors.white38),
          _statItem(
            icon: Icons.phone_android_outlined,
            valor: 'Local',
            label: 'Dispositivo',
          ),
        ],
      ),
    );
  }

  Widget _statItem({
    required IconData icon,
    required String valor,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 22),
        const SizedBox(height: 6),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
