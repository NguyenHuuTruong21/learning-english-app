import 'dart:convert';
import 'package:http/http.dart' as http;

class DictionaryEntry {
  final String word;
  final String phonetic;
  final String? audioUrl;
  final List<Meaning> meanings;

  DictionaryEntry({
    required this.word,
    required this.phonetic,
    this.audioUrl,
    required this.meanings,
  });

  factory DictionaryEntry.fromJson(Map<String, dynamic> json) {
    // Lấy phonetic
    String phonetic = '';
    String? audioUrl;
    
    if (json['phonetic'] != null) {
      phonetic = json['phonetic'];
    }
    
    // Tìm phonetic có audio
    if (json['phonetics'] != null) {
      for (var p in json['phonetics']) {
        if (p['text'] != null && p['text'].toString().isNotEmpty) {
          phonetic = p['text'];
        }
        if (p['audio'] != null && p['audio'].toString().isNotEmpty) {
          audioUrl = p['audio'];
          if (p['text'] != null) phonetic = p['text'];
          break;
        }
      }
    }

    // Parse meanings
    List<Meaning> meanings = [];
    if (json['meanings'] != null) {
      meanings = (json['meanings'] as List)
          .map((m) => Meaning.fromJson(m))
          .toList();
    }

    return DictionaryEntry(
      word: json['word'] ?? '',
      phonetic: phonetic,
      audioUrl: audioUrl,
      meanings: meanings,
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;
  final List<String> synonyms;
  final List<String> antonyms;

  Meaning({
    required this.partOfSpeech,
    required this.definitions,
    required this.synonyms,
    required this.antonyms,
  });

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'] ?? '',
      definitions: (json['definitions'] as List?)
              ?.map((d) => Definition.fromJson(d))
              .toList() ??
          [],
      synonyms: (json['synonyms'] as List?)
              ?.map((s) => s.toString())
              .toList() ??
          [],
      antonyms: (json['antonyms'] as List?)
              ?.map((a) => a.toString())
              .toList() ??
          [],
    );
  }
}

class Definition {
  final String definition;
  final String? example;

  Definition({
    required this.definition,
    this.example,
  });

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'] ?? '',
      example: json['example'],
    );
  }
}

class DictionaryService {
  static const String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  Future<DictionaryEntry?> lookupWord(String word) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/${word.trim().toLowerCase()}'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return DictionaryEntry.fromJson(data[0]);
        }
      }
      return null;
    } catch (e) {
      print('Dictionary lookup error: $e');
      return null;
    }
  }
}
