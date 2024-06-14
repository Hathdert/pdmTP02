import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'questions.dart';
import 'usersession.dart';
import 'randomquestions.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _score = 0;
  int _highScore = 0;
  String? _userAnswer;

  final int _userId = UserSession().id ?? 0;

  void _startGame(int nivel) {
    
    Map<String, String> questao = Questoes.receberQuestao(nivel);
    //Map<String, dynamic> questao = Questoes.receberQuestao(nivel);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nível $nivel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(questao['pergunta']!),
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  _userAnswer = value;
                },
                decoration: const InputDecoration(
                  hintText: 'Sua resposta',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _checkAnswer(questao['resposta']!, nivel);
              },
              child: const Text('Responder'),
            ),
          ],
        );
      },
    );
  }

  void _checkAnswer(String respostaCorreta, int nivel) async {
    bool acertou = _userAnswer != null && _userAnswer!.toLowerCase() == respostaCorreta.toLowerCase();
    int pontos = _getScoreForLevel(nivel, acertou);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(acertou ? 'Resposta correta!' : 'Resposta incorreta. Tente novamente!'),
      ),
    );

    await _updateScore(_userId, pontos);
  }

  int _getScoreForLevel(int nivel, bool acertou) {
    switch (nivel) {
      case 1:
        return acertou ? 10 : -5;
      case 2:
        return acertou ? 20 : -10;
      case 3:
        return acertou ? 30 : -15;
      default:
        return 0;
    }
  }

  Future<void> _updateScore(int userId, int pontos) async {
    int currentScore = await DatabaseHelper.instance.getUserScoreById(userId) ?? 0;
    int newScore = currentScore + pontos;

    if (newScore < 0) {
      newScore = 0; 
    }

    if (pontos > 0) {
      await DatabaseHelper.instance.addScore(userId, pontos);
    } else {
      await DatabaseHelper.instance.subtractScore(userId, -pontos); 
    }

    setState(() {
      _score = newScore;
      if (_score > _highScore) {
        _highScore = _score;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _startGame(1); // Nível 1
              },
              child: const Text('Nível 1'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _startGame(2); // Nível 2
              },
              child: const Text('Nível 2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _startGame(3); // Nível 3
              },
              child: const Text('Nível 3'),
            ),
            const SizedBox(height: 20),
            Text('Pontuação: $_score'),
            Text('Pontuação máxima: $_highScore'),
          ],
        ),
      ),
    );
  }
}
