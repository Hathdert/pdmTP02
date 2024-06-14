import 'package:flutter/material.dart';
import 'database_helper.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> _leaderboardData = [];

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  void _fetchLeaderboardData() async {
    final data = await dbHelper.queryTop5Leaderboard();
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
