import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../services/translation_service.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({Key? key}) : super(key: key);

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final TranslationService _translationService = TranslationService();
  final FlutterTts _flutterTts = FlutterTts();
  
  final TextEditingController _inputController = TextEditingController();
  String _outputText = '';
  bool _isTranslating = false;
  bool _isEnglishToVietnamese = true; // true = EN->VI, false = VI->EN
  
  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage(_isEnglishToVietnamese ? "en-US" : "vi-VN");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _translate() async {
    if (_inputController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập văn bản cần dịch')),
      );
      return;
    }

    setState(() {
      _isTranslating = true;
      _outputText = '';
    });

    try {
      String translated;
      if (_isEnglishToVietnamese) {
        // Dịch từ Anh sang Việt
        translated = await _translationService.translateToVietnamese(_inputController.text);
      } else {
        // Dịch từ Việt sang Anh
        translated = await _translationService.translateToEnglish(_inputController.text);
      }

      setState(() {
        _outputText = translated;
        _isTranslating = false;
      });
    } catch (e) {
      setState(() {
        _isTranslating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi dịch: $e')),
      );
    }
  }

  Future<void> _speak(String text, bool isEnglish) async {
    await _flutterTts.setLanguage(isEnglish ? "en-US" : "vi-VN");
    await _flutterTts.speak(text);
  }

  void _swapLanguages() {
    setState(() {
      _isEnglishToVietnamese = !_isEnglishToVietnamese;
      // Swap input và output
      final temp = _inputController.text;
      _inputController.text = _outputText;
      _outputText = temp;
    });
    _initTts();
  }

  void _clearAll() {
    setState(() {
      _inputController.clear();
      _outputText = '';
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trình Dịch',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _clearAll,
            tooltip: 'Xóa tất cả',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Language Direction Indicator
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Source Language
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _isEnglishToVietnamese ? '🇬🇧 English' : '🇻🇳 Tiếng Việt',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Swap Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: IconButton(
                      onPressed: _swapLanguages,
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.swap_horiz,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  
                  // Target Language
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _isEnglishToVietnamese ? '🇻🇳 Tiếng Việt' : '🇬🇧 English',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Input Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Nhập văn bản',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (_inputController.text.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.volume_up, color: Colors.teal),
                                onPressed: () => _speak(
                                  _inputController.text,
                                  _isEnglishToVietnamese,
                                ),
                                tooltip: 'Phát âm',
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: TextField(
                            controller: _inputController,
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              hintText: _isEnglishToVietnamese
                                  ? 'Enter English text...'
                                  : 'Nhập tiếng Việt...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {}); // Refresh để hiện nút phát âm
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Translate Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Colors.teal, Colors.tealAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.teal.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: _isTranslating ? null : _translate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: _isTranslating
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.translate, color: Colors.white, size: 28),
                  label: Text(
                    _isTranslating ? 'Đang dịch...' : 'Dịch ngay',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // Output Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  elevation: 4,
                  color: Colors.teal.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Kết quả dịch',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (_outputText.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.volume_up, color: Colors.teal),
                                onPressed: () => _speak(
                                  _outputText,
                                  !_isEnglishToVietnamese,
                                ),
                                tooltip: 'Phát âm',
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _outputText.isEmpty
                                  ? 'Kết quả dịch sẽ hiển thị ở đây...'
                                  : _outputText,
                              style: TextStyle(
                                fontSize: 16,
                                color: _outputText.isEmpty
                                    ? Colors.grey[400]
                                    : Colors.black87,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
