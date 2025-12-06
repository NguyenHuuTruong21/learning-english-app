import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import '../services/dictionary_service.dart';
import '../models/vocabulary.dart';
import '../providers/vocabulary_provider.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final DictionaryService _dictionaryService = DictionaryService();
  final TextEditingController _searchController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  
  DictionaryEntry? _entry;
  bool _isLoading = false;
  String? _errorMessage;
  List<String> _searchHistory = [];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
  }

  Future<void> _searchWord() async {
    final word = _searchController.text.trim();
    if (word.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập từ cần tra')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _entry = null;
    });

    try {
      final entry = await _dictionaryService.lookupWord(word);
      setState(() {
        _entry = entry;
        _isLoading = false;
        if (entry == null) {
          _errorMessage = 'Không tìm thấy từ "$word"';
        } else {
          // Thêm vào lịch sử tìm kiếm
          if (!_searchHistory.contains(word.toLowerCase())) {
            _searchHistory.insert(0, word.toLowerCase());
            if (_searchHistory.length > 10) {
              _searchHistory.removeLast();
            }
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Lỗi kết nối. Vui lòng thử lại.';
      });
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _addToVocabulary() {
    if (_entry == null) return;

    // Lấy nghĩa đầu tiên
    String meaning = '';
    String example = '';
    
    if (_entry!.meanings.isNotEmpty) {
      final firstMeaning = _entry!.meanings.first;
      if (firstMeaning.definitions.isNotEmpty) {
        meaning = firstMeaning.definitions.first.definition;
        example = firstMeaning.definitions.first.example ?? '';
      }
    }

    // Hiển thị dialog để chọn topic
    showDialog(
      context: context,
      builder: (context) => _AddToVocabularyDialog(
        word: _entry!.word,
        meaning: meaning,
        example: example,
        phonetic: _entry!.phonetic,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dictionary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Search Box
            _buildSearchBox(),
            
            // Content
            Expanded(
              child: _isLoading
                  ? _buildLoading()
                  : _errorMessage != null
                      ? _buildError()
                      : _entry != null
                          ? _buildResult()
                          : _buildInitialState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Nhập từ tiếng Anh...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _entry = null;
                            _errorMessage = null;
                          });
                        },
                      ),
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.indigo, Colors.indigoAccent],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: _searchWord,
                      ),
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searchWord(),
              onChanged: (value) => setState(() {}),
            ),
          ),
          
          // Search History
          if (_searchHistory.isNotEmpty && _entry == null) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _searchHistory.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(
                        _searchHistory[index],
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      onPressed: () {
                        _searchController.text = _searchHistory[index];
                        _searchWord();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.indigo),
          const SizedBox(height: 16),
          Text(
            'Đang tìm kiếm...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy thử từ khác hoặc kiểm tra chính tả',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu_book, size: 100, color: Colors.indigo.withOpacity(0.3)),
          const SizedBox(height: 24),
          Text(
            'Tra cứu từ điển Anh - Anh',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Nhập từ tiếng Anh để xem nghĩa,\nphát âm và ví dụ',
            style: TextStyle(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResult() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Word Card
          _buildWordCard(),
          
          const SizedBox(height: 16),
          
          // Meanings
          ..._entry!.meanings.map((meaning) => _buildMeaningCard(meaning)),
          
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildWordCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.indigo.shade600, Colors.indigo.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _entry!.word,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                // Speak button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white, size: 28),
                    onPressed: () => _speak(_entry!.word),
                  ),
                ),
              ],
            ),
            if (_entry!.phonetic.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _entry!.phonetic,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.9),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: 16),
            // Add to vocabulary button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addToVocabulary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'Thêm vào danh sách học',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeaningCard(Meaning meaning) {
    // Màu theo loại từ
    Color getColorForPartOfSpeech(String pos) {
      switch (pos.toLowerCase()) {
        case 'noun':
          return Colors.blue;
        case 'verb':
          return Colors.green;
        case 'adjective':
          return Colors.orange;
        case 'adverb':
          return Colors.purple;
        case 'preposition':
          return Colors.teal;
        case 'conjunction':
          return Colors.pink;
        default:
          return Colors.grey;
      }
    }

    final color = getColorForPartOfSpeech(meaning.partOfSpeech);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Part of speech tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.5)),
              ),
              child: Text(
                meaning.partOfSpeech.toUpperCase(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Definitions
            ...meaning.definitions.take(3).map((def) => _buildDefinition(def)),
            
            // Synonyms
            if (meaning.synonyms.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildWordList('Synonyms', meaning.synonyms, Colors.green),
            ],
            
            // Antonyms
            if (meaning.antonyms.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildWordList('Antonyms', meaning.antonyms, Colors.red),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDefinition(Definition def) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  def.definition,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
          if (def.example != null) ...[
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.only(left: 18),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.format_quote, color: Colors.grey[400], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      def.example!,
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWordList(String title, List<String> words, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: words.take(5).map((word) {
            return InkWell(
              onTap: () {
                _searchController.text = word;
                _searchWord();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 13,
                    color: color,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Dialog thêm từ vào danh sách học
class _AddToVocabularyDialog extends StatefulWidget {
  final String word;
  final String meaning;
  final String example;
  final String phonetic;

  const _AddToVocabularyDialog({
    required this.word,
    required this.meaning,
    required this.example,
    required this.phonetic,
  });

  @override
  State<_AddToVocabularyDialog> createState() => _AddToVocabularyDialogState();
}

class _AddToVocabularyDialogState extends State<_AddToVocabularyDialog> {
  final _topicController = TextEditingController(text: 'Dictionary');
  final _meaningController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _meaningController.text = widget.meaning;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_circle, color: Colors.indigo),
          ),
          const SizedBox(width: 12),
          const Text('Thêm từ vựng'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Word display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.spellcheck, color: Colors.indigo),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.word,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (widget.phonetic.isNotEmpty)
                        Text(
                          widget.phonetic,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Meaning field
            TextField(
              controller: _meaningController,
              decoration: InputDecoration(
                labelText: 'Nghĩa',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.translate),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            
            // Topic field
            TextField(
              controller: _topicController,
              decoration: InputDecoration(
                labelText: 'Chủ đề (Topic)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.label),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () async {
            final vocab = Vocabulary(
              word: widget.word,
              meaning: _meaningController.text.trim(),
              example: widget.example,
              pronunciation: widget.phonetic,
              topic: _topicController.text.trim(),
            );

            await Provider.of<VocabularyProvider>(context, listen: false)
                .addVocabulary(vocab);

            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đã thêm "${widget.word}" vào danh sách học'),
                backgroundColor: Colors.green,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Thêm', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _topicController.dispose();
    _meaningController.dispose();
    super.dispose();
  }
}
