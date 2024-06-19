import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'register.dart';
import 'usersession.dart';
import 'menu.dart';
import 'leaderboard.dart';

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
  
  //Cria uma nova instância da classe de base de dados - Final = não pode ser alterado - é atribuido o valor apenas uma vez. 
  final dbHelper = DatabaseHelper.instance; 

  // Instancia duas classes responsáveis por controlar os dois campos de texto da página (username, password)
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //Função para Login
  void _login() async {

    //Atribui a username e password os valores das textbox.
    String username = _usernameController.text;
    String password = _passwordController.text;

    //Verifica através da função userExists se o usuário existe na base de dados (retorna bool).
    bool userExists = await dbHelper.userExists(username, password);
    
    if (userExists) {
      
      // cria um novo objeto do tipo UserSession e preenche com os dados do usuário
      UserSession userSession = UserSession();
      userSession.username = username;
      userSession.id = await dbHelper.getUserId(username, password); //utiliza a função getUserId para recuperar o ID do usuario e juntar à sessão
      
      // Mostra um ScaffoldMessenger do tipo snackbar (mensagem na parte inferior do ecrã) - ScafoldMessenger = widget de gerenciamento de exibição de snackbar, etc.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bem-vindo, $username!'),
        ),
      );
      
      //Navegar para a página de logado ( Menu )
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MenuPage()),
      );

      
    } else {

      //Se não existir usuário, mostra o snack de invalido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário ou senha inválidos.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jogo - Redes de Computadores"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Nome de usuário',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 300,
                child: TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Palavra-Passe',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            //Botão de login
            ElevatedButton(
              onPressed: _login, //Ao ser pressional vai para a função de login mais acima
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Login'),
            ),

            //Botão de registrar
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegistrarPage()), //envia para a página registrar
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Registrar'),
            ),
            const SizedBox(height: 10),

            //Botão de classificação - top 5
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LeaderboardPage()), //envia para a página leaderBoard
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Text('Classificação - Top 5'),
            ),
          ],
        ),
      ),
    );
  }
}
