import 'package:flutter/material.dart';
import 'database_helper.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

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
    final data = await dbHelper.queryLeaderboard();
    setState(() {
      ;
    });
  }

  Widget _buildLeaderboard() {
    return ListView.builder(
      itemCount: _leaderboardData.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_leaderboardData[index]['username']),
          trailing: Text(_leaderboardData[index]['score'].toString()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: _leaderboardData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : _buildLeaderboard(),
    );
  }
}
