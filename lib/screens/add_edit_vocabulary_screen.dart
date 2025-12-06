import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/vocabulary.dart';
import '../providers/vocabulary_provider.dart';

class AddEditVocabularyScreen extends StatefulWidget {
  final Vocabulary? vocabulary;
  const AddEditVocabularyScreen({Key? key, this.vocabulary}) : super(key: key);

  @override
  State<AddEditVocabularyScreen> createState() => _AddEditVocabularyScreenState();
}

class _AddEditVocabularyScreenState extends State<AddEditVocabularyScreen> {
  final _wordCtl = TextEditingController();
  final _meaningCtl = TextEditingController();
  final _exampleCtl = TextEditingController();
  final _pronCtl = TextEditingController();
  final _topicCtl = TextEditingController();
  bool isBulk = false;
  final _bulkCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.vocabulary != null) {
      _wordCtl.text = widget.vocabulary!.word;
      _meaningCtl.text = widget.vocabulary!.meaning;
      _exampleCtl.text = widget.vocabulary!.example;
      _pronCtl.text = widget.vocabulary!.pronunciation ?? '';
      _topicCtl.text = widget.vocabulary!.topic;
    }
  }

  // InputDecoration chung cho TextField
  InputDecoration _inputDecoration(String label, IconData icon, {String? hint}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  // Nút Save gradient đẹp
  Widget _buildSaveButton(VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
          )
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        icon: const Icon(Icons.check, size: 24, color: Colors.white),
        label: const Text('Save', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<VocabularyProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vocabulary == null ? 'Add Vocabulary' : 'Edit Vocabulary'),
        leading: BackButton(),
      ),
      bottomNavigationBar: _buildSaveButton(() async {
        if (isBulk) {
          final lines = _bulkCtl.text.split('\n');
          final entries = lines.map((line) {
            final parts = line.split(',');
            if (parts.length >= 2) {
              return Vocabulary(
                word: parts[0].trim(),
                meaning: parts[1].trim(),
                example: parts.length > 2 ? parts[2].trim() : '',
                pronunciation: parts.length > 3 ? parts[3].trim() : null,
                topic: parts.length > 4 ? parts[4].trim() : 'General',
              );
            } else {
              return null;
            }
          }).whereType<Vocabulary>().toList();

          if (entries.isNotEmpty) {
            await provider.addBulk(entries);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Saved ${entries.length} words')));
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('No valid lines found')));
          }
        } else {
          final word = _wordCtl.text.trim();
          final meaning = _meaningCtl.text.trim();
          final topic = _topicCtl.text.trim();
          if (word.isNotEmpty && meaning.isNotEmpty && topic.isNotEmpty) {
            final v = Vocabulary(
              id: widget.vocabulary?.id,
              word: word,
              meaning: meaning,
              example: _exampleCtl.text.trim(),
              pronunciation: _pronCtl.text.trim().isEmpty
                  ? null
                  : _pronCtl.text.trim(),
              topic: topic,
            );
            if (widget.vocabulary == null) {
              await provider.addVocabulary(v);
            } else {
              await provider.updateVocabulary(v);
            }
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Vocabulary saved')));
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill in required fields')));
          }
        }
      }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SwitchListTile(
              title: const Text('Bulk Input Mode', style: TextStyle(fontWeight: FontWeight.bold)),
              value: isBulk,
              onChanged: (v) => setState(() => isBulk = v),
            ),
            const SizedBox(height: 16),
            if (!isBulk)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(controller: _wordCtl, decoration: _inputDecoration('Word', Icons.text_fields)),
                      const SizedBox(height: 12),
                      TextField(controller: _meaningCtl, decoration: _inputDecoration('Meaning', Icons.menu_book)),
                      const SizedBox(height: 12),
                      TextField(controller: _exampleCtl, decoration: _inputDecoration('Example (Optional)', Icons.note)),
                      const SizedBox(height: 12),
                      TextField(controller: _pronCtl, decoration: _inputDecoration('Pronunciation (Optional)', Icons.volume_up)),
                      const SizedBox(height: 12),
                      TextField(controller: _topicCtl, decoration: _inputDecoration('Topic', Icons.label)),
                    ],
                  ),
                ),
              )
            else
              TextField(
                controller: _bulkCtl,
                decoration: _inputDecoration(
                  'Enter multiple vocabularies',
                  Icons.list_alt,
                  hint: 'word,meaning,example,pronunciation,topic',
                ),
                maxLines: 12,
              ),
          ],
        ),
      ),
    );
  }
}
