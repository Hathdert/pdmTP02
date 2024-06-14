
import 'dart:math';

class Questoes {
  static List<Map<String, String>> nivel1 = [
    {
      'pergunta': 'Qual é o Network ID do endereço IP 192.168.1.10 com máscara de sub-rede /24?',
      'resposta': '192.168.1.0'
    },
    {
      'pergunta': 'Qual é o Broadcast do endereço IP 10.0.0.5 com máscara de sub-rede /8?',
      'resposta': '10.255.255.255'
    },
    {
      'pergunta': 'Os endereços IP 172.16.5.1 e 172.16.10.1 estão no mesmo segmento de rede com máscara de sub-rede /16?',
      'resposta': 'Sim'
    },
  ];

  static List<Map<String, String>> nivel2 = [
    {
      'pergunta': 'Qual é o Network ID do endereço IP 192.168.1.130 com máscara de sub-rede 255.255.255.192?',
      'resposta': '192.168.1.128'
    },
    {
      'pergunta': 'Qual é o Broadcast do endereço IP 172.16.4.66 com máscara de sub-rede 255.255.255.240?',
      'resposta': '172.16.4.79'
    },
    {
      'pergunta': 'Os endereços IP 192.168.2.33 e 192.168.2.65 estão no mesmo segmento de rede com máscara de sub-rede 255.255.255.224?',
      'resposta': 'Não'
    },
  ];

  static List<Map<String, String>> nivel3 = [
    {
      'pergunta': 'Qual é o Network ID do endereço IP 198.51.100.14 com máscara de sub-rede 255.255.252.0?',
      'resposta': '198.51.100.0'
    },
    {
      'pergunta': 'Qual é o Broadcast do endereço IP 203.0.113.75 com máscara de sub-rede 255.255.248.0 ou /21?',
      'resposta': '203.0.119.255'
    },
    {
      'pergunta': 'Os endereços IP 192.0.2.35 e 192.0.2.100 estão no mesmo segmento de rede com máscara de sub-rede 255.255.240.0?',
      'resposta': 'Sim'
    },
  ];

  static Map<String, String> receberQuestao(int nivel) {
    List<Map<String, String>> questions;
    switch (nivel) {
      case 1:
        questions = nivel1;
        break;
      case 2:
        questions = nivel2;
        break;
      case 3:
        questions = nivel3;
        break;
      default:
        return {};
    }

    Random random = Random();
    int index = random.nextInt(questions.length);
    return questions[index];
  }
}