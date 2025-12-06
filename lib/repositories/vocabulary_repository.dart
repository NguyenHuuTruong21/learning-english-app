import '../data/app_database.dart';
import '../models/vocabulary.dart';

class VocabularyRepository {
  final AppDatabase _db = AppDatabase();

  Future<List<Vocabulary>> getAll() => _db.getAllVocabulary();
  Future<List<Vocabulary>> getByTopic(String topic) => _db.getVocabularyByTopic(topic);
  Future<List<Vocabulary>> getUnlearned() => _db.getUnlearnedVocabulary();
  Future<int> insert(Vocabulary v) => _db.insertVocabulary(v);
  Future<int> update(Vocabulary v) => _db.updateVocabulary(v);
  Future<int> delete(int id) => _db.deleteVocabulary(id);
  Future<List<String>> getTopics() => _db.getAllTopics();
}
