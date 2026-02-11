# 📚 English Learning App

Ứng dụng học tiếng Anh đa nền tảng được phát triển bằng Flutter.
---

## 📱 Giới thiệu

**English Learning App** là ứng dụng hỗ trợ học tiếng Anh toàn diện, được thiết kế với giao diện thân thiện và nhiều tính năng hữu ích. Ứng dụng hỗ trợ đa nền tảng: Android, iOS, Web, Windows, macOS và Linux.

---

## ✨ Tính năng chính

### 📖 Quản lý từ vựng
- Thêm, sửa, xóa từ vựng
- Phân loại theo chủ đề (Topic)
- Lưu trữ nghĩa, ví dụ, phiên âm
- Phát âm từ vựng bằng Text-to-Speech

### 🎯 Luyện tập từ vựng (Practice)
- Flashcard học từ
- Kiểm tra với nhiều lựa chọn
- Theo dõi tiến độ học tập

### 🎧 Luyện nghe (Listening Practice)
- 3 cấp độ: Easy, Medium, Hard
- **250+ câu** luyện nghe đa dạng chủ đề
- Nghe và viết lại câu
- Điều chỉnh tốc độ phát âm
- Phát âm chậm để nghe rõ hơn
- Theo dõi điểm số

### 📚 Từ điển (Dictionary)
- Tra cứu từ điển Anh-Anh
- Hiển thị phiên âm, nghĩa, ví dụ
- Từ đồng nghĩa, trái nghĩa
- Lịch sử tra cứu
- Thêm nhanh từ vào danh sách học

### 🌐 Dịch thuật (Translator)
- Dịch Anh ↔ Việt
- Phát âm văn bản
- Giao diện đơn giản, dễ sử dụng

### 📰 Tin tức tiếng Anh (News)
- Đọc tin tức bằng tiếng Anh
- Cập nhật từ các nguồn uy tín
- Luyện đọc hiểu

### 📊 Thống kê (Statistics)
- Theo dõi tiến độ học tập
- Biểu đồ trực quan
- Lịch sử học tập

### 🌙 Dark Mode
- Hỗ trợ giao diện sáng/tối
- Bảo vệ mắt khi học ban đêm

---

## 🛠️ Công nghệ sử dụng

| Công nghệ | Mục đích |
|-----------|----------|
| **Flutter** | Framework phát triển đa nền tảng |
| **Dart** | Ngôn ngữ lập trình |
| **Provider** | Quản lý state |
| **SQLite (sqflite)** | Lưu trữ dữ liệu local |
| **flutter_tts** | Text-to-Speech phát âm |
| **http** | Gọi API |
| **Free Dictionary API** | API từ điển |

---

## 📂 Cấu trúc dự án

```
lib/
├── main.dart                 # Entry point
├── data/
│   └── app_database.dart     # SQLite database
├── models/
│   ├── vocabulary.dart       # Model từ vựng
│   ├── learning_progress.dart
│   └── news_article.dart
├── providers/
│   ├── vocabulary_provider.dart
│   ├── theme_provider.dart
│   └── learning_progress_provider.dart
├── repositories/
│   ├── vocabulary_repository.dart
│   └── learning_progress_repository.dart
├── screens/
│   ├── vocabulary_list_screen.dart    # Màn hình chính
│   ├── add_edit_vocabulary_screen.dart
│   ├── practice_screen.dart
│   ├── listening_practice_screen.dart # Luyện nghe
│   ├── dictionary_screen.dart         # Từ điển
│   ├── translator_screen.dart         # Dịch thuật
│   ├── news_screen.dart
│   ├── news_detail_screen.dart
│   ├── statistics_screen.dart
│   └── IndexScreen.dart
├── services/
│   ├── dictionary_service.dart        # API từ điển
│   ├── news_service.dart
│   └── translation_service.dart
├── utils/
│   └── date_utils.dart
└── widgets/
    └── vocabulary_card.dart
```

---

## 🚀 Hướng dẫn cài đặt

### Yêu cầu
- Flutter SDK >= 3.3.0
- Dart SDK >= 3.0.0

### Cài đặt

```bash
# Clone repository
git clone <repository-url>
cd ck_mobile_flutter-main

# Cài đặt dependencies
flutter pub get

# Chạy ứng dụng
flutter run

# Chạy trên Chrome (Web)
flutter run -d chrome

# Chạy trên Windows
flutter run -d windows

# Build APK
flutter build apk
```

---

## 📸 Screenshots

### Giao diện chính
- Danh sách từ vựng với phân loại theo chủ đề
- Bottom Navigation với 4 tính năng: Listening, Dictionary, Translator, Add Word
- Hỗ trợ Dark/Light mode

### Listening Practice
- Chọn cấp độ (Easy/Medium/Hard)
- Nút Play, Slow, Repeat
- Điều chỉnh tốc độ
- Hiển thị kết quả và câu đúng

### Dictionary
- Ô tìm kiếm từ
- Hiển thị phonetics, meanings
- Ví dụ sử dụng
- Synonyms/Antonyms

---

## 📝 Ghi chú

- Tính năng **Listening Practice**, **Dictionary** hoạt động độc lập, không cần database
- Trên nền tảng **Web**, SQLite không được hỗ trợ nên các tính năng cần database sẽ không hoạt động
- Để sử dụng đầy đủ tính năng, khuyến nghị chạy trên **Android/iOS/Windows**

---

## 📄 License

Dự án được phát triển cho mục đích học tập.

---

⭐ *Cảm ơn bạn đã quan tâm đến dự án!*
