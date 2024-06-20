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
  int _score = 0; //variável para registrar o score
  int _highScore = 0; //variável para registrar o maior score
  String? _userAnswer; //variável com a resposta do jogador

  final int _userId =
      UserSession().id ?? 0; //recupera o id do usuário na sessão

  //Função para dar inicio a um novo jogo , recebe o nivel de dificuldade do jogo que irá iniciar
  void _startGame(int nivel) {
    //é chamada a função receberQuestao, enviando o nivel e ela retorna duas strings, uma com a pergunta e outra com a resposta.
    
    //Map<String, String> questao = Questoes.receberQuestao(nivel);

    //Para ativar as questões aleatórias, descomentar o codigo e comentar o anterior:

    Map<String, dynamic> questao = QuestoesRand.receberQuestaoRand(nivel);

    //Mostra um alertDialog com a pergunta e campo para responder
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Nível $nivel'), //mostra o nivel da questao
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(questao['pergunta']!), //mostra a pergunta
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  _userAnswer = value;
                },
                decoration: const InputDecoration(
                  //espera pela resposta
                  hintText: 'Sua resposta',
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _checkAnswer(questao['resposta']!,
                    nivel); //chama a função para comparar a resposta com a correta
              },
              child: const Text('Responder'),
            ),
          ],
        );
      },
    );
  }

  //Função que verifica se as respostas estão corretas ou não
  void _checkAnswer(String respostaCorreta, int nivel) async {
    bool acertou = _userAnswer != null && _userAnswer!.toLowerCase() == respostaCorreta.toLowerCase(); // comparar respostas, usando o tolower para não ser case sensitive
    int pontos = _getScoreForLevel(nivel,acertou); //chama a função que devolve a quantide de pontos ganhos ou perdidos na questão

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(acertou
            ? 'Resposta correta!'
            : 'Resposta incorreta. Tente novamente!'),
      ),
    );

    await _updateScore(_userId, pontos); //chama a função que atualiza o score
  }

// Função que retorna a pontuação com base no nível e se acertou ou não
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

// Função assíncrona que atualiza a pontuação do usuário
  Future<void> _updateScore(int userId, int pontos) async {
    int currentScore = await DatabaseHelper.instance.getUserScoreById(userId) ?? 0; // Recupera a pontuação atual do usuário
    int newScore = currentScore + pontos; // Calcula a nova pontuação somando os pontos ganhos ou perdidos

    if (newScore < 0) {
      newScore = 0; // Garante que a pontuação não seja negativa
    }

    if (pontos > 0) {
      await DatabaseHelper.instance.addScore(userId, pontos); // Adiciona pontos à pontuação do usuário - Função addScore
    } else {
      await DatabaseHelper.instance.subtractScore(userId, -pontos); // Subtrai pontos da pontuação do usuário - Função subtractScore
    }

    setState(() {
      _score = newScore; // Atualiza a pontuação exibida na interface
      if (_score > _highScore) {
        _highScore = _score; // Atualiza a pontuação máxima se necessário
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
