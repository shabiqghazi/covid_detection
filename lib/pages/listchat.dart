import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/chatroom_model.dart';
import 'package:covid_detection/models/user_model.dart';
import 'package:covid_detection/pages/chatroom.dart';
import 'package:covid_detection/services/chatroom_services.dart';
import 'package:covid_detection/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Listchat extends StatefulWidget {
  final String userId;
  final GeoPoint curentLocation;
  const Listchat(
      {super.key, required this.userId, required this.curentLocation});

  @override
  State<Listchat> createState() => _ListchatState();
}

class _ListchatState extends State<Listchat> {
  ChatRoomServices chatRoomServices = ChatRoomServices();
  UserServices userServices = UserServices();
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
                  // Sementara data sedang dimuat
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: const Text('Loading...'),
                      subtitle: Text(item.lastMessage),
                      leading: const Icon(Icons.person),
                    );
                  }

                  // Jika ada error dalam pengambilan data
                  if (snapshot.hasError) {
                    return ListTile(
                      title: const Text('Error loading user'),
                      subtitle: Text(item.lastMessage),
                      leading: const Icon(Icons.error),
                    );
                  }

                  // Jika data tersedia
                  if (snapshot.hasData) {
                    UserModel? hospital = snapshot.data;
                    String formattedDate =
                        DateFormat('dd/MM/yy').format(item.lastUpdate);
                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatroom(
                              hospital: hospital,
                              userId: widget.userId,
                              chatRoomId: item.documentId,
                              currentLocation: widget.curentLocation,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        hospital?.name ?? "Unknown",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(item.lastMessage),
                      leading: const Icon(Icons.person),
                      trailing: Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }

                  // Jika data tidak tersedia
                  return ListTile(
                    title: const Text("Rumah sakit tidak ditemukan"),
                    subtitle: Text(item.lastMessage),
                    leading: const Icon(Icons.person),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
