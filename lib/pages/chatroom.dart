import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/report_model.dart';
import 'package:covid_detection/models/user_model.dart';
import 'package:covid_detection/pages/chats.dart';
import 'package:covid_detection/services/chatroom_services.dart';
import 'package:covid_detection/services/message_services.dart';
import 'package:covid_detection/services/report_services.dart';
import 'package:flutter/material.dart';

class Chatroom extends StatefulWidget {
  final UserModel? hospital;
  final String userId;
  final String? chatRoomId;
  final GeoPoint currentLocation;

  const Chatroom({
    super.key,
    required this.hospital,
    required this.userId,
    required this.chatRoomId,
    required this.currentLocation,
  });

  @override
  State<Chatroom> createState() => _ChatroomState();
}

class _ChatroomState extends State<Chatroom> {
  final _messageController = TextEditingController();
  final ChatRoomServices chatRoomServices = ChatRoomServices();
  final MessageServices messageServices = MessageServices();
  final ReportServices reportServices = ReportServices();
  ReportModel? report;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await chatRoomServices.updadeChatRoom(
          _messageController.text, widget.chatRoomId!);

      await messageServices.addMessage(
          _messageController.text, widget.userId, widget.chatRoomId);

      _messageController.clear();

      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  void didChangeDependencies() {
    fetchData();
    super.didChangeDependencies();
  }

  void fetchData() async {
    final fetchReport = await reportServices.getReport(
        widget.userId, widget.hospital!.documentId!);
    setState(() {
      report = fetchReport;
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

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
        title: Text(
          widget.hospital!.name!,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
        actions: [
          report != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 13),
                  child: Text(
                    report!.status,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: TextButton(
                    onPressed: () async {
                      await reportServices.createReport(
                        widget.userId,
                        widget.hospital!.documentId,
                        widget.currentLocation,
                      );

                      fetchData();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Minta Bantuan'),
                  ),
                )
        ],
      ),
      body: Chats(
        chatRoomId: widget.chatRoomId!,
        hospitalId: widget.hospital!.documentId!,
      ),
      bottomSheet: Container(
        height: screenHeight * 0.07,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(labelText: 'Message'),
                  onSubmitted: (value) {
                    sendMessage();
                  },
                ),
              ),
              SizedBox(
                width: 50,
                child: IconButton(
                  color: Colors.teal,
                  iconSize: 27,
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
