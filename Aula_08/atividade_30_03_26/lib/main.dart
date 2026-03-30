import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─────────────────────────────────────────────
//  PONTO DE ENTRADA
// ─────────────────────────────────────────────
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences – Atividades',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
          brightness: Brightness.light,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// ─────────────────────────────────────────────
//  TELA PRINCIPAL – navegação entre atividades
// ─────────────────────────────────────────────
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    NotasScreen(),    // Atividade 1
    ComprasScreen(),  // Atividade 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.note_outlined),
            selectedIcon: Icon(Icons.note),
            label: 'Notas',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Compras',
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  ATIVIDADE 1 – "Notas que NÃO Somem"
// ═══════════════════════════════════════════════════════
class NotasScreen extends StatefulWidget {
  const NotasScreen({super.key});

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {
  List<String> notas = [];
  final TextEditingController controller = TextEditingController();

  // ── PASSO 6 – initState ──────────────────────
  @override
  void initState() {
    super.initState();
    carregarNotas(); // <── chama função que carrega dados
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ── PASSO 2 – ADICIONAR nota ─────────────────
  void adicionarNota() {
    if (controller.text.isNotEmpty) {
      setState(() {
        notas.add(controller.text); // add → adicionar item
        controller.clear();          // clear → limpar campo
      });
      salvarNotas();
    }
  }

  // ── PASSO 3 – REMOVER nota ───────────────────
  void removerNota(int index) {
    setState(() {
      notas.removeAt(index); // removeAt → remover por posição
    });
    salvarNotas();
  }

  // ── PASSO 4 – SALVAR notas ───────────────────
  void salvarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList("notas", notas); // setStringList → salvar lista
  }

  // ── PASSO 5 – CARREGAR notas ─────────────────
  void carregarNotas() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notas = prefs.getStringList("notas") ?? []; // getStringList → recuperar lista
    });
  }

  // ── PASSO 7 – Interface ──────────────────────
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('📝 Minhas Notas'),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        // Contador de notas na AppBar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.onPrimary.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${notas.length} nota(s)',
                  style: TextStyle(
                      color: cs.onPrimary, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // ── Campo de entrada ─────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Digite uma nota',
                    prefixIcon: Icon(Icons.edit_note_outlined),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => adicionarNota(), // Enter salva
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: adicionarNota, // ← onPressed = adicionarNota
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Salvar Nota'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Lista de notas ───────────────────
          Expanded(
            child: notas.isEmpty
                ? _EmptyState(
                    icon: Icons.note_outlined,
                    text: 'Nenhuma nota ainda',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: notas.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 1,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: cs.primaryContainer,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                  color: cs.onPrimaryContainer,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(notas[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            tooltip: 'Remover nota',
                            onPressed: () =>
                                removerNota(index), // ← removerNota(index)
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
//  ATIVIDADE 2 – "Lista de Compras Inteligente"
// ═══════════════════════════════════════════════════════
class ComprasScreen extends StatefulWidget {
  const ComprasScreen({super.key});

  @override
  State<ComprasScreen> createState() => _ComprasScreenState();
}

class _ComprasScreenState extends State<ComprasScreen> {
  // ── Estrutura sugerida ───────────────────────
  List<String> itens    = [];
  List<bool>   comprado = [];

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ── PASSO 1 – Adicionar item ─────────────────
  void adicionarItem() {
    if (controller.text.trim().isEmpty) return;
    setState(() {
      itens.add(controller.text.trim()); // adiciona texto
      comprado.add(false);                // começa não comprado
      controller.clear();
    });
    salvarDados();
  }

  // ── PASSO 2 – Alternar comprado ──────────────
  void alternarComprado(int index) {
    setState(() {
      comprado[index] = !comprado[index]; // inverte o estado
    });
    salvarDados();
  }

  // ── Remover item ─────────────────────────────
  void removerItem(int index) {
    setState(() {
      itens.removeAt(index);
      comprado.removeAt(index);
    });
    salvarDados();
  }

  // ── DESAFIO EXTRA – Limpar lista ─────────────
  void limparLista() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Limpar lista?'),
        content:
            const Text('Todos os itens serão removidos permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        itens.clear();
        comprado.clear();
      });
      salvarDados();
    }
  }

  // ── PASSO 3 – Salvar dados ───────────────────
  void salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList("itens", itens);
    prefs.setStringList(
      "comprado",
      comprado.map((e) => e.toString()).toList(), // bool → 'true'/'false'
    );
  }

  // ── PASSO 4 – Carregar dados ─────────────────
  void carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      itens = prefs.getStringList("itens") ?? [];

      List<String> listaBool = prefs.getStringList("comprado") ?? [];
      comprado = listaBool.map((e) => e == "true").toList(); // 'true' → bool

      // Garante que as listas ficam sincronizadas
      while (comprado.length < itens.length) {
        comprado.add(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    // ── DESAFIO EXTRA – Contador ─────────────
    final totalComprado = comprado.where((c) => c).length;
    final totalItens    = itens.length;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: const Text('🛒 Lista de Compras'),
        centerTitle: true,
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        actions: [
          // ── DESAFIO EXTRA – Botão limpar lista
          if (itens.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Limpar lista',
              onPressed: limparLista,
            ),
        ],
      ),

      body: Column(
        children: [

          // ── DESAFIO EXTRA – Contador de itens ─
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: itens.isEmpty
                ? const SizedBox.shrink()
                : Container(
                    key: const ValueKey('counter'),
                    width: double.infinity,
                    color: cs.primaryContainer,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '📦 Total: $totalItens item(s)',
                          style: TextStyle(
                              color: cs.onPrimaryContainer,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '✅ Comprado: $totalComprado/$totalItens',
                          style: TextStyle(
                              color: cs.onPrimaryContainer,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
          ),

          // ── Campo de entrada ─────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Adicionar item...',
                      prefixIcon: Icon(Icons.add_shopping_cart_outlined),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => adicionarItem(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: adicionarItem,
                  style: FilledButton.styleFrom(
                      minimumSize: const Size(56, 56)),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),

          // ── Lista de itens ───────────────────
          Expanded(
            child: itens.isEmpty
                ? _EmptyState(
                    icon: Icons.shopping_cart_outlined,
                    text: 'Nenhum item na lista',
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: itens.length,
                    itemBuilder: (context, index) {
                      final done =
                          index < comprado.length ? comprado[index] : false;

                      // ── DESAFIO EXTRA – Cor quando comprado ──
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: done
                              ? Colors.green.withAlpha(20)
                              : cs.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: done
                                ? Colors.green.withAlpha(100)
                                : cs.outlineVariant,
                          ),
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          onTap: () => alternarComprado(index),

                          // Checkbox customizado
                          leading: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 26,
                            height: 26,
                            decoration: BoxDecoration(
                              color:
                                  done ? Colors.green : Colors.transparent,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: done ? Colors.green : cs.outline,
                                width: 2,
                              ),
                            ),
                            child: done
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 16)
                                : null,
                          ),

                          // ── DESAFIO VISUAL – texto riscado ───
                          title: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: TextStyle(
                              fontSize: 15,
                              color: done ? Colors.grey : cs.onSurface,
                              decoration: done
                                  ? TextDecoration.lineThrough // riscado
                                  : TextDecoration.none,
                              decorationColor: Colors.grey,
                            ),
                            child: Text(itens[index]),
                          ),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            tooltip: 'Remover item',
                            onPressed: () => removerItem(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  WIDGET AUXILIAR – Estado vazio reutilizável
// ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EmptyState({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: cs.outlineVariant),
          const SizedBox(height: 16),
          Text(
            text,
            style: TextStyle(
                color: cs.outline,
                fontSize: 16,
                fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
