import 'package:flutter/material.dart';

class Chatroom extends StatefulWidget {
  const Chatroom({super.key});

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'RS Shabiq Ghazi',
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
          height: screenHeight * 0.07,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    // controller: _messageController,
                    decoration: InputDecoration(labelText: 'Message'),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: IconButton(
                    color: Colors.teal,
                    iconSize: 27,
                    icon: const Icon(Icons.send), onPressed: () {},
                    // onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
