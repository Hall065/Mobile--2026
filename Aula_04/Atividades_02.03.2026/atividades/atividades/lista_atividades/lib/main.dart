import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  ); // Passo 1 - Tem q ser passado um Widget, pois tudo dentro do flutter é uma widget, ent o MyApp seria como a widget mãe do projeto.
}

class MyApp extends StatelessWidget {
  // Passo 2.1 - O widget deve ser Stateless.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(
        title: 'Lista de Atividades',
      ), // Passo 2.2 - É Sateless pois não guarda o Estado(Cont, Animação, Mudança dinâmica, etc), ou seja, n precisa se recontruir com base em mudanças internas.
    );
  }
}

class MyHomePage extends StatefulWidget {
  // Passo 3.1 foi preservado a estrutura da MyHomePage, que tem a mesma estrutura da TodoPage sugerida na atividade
  const MyHomePage({super.key, required this.title});
  // Main Page.
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Passo 3.2 foi preservada a class MyHomePageState, que tem a mesma estrutura da TodoPageState sugerida na atividade.
  // Passo 4 - Essa variavel tem q estar dentro da _MyHomePageState pq ela define estado da tela, e no flutter quem guarda estado é a classe State (Nesse caso _MyHomePageState), não o StatefulWidget(Classe que engloba está em questão).
  final List<String> tarefas = [];

  // Passo 5 - Controla o texto do TextField, consegue apresentar, limpar e alterar oq foi digitado.
  final TextEditingController controller = TextEditingController();

  // Função Adicionar Tarefa
  void adicionarTarefa() {
    if (controller.text.trim().isEmpty) return; // Extra 1 - Impedir tarefa vazia

    setState(() {
      // Passo 6.1 - Remover o setState resulta em vc n atualizar mais o parametro, vc ainda atualiza a lista, mas vc n exibe na tela
      tarefas.add(controller.text);
    });

    debugPrint(
      tarefas.toString(),
    ); // Passo 7.2 - apenas print(tarefas) foi trocado por essa linha por Boas praticas do dart, funcionalidade identica.

    controller
        .clear(); // Passo 6.2 - controller.clear() apaga o testo do TextField.
    // Fluxo Logico:
    //
    // Usuário digita
    //   ↓
    // controller.text
    //   ↓
    // setState()
    //   ↓
    // Lista atualiza
    //   ↓
    // build() roda de novo
    //   ↓
    // Tela atualiza
    //   ↓
    // controller.clear()
  }

  // Passo 8 - Função Remover
  void removerTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);
    });
  }
    // Fluxo completo:
    //
    // Clica no ícone
    //  ↓
    // removerTarefa(index)
    //  ↓
    // setState()
    //  ↓
    // Lista reconstrói
    //  ↓
    // Item some da tela

  @override
  Widget build(BuildContext context) {
    // Return Contexto com base na chamada do Estado.
    return Scaffold(
      appBar: AppBar(
        // Customização da AppBar.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Titulo da AppBar
        title: Text('Tarefas (${tarefas.length})'), // Extra 2 - Mostrar quantidade de tarefas no AppBar.
      ),
      body: Column(
        children: [
          // Campo de texto
          TextField(
            controller: controller,
            onSubmitted: (_) => adicionarTarefa(), // Extra 3 - Enter adiciona
          ),

          // Botão add tarefa
          ElevatedButton(
            onPressed: adicionarTarefa,
            child: const Text("Adicionar"),
          ),

          // Exibição da Lista
          //
          // Oq é index? - Possição de que um item oucupa em um array = [0, 1, 2, 3...]
          // Por que usamos .length? - Para percorrer todo o 'comprimento' do array, ou seja passar por todos os itens e fazer algo com eles, nesse caso exibilos.
          Expanded(
            child: tarefas.isEmpty
              ? const Center( // Extra 4 - Mensagem se vazio
                  child: Text(
                    "Nenhuma tarefa ainda",
                    style: TextStyle(fontSize: 18),
                  ),
                )
            : ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tarefas[index]),
                    trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => removerTarefa(index),
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
