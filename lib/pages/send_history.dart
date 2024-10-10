import 'package:covid_detection/models/history_model.dart';
import 'package:covid_detection/services/chatroom_services.dart';
import 'package:covid_detection/services/history_services.dart';
import 'package:covid_detection/services/message_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SendHistory extends StatefulWidget {
  final String userId;
  final String chatRoomId;
  const SendHistory(
      {super.key, required this.userId, required this.chatRoomId});

  @override
  State<SendHistory> createState() => _SendHistoryState();
}

class _SendHistoryState extends State<SendHistory> {
  final HistoryServices historyServices = HistoryServices();
  final MessageServices messageServices = MessageServices();
  final ChatRoomServices chatRoomServices = ChatRoomServices();

  Future<List<HistoryModel>?> fetchData() async {
    try {
      final histories = await historyServices.getHistories(widget.userId);
      return histories;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih salah satu',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Padding(
              padding: EdgeInsets.only(right: 13),
              child: Text(
                'Error',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          final histories = snapshot.data;

          if (histories != null) {
            if (histories.isNotEmpty) {
              return ListView.builder(
                itemCount: histories.length,
                itemBuilder: (context, index) {
                  DateTime createdAt = histories[index].createdAt;
                  String formattedDate =
                      DateFormat('dd/MM/yy').format(createdAt);
                  String formattedTime =
                      '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.multitrack_audio,
                          size: 30,
                          color: Colors.blue[700],
                        ),
                        title: Text(
                          formattedTime,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${histories[index].status}'),
                            Text(
                              'dim: ${double.parse(histories[index].dimension).toStringAsFixed(2)}  size: ${double.parse(histories[index].size).toStringAsFixed(2)}  dispersi: ${double.parse(histories[index].dispersi).toStringAsFixed(2)}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                            )
                          ],
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              formattedDate,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () async {
                                await messageServices.addHistoryMessage(
                                  histories[index].dimension,
                                  histories[index].size,
                                  histories[index].dispersi,
                                  widget.userId,
                                  widget.chatRoomId,
                                );

                                await chatRoomServices.updateChatRoom(
                                  'You sent your history',
                                  widget.chatRoomId,
                                  widget.userId,
                                );

                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.send,
                                size: 25,
                                color: Colors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const Center(
                child: Text(
                  'Riwayat anda kosong.',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: Text(
                'Riwayat anda kosong.',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
