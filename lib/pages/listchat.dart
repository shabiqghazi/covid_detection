import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/chatroom_model.dart';
import 'package:covid_detection/models/user_model.dart';
import 'package:covid_detection/pages/chatroom.dart';
import 'package:covid_detection/services/chatroom_services.dart';
import 'package:covid_detection/services/report_services.dart';
import 'package:covid_detection/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Listchat extends StatefulWidget {
  final String userId;
  final GeoPoint curentLocation;
  const Listchat({
    super.key,
    required this.userId,
    required this.curentLocation,
  });

  @override
  State<Listchat> createState() => _ListchatState();
}

class _ListchatState extends State<Listchat> {
  final ChatRoomServices chatRoomServices = ChatRoomServices();
  final UserServices userServices = UserServices();
  final ReportServices reportServices = ReportServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: chatRoomServices.getChatRooms(widget.userId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Jika data tersedia
          final data = snapshot.data ?? [];

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var item = data[index];
              return FutureBuilder<UserModel>(
                future: userServices.getUserByUid(item.participants.first),
                builder: (context, snapshot) {
                  // Jika ada error dalam pengambilan data
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text(
                        'Load data error (periksa jaringan anda)',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasData) {
                    UserModel? hospital = snapshot.data;
                    String formattedDate =
                        DateFormat('dd/MM/yy').format(item.lastUpdate);
                    return ListTile(
                      onTap: () async {
                        final report = await reportServices.getReport(
                            widget.userId, hospital!.documentId!);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatroom(
                              hospital: hospital,
                              userId: widget.userId,
                              chatRoomId: item.documentId,
                              currentLocation: widget.curentLocation,
                              report: report,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        hospital?.name ?? "Unknown",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          item.lastParticipant == widget.userId
                              ? item.isHospitalRead == true
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.blue,
                                      size: 18,
                                    )
                                  : const Icon(
                                      Icons.check,
                                      color: Colors.grey,
                                      size: 18,
                                    )
                              : item.isUserRead == true
                                  ? const SizedBox()
                                  : const Icon(
                                      Icons.notifications_rounded,
                                      color: Colors.green,
                                      size: 18,
                                    ),
                          item.lastMessage == 'You sent your history'
                              ? Text(
                                  item.lastMessage,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                  ),
                                )
                              : Expanded(
                                  child: Text(
                                    item.lastMessage.length > 20
                                        ? '${item.lastMessage.substring(0, 20)}...'
                                        : item.lastMessage,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: item.lastParticipant !=
                                                  widget.userId &&
                                              item.isUserRead == false
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      leading: Icon(
                        Icons.health_and_safety,
                        color: Colors.green[600],
                        size: 35,
                      ),
                      trailing: Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 13,
                          color: item.lastParticipant != widget.userId &&
                                  item.isUserRead == false
                              ? Colors.green
                              : Colors.black54,
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
