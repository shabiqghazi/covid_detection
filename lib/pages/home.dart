import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_detection/models/user_model.dart';
import 'package:covid_detection/services/auth_services.dart';
import 'package:covid_detection/pages/bantuan.dart';
import 'package:covid_detection/pages/cara_kerja.dart';
import 'package:covid_detection/pages/history.dart';
import 'package:covid_detection/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final AuthServices _authServices = AuthServices();
  final UserServices userServices = UserServices();
  User? userAccount = FirebaseAuth.instance.currentUser;
  UserModel user = UserModel();
  GeoPoint _currentPosition = const GeoPoint(-7.0, 108.0);

  @override
  void initState() {
    fetchData();
    _requestPermissions();
    super.initState();
  }

  Future<void> fetchData() async {
    UserModel fetchUser = await userServices.getUserByUid(userAccount!.uid);
    setState(() {
      user = fetchUser;
    });
  }

  // Meminta izin akses mikrofon
  Future<void> _requestPermissions() async {
    var mic = await Permission.microphone.request();
    var location = await Permission.location.request();

    if (mic != PermissionStatus.granted) {
      await openAppSettings();
    }

    if (location != PermissionStatus.granted) {
      await openAppSettings();
    } else {
      await _getCurrentLocation();
    }
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin logout?'),
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
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      await _authServices.signOut(context);
    }
  }

  // Mengambil lokasi saat ini
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = GeoPoint(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Gagal mendapatkan lokasi: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(
              user.name?.isNotEmpty == true
                  ? 'Halo, ${user.name}!'
                  : userAccount?.displayName != null
                      ? 'Halo, ${userAccount!.displayName}!'
                      : 'Halo, ',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: PopupMenuButton<String>(
                  onSelected: (value) {
                    // Gunakan Future.microtask untuk menangani kode asinkron
                    Future.microtask(() async {
                      if (value == 'profile') {
                        Navigator.pushNamed(
                          context,
                          '/profile',
                          arguments: user,
                        );
                      } else if (value == 'logout') {
                        _confirmLogout(context);
                      }
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return const [
                      PopupMenuItem<String>(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 8),
                            Text('Profile'),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout),
                            SizedBox(width: 8),
                            Text('Logout'),
                          ],
                        ),
                      ),
                    ];
                  },
                  child: userAccount!.photoURL != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            userAccount!.photoURL!,
                            width: 30,
                          ),
                        )
                      : const Icon(
                          Icons.account_circle,
                          size: 30,
                          color: Colors.white,
                        ),
                ),
              ),
            ],
            bottom: const TabBar(
              unselectedLabelColor: Colors.white70,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: 'Cara Kerja',
                ),
                Tab(
                  text: 'Riwayat',
                ),
                Tab(
                  text: 'Bantuan',
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: TabBarView(
              children: <Widget>[
                const CaraKerja(),
                Riwayat(
                  userId: userAccount!.uid,
                ),
                Bantuan(currentPosition: _currentPosition),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
