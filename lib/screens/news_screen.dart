import 'package:flutter/material.dart';
import '../models/news_article.dart';
import '../services/news_service.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final NewsService _newsService = NewsService();
  List<NewsArticle> _articles = [];
  bool _isLoading = true;
  String _error = '';
  bool _isUsingMockData = false;

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  Future<void> _loadNews() async {
    setState(() {
      _isLoading = true;
      _error = '';
      _isUsingMockData = false;
    });

    try {
      final articles = await _newsService.fetchEnglishNews();
      setState(() {
        _articles = articles;
        _isLoading = false;
        // Kiểm tra xem có phải mock data không (source có "Mock" hoặc số lượng = 20)
        _isUsingMockData = articles.length == 20 && 
            articles.any((a) => a.source.contains('Global News Network'));
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load news: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'English News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadNews,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Column(
        children: [
          // Status banner
          if (!_isLoading && _articles.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isUsingMockData
                      ? [Colors.orange.shade100, Colors.orange.shade50]
                      : [Colors.green.shade100, Colors.green.shade50],
                ),
                border: Border(
                  bottom: BorderSide(
                    color: _isUsingMockData ? Colors.orange : Colors.green,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isUsingMockData ? Icons.wifi_off : Icons.wifi,
                    size: 18,
                    color: _isUsingMockData ? Colors.orange.shade900 : Colors.green.shade900,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isUsingMockData
                          ? '📚 Offline Mode - Showing 20 saved articles'
                          : '🌐 Online - Latest news from NewsAPI',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _isUsingMockData ? Colors.orange.shade900 : Colors.green.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Main content
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading news...'),
                      ],
                    ),
                  )
                : _error.isNotEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text(_error),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadNews,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadNews,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          itemCount: _articles.length,
                          itemBuilder: (context, index) {
                            final article = _articles[index];
                            return _buildNewsCard(article);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(NewsArticle article) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NewsDetailScreen(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (article.imageUrl != null)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  article.imageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.article,
                        size: 64,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Source and date
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          article.source,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatDate(article.publishedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Title
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    article.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  
                  // Read more button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => NewsDetailScreen(article: article),
                            ),
                          );
                        },
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Read More'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateStr;
    }
  }
}
