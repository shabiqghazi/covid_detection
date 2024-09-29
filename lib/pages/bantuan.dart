import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/pages/chatroom.dart';
import 'package:covid_detection/services/hospital_services.dart';
import 'package:covid_detection/pages/map.dart';
import 'package:flutter/material.dart';

class Bantuan extends StatefulWidget {
  final GeoPoint currentPosition;
  const Bantuan({super.key, required this.currentPosition});

  @override
  State<Bantuan> createState() => _BantuanState();
}

class _BantuanState extends State<Bantuan> {
  List<dynamic> _hospitals = [];
  bool _isLoading = true;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  Future<void> _fetchData() async {
    try {
      HospitalServices().getDocs(widget.currentPosition).then((hospitals) {
        setState(() {
          _hospitals = hospitals;
          _isLoading = false;
        });
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child:
              MapScreen(hospitals: _hospitals, center: widget.currentPosition),
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
                      // Navigator.of(context).pushNamed('/chatroom');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Chatroom()),
                      );
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
