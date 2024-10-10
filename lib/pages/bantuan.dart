import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/pages/chatroom.dart';
import 'package:covid_detection/services/chatroom_services.dart';
import 'package:covid_detection/services/hospital_services.dart';
import 'package:covid_detection/pages/map.dart';
import 'package:covid_detection/services/report_services.dart';
import 'package:covid_detection/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Bantuan extends StatefulWidget {
  final GeoPoint currentLocation;
  final String userId;
  const Bantuan({
    super.key,
    required this.currentLocation,
    required this.userId,
  });

  @override
  State<Bantuan> createState() => _BantuanState();
}

class _BantuanState extends State<Bantuan> {
  final UserServices userServices = UserServices();
  final ReportServices reportServices = ReportServices();
  final ChatRoomServices chatRoomServices = ChatRoomServices();
  List<dynamic> _hospitals = [];

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
          child: Map(hospitals: _hospitals, center: widget.currentLocation),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  'Rumah sakit terdekat : ',
                  style: GoogleFonts.signika(
                    textStyle: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _hospitals.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 6, right: 3),
                      leading: Icon(
                        Icons.health_and_safety,
                        color: Colors.green[600],
                        size: 35,
                      ),
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
                          final user =
                              await userServices.getUserByUid(widget.userId);

                          if (user.name!.isNotEmpty &&
                              user.email!.isNotEmpty &&
                              user.phone!.isNotEmpty &&
                              user.address!.isNotEmpty &&
                              user.gender!.isNotEmpty &&
                              user.birthDate!.isNotEmpty) {
                            final chatRoom = await chatRoomServices.getChatRoom(
                                widget.userId, _hospitals[index]['documentId']);

                            final hospital = await userServices
                                .getUserByUid(_hospitals[index]['documentId']);

                            final report = await reportServices.getReport(
                                widget.userId, hospital.documentId!);

                            if (chatRoom != null) {
                              await chatRoomServices
                                  .updateIsUserRead(chatRoom.documentId!);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chatroom(
                                    hospital: hospital,
                                    userId: widget.userId,
                                    chatRoomId: chatRoom.documentId,
                                    currentLocation: widget.currentLocation,
                                    report: report,
                                  ),
                                ),
                              );
                            } else {
                              final chatRoom =
                                  await chatRoomServices.createChatRoom(
                                      widget.userId,
                                      _hospitals[index]['documentId']);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chatroom(
                                    hospital: hospital,
                                    userId: widget.userId,
                                    chatRoomId: chatRoom!.documentId,
                                    currentLocation: widget.currentLocation,
                                    report: report,
                                  ),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Lengkapin profile anda terlebih dahulu'),
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
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
