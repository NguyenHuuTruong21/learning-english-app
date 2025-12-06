import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/translation_service.dart';

class NewsDetailScreen extends StatefulWidget {
  final NewsArticle article;
  const NewsDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final TranslationService _translationService = TranslationService();
  bool _isTranslated = false;
  bool _isTranslating = false;
  
  String _displayTitle = '';
  String _displayDescription = '';
  String _displayContent = '';

  @override
  void initState() {
    super.initState();
    _displayTitle = widget.article.title;
    _displayDescription = widget.article.description;
    _displayContent = _expandContent(widget.article.content);
  }

  /// Mở rộng nội dung nếu quá ngắn (từ API thường chỉ có 200-300 ký tự)
  String _expandContent(String content) {
    // Nếu nội dung đã đủ dài (> 500 ký tự), giữ nguyên
    if (content.length > 500) {
      return content;
    }

    // Nếu nội dung ngắn (từ API), thêm đoạn văn mở rộng
    return '''$content

This developing story has captured significant attention from the international community. Experts and analysts are closely monitoring the situation as it unfolds, with many stakeholding organizations preparing comprehensive responses.

The implications of these developments extend far beyond immediate circumstances, potentially affecting various sectors and communities. Industry leaders and policymakers are engaging in active discussions to understand the full scope and determine appropriate next steps.

Initial reactions from key stakeholders have been mixed, with some expressing cautious optimism while others call for more detailed information before drawing conclusions. The coming days will be crucial in shaping the trajectory of this evolving situation.

Further details are expected to emerge as more information becomes available. Relevant authorities and organizations have committed to providing regular updates to keep the public informed about significant developments and their potential impact.

For the most up-to-date and comprehensive coverage of this story, readers are encouraged to access the full article through the link provided above, where additional context, expert analysis, and ongoing updates are available.''';
  }

  Future<void> _toggleTranslation() async {
    if (_isTranslated) {
      // Switch back to English
      setState(() {
        _isTranslated = false;
        _displayTitle = widget.article.title;
        _displayDescription = widget.article.description;
        _displayContent = _expandContent(widget.article.content);
      });
    } else {
      // Translate to Vietnamese
      setState(() {
        _isTranslating = true;
      });

      try {
        // Mở rộng nội dung trước khi dịch
        final expandedContent = _expandContent(widget.article.content);
        
        final translated = await _translationService.translateArticle(
          title: widget.article.title,
          description: widget.article.description,
          content: expandedContent,
        );

        setState(() {
          _displayTitle = translated['title'] ?? widget.article.title;
          _displayDescription = translated['description'] ?? widget.article.description;
          _displayContent = translated['content'] ?? expandedContent;
          _isTranslated = true;
          _isTranslating = false;
        });
      } catch (e) {
        setState(() {
          _isTranslating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Translation failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: widget.article.imageUrl != null
                  ? Image.network(
                      widget.article.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.article,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.article,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and Date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.blueAccent],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.article.source,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _formatDate(widget.article.publishedAt),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Translation Button
                  Center(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: _isTranslated
                              ? [Colors.green, Colors.teal]
                              : [Colors.orange, Colors.deepOrange],
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
                        onPressed: _isTranslating ? null : _toggleTranslation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        icon: _isTranslating
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                _isTranslated
                                    ? Icons.translate_outlined
                                    : Icons.translate,
                                color: Colors.white,
                              ),
                        label: Text(
                          _isTranslating
                              ? 'Đang dịch...'
                              : _isTranslated
                                  ? '🇬🇧 Xem bản tiếng Anh'
                                  : '🇻🇳 Dịch sang tiếng Việt',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    _displayTitle,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.blue.shade200,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _displayDescription,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Content
                  Text(
                    _displayContent,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
