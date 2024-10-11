import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: const Text(
          'Tentang',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        children: [
          const ListTile(
            title: Text("Tentang Aplikasi", style: TextStyle(fontSize: 20)),
            subtitle: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Divider(),
                ),
                Text(
                  'Aplikasi ini merupakan alat pendeteksi dini COVID-19 yang dirancang untuk pengguna individu. Dengan menggunakan teknologi kecerdasan buatan, aplikasi mampu menganalisis suara batuk dan beberapa parameter kesehatan untuk memprediksi kemungkinan terpapar COVID-19. Pengguna cukup melakukan beberapa langkah sederhana untuk melakukan pemeriksaan mandiri secara praktis dan cepat, tanpa perlu ke fasilitas kesehatan.',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
          ),
          const Expanded(child: Divider()),
          const ListTile(
            title: Text("Tentang Pengembang", style: TextStyle(fontSize: 20)),
            subtitle: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Divider(),
                ),
                Text(
                    "Andromeda Teknologi adalah perusahaan pengembang perangkat lunak yang berfokus pada solusi digital inovatif untuk berbagai sektor, termasuk kesehatan, pendidikan, dan teknologi konsumen. Dengan komitmen untuk menghadirkan teknologi yang dapat memudahkan kehidupan sehari-hari, Andromeda Teknologi menggabungkan kecerdasan buatan (AI) dan pendekatan berbasis data untuk menciptakan aplikasi yang tangguh, aman, dan mudah digunakan.",
                    style: TextStyle(fontSize: 15)),
              ],
            ),
          ),
          const Expanded(child: Divider()),
          ListTile(
            title: const Text("Pengembang", style: TextStyle(fontSize: 20)),
            subtitle: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Divider(),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/zawil.jpeg',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                          );
                        },
                      )),
                  title: const Text("Zawil Hikam"),
                  subtitle: const Text("instagram: @zawilhikam"),
                  // onTap: () async {
                  //   var url = "https://www.instagram.com/zawilhikam";
                  //   if (await canLaunchUrlString(url)) {
                  //     await launchUrlString(url);
                  //   } else {
                  //     throw 'Could not launch $url';
                  //   }
                  // },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/shabiq.jpeg',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                          );
                        },
                      )),
                  title: const Text("Shabiq Ghazi Arkaan"),
                  subtitle: const Text("instagram: @shabiqghazi"),
                  // onTap: () async {
                  //   var url = "https://www.instagram.com/shabiqghazi";
                  //   if (await canLaunchUrlString(url)) {
                  //     await launchUrlString(url);
                  //   } else {
                  //     throw 'Could not launch $url';
                  //   }
                  // },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/yoss.jpeg',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                          );
                        },
                      )),
                  title: const Text("Yoss Sagita Ananto"),
                  subtitle: const Text("instagram: @yossananto"),
                  // onTap: () async {
                  //   var url = "https://www.instagram.com/yossananto";
                  //   if (await canLaunchUrlString(url)) {
                  //     await launchUrlString(url);
                  //   } else {
                  //     throw 'Could not launch $url';
                  //   }
                  // },
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'images/mamat.jpeg',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.person,
                            size: 40,
                          );
                        },
                      )),
                  title: const Text("Rizky Rahmat Nugraha"),
                  subtitle: const Text("instagram: @rrahmatn_"),
                  // onTap: () async {
                  //   var url = "https://www.instagram.com/rrahmatn_";
                  //   if (await canLaunchUrlString(url)) {
                  //     await launchUrlString(url);
                  //   } else {
                  //     throw 'Could not launch $url';
                  //   }
                  // },
                )
              ],
            ),
          ),
          const Expanded(child: Divider()),
          const ListTile(
            title: Text("Versi Aplikasi"),
            subtitle: Text("1.0.0"),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
                child: Text(
              'Copyright Ⓒ 2024 Andromeda Teknologi',
              style: TextStyle(fontSize: 13),
            )),
          ),
        ],
      ),
    );
  }
}
