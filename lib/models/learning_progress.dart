class LearningProgress {
  int id;
  int totalWordsLearned;
  int totalCorrectAnswers;
  int totalAttempts;
  int lastStudyDate; // epoch millis
  int streak;

  LearningProgress({
    this.id = 1,
    this.totalWordsLearned = 0,
    this.totalCorrectAnswers = 0,
    this.totalAttempts = 0,
    int? lastStudyDate,
    this.streak = 0,
  }) : lastStudyDate = lastStudyDate ?? DateTime.now().millisecondsSinceEpoch;

  factory LearningProgress.fromMap(Map<String, dynamic> m) => LearningProgress(
    id: m['id'] as int,
    totalWordsLearned: m['totalWordsLearned'] as int,
    totalCorrectAnswers: m['totalCorrectAnswers'] as int,
    totalAttempts: m['totalAttempts'] as int,
    lastStudyDate: m['lastStudyDate'] as int,
    streak: m['streak'] as int,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'totalWordsLearned': totalWordsLearned,
    'totalCorrectAnswers': totalCorrectAnswers,
    'totalAttempts': totalAttempts,
    'lastStudyDate': lastStudyDate,
    'streak': streak,
  };
}
