
// Classe responsável pela criação de "Cookies". Para manter as informações persistentes depois do login.
// Utiliza o padrão singleton - apenas uma instância é criada. 

class UserSession {

  static final UserSession _instance = UserSession._internal(); //Singleton
  
  //Atributos
  String? username; //Nome de usuário
  int? id; //Id do usuário

  //Construtor
  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  //Método para limpar sessão
  void clear() {
    username = null;
    id = null;
  }
}
