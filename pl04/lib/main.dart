import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'registrar.dart';
import 'usersession.dart';
import 'menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // A instância da base de dados é criada antes de iniciar a app
  await DatabaseHelper.instance.database;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Verifica se o usuário existe com a senha correspondente
    bool userExists = await dbHelper.userExists(username, password);
    if (userExists) {
      // Show a Snackbar to indicate successful login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bem-vindo, $username!'),
        ),
      );

      UserSession userSession = UserSession();
      userSession.username = username;
      // Navigate to the new page after a short delay
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MenuPage()),
        );
      });
    } else {
      // Show a Snackbar to indicate invalid credentials
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuário ou senha inválidos.'),
        ),
      );
    }
  }

  void _delete() async {
    String nome = _usernameController.text;
    showAlertDialog(this.context, nome);
    await dbHelper.delete(nome);
    _usernameController.clear(); // Limpa o TextField após a inserção
  }

  List<Map<String, dynamic>> _rows = [];
  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    setState(() {
      _rows =
          allRows; // Atualiza a lista de dados com os resultados da consulta
    });
  }

  Widget _buildListView() {
    return ListView.builder(
      itemCount: _rows.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_rows[index][DatabaseHelper.columnName]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite"),
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
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrarPage()),
                );
              },
              child: const Text('Registrar'),
            ),
            Expanded(
              child: _buildListView(),
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context, String message) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {},
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: const Text("DEBUG"),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
