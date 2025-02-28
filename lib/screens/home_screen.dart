import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/user_tile.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/my_drawer.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/chat/chat_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final AuthService authService = AuthService();
  final ChatService chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: chatService.getUsersStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    if (userData['email'] != authService.getCurrentUser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                receiverEmail: userData['email'],
                receiverId: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
