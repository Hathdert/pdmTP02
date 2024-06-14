import 'dart:math';

class QuestoesRand {
  static List<Map<String, dynamic>> nivel1 = [
    {
      'pergunta': 'Qual é o Network ID do endereço IP {IP} com máscara de sub-rede /24? Resposta: ',
      'resposta': (String ip) => '${ip.split('.').sublist(0, 3).join('.')}.0',
    },
    {
      'pergunta': 'Qual é o Broadcast do endereço IP {IP} com máscara de sub-rede /8? Resposta: ',
      'resposta': (String ip) => '10.255.255.255',
    },
    {
      'pergunta': 'Os endereços IP {IP1} e {IP2} estão no mesmo segmento de rede com máscara de sub-rede /16? Resposta: ',
      'resposta': (String ip1, String ip2) {
        List<String> parts1 = ip1.split('.');
        List<String> parts2 = ip2.split('.');
        return parts1.sublist(0, 2).join('.') == parts2.sublist(0, 2).join('.');
      },
    },
  ];

  static List<Map<String, dynamic>> nivel2 = [
    {
      'pergunta': 'Qual é o Network ID do endereço IP {IP} com máscara de sub-rede 255.255.255.192? Resposta: ',
      'resposta': (String ip) {
        List<String> parts = ip.split('.');
        int subnetMask = 192;
        int networkID = int.parse(parts[2]) & (255 - subnetMask);
        return '${parts[0]}.${parts[1]}.${networkID}.0';
      },
    },
    {
      'pergunta': 'Qual é o Broadcast do endereço IP {IP} com máscara de sub-rede 255.255.255.240? Resposta: ',
      'resposta': (String ip) {
        List<String> parts = ip.split('.');
        int subnetMask = 240;
        int broadcast = int.parse(parts[3]) | (255 - subnetMask);
        return '${parts[0]}.${parts[1]}.${parts[2]}.$broadcast';
      },
    },
    {
      'pergunta': 'Os endereços IP {IP1} e {IP2} estão no mesmo segmento de rede com máscara de sub-rede 255.255.255.224? Resposta: ',
      'resposta': (String ip1, String ip2) {
        List<String> parts1 = ip1.split('.');
        List<String> parts2 = ip2.split('.');
        return parts1.sublist(0, 3).join('.') == parts2.sublist(0, 3).join('.');
      },
    },
  ];

  static List<Map<String, dynamic>> nivel3 = [
    {
      'pergunta': 'Qual é o Network ID do endereço IP {IP} com máscara de sub-rede 255.255.252.0? Resposta: ',
      'resposta': (String ip) {
        List<String> parts = ip.split('.');
        int subnetMask = 252;
        int networkID = int.parse(parts[2]) & (255 - subnetMask);
        return '${parts[0]}.${parts[1]}.${networkID}.0';
      },
    },
    {
      'pergunta': 'Qual é o Broadcast do endereço IP {IP} com máscara de sub-rede 255.255.248.0 ou /21? Resposta: ',
      'resposta': (String ip) {
        List<String> parts = ip.split('.');
        int subnetMask = 248;
        int broadcast = int.parse(parts[3]) | (255 - subnetMask);
        return '${parts[0]}.${parts[1]}.${parts[2]}.$broadcast';
      },
    },
    {
      'pergunta': 'Os endereços IP {IP1} e {IP2} estão no mesmo segmento de rede com máscara de sub-rede 255.255.240.0? Resposta: ',
      'resposta': (String ip1, String ip2) {
        List<String> parts1 = ip1.split('.');
        List<String> parts2 = ip2.split('.');
        return parts1.sublist(0, 3).join('.') == parts2.sublist(0, 3).join('.');
      },
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

    Random random = Random();
    int index = random.nextInt(questions.length);

    String ip1 = '${random.nextInt(256)}.${random.nextInt(256)}.${random.nextInt(256)}.${random.nextInt(256)}';
    String ip2 = '${random.nextInt(256)}.${random.nextInt(256)}.${random.nextInt(256)}.${random.nextInt(256)}';
    String ip = '${random.nextInt(256)}.${random.nextInt(256)}.${random.nextInt(256)}.${random.nextInt(256)}';

    String pergunta = questions[index]['pergunta'].replaceAll('{IP}', ip).replaceAll('{IP1}', ip1).replaceAll('{IP2}', ip2);
    dynamic resposta = questions[index]['resposta'];
    
    if (resposta is Function) {
      int numArgs = resposta.runtimeType.toString().split(',').length;
      if (numArgs == 1) {
        resposta = resposta(ip);
      } else if (numArgs == 2) {
        resposta = resposta(ip1, ip2);
      }
    }

    return {
      'pergunta': pergunta + resposta.toString(),
      'resposta': resposta.toString(),
    };
  }
}
