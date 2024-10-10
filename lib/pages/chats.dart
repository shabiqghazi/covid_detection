import 'package:covid_detection/models/message_model.dart';
import 'package:covid_detection/services/message_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<List<MessageModel>>(
      stream: messageServices.getMessages(widget.chatRoomId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

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
                    DateTime timestamp = data[index].timestamp;
                    String formattedDate =
                        DateFormat('d MMMM yyyy').format(timestamp);
                    String formattedTime =
                        '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
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
                            constraints: BoxConstraints(
                              maxWidth: screenWidth * 0.8,
                            ),
                            decoration: BoxDecoration(
                              color: item.type == 'text'
                                  ? Colors.teal
                                  : Colors.blue[700],
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: item.type == 'text'
                                  ? Text(
                                      item.text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 3),
                                          child: Text(
                                            'Dim: ${double.parse(item.dimension!).toStringAsFixed(2)}  Size: ${double.parse(item.size!).toStringAsFixed(2)}  Dispersi: ${double.parse(item.dispersi!).toStringAsFixed(2)}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              formattedTime,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            const SizedBox(width: 7),
                                            Text(
                                              formattedDate,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
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
