import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'main.dart'; 

class RegistrarPage extends StatelessWidget {
  const RegistrarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>
    with SingleTickerProviderStateMixin {
  final dbHelper = DatabaseHelper.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  //Função para registrar usuário
  void _register() async {
  String username = _usernameController.text.trim();
  String password = _passwordController.text.trim(); 

  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preencha todos os campos!')),
    );
    return; 
  }

  // Verifica se o nome de usuário já existe (database_helper)
  bool userExists = await dbHelper.usernameExists(username);

  if (userExists) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário já existe!')),
    );
  } else {
    // Se o usuário não existe e os campos estão preenchidos, registra o novo usuário
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: username,
      DatabaseHelper.columnPassword: password,
      DatabaseHelper.columnScore: 0, // Inicia o score com 0 ao registrar
    };

    await dbHelper.insert(row);
    _usernameController.clear();
    _passwordController.clear();

    // Animação
    _animationController.forward(from: 0.0);

    // Mostra um SnackBar de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário registrado com sucesso!')),
    );

    // Navega de volta para a página inicial após um pequeno atraso para que o SnackBar seja visível
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );
  }
}


  void _voltar() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              const MyHomePage()), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Usuário"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Nome de usuário',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Palavra-Passe',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Registrar'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: _voltar,
              child: const Text('Voltar'),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: FadeTransition(
                opacity: _animation,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
