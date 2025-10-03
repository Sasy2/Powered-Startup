import 'package:flutter/widgets.dart';
import '../models/chat_model.dart';
// import '../services/firebase_service.dart';
// import '../services/ai_service.dart';

class ChatProvider with ChangeNotifier {
  // final FirebaseService _firebaseService = FirebaseService();
  // final AIService _aiService = AIService();
  
  List<ChatMessage> _messages = [];
  ChatSession? _currentSession;
  bool _isLoading = false;
  bool _isTyping = false;
  String? _error;

  List<ChatMessage> get messages => _messages;
  ChatSession? get currentSession => _currentSession;
  bool get isLoading => _isLoading;
  bool get isTyping => _isTyping;
  String? get error => _error;

  Future<void> loadMessages(String userId) async {
    _isLoading = true;
    _error = null;
    
    // Don't call notifyListeners() here to avoid setState during build

    try {
      // For now, just initialize with a welcome message
      _messages = [
        ChatMessage(
          id: 'welcome_1',
          userId: userId,
          content: 'Hello! I\'m your AI eye care assistant. How can I help you today?',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
          isFromUser: false,
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      // Use post frame callback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> startNewSession(String userId) async {
    try {
      _currentSession = ChatSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        startTime: DateTime.now(),
        messages: [],
      );
      
      // For now, just create the session locally
      // await _firebaseService.saveChatSession(_currentSession!);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> sendMessage(String userId, String content, {MessageType type = MessageType.text}) async {
    try {
      // Create user message
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        content: content,
        type: type,
        timestamp: DateTime.now(),
        isFromUser: true,
      );

      // Add user message locally
      _messages.add(userMessage);
      notifyListeners();

      // Get AI response
      await _getAIResponse(userId, content);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _getAIResponse(String userId, String userMessage) async {
    _isTyping = true;
    notifyListeners();

    // Simulate AI thinking time
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Simple AI responses based on keywords
      String aiResponse = _generateSimpleResponse(userMessage);

      // Generate actions for the response
      final actions = _generateMessageActions(aiResponse);

      // Create AI message
      final aiMessage = ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_ai',
        userId: userId,
        content: aiResponse,
        type: MessageType.text,
        timestamp: DateTime.now(),
        isFromUser: false,
        actions: actions.isNotEmpty ? actions : null,
      );

      // Add AI message locally
      _messages.add(aiMessage);
    } catch (e) {
      _error = e.toString();
      
      // Send error message
      final errorMessage = ChatMessage(
        id: '${DateTime.now().millisecondsSinceEpoch}_error',
        userId: userId,
        content: 'I apologize, but I\'m having trouble connecting right now. Please try again later.',
        type: MessageType.text,
        timestamp: DateTime.now(),
        isFromUser: false,
      );
      
      _messages.add(errorMessage);
    } finally {
      _isTyping = false;
      notifyListeners();
    }
  }

  String _generateSimpleResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Greeting responses with variation
    if (message.contains('hello') || message.contains('hi') || message.contains('hey')) {
      final greetings = [
        'Hello! I\'m EyeDoctor, your intelligent eye care assistant. How can I help you with your eye health today?',
        'Hi there! I\'m here to help with all your eye health questions. What would you like to know?',
        'Hey! Welcome to Sighty. I\'m your virtual eye care assistant. How can I assist you today?',
        'Hello! I\'m excited to help you with your eye health journey. What brings you here today?',
      ];
      return greetings[DateTime.now().millisecond % greetings.length];
    }
    
    // Pain and discomfort responses
    else if (message.contains('pain') || message.contains('hurt') || message.contains('ache')) {
      final painResponses = [
        'I understand you\'re experiencing eye pain. This could be due to various reasons like eye strain, dry eyes, or other conditions. I recommend:\n\n1. Take regular breaks from screens\n2. Use artificial tears if your eyes feel dry\n3. Apply a warm compress\n4. If pain persists, please consult an eye doctor\n\nWould you like me to help you with any specific eye exercises?',
        'Eye pain can be concerning. Let me help you with some immediate relief strategies:\n\n• **Rest your eyes** - Close them for 5-10 minutes\n• **Apply warmth** - Use a warm, damp cloth\n• **Stay hydrated** - Drink plenty of water\n• **Check lighting** - Ensure adequate, non-glaring light\n\nIf the pain is severe or sudden, please seek immediate medical attention.',
        'I\'m sorry to hear you\'re experiencing eye discomfort. This could be related to:\n\n• Digital eye strain from screen use\n• Dry eye syndrome\n• Allergies or environmental factors\n• Underlying health conditions\n\nLet\'s work together to find some relief. What type of pain are you feeling?',
      ];
      return painResponses[DateTime.now().millisecond % painResponses.length];
    }
    
    // Exercise and vision improvement
    else if (message.contains('exercise') || message.contains('vision') || message.contains('improve')) {
      final exerciseResponses = [
        'Great! I can help you with eye exercises to improve your vision and reduce eye strain. Here are some effective exercises:\n\n1. **20-20-20 Rule**: Every 20 minutes, look at something 20 feet away for 20 seconds\n2. **Eye Rolling**: Slowly roll your eyes in circles\n3. **Focus Shifting**: Focus on near and far objects alternately\n4. **Blinking**: Blink rapidly for 30 seconds\n\nWould you like detailed instructions for any of these exercises?',
        'Excellent! Eye exercises can really help improve your vision and reduce strain. Here are my top recommendations:\n\n• **Palming** - Cover your eyes with your palms for 2-3 minutes\n• **Figure 8s** - Trace figure 8s with your eyes\n• **Near-Far Focus** - Alternate between close and distant objects\n• **Eye Massage** - Gently massage around your eyes\n\nWhich exercise interests you most?',
        'I love helping with vision improvement! Here are some proven techniques:\n\n1. **Blinking Exercises** - 20 rapid blinks, then close eyes for 20 seconds\n2. **Zoom Focus** - Hold thumb at arm\'s length, focus on it, then on something far away\n3. **Eye Circles** - Look up, right, down, left in slow circles\n4. **Distance Gazing** - Look at the horizon for 2-3 minutes\n\nReady to try one of these?',
      ];
      return exerciseResponses[DateTime.now().millisecond % exerciseResponses.length];
    }
    
    // Dry and tired eyes
    else if (message.contains('dry') || message.contains('tired') || message.contains('fatigue')) {
      final dryEyeResponses = [
        'Dry or tired eyes are common, especially with screen use. Here are some solutions:\n\n1. **Blink more frequently** - We tend to blink less when looking at screens\n2. **Use artificial tears** - Lubricating eye drops can help\n3. **Adjust your screen** - Position it slightly below eye level\n4. **Take breaks** - Follow the 20-20-20 rule\n5. **Humidify your space** - Dry air can worsen symptoms\n\nTry these tips and let me know if you need more specific advice!',
        'I understand the struggle with dry, tired eyes. Here\'s what I recommend:\n\n• **Hydration** - Drink 8-10 glasses of water daily\n• **Humidifier** - Add moisture to your environment\n• **Omega-3** - Consider fish oil supplements\n• **Warm Compress** - Apply for 5-10 minutes daily\n• **Screen Settings** - Reduce blue light and brightness\n\nHow long have you been experiencing this?',
        'Dry and tired eyes can really affect your daily life. Let me help you with some targeted solutions:\n\n• **Blinking Breaks** - Every 10 minutes, blink 10 times slowly\n• **Eye Drops** - Use preservative-free artificial tears\n• **Air Quality** - Avoid fans blowing directly on your face\n• **Sleep Quality** - Ensure 7-8 hours of quality sleep\n• **Nutrition** - Eat foods rich in vitamin A and omega-3s\n\nWhat\'s your current screen time like?',
      ];
      return dryEyeResponses[DateTime.now().millisecond % dryEyeResponses.length];
    }
    
    // Headaches and migraines
    else if (message.contains('headache') || message.contains('migraine') || message.contains('pressure')) {
      final headacheResponses = [
        'Eye-related headaches can be caused by several factors:\n\n1. **Eye strain** from prolonged screen use\n2. **Uncorrected vision** problems\n3. **Poor lighting** conditions\n4. **Incorrect screen distance** or angle\n\nI recommend:\n- Taking regular breaks\n- Ensuring proper lighting\n- Getting your vision checked\n- Adjusting your screen settings\n\nIf headaches persist, please consult a healthcare professional.',
        'Headaches related to vision issues are more common than you might think. Here\'s what could be causing them:\n\n• **Digital Eye Strain** - Blue light and screen glare\n• **Uncorrected Refractive Error** - Need for glasses/contacts\n• **Poor Posture** - Incorrect screen positioning\n• **Dehydration** - Not enough water intake\n• **Sleep Issues** - Inadequate rest\n\nWhen do these headaches typically occur?',
        'I\'m sorry you\'re dealing with headaches. Vision-related headaches often have specific triggers:\n\n• **Screen Time** - Too much digital device use\n• **Lighting** - Harsh or insufficient lighting\n• **Focus Strain** - Eyes working too hard to see clearly\n• **Neck Tension** - Poor posture while working\n• **Eye Muscle Fatigue** - Overuse of eye muscles\n\nLet\'s work on some immediate relief strategies. What\'s your work setup like?',
      ];
      return headacheResponses[DateTime.now().millisecond % headacheResponses.length];
    }
    
    // Vision test related
    else if (message.contains('test') || message.contains('check') || message.contains('exam')) {
      final testResponses = [
        'Great idea to get your vision tested! I can help you with our comprehensive vision test that includes:\n\n• **Visual Acuity** - How clearly you can see\n• **Astigmatism** - Irregular cornea shape\n• **Duochrome** - Fine-tuning your prescription\n• **Near Vision** - Reading distance clarity\n\nWould you like to start with our vision test?',
        'Regular vision testing is so important for maintaining good eye health! Our test covers:\n\n• **Distance Vision** - How well you see far away\n• **Color Vision** - Ability to distinguish colors\n• **Depth Perception** - 3D vision capability\n• **Eye Coordination** - How well your eyes work together\n\nReady to take the test? It only takes about 10-15 minutes!',
        'I\'m glad you\'re thinking about getting your vision checked! Our digital vision test is designed to:\n\n• **Detect Refractive Errors** - Nearsightedness, farsightedness, astigmatism\n• **Assess Eye Health** - Early detection of potential issues\n• **Provide Recommendations** - Personalized advice based on results\n• **Track Changes** - Monitor your vision over time\n\nShall we begin your vision assessment?',
      ];
      return testResponses[DateTime.now().millisecond % testResponses.length];
    }
    
    // Gratitude responses
    else if (message.contains('thank') || message.contains('thanks') || message.contains('appreciate')) {
      final thankResponses = [
        'You\'re very welcome! I\'m here to help with any eye health questions you might have. Feel free to ask about exercises, symptoms, or general eye care tips anytime!',
        'My pleasure! Helping you maintain healthy vision is what I\'m here for. Don\'t hesitate to reach out if you have any other questions!',
        'You\'re so welcome! I\'m always happy to help with your eye health journey. Remember, regular eye care is an investment in your overall well-being!',
        'It\'s my absolute pleasure! I love helping people take better care of their eyes. Feel free to ask me anything about eye health anytime!',
      ];
      return thankResponses[DateTime.now().millisecond % thankResponses.length];
    }
    
    // General health and lifestyle
    else if (message.contains('health') || message.contains('lifestyle') || message.contains('prevent')) {
      final healthResponses = [
        'Maintaining good eye health is all about lifestyle choices! Here are some key factors:\n\n• **Nutrition** - Eat leafy greens, fish, and colorful fruits\n• **Exercise** - Regular physical activity improves circulation\n• **Sleep** - 7-8 hours of quality sleep nightly\n• **Hydration** - Drink plenty of water throughout the day\n• **Protection** - Wear sunglasses and safety glasses when needed\n\nWhat aspect of eye health interests you most?',
        'Prevention is the best medicine when it comes to eye health! Here\'s what I recommend:\n\n• **Regular Checkups** - Annual comprehensive eye exams\n• **Screen Breaks** - Follow the 20-20-20 rule religiously\n• **UV Protection** - Wear sunglasses year-round\n• **Healthy Diet** - Focus on antioxidants and omega-3s\n• **Manage Health Conditions** - Control diabetes, blood pressure\n\nAre you looking to improve any specific area?',
        'Great question about eye health! Here are some proactive steps you can take:\n\n• **Eye-Friendly Foods** - Carrots, spinach, salmon, berries\n• **Proper Lighting** - Avoid glare and harsh lighting\n• **Eye Exercises** - Regular practice of focus and movement exercises\n• **Stress Management** - High stress can affect eye health\n• **Environmental Factors** - Control humidity and air quality\n\nWhat\'s your current eye care routine like?',
      ];
      return healthResponses[DateTime.now().millisecond % healthResponses.length];
    }
    
    // Default response with more variety
    else {
      final defaultResponses = [
        'I\'m here to help with your eye health questions! You can ask me about:\n\n• Eye exercises and vision improvement\n• Common eye problems and solutions\n• Tips for reducing eye strain\n• General eye care advice\n\nWhat would you like to know about?',
        'That\'s an interesting question! I\'m your AI eye care assistant, and I can help with:\n\n• Vision testing and assessment\n• Eye exercise recommendations\n• Symptom analysis and guidance\n• Preventive eye care tips\n\nHow can I assist you today?',
        'I\'m always happy to help with eye health topics! Feel free to ask me about:\n\n• Digital eye strain solutions\n• Vision improvement techniques\n• Eye health maintenance\n• When to see an eye doctor\n\nWhat\'s on your mind regarding your eye health?',
        'Great question! As your virtual eye care assistant, I can provide guidance on:\n\n• Comprehensive vision testing\n• Eye exercise routines\n• Lifestyle changes for better vision\n• Early warning signs to watch for\n\nWhat specific aspect of eye health would you like to explore?',
      ];
      return defaultResponses[DateTime.now().millisecond % defaultResponses.length];
    }
  }

  List<ChatAction> _generateMessageActions(String message) {
    final actions = <ChatAction>[];
    
    // Add action based on message content
    if (message.toLowerCase().contains('exercise')) {
      actions.add(ChatAction(
        id: 'start_exercise',
        title: 'Start Exercise',
        type: 'navigate',
        data: {'route': '/exercises'},
      ));
    }
    
    if (message.toLowerCase().contains('test') || message.toLowerCase().contains('vision')) {
      actions.add(ChatAction(
        id: 'take_test',
        title: 'Take Vision Test',
        type: 'navigate',
        data: {'route': '/vision_test'},
      ));
    }
    
    if (message.toLowerCase().contains('doctor') || message.toLowerCase().contains('professional')) {
      actions.add(ChatAction(
        id: 'find_doctor',
        title: 'Find Eye Doctor',
        type: 'external',
        data: {'url': 'https://www.google.com/search?q=eye+doctor+near+me'},
      ));
    }
    
    return actions;
  }

  Future<void> sendVoiceMessage(String userId, String audioUrl) async {
    // Voice functionality disabled for now
    _error = 'Voice messages are not available in this version';
    notifyListeners();
  }

  Future<String> getVoiceResponse(String text) async {
    // Voice functionality disabled for now
    return '';
  }

  Future<void> endSession() async {
    if (_currentSession != null) {
      try {
        _currentSession = ChatSession(
          id: _currentSession!.id,
          userId: _currentSession!.userId,
          startTime: _currentSession!.startTime,
          endTime: DateTime.now(),
          messages: _currentSession!.messages,
          summary: _generateSessionSummary(),
          status: ChatStatus.ended,
        );
        
        // Session ended locally
        // await _firebaseService.saveChatSession(_currentSession!);
      } catch (e) {
        _error = e.toString();
        notifyListeners();
      }
    }
  }

  String _generateSessionSummary() {
    if (_messages.isEmpty) return '';
    
    final userMessages = _messages.where((m) => m.isFromUser).length;
    final aiMessages = _messages.where((m) => !m.isFromUser).length;
    
    return 'Session with $userMessages user messages and $aiMessages AI responses';
  }

  void clearMessages() {
    _messages.clear();
    _currentSession = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

