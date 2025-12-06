import '../data/app_database.dart';
import '../models/learning_progress.dart';

class LearningProgressRepository {
  final AppDatabase _db = AppDatabase();

  Future<LearningProgress> getProgress() => _db.getLearningProgress();
  Future<void> initialize() async {
    // DB initialization already inserts default row
    await _db.getLearningProgress();
  }

  Future<void> incrementWordsLearned() => _db.incrementWordsLearned().then((_) => null);
  Future<void> incrementCorrectAnswers() => _db.incrementCorrectAnswers().then((_) => null);
  Future<void> incrementAttempts() => _db.incrementAttempts().then((_) => null);
  Future<void> updateStudyStreak() => _db.updateStudyStreak().then((_) => null);
}
