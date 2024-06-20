import 'package:flutter/material.dart';
import 'database_helper.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  //Cria uma nova instância da classe de base de dados - Final = não pode ser alterado - é atribuido o valor apenas uma vez.
  final dbHelper = DatabaseHelper.instance;

  // Variável para o valor do leaderboard
  List<Map<String, dynamic>> _leaderboardData = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData(); //ao iniciar a pagina, chama a função para preencher o leaderboard
  }

  void _fetchLeaderboardData() async {
    final data = await dbHelper
        .queryTop5Leaderboard(); //utiliza a função queryTop5Leaderboard
    setState(() {
      _leaderboardData = data;
    });
  }

  Widget _buildLeaderboard() {
    return ListView.builder(
      itemCount: _leaderboardData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'NOME',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                _leaderboardData[index][DatabaseHelper.columnName],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'PONTOS',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                _leaderboardData[index][DatabaseHelper.columnScore].toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top 5 - Classificados'),
      ),
      body: _leaderboardData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildLeaderboard(),
    );
  }
}
