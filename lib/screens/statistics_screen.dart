import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/learning_progress_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LearningProgressProvider>(context);
    final p = provider.progress;

    final totalAttempts = p?.totalAttempts ?? 0;
    final accuracy = totalAttempts > 0
        ? ((p!.totalCorrectAnswers / totalAttempts) * 100).toStringAsFixed(1) + '%'
        : '0%';

    final stats = [
      {
        'title': 'Words Learned',
        'value': '${p?.totalWordsLearned ?? 0}',
        'icon': Icons.school,
        'color': Colors.blue,
      },
      {
        'title': 'Accuracy',
        'value': accuracy,
        'icon': Icons.check_circle,
        'color': Colors.green,
      },
      {
        'title': 'Study Streak',
        'value': '${p?.streak ?? 0} days',
        'icon': Icons.local_fire_department,
        'color': Colors.orange,
      },
      {
        'title': 'Total Practice Attempts',
        'value': '${p?.totalAttempts ?? 0}',
        'icon': Icons.bar_chart,
        'color': Colors.purple,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text(
          'Learning Statistics',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stats.length,
        itemBuilder: (context, index) {
          final s = stats[index];
          return _statCard(
            title: s['title'] as String,
            value: s['value'] as String,
            icon: s['icon'] as IconData,
            color: s['color'] as Color,
          );
        },
      ),
    );
  }

  Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
