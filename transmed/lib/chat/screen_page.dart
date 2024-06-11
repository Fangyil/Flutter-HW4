import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'fetch.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.name});

  final String name;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatUser user = ChatUser(id: "1", firstName: widget.name);
  ChatUser bot = ChatUser(
      id: "2", firstName: "Gemini", profileImage: "assets/gemini_logo.png");

  List<ChatMessage> messages = [];
  List<ChatUser> typing = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (messages.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Hello! ${user.firstName}\nHow can I assist you?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff607DEF)),
              ),
            ),
          Expanded(
            child: DashChat(
              typingUsers: typing,
              currentUser: user,
              onSend: _onSend,
              messages: messages,
              inputOptions: InputOptions(
                  alwaysShowSend: true, sendButtonBuilder: _sendButtons),
              messageOptions: MessageOptions(
                showOtherUsersAvatar: true,
                currentUserContainerColor: const Color(0xff607DEF),
                showTime: true,
                avatarBuilder: (bot, onPressAvatar, onLongPressAvatar) {
                  return DefaultAvatar(
                      user: bot,
                      fallbackImage:
                          const AssetImage("assets/gemini_logo.png"));
                },
              ),
              scrollToBottomOptions: ScrollToBottomOptions(
                scrollToBottomBuilder: _scrollToBottomBuilder,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onSend(ChatMessage msg) {
    if (msg.text.trim().isNotEmpty) {
      _sendMessage(msg);
    }
  }

  Future<void> _sendMessage(ChatMessage msg) async {
    typing.add(bot);
    messages.insert(0, msg);
    setState(() {});

    try {
      final response = await generateResponse(msg.text);
      final msgText = response!;
      final responseMsg = ChatMessage(
          text: msgText,
          user: bot,
          createdAt: DateTime.now(),
          isMarkdown: true);
      messages.insert(0, responseMsg);
    } catch (e) {
      debugPrint('Error sending message: $e');
    } finally {
      typing.remove(bot);
      setState(() {});
    }
  }

  Widget _sendButtons(void Function() onPressedCallback) {
    return Row(
      children: [
        _iconButton(Icons.send, onPressedCallback),
      ],
    );
  }

  Widget _iconButton(IconData icon, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: const Color(0xff607DEF),
        ),
      ),
    );
  }

  Widget _scrollToBottomBuilder(ScrollController scrollController) {
    return DefaultScrollToBottom(
      scrollController: scrollController,
      textColor: const Color(0xff607DEF),
      backgroundColor: Colors.white,
    );
  }
}
