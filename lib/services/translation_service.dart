import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateToVietnamese(String text) async {
    try {
      if (text.isEmpty) return '';
      
      final translation = await _translator.translate(
        text,
        from: 'en',
        to: 'vi',
      );
      
      return translation.text;
    } catch (e) {
      print('Translation error: $e');
      return 'Lỗi khi dịch văn bản';
    }
  }

  Future<String> translateToEnglish(String text) async {
    try {
      if (text.isEmpty) return '';
      
      final translation = await _translator.translate(
        text,
        from: 'vi',
        to: 'en',
      );
      
      return translation.text;
    } catch (e) {
      print('Translation error: $e');
      return 'Translation error';
    }
  }

  Future<Map<String, String>> translateArticle({
    required String title,
    required String description,
    required String content,
  }) async {
    try {
      final translatedTitle = await translateToVietnamese(title);
      final translatedDescription = await translateToVietnamese(description);
      final translatedContent = await translateToVietnamese(content);

      return {
        'title': translatedTitle,
        'description': translatedDescription,
        'content': translatedContent,
      };
    } catch (e) {
      print('Article translation error: $e');
      return {
        'title': title,
        'description': description,
        'content': content,
      };
    }
  }
}
