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

class _RegisterFormState extends State<RegisterForm> {
  //Cria uma nova instância da classe de base de dados - Final = não pode ser alterado - é atribuido o valor apenas uma vez.
  final dbHelper = DatabaseHelper.instance;

  // Instancia duas classes responsáveis por controlar os dois campos de texto da página (username, password)
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Função para registrar novo usuário
  void _register() async {
    //Atribui a username e password os valores das textbox.
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    //Verifica se o conteudo das textbox estão vazios e mostra um snackbar com o erro
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    // Verifica se o nome de usuário já existe através da função usernameExists (retorna bool)
    bool userExists = await dbHelper.usernameExists(username);

    //se existir, mostra snackbar dizendo que existe
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
      _usernameController.clear(); //limpa o conteudo da textbox
      _passwordController.clear(); //limpa o conteudo da textbox

      // Mostra um SnackBar de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário registrado com sucesso!')),
      );

      // Navega de volta para a página inicial
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }

  //Função de voltar - Utilizada pelo botão de voltar
  void _voltar() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
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
            const SizedBox(height: 50),
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
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Palavra-Passe',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _register, //chama a função para registrar
              child: const Text('Registrar'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _voltar, //chama a função de voltar
              child: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
