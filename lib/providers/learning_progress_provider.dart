import 'package:flutter/material.dart';
import '../models/learning_progress.dart';
import '../repositories/learning_progress_repository.dart';

class LearningProgressProvider extends ChangeNotifier {
  final LearningProgressRepository _repo = LearningProgressRepository();
  LearningProgress? _progress;

  LearningProgress? get progress => _progress;

  LearningProgressProvider() {
    _init();
  }

  Future<void> _init() async {
    await _repo.initialize();
    _progress = await _repo.getProgress();
    notifyListeners();
  }

  Future<void> updateProgress({bool isCorrect = false}) async {
    await _repo.incrementAttempts();
    if (isCorrect) await _repo.incrementCorrectAnswers();
    await _repo.updateStudyStreak();
    _progress = await _repo.getProgress();
    notifyListeners();
  }

  Future<void> incrementWordsLearned() async {
    await _repo.incrementWordsLearned();
    _progress = await _repo.getProgress();
    notifyListeners();
  }
}
