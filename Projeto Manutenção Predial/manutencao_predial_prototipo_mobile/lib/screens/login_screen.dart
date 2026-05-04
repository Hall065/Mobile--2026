import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../database/database_helper.dart';
import '../widgets/common_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _senhaVisible = false;
  bool _loading = false;
  String? _erro;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _loading = true; _erro = null; });
    try {
      final user = await DatabaseHelper.instance
          .login(_emailCtrl.text.trim(), _senhaCtrl.text);
      if (!mounted) return;
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/dashboard',
            arguments: {'userName': user.nome});
      } else {
        setState(() { _erro = 'Usuário ou senha incorretos.'; });
      }
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Geometric background shapes
          Positioned(
            bottom: -20,
            right: -30,
            child: _GeometricShape(size: 200, opacity: 0.08),
          ),
          Positioned(
            bottom: 60,
            left: -40,
            child: _GeometricShape(size: 150, opacity: 0.05),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    // Logo
                    const Center(child: SenaiLogo()),
                    const SizedBox(height: 56),
                    // Title
                    const Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Acesse sua conta para continuar',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 36),
                    // Usuário
                    const _FieldLabel(text: 'Usuário'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: 'Email ou CPF',
                        prefixIcon: Icon(Icons.person_outline,
                            color: AppColors.textSecondary, size: 20),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe o usuário' : null,
                    ),
                    const SizedBox(height: 20),
                    // Senha
                    const _FieldLabel(text: 'Senha'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _senhaCtrl,
                      obscureText: !_senhaVisible,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: '••••••••',
                        prefixIcon: const Icon(Icons.lock_outline,
                            color: AppColors.textSecondary, size: 20),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() { _senhaVisible = !_senhaVisible; }),
                          icon: Icon(
                            _senhaVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Informe a senha' : null,
                    ),
                    if (_erro != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _erro!,
                        style: const TextStyle(
                            color: AppColors.primary, fontSize: 13),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Esqueceu a senha?',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botão acessar
                    ElevatedButton(
                      onPressed: _loading ? null : _login,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Text('Acessar'),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, '/cadastro'),
                        child: RichText(
                          text: const TextSpan(
                            text: 'Não possui conta? ',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 13),
                            children: [
                              TextSpan(
                                text: 'Fazer Cadastro',
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
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _GeometricShape extends StatelessWidget {
  final double size;
  final double opacity;
  const _GeometricShape({required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: CustomPaint(
        size: Size(size, size),
        painter: _CubePainter(),
      ),
    );
  }
}

class _CubePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.4;

    // Draw diamond/cube shape
    final path = Path()
      ..moveTo(cx, cy - r)
      ..lineTo(cx + r * 0.866, cy - r * 0.5)
      ..lineTo(cx + r * 0.866, cy + r * 0.5)
      ..lineTo(cx, cy + r)
      ..lineTo(cx - r * 0.866, cy + r * 0.5)
      ..lineTo(cx - r * 0.866, cy - r * 0.5)
      ..close();

    canvas.drawPath(path, paint);

    // Inner lines for 3D effect
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r * 0.2), paint);
    canvas.drawLine(Offset(cx + r * 0.866, cy - r * 0.5),
        Offset(cx - r * 0.4, cy + r * 0.2), paint);
    canvas.drawLine(Offset(cx - r * 0.866, cy - r * 0.5),
        Offset(cx + r * 0.4, cy + r * 0.2), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
