// Classe responsável pela criação de "Cookies". Para manter as informações persistentes depois do login.

class UserSession {
  static final UserSession _instance = UserSession._internal();
  String? username;
  int? id;

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  void clear() {
    username = null;
    id = null;
  }
}
