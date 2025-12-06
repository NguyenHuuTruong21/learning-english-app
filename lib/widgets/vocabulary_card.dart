import 'package:flutter/material.dart';
import '../models/vocabulary.dart';

class VocabularyCard extends StatelessWidget {
  final Vocabulary vocabulary;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const VocabularyCard({
    Key? key,
    required this.vocabulary,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        title: Text(
          vocabulary.word,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Meaning: ${vocabulary.meaning}'),
            if (vocabulary.pronunciation != null && vocabulary.pronunciation!.isNotEmpty)
              Text('Pronunciation: ${vocabulary.pronunciation}'),
            if (vocabulary.example.isNotEmpty)
              Text('Example: ${vocabulary.example}'),
          ],
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
