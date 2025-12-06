import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vocabulary_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/vocabulary_card.dart';
import 'add_edit_vocabulary_screen.dart';
import 'practice_screen.dart';
import 'statistics_screen.dart';
import 'news_screen.dart';
import 'translator_screen.dart';
import 'dictionary_screen.dart';
import 'listening_practice_screen.dart';

// Hàm tạo màu ngẫu nhiên
Color getRandomColor() {
  final random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

class VocabularyListScreen extends StatelessWidget {
  const VocabularyListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VocabularyProvider>(context);
    final list = provider.vocabularyList;
    final topics = provider.topics;
    final selectedTopic = provider.selectedTopic;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Vocabulary List',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          // News button - ICON ONLY
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NewsScreen()),
            ),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.purpleAccent, Colors.deepPurple],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.newspaper, color: Colors.white, size: 20),
            ),
            tooltip: 'News',
          ),

          // Stats button - ICON ONLY
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StatisticsScreen()),
            ),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.bar_chart, color: Colors.white, size: 20),
            ),
            tooltip: 'Statistics',
          ),

          // Theme toggle button - ICON ONLY
          IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: themeProvider.isDarkMode
                      ? [Colors.grey[800]!, Colors.black87]
                      : [Colors.orangeAccent, Colors.deepOrange],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: Colors.white,
                size: 20,
              ),
            ),
            tooltip: themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
          ),
          const SizedBox(width: 8),
        ],
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),

      // Bottom Navigation Bar với 4 nút cân đối
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Listening Practice
            _buildNavButton(
              context,
              icon: Icons.headphones,
              label: 'Listening',
              color: Colors.deepPurple,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ListeningPracticeScreen()),
              ),
            ),
            // Dictionary
            _buildNavButton(
              context,
              icon: Icons.menu_book,
              label: 'Dictionary',
              color: Colors.indigo,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DictionaryScreen()),
              ),
            ),
            // Translator
            _buildNavButton(
              context,
              icon: Icons.translate,
              label: 'Translator',
              color: Colors.teal,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TranslatorScreen()),
              ),
            ),
            // Add Vocabulary
            _buildNavButton(
              context,
              icon: Icons.add_circle,
              label: 'Add Word',
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddEditVocabularyScreen()),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Topic selector với màu ngẫu nhiên
          SizedBox(
            height: 56,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: selectedTopic == null,
                  selectedColor: getRandomColor(),
                  backgroundColor: getRandomColor().withOpacity(0.2),
                  onSelected: (_) => provider.setSelectedTopic(null),
                ),
                ...topics.map((t) {
                  final randomColor = getRandomColor();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(t),
                      selected: selectedTopic == t,
                      selectedColor: randomColor,
                      backgroundColor: randomColor.withOpacity(0.2),
                      onSelected: (_) => provider.setSelectedTopic(t),
                    ),
                  );
                }),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PracticeScreen(topic: provider.selectedTopic),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow, color: Colors.white),
                label: Text(
                  'Practice ${selectedTopic ?? "All"} Words',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              itemBuilder: (context, idx) {
                final v = list[idx];
                return VocabularyCard(
                  vocabulary: v,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddEditVocabularyScreen(vocabulary: v),
                      ),
                    );
                  },
                  onDelete: () => provider.deleteVocabulary(v.id!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
