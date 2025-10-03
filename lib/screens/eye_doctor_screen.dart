import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:speech_to_text/speech_to_text.dart';
// import 'package:flutter_tts/flutter_tts.dart';
import '../providers/chat_provider.dart';
import '../models/chat_model.dart';
import '../widgets/app_header.dart';
import '../widgets/app_footer.dart';

class EyeDoctorScreen extends StatefulWidget {
  const EyeDoctorScreen({super.key});

  @override
  State<EyeDoctorScreen> createState() => _EyeDoctorScreenState();
}

class _EyeDoctorScreenState extends State<EyeDoctorScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // final SpeechToText _speechToText = SpeechToText();
  // final FlutterTts _flutterTts = FlutterTts();
  
  final bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _loadMessages();
  }

  void _initializeSpeech() async {
    // await _speechToText.initialize();
    // await _flutterTts.setLanguage("en-US");
    // await _flutterTts.setSpeechRate(0.5);
  }

  void _loadMessages() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    // Use a default user ID for now since we're not using Firebase auth
    const defaultUserId = 'demo_user';
    chatProvider.loadMessages(defaultUserId);
    chatProvider.startNewSession(defaultUserId);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(title: 'EyeDoctor'),
            Expanded(child: _buildChatArea()),
            _buildInputArea(),
            const AppFooter(currentIndex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF10B2D0), Color(0xFF0891A6)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Ask EyeDoctor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: 20),
          _buildDoctorInfo(),
        ],
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.medical_services,
              color: Color(0xFF10B2D0),
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EyeDoctor',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Eye Care Assistant',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'Online',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea() {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.messages.isEmpty) {
          return _buildWelcomeMessage();
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(20),
          itemCount: provider.messages.length,
          itemBuilder: (context, index) {
            final message = provider.messages[index];
            return _buildMessageBubble(message);
          },
        );
      },
    );
  }

  Widget _buildWelcomeMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF10B2D0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 60,
              color: Color(0xFF10B2D0),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Hello! I\'m EyeDoctor',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111718),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Your intelligent eye care assistant.\nHow can I help you today?',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF618389),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Vision Test', 
        'icon': Icons.visibility, 
        'action': () {
          _messageController.text = 'I want to take a vision test';
          _sendMessage();
        }
      },
      {
        'title': 'Eye Exercises', 
        'icon': Icons.fitness_center, 
        'action': () {
          _messageController.text = 'Show me some eye exercises';
          _sendMessage();
        }
      },
      {
        'title': 'Eye Strain', 
        'icon': Icons.computer, 
        'action': () {
          _messageController.text = 'I have eye strain from computer work';
          _sendMessage();
        }
      },
      {
        'title': 'General Health', 
        'icon': Icons.health_and_safety, 
        'action': () {
          _messageController.text = 'Tell me about general eye health';
          _sendMessage();
        }
      },
    ];

    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: actions.map((action) {
        return GestureDetector(
          onTap: action['action'] as VoidCallback,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  action['icon'] as IconData,
                  color: const Color(0xFF10B2D0),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  action['title'] as String,
                  style: const TextStyle(
                    color: Color(0xFF111718),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: message.isFromUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isFromUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF10B2D0),
              child: const Icon(
                Icons.medical_services,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: message.isFromUser 
                    ? const Color(0xFF10B2D0)
                    : const Color(0xFFF8FAFB),
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomLeft: message.isFromUser 
                      ? const Radius.circular(20)
                      : const Radius.circular(5),
                  bottomRight: message.isFromUser 
                      ? const Radius.circular(5)
                      : const Radius.circular(20),
                ),
                border: message.isFromUser 
                    ? null
                    : Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: message.isFromUser 
                          ? Colors.white
                          : const Color(0xFF111718),
                      fontSize: 16,
                    ),
                  ),
                  if (message.actions != null && message.actions!.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: message.actions!.map((action) {
                        return GestureDetector(
                          onTap: () => _handleAction(action),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: message.isFromUser 
                                  ? Colors.white.withValues(alpha: 0.2)
                                  : const Color(0xFF10B2D0).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              action.title,
                              style: TextStyle(
                                color: message.isFromUser 
                                    ? Colors.white
                                    : const Color(0xFF10B2D0),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (message.isFromUser) ...[
            const SizedBox(width: 10),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF4ECDC4),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Consumer<ChatProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: const Color(0xFFE5E7EB),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFB),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Ask EyeDoctor anything...',
                      hintStyle: TextStyle(color: Color(0xFF618389)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                    maxLines: null,
                    onSubmitted: (text) => _sendMessage(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _isListening ? _stopListening : _startListening,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isListening 
                        ? const Color(0xFFFF6B6B)
                        : const Color(0xFF10B2D0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    _isListening ? Icons.stop : Icons.mic,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4ECDC4),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFDBE4E6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF10B2D0),
          unselectedItemColor: const Color(0xFF618389),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          currentIndex: 3,
          onTap: (index) {
            if (index == 0) {
              Navigator.pop(context);
            } else if (index == 1) {
              Navigator.pushNamed(context, '/vision_test');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/exercises');
            } else if (index == 4) {
              Navigator.pushNamed(context, '/profile');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.visibility),
              label: 'Vision Test',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Exercises',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy),
              label: 'EyeDoctor',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    
    // Use a default user ID for now since we're not using Firebase auth
    const defaultUserId = 'demo_user';
    chatProvider.sendMessage(defaultUserId, text);
    _messageController.clear();
    _scrollToBottom();
  }

  void _startListening() async {
    // Voice functionality temporarily disabled
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice input temporarily disabled. Please type your message.'),
        backgroundColor: Color(0xFF10B2D0),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _stopListening() async {
    // Voice functionality temporarily disabled
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice input temporarily disabled. Please type your message.'),
        backgroundColor: Color(0xFF10B2D0),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleAction(ChatAction action) {
    // Handle action based on type
    switch (action.type) {
      case 'navigate':
        // Navigate to specific route
        final route = action.data?['route'] as String?;
        if (route != null) {
          Navigator.pushNamed(context, route);
        }
        break;
      case 'external':
        // Open external URL
        final url = action.data?['url'] as String?;
        if (url != null) {
          // For now, show a message about external links
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('External link: $url'),
              backgroundColor: const Color(0xFF10B2D0),
            ),
          );
        }
        break;
      default:
        // Send action as message
        _messageController.text = action.title;
        _sendMessage();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
