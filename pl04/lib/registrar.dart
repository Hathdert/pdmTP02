import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'main.dart'; // Importa o main.dart para navegar para a página principal

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

  void _register() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: _usernameController.text,
      DatabaseHelper.columnPassword: _passwordController.text,
      DatabaseHelper.columnScore: 0, // Inicia o score com 0 ao registrar
    };
    await dbHelper.insert(row);
    _usernameController.clear();
    _passwordController.clear();

    // Start the animation
    _animationController.forward(from: 0.0);

    // Show a SnackBar with confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuário registrado com sucesso!')),
    );

    // Navigate back to the main screen after a delay to allow SnackBar to be visible
    await Future.delayed(const Duration(seconds: 2));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()), // Navega para a página principal
    );
  }

  void _voltar() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()), // Navega para a página principal
    );
  }

  Widget _buildListView() {
    return ListView(
      children: const [
        ListTile(
          title: Text('Usuário registrado com sucesso!'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar"),
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
                  hintText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  hintText: 'Password',
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
                child: _buildListView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
