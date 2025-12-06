import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:math';

class ListeningPracticeScreen extends StatefulWidget {
  const ListeningPracticeScreen({Key? key}) : super(key: key);

  @override
  State<ListeningPracticeScreen> createState() => _ListeningPracticeScreenState();
}

class _ListeningPracticeScreenState extends State<ListeningPracticeScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _answerController = TextEditingController();
  
  // Danh sách câu luyện nghe theo level
  final Map<String, List<String>> _sentencesByLevel = {
    'Easy': [
      // Greetings & Introduction
      'Hello, how are you?',
      'My name is John.',
      'Nice to meet you.',
      'Good morning, everyone.',
      'See you tomorrow.',
      'Have a nice day.',
      'What is your name?',
      'Where are you from?',
      'How old are you?',
      'I am fine, thank you.',
      
      // Daily activities
      'I like to read books.',
      'She has a beautiful cat.',
      'We go to school every day.',
      'He drinks coffee in the morning.',
      'They play football on weekends.',
      'I love my family.',
      'I wake up at seven.',
      'She goes to bed early.',
      'We eat lunch at noon.',
      'He watches TV at night.',
      
      // Weather & Nature
      'The weather is nice today.',
      'The sun is shining.',
      'It is raining outside.',
      'The sky is blue.',
      'I like spring weather.',
      'Winter is very cold.',
      'Summer is my favorite season.',
      'The flowers are beautiful.',
      'Birds are singing.',
      'The wind is strong today.',
      
      // Simple requests & responses
      'Please open the door.',
      'Thank you very much.',
      'You are welcome.',
      'Can you help me?',
      'I need some water.',
      'Please sit down.',
      'Close the window please.',
      'Turn on the light.',
      'Give me the book.',
      'Wait for me.',
      
      // Feelings & descriptions
      'I am happy today.',
      'She is my best friend.',
      'We live in a big city.',
      'This food is delicious.',
      'The movie was funny.',
      'I feel tired today.',
      'He looks very sad.',
      'The dog is friendly.',
      'My room is clean.',
      'The test was easy.',
      
      // Numbers & time
      'I have two brothers.',
      'She is twenty years old.',
      'It is three o\'clock.',
      'Today is Monday.',
      'My birthday is in May.',
      'There are five apples.',
      'I need ten minutes.',
      'The store opens at nine.',
      'We have three cats.',
      'I work five days a week.',
      
      // Places
      'I am at home.',
      'She is at school.',
      'We are in the park.',
      'The bank is near here.',
      'The hospital is far away.',
      'I like this restaurant.',
      'The library is closed.',
      'Let\'s go to the beach.',
      'The airport is busy.',
      'I work in an office.',
      
      // Food & drinks
      'I like pizza.',
      'She drinks milk.',
      'We had breakfast.',
      'The coffee is hot.',
      'I want some ice cream.',
      'He eats rice every day.',
      'Do you like apples?',
      'The soup is ready.',
      'I need more salt.',
      'This cake is sweet.',
    ],
    'Medium': [
      // Time expressions
      'I have been studying English for three years.',
      'She has been working at this company for five years.',
      'He always arrives at work before eight o\'clock.',
      'The train leaves from platform three at noon.',
      'The library is open from nine to five on weekdays.',
      'I usually go jogging in the park every morning.',
      'We have been waiting here for almost an hour.',
      'The meeting will start in fifteen minutes.',
      'She finished her homework before dinner time.',
      'They have lived in this house since two thousand ten.',
      
      // Daily life
      'The restaurant on the corner serves delicious food.',
      'My grandmother makes the best chocolate cake.',
      'The children were playing happily in the garden.',
      'He forgot to bring his umbrella and got wet.',
      'I usually take the bus to work in the morning.',
      'She always drinks a cup of tea after lunch.',
      'We decided to order pizza for dinner tonight.',
      'He spends most of his free time reading novels.',
      'The neighbors are having a party this weekend.',
      'I need to buy some groceries after work today.',
      
      // Travel & plans
      'She decided to travel around the world next summer.',
      'They are planning to buy a new house next year.',
      'We should protect the environment for future generations.',
      'I am thinking about learning a new language.',
      'He wants to visit his grandparents next month.',
      'She is saving money to buy a new car.',
      'We are going on vacation to the beach.',
      'They have booked a hotel for the weekend.',
      'I would like to try the local food there.',
      'The flight departs at six in the morning.',
      
      // Work & study
      'Learning a new language requires patience and practice.',
      'The movie we watched last night was very interesting.',
      'He received a promotion at work last week.',
      'She needs to submit her report by Friday.',
      'The teacher gave us a lot of homework today.',
      'I have an important meeting with my boss tomorrow.',
      'She is preparing for her final exams next week.',
      'He got the highest score in the class.',
      'The company is hiring new employees this month.',
      'I finished reading that book you recommended.',
      
      // Health & lifestyle
      'Regular exercise helps you stay healthy and fit.',
      'She tries to eat vegetables every single day.',
      'Getting enough sleep is important for your health.',
      'He goes to the gym three times a week.',
      'I have been feeling tired lately and need rest.',
      'She quit smoking last year and feels much better.',
      'Drinking plenty of water is good for your skin.',
      'He walks to work instead of driving his car.',
      'I should eat less sugar and more fruits.',
      'She practices yoga every morning before breakfast.',
      
      // Technology & communication
      'I forgot my password and cannot log in.',
      'She sent me an email but I did not receive it.',
      'The internet connection is very slow today.',
      'He bought a new smartphone last weekend.',
      'I need to charge my phone before we leave.',
      'She spends too much time on social media.',
      'The website is under maintenance right now.',
      'He downloaded a new app for learning languages.',
      'I cannot find my phone anywhere in the house.',
      'She prefers texting over making phone calls.',
      
      // Shopping & money
      'This shirt is too expensive for my budget.',
      'She found a great deal at the supermarket.',
      'I need to withdraw some money from the bank.',
      'He paid for the meal with his credit card.',
      'The store is having a big sale this weekend.',
      'She always compares prices before buying anything.',
      'I forgot my wallet at home this morning.',
      'He is saving money for a new laptop.',
      'The shoes were on sale so I bought two pairs.',
      'She returned the dress because it did not fit.',
      
      // Social situations
      'We are having a birthday party on Saturday.',
      'She invited all her friends to the wedding.',
      'He apologized for being late to the meeting.',
      'I met an old friend at the coffee shop.',
      'They celebrated their anniversary at a fancy restaurant.',
      'She thanked everyone for coming to her party.',
      'He offered to help me with my homework.',
      'I congratulated her on passing the exam.',
      'They had a wonderful time at the concert.',
      'She promised to call me when she arrives.',
    ],
    'Hard': [
      // Academic & professional
      'Despite the challenging circumstances, she managed to complete her degree with honors.',
      'The unprecedented technological advancements have transformed the way we communicate.',
      'Effective communication skills are essential for professional success in any field.',
      'The committee has unanimously decided to postpone the conference until further notice.',
      'The comprehensive report highlighted several areas requiring immediate attention.',
      'Critical thinking and problem-solving abilities are highly valued by employers.',
      'The professor emphasized the importance of conducting thorough research before drawing conclusions.',
      'Successful entrepreneurs often possess exceptional resilience and adaptability.',
      'The internship program provides valuable hands-on experience for university students.',
      'Academic integrity is a fundamental principle that all scholars must uphold.',
      
      // Environment & science
      'Environmental sustainability should be a priority for governments worldwide.',
      'Scientific research indicates that regular exercise significantly improves mental health.',
      'Artificial intelligence is revolutionizing various industries at an unprecedented pace.',
      'The documentary explored the consequences of climate change on marine ecosystems.',
      'Renewable energy sources are becoming increasingly cost-effective and accessible.',
      'The conservation efforts have successfully increased the population of endangered species.',
      'Deforestation continues to threaten biodiversity in tropical rainforest regions.',
      'The research team published their groundbreaking findings in a prestigious journal.',
      'Sustainable development requires a balance between economic growth and environmental protection.',
      'The experiment demonstrated a significant correlation between the two variables.',
      
      // Culture & society
      'The archaeological discovery provided valuable insights into ancient civilizations.',
      'Understanding different cultural perspectives enhances our ability to collaborate globally.',
      'The symphony orchestra delivered a magnificent performance at the concert hall.',
      'Contemporary art challenges traditional notions of beauty and aesthetic value.',
      'The museum exhibition showcases artifacts from various historical periods.',
      'Multilingualism offers numerous cognitive and professional advantages in today\'s world.',
      'Social media has fundamentally altered how people form and maintain relationships.',
      'The documentary filmmaker spent three years interviewing survivors of the conflict.',
      'Cultural exchange programs promote mutual understanding between different nations.',
      'The literary masterpiece has been translated into more than fifty languages.',
      
      // Business & economics
      'The entrepreneur successfully launched her innovative startup despite initial skepticism.',
      'Global economic fluctuations have significant implications for international trade.',
      'The merger between the two corporations created the largest company in the industry.',
      'Consumer behavior has shifted dramatically due to the rise of e-commerce.',
      'The central bank announced a series of measures to combat rising inflation.',
      'Venture capitalists are increasingly investing in sustainable technology companies.',
      'The quarterly earnings report exceeded analyst expectations by a considerable margin.',
      'Supply chain disruptions have affected manufacturing operations across multiple continents.',
      'The company implemented a comprehensive restructuring plan to improve efficiency.',
      'Market volatility has prompted investors to diversify their portfolios more carefully.',
      
      // Health & medicine
      'Maintaining a healthy work-life balance is crucial for long-term well-being.',
      'The pharmaceutical company received approval for its groundbreaking cancer treatment.',
      'Preventive healthcare measures can significantly reduce the burden on medical systems.',
      'The surgeon performed a complex procedure that lasted over twelve hours.',
      'Mental health awareness has increased substantially over the past decade.',
      'The clinical trial showed promising results for patients with chronic conditions.',
      'Telemedicine has made healthcare more accessible to people in remote areas.',
      'The nutritionist recommended a balanced diet rich in vitamins and minerals.',
      'Advancements in genetic research have opened new possibilities for personalized medicine.',
      'The hospital implemented strict protocols to prevent the spread of infections.',
      
      // Technology & innovation
      'The development of quantum computing could revolutionize data processing capabilities.',
      'Cybersecurity threats have become increasingly sophisticated and difficult to detect.',
      'The autonomous vehicle passed all safety tests conducted by regulatory authorities.',
      'Blockchain technology has applications beyond cryptocurrency in various industries.',
      'The software engineer identified a critical vulnerability in the system architecture.',
      'Virtual reality experiences are becoming indistinguishable from actual reality.',
      'The telecommunications company invested billions in expanding its network infrastructure.',
      'Machine learning algorithms can now diagnose certain diseases with remarkable accuracy.',
      'The startup developed an innovative solution to reduce electronic waste globally.',
      'Cloud computing has enabled businesses to scale their operations more efficiently.',
      
      // Politics & law
      'The constitutional amendment requires approval from two-thirds of the legislature.',
      'International cooperation is essential for addressing transnational challenges effectively.',
      'The diplomatic negotiations resulted in a historic peace agreement between the nations.',
      'Human rights organizations continue to advocate for marginalized communities worldwide.',
      'The landmark court decision established an important precedent for future cases.',
      'Electoral reforms are necessary to ensure fair and transparent democratic processes.',
      'The trade agreement eliminated tariffs on hundreds of products between the countries.',
      'Civil society organizations play a crucial role in holding governments accountable.',
      'The humanitarian crisis prompted an international response from multiple aid organizations.',
      'Legislative procedures require careful deliberation and extensive consultation with stakeholders.',
      
      // Philosophy & abstract
      'The philosophical implications of artificial consciousness remain highly contentious.',
      'Ethical considerations should guide the development and deployment of emerging technologies.',
      'The existential questions raised by the author continue to resonate with modern readers.',
      'Epistemological debates have shaped our understanding of knowledge and truth.',
      'The interdisciplinary approach allowed researchers to examine the problem from multiple perspectives.',
      'Abstract concepts often require concrete examples to be fully comprehended.',
      'The paradox highlighted fundamental limitations in our logical reasoning systems.',
      'Philosophical inquiry encourages us to question assumptions we often take for granted.',
      'The theoretical framework provides a foundation for understanding complex phenomena.',
      'Metaphysical speculation has fascinated thinkers throughout human history.',
    ],
  };

  String _selectedLevel = 'Easy';
  String _currentSentence = '';
  int _currentIndex = 0;
  int _score = 0;
  int _totalAttempts = 0;
  bool _showResult = false;
  bool _isCorrect = false;
  bool _isPlaying = false;
  double _speechRate = 0.5;
  List<String> _shuffledSentences = [];

  @override
  void initState() {
    super.initState();
    _initTts();
    _shuffleSentences();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setCompletionHandler(() {
      setState(() => _isPlaying = false);
    });
  }

  void _shuffleSentences() {
    _shuffledSentences = List.from(_sentencesByLevel[_selectedLevel]!);
    _shuffledSentences.shuffle(Random());
    _currentIndex = 0;
    _currentSentence = _shuffledSentences[_currentIndex];
  }

  Future<void> _speak() async {
    if (_isPlaying) {
      await _flutterTts.stop();
      setState(() => _isPlaying = false);
    } else {
      setState(() => _isPlaying = true);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.speak(_currentSentence);
    }
  }

  Future<void> _speakSlow() async {
    setState(() => _isPlaying = true);
    await _flutterTts.setSpeechRate(0.3);
    await _flutterTts.speak(_currentSentence);
  }

  void _checkAnswer() {
    final userAnswer = _answerController.text.trim().toLowerCase();
    final correctAnswer = _currentSentence.toLowerCase();
    
    // So sánh bỏ qua dấu câu
    final cleanUserAnswer = userAnswer.replaceAll(RegExp(r'[^\w\s]'), '');
    final cleanCorrectAnswer = correctAnswer.replaceAll(RegExp(r'[^\w\s]'), '');
    
    setState(() {
      _showResult = true;
      _totalAttempts++;
      _isCorrect = cleanUserAnswer == cleanCorrectAnswer;
      if (_isCorrect) _score++;
    });
  }

  void _nextSentence() {
    setState(() {
      _showResult = false;
      _answerController.clear();
      _currentIndex++;
      if (_currentIndex >= _shuffledSentences.length) {
        _currentIndex = 0;
        _shuffleSentences();
      }
      _currentSentence = _shuffledSentences[_currentIndex];
    });
  }

  void _changeLevel(String level) {
    setState(() {
      _selectedLevel = level;
      _score = 0;
      _totalAttempts = 0;
      _showResult = false;
      _answerController.clear();
      _shuffleSentences();
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Listening Practice',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Score display
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                Text(
                  '$_score/$_totalAttempts',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade50, Colors.white],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Level selector
              _buildLevelSelector(),
              
              const SizedBox(height: 20),
              
              // Instructions card
              _buildInstructionsCard(),
              
              const SizedBox(height: 20),
              
              // Play buttons
              _buildPlayButtons(),
              
              const SizedBox(height: 16),
              
              // Speed control
              _buildSpeedControl(),
              
              const SizedBox(height: 20),
              
              // Answer input
              _buildAnswerInput(),
              
              const SizedBox(height: 16),
              
              // Check button
              if (!_showResult)
                _buildCheckButton()
              else
                _buildResultCard(),
              
              const SizedBox(height: 20),
              
              // Tips
              _buildTipsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelSelector() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chọn cấp độ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Easy', 'Medium', 'Hard'].map((level) {
                final isSelected = _selectedLevel == level;
                Color color;
                IconData icon;
                
                switch (level) {
                  case 'Easy':
                    color = Colors.green;
                    icon = Icons.sentiment_satisfied;
                    break;
                  case 'Medium':
                    color = Colors.orange;
                    icon = Icons.sentiment_neutral;
                    break;
                  default:
                    color = Colors.red;
                    icon = Icons.sentiment_very_dissatisfied;
                }
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton.icon(
                      onPressed: () => _changeLevel(level),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? color : Colors.grey.shade200,
                        foregroundColor: isSelected ? Colors.white : Colors.grey.shade700,
                        elevation: isSelected ? 4 : 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(icon, size: 18),
                      label: Text(level, style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade600, Colors.deepPurple.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.headphones,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Câu ${_currentIndex + 1}/${_shuffledSentences.length}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Nghe và viết lại câu',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white.withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Nhấn nút Play để nghe, sau đó viết lại chính xác những gì bạn nghe được',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
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

  Widget _buildPlayButtons() {
    return Row(
      children: [
        // Normal speed
        Expanded(
          flex: 2,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: _isPlaying 
                    ? [Colors.red.shade400, Colors.red.shade600]
                    : [Colors.blue.shade400, Colors.blue.shade600],
              ),
              boxShadow: [
                BoxShadow(
                  color: (_isPlaying ? Colors.red : Colors.blue).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _speak,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isPlaying ? Icons.stop : Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isPlaying ? 'Dừng' : 'Phát',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Slow speed
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.orange.shade400, Colors.orange.shade600],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _speakSlow,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.slow_motion_video, color: Colors.white, size: 32),
                    SizedBox(height: 4),
                    Text(
                      'Chậm',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Repeat
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.teal.shade400, Colors.teal.shade600],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _speak,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.replay, color: Colors.white, size: 32),
                    SizedBox(height: 4),
                    Text(
                      'Lặp lại',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeedControl() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.speed, color: Colors.deepPurple, size: 20),
            const SizedBox(width: 8),
            const Text('Tốc độ:', style: TextStyle(fontWeight: FontWeight.w500)),
            Expanded(
              child: Slider(
                value: _speechRate,
                min: 0.25,
                max: 0.75,
                divisions: 4,
                activeColor: Colors.deepPurple,
                label: _speechRate == 0.25 
                    ? 'Rất chậm'
                    : _speechRate == 0.5 
                        ? 'Bình thường'
                        : 'Nhanh',
                onChanged: (value) {
                  setState(() => _speechRate = value);
                },
              ),
            ),
            Text(
              '${(_speechRate * 2).toStringAsFixed(1)}x',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerInput() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.edit, color: Colors.deepPurple, size: 20),
                SizedBox(width: 8),
                Text(
                  'Viết câu trả lời',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _answerController,
              maxLines: 3,
              enabled: !_showResult,
              decoration: InputDecoration(
                hintText: 'Nhập những gì bạn nghe được...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
                ),
              ),
              style: const TextStyle(fontSize: 16),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _checkAnswer(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Colors.deepPurple, Colors.purpleAccent],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _answerController.text.trim().isNotEmpty ? _checkAnswer : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.check_circle, color: Colors.white),
        label: const Text(
          'Kiểm tra',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Result icon and text
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isCorrect ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isCorrect ? Icons.check : Icons.close,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isCorrect ? 'Chính xác! 🎉' : 'Chưa đúng 😅',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                      if (_isCorrect)
                        Text(
                          'Tuyệt vời! Tiếp tục phát huy!',
                          style: TextStyle(
                            color: Colors.green.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            
            // Correct answer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade600, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Câu đúng:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: Colors.deepPurple),
                        onPressed: _speak,
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentSentence,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            
            // User's answer if wrong
            if (!_isCorrect) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.edit, color: Colors.red.shade600, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Bạn viết:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _answerController.text,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 20),
            
            // Next button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _nextSentence,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text(
                  'Câu tiếp theo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.amber.shade700, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Mẹo luyện nghe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.amber.shade900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTipItem('🎧', 'Nghe ít nhất 2-3 lần trước khi viết'),
            _buildTipItem('🐢', 'Dùng nút "Chậm" nếu câu quá khó'),
            _buildTipItem('✍️', 'Chú ý các từ nối và mạo từ (a, an, the)'),
            _buildTipItem('🔤', 'Không cần lo về dấu câu, chỉ cần đúng từ'),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.amber.shade900,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
