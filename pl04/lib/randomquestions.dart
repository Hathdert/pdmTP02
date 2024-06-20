import 'dart:math';

class QuestoesRand {
  static Random _random = Random();

  static List<Map<String, dynamic>> nivel1 = [
    {
      'pergunta': 'Qual é o Network ID do endereço IP {IP} com máscara de sub-rede /24? Resposta: {RESPOSTA}',
      'resposta': (String ip) => '${ip.split('.').sublist(0, 3).join('.')}.0',
    },
    {
      'pergunta': 'Qual é o Broadcast do endereço IP {IP} com máscara de sub-rede /8? Resposta: 10.255.255.255',
      'resposta': (String ip) => '10.255.255.255',
    },
    {
      'pergunta': 'Os endereços IP {IP1} e {IP2} estão no mesmo segmento de rede com máscara de sub-rede /16? Resposta: {RESPOSTA}',
      'resposta': (String ip1, String ip2) =>
          ip1.split('.').sublist(0, 2).join('.') == ip2.split('.').sublist(0, 2).join('.') ? 'Sim' : 'Não',
    },
  ];

  static List<Map<String, dynamic>> nivel2 = [
    {
      'pergunta': 'Qual é o Network ID do endereço IP {IP} com máscara de sub-rede 255.255.255.192? Resposta: {RESPOSTA}',
      'resposta': (String ip) {
        List<String> parts = ip.split('.');
        int subnetMask = 192;
        int networkID = int.parse(parts[2]) & (255 - subnetMask);
        return '${parts[0]}.${parts[1]}.${networkID}.0';
      },
    },
    {
      'pergunta': 'Qual é o Broadcast do endereço IP {IP} com máscara de sub-rede 255.255.255.240? Resposta: {RESPOSTA}',
      'resposta': (String ip) {
        List<String> parts = ip.split('.');
        int subnetMask = 240;
        int broadcast = int.parse(parts[3]) | (255 - subnetMask);
        return '${parts[0]}.${parts[1]}.${parts[2]}.$broadcast';
      },
    },
    {
      'pergunta': 'Os endereços IP {IP1} e {IP2} estão no mesmo segmento de rede com máscara de sub-rede 255.255.255.224? Resposta: {RESPOSTA}',
      'resposta': (String ip1, String ip2) =>
          ip1.split('.').sublist(0, 3).join('.') == ip2.split('.').sublist(0, 3).join('.') ? 'Sim' : 'Não',
    },
  ];

  static List<Map<String, dynamic>> nivel3 = [
    {
      'pergunta': 'Qual é o Network ID do endereço IP {IP} com máscara de sub-rede 255.255.252.0? Resposta: {RESPOSTA}',
      'resposta': (String ip) {
        List<String> parts = ip.split('.');
        int subnetMask = 252;
        int networkID = int.parse(parts[2]) & (255 - subnetMask);
        return '${parts[0]}.${parts[1]}.${networkID}.0';
      },
    },
    {
      'pergunta': 'Qual é o Broadcast do endereço IP {IP} com máscara de sub-rede 255.255.248.0 ou /21? Resposta: {RESPOSTA}',
      'resposta': (String ip) {
        List<String> parts = ip.split('.');
        int subnetMask = 248;
        int broadcast = int.parse(parts[3]) | (255 - subnetMask);
        return '${parts[0]}.${parts[1]}.${parts[2]}.$broadcast';
      },
    },
    {
      'pergunta': 'Os endereços IP {IP1} e {IP2} estão no mesmo segmento de rede com máscara de sub-rede 255.255.240.0? Resposta: {RESPOSTA}',
      'resposta': (String ip1, String ip2) =>
          ip1.split('.').sublist(0, 3).join('.') == ip2.split('.').sublist(0, 3).join('.') ? 'Sim' : 'Não',
    },
  ];

  static Map<String, dynamic> receberQuestaoRand(int nivel) {
    List<Map<String, dynamic>> questions;
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

    int index = _random.nextInt(questions.length);

    String randomIP() => '${_random.nextInt(256)}.${_random.nextInt(256)}.${_random.nextInt(256)}.${_random.nextInt(256)}';

    String ip1 = randomIP();
    String ip2 = randomIP();
    String ip = randomIP();

    String pergunta = questions[index]['pergunta']
        .replaceAll('{IP}', ip)
        .replaceAll('{IP1}', ip1)
        .replaceAll('{IP2}', ip2);
    dynamic resposta = questions[index]['resposta'];

    if (resposta is Function) {
      int numArgs = resposta.runtimeType.toString().split(',').length;
      if (numArgs == 1) {
        resposta = resposta(ip);
      } else if (numArgs == 2) {
        resposta = resposta(ip1, ip2);
      }
    }

    pergunta = pergunta.replaceAll('{RESPOSTA}', resposta.toString());

    return {
      'pergunta': pergunta,
      'resposta': resposta.toString(),
    };
  }
}
