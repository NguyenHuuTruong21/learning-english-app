class Vocabulary {
  int? id;
  String word;
  String meaning;
  String example;
  String? pronunciation;
  String topic;
  bool isLearned;
  int lastReviewed; // epoch millis

  Vocabulary({
    this.id,
    required this.word,
    required this.meaning,
    this.example = '',
    this.pronunciation,
    required this.topic,
    this.isLearned = false,
    int? lastReviewed,
  }) : lastReviewed = lastReviewed ?? DateTime.now().millisecondsSinceEpoch;

  factory Vocabulary.fromMap(Map<String, dynamic> m) => Vocabulary(
    id: m['id'] as int?,
    word: m['word'] as String,
    meaning: m['meaning'] as String,
    example: m['example'] as String? ?? '',
    pronunciation: m['pronunciation'] as String?,
    topic: m['topic'] as String,
    isLearned: (m['isLearned'] as int? ?? 0) == 1,
    lastReviewed: m['lastReviewed'] as int? ?? DateTime.now().millisecondsSinceEpoch,
  );

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'word': word,
    'meaning': meaning,
    'example': example,
    'pronunciation': pronunciation,
    'topic': topic,
    'isLearned': isLearned ? 1 : 0,
    'lastReviewed': lastReviewed,
  };
}
