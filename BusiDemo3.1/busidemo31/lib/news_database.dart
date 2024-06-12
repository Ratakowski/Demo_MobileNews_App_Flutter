import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:busidemo31/user.dart';

class News {
  final int? id;
  final String title;
  final String summary;
  final String image;
  final String category;

  News({this.id, required this.title, required this.summary, required this.image, required this.category});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'image': image,
      'category': category,
    };
  }

  static News fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'],
      title: map['title'],
      summary: map['summary'],
      image: map['image'],
      category: map['category'],
    );
  }
}

class NewsDatabase {
  static final NewsDatabase instance = NewsDatabase._init();

  static Database? _database;

  NewsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('news.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE news (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        summary TEXT,
        image TEXT,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT,
        last_login_location TEXT
      )
    ''');
  }

  Future<int> insertNews(News news) async {
    final db = await instance.database;
    return await db.insert('news', news.toMap());
  }

  Future<List<News>> fetchNews(String category) async {
    final db = await instance.database;

    final results = await db.query(
      'news',
      where: 'category = ?',
      whereArgs: [category],
    );

    return results.map((result) => News.fromMap(result)).toList();
  }

  Future<int> updateNews(News news) async {
    final db = await instance.database;
    return await db.update(
      'news',
      news.toMap(),
      where: 'id = ?',
      whereArgs: [news.id],
    );
  }

  Future<int> deleteNews(int id) async {
    final db = await instance.database;
    return await db.delete(
      'news',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertUser(User user) async {
    final db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> authenticate(String username, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<void> updateLoginLocation(int userId, String location) async {
    final db = await instance.database;
    await db.update(
      'users',
      {'last_login_location': location},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    if (db.isOpen) {
      await db.close();
    }
  }
}
