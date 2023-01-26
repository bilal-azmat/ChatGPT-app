import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDatabase {
  static final ChatDatabase instance = ChatDatabase._init();
  static Database? _database;
  ChatDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('chats.db');
    return _database!;
  }
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    await db.execute('''
      create table ${ChatFields.tableChat} (
      ${ChatFields.columnId} $idType,
      ${ChatFields.columnQuestion} $textType,
      ${ChatFields.columnAnswer} $textType,
      ${ChatFields.columnDateTime} $textType
      )
    ''');
  }

  Future<Chat> create(Chat chat) async {
    final db = await instance.database;
    final id = await db.insert(ChatFields.tableChat, chat.toJson());
    return chat.copy(id:id);
  }

  Future<Chat> readChat(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      ChatFields.tableChat,
      columns: ChatFields.values,
      where: '${ChatFields.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Chat.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }


  Future<List<Chat>> readAllChat() async {
    final db = await instance.database;
    final result = await db.query(ChatFields.tableChat);
    return result.map((json) => Chat.fromJson(json)).toList();
  }


  Future<List<Chat>> getChatFromDB(String question) async {
    final db = await instance.database;
    final result = await db.query(ChatFields.tableChat,
        where: 'question = ?',
        whereArgs: [question]
    );
    return result.map((json) => Chat.fromJson(json)).toList();
  }

  Future<int> update(Chat chat) async {
    final db = await instance.database;

    return db.update(
      ChatFields.tableChat,
      chat.toJson(),
      where: '${ChatFields.columnId} = ?',
      whereArgs: [chat.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      ChatFields.tableChat,
      where: '${ChatFields.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllChat() async {
    final db = await instance.database;
    return await db.delete(
      ChatFields.tableChat
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}





class ChatFields {
  static final List<String> values = [
    /// Add all fields
    columnId, columnQuestion, columnAnswer, columnDateTime
  ];

  static const  String tableChat = 'chat';
  static const  String columnId = '_id';
  static const String columnQuestion = 'question';
  static const  String columnAnswer = 'answer';
  static const  String columnDateTime = 'dateTime';
}

class Chat {
  final int? id;
  final String question;
  final String answer;
  final String dateTime;
  const Chat({
    this.id,
    required this.question,
    required this.answer,
    required this.dateTime
  });
  Chat copy({
    int? id,
    String? question,
    String? answer,
    String? dateTime
  }) =>
      Chat(
        id: id ?? this.id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
          dateTime:dateTime ?? this.dateTime
      );
  static Chat fromJson(Map<String, Object?> json) => Chat(
    id: json[ChatFields.columnId] as int?,
    question: json[ChatFields.columnQuestion] as String,
    answer: json[ChatFields.columnAnswer] as String,
    dateTime: json[ChatFields.columnDateTime] as String,
  );
  Map<String, Object?> toJson() => {
    ChatFields.columnId: id,
    ChatFields.columnQuestion: question,
    ChatFields.columnAnswer: answer,
    ChatFields.columnDateTime:dateTime
  };
}