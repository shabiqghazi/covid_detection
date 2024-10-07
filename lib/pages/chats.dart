import 'package:covid_detection/models/message_model.dart';
import 'package:covid_detection/services/message_services.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  final String chatRoomId;
  final String hospitalId;
  const Chats({super.key, required this.chatRoomId, required this.hospitalId});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  MessageServices messageServices = MessageServices();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<List<MessageModel>>(
      stream: messageServices.getMessages(widget.chatRoomId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Jika data tersedia
        final data = snapshot.data ?? [];

        return Padding(
          padding: EdgeInsets.only(top: 5, bottom: screenHeight * 0.08),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var item = data[index];
                    return Row(
                      mainAxisAlignment: widget.hospitalId == item.sender
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 3,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                item.text,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
