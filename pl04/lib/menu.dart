import 'package:flutter/material.dart';
import 'package:pl04/main.dart';
import 'database_helper.dart';
import 'usersession.dart';
import 'game.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late Future<String> _username;
  late Future<int> _score;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Carrega o nome do usuário do UserSession
    _username = Future<String>(() async {
      return UserSession().username ?? '';
    });

    // Carrega o score do usuário usando o ID do UserSession
    _score = Future<int>(() async {
      int? userId = UserSession().id;
      if (userId != null) {
        return await DatabaseHelper.instance.getUserScoreById(userId) ?? 0;
      } else {
        return 0; // Define um valor padrão se o ID do usuário não estiver definido
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
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Mostra um indicador de carregamento enquanto os dados são carregados
            } else if (snapshot.hasError) {
              return Text('Erro ao carregar os dados'); // Trata erros, se houver
            } else {
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
                  
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      UserSession().clear();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const MyHomePage()),
                      );
                    },
                    child: const Text('Sair'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
