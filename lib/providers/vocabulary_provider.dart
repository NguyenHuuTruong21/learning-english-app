import 'package:flutter/material.dart';
import '../models/vocabulary.dart';
import '../repositories/vocabulary_repository.dart';

class VocabularyProvider extends ChangeNotifier {
  final VocabularyRepository _repo = VocabularyRepository();

  List<Vocabulary> _vocabList = [];
  List<String> _topics = [];
  String? _selectedTopic;

  List<Vocabulary> get vocabularyList => _vocabList;
  List<String> get topics => _topics;
  String? get selectedTopic => _selectedTopic;

  VocabularyProvider() {
    loadAll();
    loadTopics();
  }

  Future<void> loadAll() async {
    final list = await _repo.getAll();
    _vocabList = list;
    notifyListeners();
  }

  Future<void> loadTopics() async {
    final t = await _repo.getTopics();
    _topics = t;
    notifyListeners();
  }

  Future<void> setSelectedTopic(String? topic) async {
    _selectedTopic = topic;
    if (topic == null) {
      await loadAll();
    } else {
      _vocabList = await _repo.getByTopic(topic);
      notifyListeners();
    }
  }

  Future<void> addVocabulary(Vocabulary v) async {
    await _repo.insert(v);
    await loadAll();
    await loadTopics();
  }

  Future<void> addBulk(List<Vocabulary> list) async {
    for (var v in list) {
      await _repo.insert(v);
    }
    await loadAll();
    await loadTopics();
  }

  Future<void> updateVocabulary(Vocabulary v) async {
    await _repo.update(v);
    await loadAll();
  }

  Future<void> deleteVocabulary(int id) async {
    await _repo.delete(id);
    await loadAll();
    await loadTopics();
  }
}
