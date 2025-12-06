# 📖 Hướng dẫn tìm hiểu mã nguồn - English Learning App

Tài liệu này hướng dẫn chi tiết cách đọc và tìm hiểu code cho từng chức năng trong ứng dụng.

---

## 📋 Mục lục

1. [Cấu trúc tổng quan](#1-cấu-trúc-tổng-quan)
2. [Điểm khởi đầu - Entry Point](#2-điểm-khởi-đầu---entry-point)
3. [Quản lý từ vựng](#3-quản-lý-từ-vựng)
4. [Luyện tập từ vựng (Practice)](#4-luyện-tập-từ-vựng-practice)
5. [Luyện nghe (Listening Practice)](#5-luyện-nghe-listening-practice)
6. [Từ điển (Dictionary)](#6-từ-điển-dictionary)
7. [Dịch thuật (Translator)](#7-dịch-thuật-translator)
8. [Tin tức (News)](#8-tin-tức-news)
9. [Thống kê (Statistics)](#9-thống-kê-statistics)
10. [Theme (Dark/Light Mode)](#10-theme-darklight-mode)

---

## 1. Cấu trúc tổng quan

```
lib/
├── main.dart                    # 🚀 Entry point - Bắt đầu đọc từ đây
├── data/                        # 💾 Tầng Database
├── models/                      # 📦 Các class mô hình dữ liệu
├── providers/                   # 🔄 Quản lý state (Provider pattern)
├── repositories/                # 🗄️ Tầng truy cập dữ liệu
├── screens/                     # 📱 Các màn hình UI
├── services/                    # 🌐 Gọi API bên ngoài
├── utils/                       # 🛠️ Các hàm tiện ích
└── widgets/                     # 🧩 Các widget tái sử dụng
```

### Kiến trúc ứng dụng

```
┌─────────────────────────────────────────────────────────────┐
│                        SCREENS (UI)                          │
│         Hiển thị giao diện, nhận tương tác người dùng        │
└─────────────────────────────────────────────────────────────┘
                              ↕
┌─────────────────────────────────────────────────────────────┐
│                      PROVIDERS (State)                       │
│              Quản lý trạng thái, business logic              │
└─────────────────────────────────────────────────────────────┘
                              ↕
┌───────────────────────────┬─────────────────────────────────┐
│      REPOSITORIES         │           SERVICES               │
│   Truy cập Database       │        Gọi API bên ngoài         │
└───────────────────────────┴─────────────────────────────────┘
                              ↕
┌───────────────────────────┬─────────────────────────────────┐
│        DATABASE           │         EXTERNAL APIs            │
│    SQLite (sqflite)       │   Dictionary API, News API...    │
└───────────────────────────┴─────────────────────────────────┘
```

---

## 2. Điểm khởi đầu - Entry Point

### 📚 Thứ tự đọc:

| # | File | Mục đích |
|---|------|----------|
| 1 | `lib/main.dart` | Điểm khởi đầu, khởi tạo app, setup Providers |

### 🔍 Chi tiết `main.dart`:

```dart
// 1. Import các thư viện và file cần thiết
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ...

// 2. Hàm main() - Điểm bắt đầu
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo database, sau đó chạy app
}

// 3. MyApp - Widget gốc
class MyApp extends StatelessWidget {
  // Setup MultiProvider để cung cấp state cho toàn app
  // Định nghĩa theme sáng/tối
  // Chỉ định màn hình đầu tiên (home)
}
```

### 💡 Điểm quan trọng cần hiểu:
- **MultiProvider**: Wrap toàn bộ app, cung cấp các Provider (VocabularyProvider, ThemeProvider...)
- **MaterialApp**: Cấu hình app (theme, routes, home screen)
- **Khởi tạo Database**: `AppDatabase.instance.database` chạy trước khi app start

---

## 3. Quản lý từ vựng

### 📚 Thứ tự đọc:

| # | File | Vai trò | Mô tả |
|---|------|---------|-------|
| 1 | `lib/models/vocabulary.dart` | Model | Định nghĩa cấu trúc dữ liệu từ vựng |
| 2 | `lib/data/app_database.dart` | Database | Tạo bảng, kết nối SQLite |
| 3 | `lib/repositories/vocabulary_repository.dart` | Repository | CRUD operations với database |
| 4 | `lib/providers/vocabulary_provider.dart` | Provider | Quản lý state, business logic |
| 5 | `lib/screens/vocabulary_list_screen.dart` | Screen | Màn hình danh sách từ vựng |
| 6 | `lib/screens/add_edit_vocabulary_screen.dart` | Screen | Màn hình thêm/sửa từ |
| 7 | `lib/widgets/vocabulary_card.dart` | Widget | Card hiển thị từng từ vựng |

### 🔍 Chi tiết từng file:

#### 3.1 `models/vocabulary.dart`
```dart
class Vocabulary {
  int? id;           // ID tự tăng
  String word;       // Từ tiếng Anh
  String meaning;    // Nghĩa tiếng Việt
  String? example;   // Câu ví dụ
  String? phonetic;  // Phiên âm
  String? topic;     // Chủ đề

  // Các phương thức:
  // - toMap(): Chuyển object → Map (để lưu DB)
  // - fromMap(): Chuyển Map → Object (đọc từ DB)
}
```

#### 3.2 `data/app_database.dart`
```dart
class AppDatabase {
  // Singleton pattern - chỉ có 1 instance database
  static final AppDatabase instance = AppDatabase._init();
  
  // Tạo bảng vocabulary với các cột
  // Tạo bảng learning_progress
  
  Future<Database> get database async {
    // Mở hoặc tạo database
  }
}
```

#### 3.3 `repositories/vocabulary_repository.dart`
```dart
class VocabularyRepository {
  // CRUD Operations:
  Future<int> insert(Vocabulary v);        // Thêm từ mới
  Future<List<Vocabulary>> getAll();       // Lấy tất cả từ
  Future<int> update(Vocabulary v);        // Cập nhật từ
  Future<int> delete(int id);              // Xóa từ
  Future<List<String>> getTopics();        // Lấy danh sách topic
}
```

#### 3.4 `providers/vocabulary_provider.dart`
```dart
class VocabularyProvider extends ChangeNotifier {
  List<Vocabulary> _vocabularyList = [];
  String? _selectedTopic;
  
  // Getter để UI đọc dữ liệu
  List<Vocabulary> get vocabularyList => ...;
  
  // Methods để thay đổi dữ liệu
  Future<void> loadVocabulary();           // Load từ DB
  Future<void> addVocabulary(v);           // Thêm từ
  Future<void> updateVocabulary(v);        // Sửa từ
  Future<void> deleteVocabulary(id);       // Xóa từ
  void setSelectedTopic(topic);            // Filter theo topic
  
  // notifyListeners() - Thông báo UI cập nhật
}
```

#### 3.5 `screens/vocabulary_list_screen.dart`
```dart
class VocabularyListScreen extends StatelessWidget {
  // Sử dụng Provider.of<VocabularyProvider>(context) để đọc state
  
  // UI bao gồm:
  // - AppBar với các nút News, Stats, Theme toggle
  // - Topic filter (ChoiceChip)
  // - Nút Practice
  // - ListView hiển thị các VocabularyCard
  // - Bottom Navigation (Listening, Dictionary, Translator, Add)
}
```

### 📊 Luồng dữ liệu:

```
User nhấn "Add Word"
        ↓
AddEditVocabularyScreen (nhập liệu)
        ↓
VocabularyProvider.addVocabulary()
        ↓
VocabularyRepository.insert()
        ↓
SQLite Database (lưu)
        ↓
notifyListeners()
        ↓
VocabularyListScreen (tự động cập nhật UI)
```

---

## 4. Luyện tập từ vựng (Practice)

### 📚 Thứ tự đọc:

| # | File | Vai trò |
|---|------|---------|
| 1 | `lib/models/learning_progress.dart` | Model tiến độ học |
| 2 | `lib/repositories/learning_progress_repository.dart` | Lưu/đọc tiến độ |
| 3 | `lib/providers/learning_progress_provider.dart` | Quản lý state tiến độ |
| 4 | `lib/screens/practice_screen.dart` | Màn hình luyện tập |

### 🔍 Cách hoạt động:

```
1. PracticeScreen nhận danh sách từ vựng (theo topic hoặc all)
2. Hiển thị flashcard hoặc quiz
3. User trả lời → cập nhật LearningProgress
4. Lưu tiến độ vào database
5. Hiển thị kết quả
```

---

## 5. Luyện nghe (Listening Practice)

### 📚 Thứ tự đọc:

| # | File | Vai trò |
|---|------|---------|
| 1 | `lib/screens/listening_practice_screen.dart` | Toàn bộ tính năng |

### 🔍 Chi tiết:

```dart
class ListeningPracticeScreen extends StatefulWidget {
  // Dữ liệu:
  Map<String, List<String>> _sentencesByLevel = {
    'Easy': [...],    // 90 câu
    'Medium': [...],  // 80 câu
    'Hard': [...],    // 80 câu
  };
  
  // State:
  String _selectedLevel;      // Level đang chọn
  String _currentSentence;    // Câu hiện tại
  int _score;                 // Điểm số
  bool _showResult;           // Hiển thị kết quả
  
  // FlutterTts:
  FlutterTts _flutterTts;     // Text-to-speech engine
  
  // Methods:
  _speak();                   // Phát âm bình thường
  _speakSlow();               // Phát âm chậm
  _checkAnswer();             // Kiểm tra đáp án
  _nextSentence();            // Chuyển câu tiếp
  
  // UI:
  // - Level selector (Easy/Medium/Hard)
  // - Play buttons (Play, Slow, Repeat)
  // - Speed slider
  // - Text input
  // - Result card
}
```

### 💡 Điểm đặc biệt:
- **Tính năng độc lập**: Không cần database
- **flutter_tts**: Sử dụng để phát âm
- **So sánh đáp án**: Bỏ qua dấu câu, không phân biệt hoa/thường

---

## 6. Từ điển (Dictionary)

### 📚 Thứ tự đọc:

| # | File | Vai trò |
|---|------|---------|
| 1 | `lib/services/dictionary_service.dart` | Gọi API từ điển |
| 2 | `lib/screens/dictionary_screen.dart` | Màn hình từ điển |

### 🔍 Chi tiết:

#### 6.1 `services/dictionary_service.dart`
```dart
// Models cho dữ liệu từ API
class DictionaryEntry {
  String word;
  String? phonetic;
  List<Phonetic> phonetics;
  List<Meaning> meanings;
}

class Meaning {
  String partOfSpeech;  // noun, verb, adjective...
  List<Definition> definitions;
  List<String> synonyms;
  List<String> antonyms;
}

class Definition {
  String definition;
  String? example;
}

// Service gọi API
class DictionaryService {
  static const String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';
  
  Future<List<DictionaryEntry>> lookupWord(String word) async {
    // GET request đến API
    // Parse JSON response
    // Return List<DictionaryEntry>
  }
}
```

#### 6.2 `screens/dictionary_screen.dart`
```dart
class DictionaryScreen extends StatefulWidget {
  // State:
  List<DictionaryEntry>? _entries;    // Kết quả tra cứu
  List<String> _searchHistory;        // Lịch sử (10 từ gần nhất)
  bool _isLoading;                    // Đang tải
  
  // Methods:
  _searchWord(String word);           // Tra từ
  _speakWord(String word);            // Phát âm
  _addToVocabulary(entry);            // Thêm vào danh sách học
  
  // UI:
  // - Search box
  // - Search history chips
  // - Result cards (phonetic, meanings, examples, synonyms, antonyms)
}
```

### 📊 Luồng hoạt động:

```
User nhập từ "hello" → nhấn Search
        ↓
DictionaryService.lookupWord("hello")
        ↓
HTTP GET: api.dictionaryapi.dev/api/v2/entries/en/hello
        ↓
Parse JSON → List<DictionaryEntry>
        ↓
Hiển thị kết quả trên UI
        ↓
(Optional) User nhấn "Add to Vocabulary"
        ↓
Mở dialog nhập nghĩa → Lưu vào VocabularyProvider
```

---

## 7. Dịch thuật (Translator)

### 📚 Thứ tự đọc:

| # | File | Vai trò |
|---|------|---------|
| 1 | `lib/services/translation_service.dart` | Logic dịch (sử dụng package translator) |
| 2 | `lib/screens/translator_screen.dart` | Màn hình dịch |

### 🔍 Chi tiết:

```dart
// TranslationService sử dụng package 'translator'
class TranslationService {
  Future<String> translate(String text, String from, String to);
}

// TranslatorScreen
class TranslatorScreen extends StatefulWidget {
  // Cho phép dịch 2 chiều: EN ↔ VI
  // Sử dụng flutter_tts để phát âm
  // Swap button để đổi ngôn ngữ
}
```

---

## 8. Tin tức (News)

### 📚 Thứ tự đọc:

| # | File | Vai trò |
|---|------|---------|
| 1 | `lib/models/news_article.dart` | Model bài báo |
| 2 | `lib/services/news_service.dart` | Gọi News API |
| 3 | `lib/screens/news_screen.dart` | Danh sách tin |
| 4 | `lib/screens/news_detail_screen.dart` | Chi tiết bài báo |

### 🔍 Chi tiết:

```dart
class NewsArticle {
  String title;
  String? description;
  String? urlToImage;
  String? content;
  String? url;
  DateTime? publishedAt;
}

class NewsService {
  // Gọi News API để lấy tin tiếng Anh
  Future<List<NewsArticle>> getNews();
}
```

---

## 9. Thống kê (Statistics)

### 📚 Thứ tự đọc:

| # | File | Vai trò |
|---|------|---------|
| 1 | `lib/models/learning_progress.dart` | Model tiến độ |
| 2 | `lib/providers/learning_progress_provider.dart` | Lấy dữ liệu thống kê |
| 3 | `lib/screens/statistics_screen.dart` | Màn hình thống kê |

### 🔍 Dữ liệu thống kê:
- Tổng số từ đã học
- Số từ đã thuộc
- Số ngày học liên tục
- Biểu đồ tiến độ theo thời gian

---

## 10. Theme (Dark/Light Mode)

### 📚 Thứ tự đọc:

| # | File | Vai trò |
|---|------|---------|
| 1 | `lib/providers/theme_provider.dart` | Quản lý theme state |
| 2 | `lib/main.dart` | Áp dụng theme cho MaterialApp |

### 🔍 Chi tiết:

```dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  
  bool get isDarkMode => _isDarkMode;
  
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();  // Thông báo toàn app cập nhật theme
  }
}

// Trong main.dart
MaterialApp(
  theme: ThemeData.light(),
  darkTheme: ThemeData.dark(),
  themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
)
```

---

## 🎯 Gợi ý cách học

### Cho người mới bắt đầu:

1. **Tuần 1**: Đọc hiểu `main.dart` và flow cơ bản
2. **Tuần 2**: Tìm hiểu chức năng Quản lý từ vựng (đầy đủ các tầng)
3. **Tuần 3**: Nghiên cứu các tính năng độc lập (Dictionary, Listening)
4. **Tuần 4**: Tìm hiểu các tính năng còn lại

### Cho người có kinh nghiệm:

1. Đọc `main.dart` để hiểu cấu trúc Provider
2. Chọn 1 tính năng và trace từ UI → Provider → Repository → Database
3. Thử thêm tính năng mới theo pattern có sẵn

---

## 📝 Các pattern quan trọng

### 1. Provider Pattern
```dart
// Khai báo Provider
class MyProvider extends ChangeNotifier {
  // State
  // Methods thay đổi state
  // notifyListeners() khi state thay đổi
}

// Sử dụng trong UI
final provider = Provider.of<MyProvider>(context);
// hoặc
Consumer<MyProvider>(builder: (context, provider, child) => ...)
```

### 2. Repository Pattern
```dart
// Repository đứng giữa Provider và Database
class MyRepository {
  final Database _db;
  
  Future<List<T>> getAll();
  Future<int> insert(T item);
  Future<int> update(T item);
  Future<int> delete(int id);
}
```

### 3. Singleton Pattern (Database)
```dart
class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;
  
  AppDatabase._init();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }
}
```

---

## 🔗 Liên kết hữu ích

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [sqflite Package](https://pub.dev/packages/sqflite)
- [flutter_tts Package](https://pub.dev/packages/flutter_tts)
- [Free Dictionary API](https://dictionaryapi.dev/)

---

*Tài liệu được tạo bởi Nguyễn Văn Dũng - MSSV: 4551190009*
