import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Workflow extends StatelessWidget {
  const Workflow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Izinkan aplikasi mengakses microphone perangkat anda!',
                    style: GoogleFonts.signika(
                      textStyle: const TextStyle(
                        color: Color(0xff01b399),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'images/mic_permission.jpeg',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'images/loc_permission.jpeg',
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Izinkan aplikasi mengakses lokasi perangkat anda!',
                    style: GoogleFonts.signika(
                      textStyle: const TextStyle(
                        color: Color(0xff01b399),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Geser ke kanan untuk merekam suara batuk dengan mengklik tombol!',
                    style: GoogleFonts.signika(
                      textStyle: const TextStyle(
                        color: Color(0xff01b399),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: IconButton(
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(
                        Colors.teal,
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(
                      Icons.mic,
                      size: 33,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Tab Riwayat untuk melihat riwayat rekaman suara batuk!',
                    style: GoogleFonts.signika(
                      textStyle: const TextStyle(
                        color: Color(0xff01b399),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    'Tab Bantuan untuk melihat list rumah sakit terdekat serta meminta bantuan!',
                    style: GoogleFonts.signika(
                      textStyle: const TextStyle(
                        color: Color(0xff01b399),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
