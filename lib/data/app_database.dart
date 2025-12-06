import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/vocabulary.dart';
import '../models/learning_progress.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _db;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB('vocabulary_database.db');
    return _db!;
  }

  Future<Database> _initDB(String fileName) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, fileName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vocabulary (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        meaning TEXT NOT NULL,
        example TEXT,
        pronunciation TEXT,
        topic TEXT NOT NULL,
        isLearned INTEGER DEFAULT 0,
        lastReviewed INTEGER
      );
    ''');

    await db.execute('''
      CREATE TABLE learning_progress (
        id INTEGER PRIMARY KEY,
        totalWordsLearned INTEGER DEFAULT 0,
        totalCorrectAnswers INTEGER DEFAULT 0,
        totalAttempts INTEGER DEFAULT 0,
        lastStudyDate INTEGER,
        streak INTEGER DEFAULT 0
      );
    ''');

    // Insert default progress row id = 1
    final now = DateTime.now().millisecondsSinceEpoch;
    await db.insert('learning_progress', {
      'id': 1,
      'totalWordsLearned': 0,
      'totalCorrectAnswers': 0,
      'totalAttempts': 0,
      'lastStudyDate': now,
      'streak': 0
    });
  }

  // Vocabulary CRUD
  Future<List<Vocabulary>> getAllVocabulary() async {
    final db = await database;
    final rows = await db.query('vocabulary', orderBy: 'word ASC');
    return rows.map((r) => Vocabulary.fromMap(r)).toList();
  }

  Future<List<Vocabulary>> getVocabularyByTopic(String topic) async {
    final db = await database;
    final rows = await db.query('vocabulary', where: 'topic = ?', whereArgs: [topic], orderBy: 'word ASC');
    return rows.map((r) => Vocabulary.fromMap(r)).toList();
  }

  Future<List<Vocabulary>> getUnlearnedVocabulary() async {
    final db = await database;
    final rows = await db.query('vocabulary', where: 'isLearned = 0');
    return rows.map((r) => Vocabulary.fromMap(r)).toList();
  }

  Future<int> insertVocabulary(Vocabulary v) async {
    final db = await database;
    return await db.insert('vocabulary', v.toMap());
  }

  Future<int> updateVocabulary(Vocabulary v) async {
    final db = await database;
    return await db.update('vocabulary', v.toMap(), where: 'id = ?', whereArgs: [v.id]);
  }

  Future<int> deleteVocabulary(int id) async {
    final db = await database;
    return await db.delete('vocabulary', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<String>> getAllTopics() async {
    final db = await database;
    final rows = await db.rawQuery('SELECT DISTINCT topic FROM vocabulary');
    return rows.map((r) => r['topic'] as String).toList();
  }

  // Learning progress
  Future<LearningProgress> getLearningProgress() async {
    final db = await database;
    final rows = await db.query('learning_progress', where: 'id = ?', whereArgs: [1]);
    return LearningProgress.fromMap(rows.first);
  }

  Future<int> incrementWordsLearned() async {
    final db = await database;
    return db.rawUpdate('UPDATE learning_progress SET totalWordsLearned = totalWordsLearned + 1 WHERE id = 1');
  }

  Future<int> incrementCorrectAnswers() async {
    final db = await database;
    return db.rawUpdate('UPDATE learning_progress SET totalCorrectAnswers = totalCorrectAnswers + 1 WHERE id = 1');
  }

  Future<int> incrementAttempts() async {
    final db = await database;
    return db.rawUpdate('UPDATE learning_progress SET totalAttempts = totalAttempts + 1 WHERE id = 1');
  }

  Future<int> updateStudyStreak([int? currentDateMillis]) async {
    final db = await database;
    final now = currentDateMillis ?? DateTime.now().millisecondsSinceEpoch;
    // Get lastStudyDate
    final rows = await db.query('learning_progress', where: 'id = ?', whereArgs: [1]);
    final last = rows.first['lastStudyDate'] as int? ?? now;
    final diffDays = ((now - last) / 86400000).floor();
    int newStreak = rows.first['streak'] as int? ?? 0;
    if (diffDays == 1) {
      newStreak += 1;
    } else if (diffDays > 1) {
      newStreak = 1;
    } else {
      // same day => no change
      newStreak = newStreak;
    }
    return db.update('learning_progress', {
      'lastStudyDate': now,
      'streak': newStreak,
    }, where: 'id = ?', whereArgs: [1]);
  }
}
