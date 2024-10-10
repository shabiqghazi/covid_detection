import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatefulWidget {
  final GeoPoint center;
  Map({super.key, required this.hospitals, required this.center});
  List<dynamic> hospitals;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(widget.center.latitude, widget.center.longitude),
          zoom: 11.5,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 100.0,
                height: 100.0,
                point: LatLng(widget.center.latitude, widget.center.longitude),
                builder: (ctx) => const Column(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 40.0),
                    Text(
                      'You',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                        shadows: [Shadow(color: Colors.white, blurRadius: 2.0)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          MarkerLayer(
            markers: List.of(
              widget.hospitals.map(
                (hospital) {
                  return Marker(
                    width: 100.0,
                    height: 100.0,
                    point: LatLng(hospital['geoPoint'].latitude,
                        hospital['geoPoint'].longitude),
                    builder: (ctx) => Column(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.red, size: 40.0),
                        Text(
                          hospital['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10.0,
                              shadows: [
                                Shadow(color: Colors.white, blurRadius: 2.0)
                              ]),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
