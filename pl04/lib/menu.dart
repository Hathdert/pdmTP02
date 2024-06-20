import 'package:flutter/material.dart';
import 'package:pl04/main.dart';
import 'database_helper.dart';
import 'usersession.dart';
import 'game.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<String> _username; // Variável para guardar o username da sessão
  late Future<int> _score; // Variável para guardar o score

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Ao abrir a página, chama a função para recuperar dados do usuário
  }

  Future<void> _loadUserData() async {
    // Carrega o nome do usuário do UserSession
    _username = Future<String>(() async {
      return UserSession().username ??
          ''; // Retorna de forma assíncrona o valor do username
    });

    // Carrega o score do usuário usando o ID recuperado do UserSession
    _score = Future<int>(() async {
      int? userId = UserSession().id;
      if (userId != null) {
        return await DatabaseHelper.instance.getUserScoreById(userId) ??
            0; // Recupera o score do usuário
      } else {
        return 0; // Retorna 0 se o ID do usuário for nulo
      }
    });

    // Atualiza a UI após carregar os dados
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: Future.wait([_username, _score]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (!snapshot.hasData) {
              return SizedBox
                  .shrink(); // Retorna um widget vazio se não houver dados
            }

            String username = snapshot.data?[0] ?? '';
            int score = snapshot.data?[1] ?? 0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Bem-vindo, $username!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Pontos: $score',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    // Navega para a página do jogo e espera até que a página do jogo seja concluída
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GamePage()),
                    );

                    // Após retornar da página do jogo, recarrega os dados do usuário
                    _loadUserData();
                  },
                  child: const Text('Começar novo jogo'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Limpa a sessão do usuário e volta para a página inicial
                    UserSession().clear();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const MyHomePage()),
                    );
                  },
                  child: const Text('Sair'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
