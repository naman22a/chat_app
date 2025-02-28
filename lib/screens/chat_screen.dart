import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:chat_app/widgets/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/chat/chat_service.dart';
import '../services/auth/auth_service.dart';

class ChatScreen extends StatefulWidget {
  final String receiverEmail;
  final String receiverId;

  const ChatScreen({
    super.key,
    required this.receiverEmail,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(
      () {
        if (myFocusNode.hasFocus) {
          Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
        }
      },
    );

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverId, _messageController.text);
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          // display all messages
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderId = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverId, senderId),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // list view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs
              .map(
                (doc) => _buildMessageItem(doc),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderId'] == _authService.getCurrentUser()!.uid;

    // align message to the right if sender is the current user, otherwise left
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(
        message: data['message'],
        isCurrentUser: isCurrentUser,
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          // textfield should take up most of the space
          Expanded(
            child: MyTextField(
              focusNode: myFocusNode,
              hintText: 'Type a message',
              controller: _messageController,
            ),
          ),

          // send message button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25.0),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
