import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _currentQuestionIndex = 0;
  List<String> _questions = [
    'What is 2 + 2?',
    'What is the capital of France?',
    'What is the largest planet in our solar system?'
  ];
  List<String> _answers = ['4', 'Paris', 'Jupiter'];
  String? _userAnswer;
  int _score = 0;
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _shuffleQuestions();
    _loadHighScore();
  }

  void _shuffleQuestions() {
    final random = Random();
    _questions.shuffle(random);
  }

  void _loadHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  void _saveHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', _highScore);
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
            Text(_questions[_currentQuestionIndex]),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                _userAnswer = value;
              },
              decoration: const InputDecoration(
                hintText: 'Your answer',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _checkAnswer();
              },
              child: const Text('Submit'),
            ),
            const SizedBox(height: 20),
            Text('Score: $_score'),
            Text('High Score: $_highScore'),
          ],
        ),
      ),
    );
  }

// ADICIONAR A BASE DE DADOS
  void _checkAnswer() {
    if (_userAnswer != null && _userAnswer == _answers[_currentQuestionIndex]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correct!'),
        ),
      );
      _score++;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect. Try again!'),
        ),
      );
    }

    if (_score > _highScore) {
      _highScore = _score;
      _saveHighScore();
    }

    setState(() {
      _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;
      _userAnswer = null;
    });
  }
}

void main() {
  runApp(const MaterialApp(
    home: GamePage(),
  ));
}
