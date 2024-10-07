import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/chatroom_model.dart';
import 'package:covid_detection/models/user_model.dart';
import 'package:covid_detection/pages/chatroom.dart';
import 'package:covid_detection/services/chatroom_services.dart';
import 'package:covid_detection/services/hospital_services.dart';
import 'package:covid_detection/pages/map.dart';
import 'package:covid_detection/services/user_services.dart';
import 'package:flutter/material.dart';

class Bantuan extends StatefulWidget {
  final GeoPoint currentLocation;
  final String userId;
  const Bantuan(
      {super.key, required this.currentLocation, required this.userId});

  @override
  State<Bantuan> createState() => _BantuanState();
}

class _BantuanState extends State<Bantuan> {
  List<dynamic> _hospitals = [];
  ChatRoomServices chatRoomServices = ChatRoomServices();
  UserServices userServices = UserServices();

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      HospitalServices().getDocs(widget.currentLocation).then((hospitals) {
        setState(() {
          _hospitals = hospitals;
        });
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child:
              MapScreen(hospitals: _hospitals, center: widget.currentLocation),
        ),
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: _hospitals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(
                    _hospitals[index]['name'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: Text(
                    _hospitals[index]['address'],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      ChatRoomModel? chatRoom =
                          await chatRoomServices.getChatRoom(
                              widget.userId, _hospitals[index]['documentId']);

                      if (chatRoom != null) {
                        UserModel hospital = await userServices
                            .getUserByUid(_hospitals[index]['documentId']);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatroom(
                              hospital: hospital,
                              userId: widget.userId,
                              chatRoomId: chatRoom.documentId,
                              currentLocation: widget.currentLocation,
                            ),
                          ),
                        );
                      } else {
                        ChatRoomModel? chatRoom =
                            await chatRoomServices.createChatRoom(
                                widget.userId, _hospitals[index]['documentId']);

                        UserModel hospital = await userServices
                            .getUserByUid(_hospitals[index]['documentId']);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Chatroom(
                              hospital: hospital,
                              userId: widget.userId,
                              chatRoomId: chatRoom!.documentId,
                              currentLocation: widget.currentLocation,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.chat,
                      size: 30,
                      color: Colors.grey,
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
