import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../database/database_helper.dart';
import '../models/usuario.dart';
import '../widgets/common_widgets.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _senhaVisible = false;
  bool _confirmVisible = false;
  bool _loading = false;
  String? _erro;

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _erro = null; });
    try {
      final exists = await DatabaseHelper.instance.emailExists(_emailCtrl.text.trim());
      if (exists) {
        setState(() { _erro = 'Este e-mail/CPF já está cadastrado.'; });
        return;
      }
      final usuario = Usuario(
        nome: _nomeCtrl.text.trim(),
        emailCpf: _emailCtrl.text.trim(),
        senha: _senhaCtrl.text,
        createdAt: DateTime.now().toIso8601String(),
      );
      await DatabaseHelper.instance.insertUsuario(usuario);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: AppColors.statusConcluido,
        ),
      );
      Navigator.pop(context);
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                const Center(child: SenaiLogo()),
                const SizedBox(height: 48),
                const Text(
                  'Cadastro',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Crie sua conta para acessar o sistema',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 36),

                // Nome Completo
                _buildField(
                  label: 'Nome Completo',
                  controller: _nomeCtrl,
                  hint: 'Seu nome completo',
                  icon: Icons.person_outline,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Informe o nome' : null,
                ),
                const SizedBox(height: 20),

                // Email ou CPF
                _buildField(
                  label: 'Email ou CPF',
                  controller: _emailCtrl,
                  hint: 'ex: joao@email.com ou 123.456.789-00',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Informe o email ou CPF' : null,
                ),
                const SizedBox(height: 20),

                // Senha
                _buildField(
                  label: 'Senha',
                  controller: _senhaCtrl,
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscure: !_senhaVisible,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() { _senhaVisible = !_senhaVisible; }),
                    icon: Icon(
                      _senhaVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondary, size: 20,
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 20),

                // Confirmar Senha
                _buildField(
                  label: 'Confirmar Senha',
                  controller: _confirmCtrl,
                  hint: '••••••••',
                  icon: Icons.lock_outline,
                  obscure: !_confirmVisible,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() { _confirmVisible = !_confirmVisible; }),
                    icon: Icon(
                      _confirmVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: AppColors.textSecondary, size: 20,
                    ),
                  ),
                  validator: (v) =>
                      v != _senhaCtrl.text ? 'As senhas não coincidem' : null,
                ),

                if (_erro != null) ...[
                  const SizedBox(height: 12),
                  Text(_erro!, style: const TextStyle(color: AppColors.primary, fontSize: 13)),
                ],
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _loading ? null : _cadastrar,
                  child: _loading
                      ? const SizedBox(height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Avançar'),
                ),
                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Já possui conta? ',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        children: [
                          TextSpan(
                            text: 'Fazer Login',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
            suffixIcon: suffixIcon,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
