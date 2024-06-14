import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "tp02sqlite.db";
  static final _databaseVersion = 1;
  static final table = 'Utilizadores';
  static final columnId = 'id';
  static final columnName = 'nome';
  static final columnPassword = 'password';
  static final columnScore = 'score';
  
  // Classe que usa padrão singleton
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  // Abre a base de dados e a cria (se não existir)
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL para criar a tabela (se não existir)
  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName VARCHAR(50),
        $columnPassword VARCHAR(50),
        $columnScore INTEGER

        )
        ''');
  }

  // Método para inserir usuários
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

   //verifica se usuario existe ou não - retorna bool
  Future<bool> userExists(String nome, String senha) async {
    Database db = await instance.database;
    var res = await db.query(table, where: "$columnName = ? AND $columnPassword = ?", whereArgs: [nome, senha]);
    return res.isNotEmpty;
  }

  // Retorna os 5 usuários com os maiores pontos
Future<List<Map<String, dynamic>>> queryTop5Leaderboard() async {
  Database db = await instance.database;
  var res = await db.query(
    table,
    orderBy: "$columnScore DESC",
    limit: 5, // Limita a consulta aos primeiros 5 registros
  );
  return res;
}


  // Retorna o ID do usuário 
  Future<int?> getUserId(String nome, String senha) async {
    Database db = await instance.database;
    var res = await db.query(table,
        columns: [columnId],
        where: "$columnName = ? AND $columnPassword = ?",
        whereArgs: [nome, senha]);
    if (res.isNotEmpty) {
      return res.first[columnId] as int?;
    } else {
      return null;
    }
  }

  // Verifica se um nome de usuário já existe na base de dados (para fazer verificação no registrar)
  Future<bool> usernameExists(String nome) async {
    Database db = await instance.database;
    var res = await db.query(table,
        columns: [columnName],
        where: "$columnName = ?",
        whereArgs: [nome]);
    return res.isNotEmpty;
  }

  // Retorna o score do usuário pelo ID ( para mostrar no menu do usuário)
  Future<int?> getUserScoreById(int id) async {
    Database db = await instance.database;
    var res = await db.query(table,
        columns: [columnScore],
        where: "$columnId = ?",
        whereArgs: [id]);
    if (res.isNotEmpty) {
      return res.first[columnScore] as int?;
    } else {
      return null;
    }
  }

  // Adiciona pontos ao usuário com base no ID da sessão
  Future<void> addScore(int userId, int pointsToAdd) async {

    
      Database db = await instance.database;
      int currentScore = await getUserScoreById(userId) ?? 0;
      int newScore = currentScore + pointsToAdd;

      await db.update(
        table,
        {columnScore: newScore},
        where: "$columnId = ?",
        whereArgs: [userId],
      );
    
  }

  // Subtrai pontos do usuário com base no ID da sessão
  Future<void> subtractScore(int userId, int pointsToSubtract) async {
  
    
      Database db = await instance.database;
      int currentScore = await getUserScoreById(userId) ?? 0;
      int newScore = currentScore - pointsToSubtract;

      // Garante que o score nunca seja menor que zero
      if (newScore < 0) {
        newScore = 0;
      }

      await db.update(
        table,
        {columnScore: newScore},
        where: "$columnId = ?",
        whereArgs: [userId],
      );
    
  }
}