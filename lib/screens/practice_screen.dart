import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vocabulary_provider.dart';
import '../providers/learning_progress_provider.dart';
import '../models/vocabulary.dart';

enum PracticeMode { MULTIPLE_CHOICE, FILL_IN_BLANK, MATCHING, FLASHCARD }

class PracticeScreen extends StatefulWidget {
  final String? topic;
  const PracticeScreen({Key? key, this.topic}) : super(key: key);

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  PracticeMode? selectedMode;
  int currentIndex = 0;
  int score = 0;
  bool showResults = false;
  Set<int> learnedWords = {};

  List<Vocabulary> _getList(VocabularyProvider provider) {
    if (widget.topic == null) return provider.vocabularyList;
    return provider.vocabularyList.where((v) => v.topic == widget.topic).toList();
  }

  // Style chung cho các nút
  ButtonStyle _buttonStyle(Color color) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      backgroundColor: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // tăng độ đậm
      elevation: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vocabProvider = Provider.of<VocabularyProvider>(context);
    final progressProvider = Provider.of<LearningProgressProvider>(context, listen: false);
    final vocabList = _getList(vocabProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: selectedMode == null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Practice Mode',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            ...PracticeMode.values.map((m) {
              Icon icon;
              Color color;

              switch (m) {
                case PracticeMode.MULTIPLE_CHOICE:
                  icon = const Icon(Icons.list_alt);
                  color = Colors.blueAccent;
                  break;
                case PracticeMode.FILL_IN_BLANK:
                  icon = const Icon(Icons.edit);
                  color = Colors.purpleAccent;
                  break;
                case PracticeMode.MATCHING:
                  icon = const Icon(Icons.link);
                  color = Colors.teal;
                  break;
                case PracticeMode.FLASHCARD:
                  icon = const Icon(Icons.credit_card);
                  color = Colors.orangeAccent;
                  break;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      selectedMode = m;
                      learnedWords.clear();
                      currentIndex = 0;
                      score = 0;
                      showResults = false;
                    });
                  },
                  style: _buttonStyle(color),
                  icon: icon,
                  label: Text(m.toString().split('.').last.replaceAll('_', ' ')),
                ),
              );
            })
          ],
        )
            : (!showResults
            ? _buildPracticeContent(selectedMode!, vocabList, progressProvider)
            : _buildResults(vocabList)),
      ),
    );
  }

  Widget _buildResults(List<Vocabulary> list) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          color: Colors.blueGrey[50],
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.emoji_events, size: 64, color: Colors.orangeAccent),
                const SizedBox(height: 16),
                const Text(
                  'Practice Complete!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                const SizedBox(height: 24),
                Text(
                  'Score: $score/${list.length}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Text(
                  'Words Learned: ${learnedWords.length}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF43CEA2), Color(0xFF185A9D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedMode = null;
                        currentIndex = 0;
                        score = 0;
                        showResults = false;
                        learnedWords.clear();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text('Try Again', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildPracticeContent(
      PracticeMode mode, List<Vocabulary> list, dynamic progressProvider) {
    if (list.isEmpty) return const Center(child: Text('No vocabulary for this topic'));
    final vocab = list[currentIndex];

    switch (mode) {
      case PracticeMode.MULTIPLE_CHOICE:
        final options = (List<String>.from(list.map((e) => e.meaning))..shuffle()).take(4).toList();
        return _multipleChoice(vocab, options, list, progressProvider);
      case PracticeMode.FILL_IN_BLANK:
        return _fillInBlank(vocab, list, progressProvider);
      case PracticeMode.MATCHING:
        return _matching(list, progressProvider);
      case PracticeMode.FLASHCARD:
        return _flashcard(vocab, list, progressProvider);
    }
  }

  Widget _multipleChoice(
      Vocabulary vocab, List<String> options, List<Vocabulary> list, dynamic progressProvider) {
    final opts = (options..removeWhere((o) => o == vocab.meaning)) + [vocab.meaning];
    opts.shuffle();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        Text(vocab.word, style: const TextStyle(fontSize: 24), textAlign: TextAlign.center),
        const SizedBox(height: 20),
        ...opts.map((o) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton.icon(
              onPressed: () async {
                final isCorrect = o == vocab.meaning;
                await progressProvider.updateProgress(isCorrect: isCorrect);
                if (isCorrect && !learnedWords.contains(vocab.id)) {
                  await progressProvider.incrementWordsLearned();
                  learnedWords.add(vocab.id!);
                  score++;
                }
                if (currentIndex < list.length - 1) {
                  setState(() => currentIndex++);
                } else {
                  setState(() => showResults = true);
                }
              },
              style: _buttonStyle(Colors.orangeAccent),
              icon: const Icon(Icons.check_circle_outline),
              label: Text(o),
            ),
          );
        }),
      ],
    );
  }

  Widget _fillInBlank(Vocabulary vocab, List<Vocabulary> list, dynamic progressProvider) {
    final controller = TextEditingController();
    return Column(
      children: [
        const SizedBox(height: 12),
        Text(vocab.meaning, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 12),
        TextField(controller: controller, decoration: const InputDecoration(labelText: 'Enter the word')),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () async {
            final ans = controller.text.trim();
            final isCorrect = ans.toLowerCase() == vocab.word.toLowerCase();
            await progressProvider.updateProgress(isCorrect: isCorrect);
            if (isCorrect && !learnedWords.contains(vocab.id)) {
              await progressProvider.incrementWordsLearned();
              learnedWords.add(vocab.id!);
              score++;
            }
            controller.clear();
            if (currentIndex < list.length - 1) {
              setState(() => currentIndex++);
            } else {
              setState(() => showResults = true);
            }
          },
          style: _buttonStyle(Colors.purpleAccent),
          icon: const Icon(Icons.check),
          label: const Text('Check Answer'),
        )
      ],
    );
  }

  Widget _matching(List<Vocabulary> list, dynamic progressProvider) {
    final sessionWords = List<Vocabulary>.from(list)..shuffle();
    final meanings = sessionWords.map((e) => e.meaning).toList()..shuffle();
    final matched = <int>{};
    Vocabulary? selectedWord;
    String? selectedMeaning;

    return StatefulBuilder(builder: (context, setSt) {
      return Column(
        children: [
          const SizedBox(height: 12),
          const Text('Match words with meanings', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 12),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView(
                    children: sessionWords.map((w) {
                      final isMatched = matched.contains(w.id!);
                      return Card(
                        color: isMatched ? Colors.green[100] : null,
                        child: ListTile(
                          leading: const Icon(Icons.arrow_right),
                          title: Text(w.word),
                          onTap: () {
                            setSt(() {
                              selectedWord = w;
                              if (selectedMeaning != null) {
                                if (selectedMeaning == w.meaning) {
                                  matched.add(w.id!);
                                }
                                selectedMeaning = null;
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: meanings.map((m) {
                      final isUsed = sessionWords.any((w) => matched.contains(w.id!) && w.meaning == m);
                      return Card(
                        color: isUsed ? Colors.green[100] : null,
                        child: ListTile(
                          leading: const Icon(Icons.arrow_right_alt),
                          title: Text(m),
                          onTap: () {
                            setSt(() {
                              selectedMeaning = m;
                              if (selectedWord != null) {
                                if (selectedWord!.meaning == m) {
                                  matched.add(selectedWord!.id!);
                                }
                                selectedWord = null;
                              }
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
          if (matched.length == sessionWords.length)
            ElevatedButton.icon(
              onPressed: () async {
                final correct = matched.length;
                for (int i = 0; i < correct; i++) {
                  await progressProvider.updateProgress(isCorrect: i < correct);
                }
                for (var id in matched) {
                  if (!learnedWords.contains(id)) {
                    await progressProvider.incrementWordsLearned();
                    learnedWords.add(id);
                  }
                }
                setState(() => showResults = true);
                score = correct;
              },
              style: _buttonStyle(Colors.teal),
              icon: const Icon(Icons.checklist_rounded),
              label: const Text('Complete'),
            )
        ],
      );
    });
  }

  Widget _flashcard(Vocabulary vocab, List<Vocabulary> list, dynamic progressProvider) {
    bool showMeaning = false;
    return StatefulBuilder(builder: (context, setSt) {
      return Column(
        children: [
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setSt(() => showMeaning = !showMeaning),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Container(
                height: 220,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(showMeaning ? vocab.meaning : vocab.word,
                        style: const TextStyle(fontSize: 24)),
                    if (showMeaning && vocab.pronunciation != null)
                      Text('Pronunciation: ${vocab.pronunciation}'),
                    if (showMeaning && vocab.example.isNotEmpty)
                      Text('Example: ${vocab.example}'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(() {
                    if (currentIndex > 0) currentIndex--;
                    showMeaning = false;
                  }),
                  style: _buttonStyle(Colors.redAccent),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous Card'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (!learnedWords.contains(vocab.id)) {
                      await progressProvider.incrementWordsLearned();
                      learnedWords.add(vocab.id!);
                    }
                    await progressProvider.updateProgress(isCorrect: true);
                    if (currentIndex < list.length - 1) {
                      setState(() => currentIndex++);
                    } else {
                      setState(() => showResults = true);
                    }
                  },
                  style: _buttonStyle(Colors.greenAccent),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next Card'),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
