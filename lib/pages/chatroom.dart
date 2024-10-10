import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/report_model.dart';
import 'package:covid_detection/models/user_model.dart';
import 'package:covid_detection/pages/chats.dart';
import 'package:covid_detection/pages/send_history.dart';
import 'package:covid_detection/services/chatroom_services.dart';
import 'package:covid_detection/services/message_services.dart';
import 'package:covid_detection/services/report_services.dart';
import 'package:covid_detection/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chatroom extends StatefulWidget {
  final UserModel hospital;
  final ReportModel? report;
  final String? chatRoomId;
  final String userId;
  final GeoPoint currentLocation;

  const Chatroom({
    super.key,
    required this.hospital,
    required this.report,
    required this.chatRoomId,
    required this.userId,
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
  final UserServices userServices = UserServices();
  ReportModel? report;
  UserModel user = UserModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
    chatRoomServices.updateIsUserRead(widget.chatRoomId!);
    report = widget.report;
  }

  Future<void> fetchData() async {
    user = await userServices.getUserByUid(widget.userId);
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await messageServices.addTextMessage(
          _messageController.text, widget.userId, widget.chatRoomId);

      await chatRoomServices.updateChatRoom(
          _messageController.text, widget.chatRoomId!, widget.userId);

      _messageController.clear();

      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  Future<void> confirmReport(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Konfirmasi Bantuan',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          content: const SizedBox(
            height: 90,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Apakah anda yakin meminta bantuan?'),
                Text(
                  'Note : Anda akan mengirim data diri anda yang terdapat pada aplikasi ini.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Setuju'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      setState(() {
        isLoading = true;
      });

      DateTime birthDate = DateFormat('EEE, MMM d, y').parse(user.birthDate!);
      DateTime today = DateTime.now();
      int years = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        years--;
      }
      String age = years.toString();

      String message =
          'Saya mengajukan permintaan bantuan. Nama Lengkap: ${user.name} Usia: $age Jenis Kelamin : ${user.gender} Telepon: ${user.phone} Alamat: ${user.address} Email: ${user.email}';

      await messageServices.addTextMessage(
        message,
        widget.userId,
        widget.chatRoomId,
      );

      await chatRoomServices.updateChatRoom(
          message, widget.chatRoomId!, widget.userId);

      await reportServices.createReport(
        widget.userId,
        widget.hospital.documentId,
        widget.currentLocation,
      );

      final fetchReport = await reportServices.getReport(
          widget.userId, widget.hospital.documentId!);

      setState(() {
        report = fetchReport;
        isLoading = false;
      });
    }
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
          widget.hospital.name!,
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
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 103,
                    height: 30,
                    child: TextButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              await confirmReport(context);
                            },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('Minta Bantuan'),
                    ),
                  ),
                ),
        ],
      ),
      body: Chats(
        chatRoomId: widget.chatRoomId!,
        hospitalId: widget.hospital.documentId!,
      ),
      bottomSheet: Container(
        height: screenHeight * 0.07,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 50,
              child: IconButton(
                color: Colors.grey,
                iconSize: 30,
                icon: const Icon(Icons.report),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SendHistory(
                        userId: widget.userId,
                        chatRoomId: widget.chatRoomId!,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
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
    );
  }
}
