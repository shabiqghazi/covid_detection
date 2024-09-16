import 'package:covid_detection/services/auth_services.dart';
import 'package:covid_detection/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Daftar extends StatefulWidget {
  const Daftar({super.key});
  static const routeName = '/daftar';

  @override
  State<Daftar> createState() => _DaftarState();
}

class _DaftarState extends State<Daftar> {
  final AuthServices _authServices = AuthServices();
  final UserServices _userServices = UserServices();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: screenHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      width: screenWidth * 0.7,
                      height: screenWidth * 0.7,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Container(
                      width: screenWidth * 0.8,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "Daftarkan akun anda segera!",
                              style: GoogleFonts.signika(
                                textStyle: const TextStyle(
                                  color: Color(0xff01b399),
                                  fontSize: 27,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              autocorrect: false,
                              controller: _nameController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Nama harus diisi!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.account_circle_outlined,
                                  color: Color(0xff01b399),
                                ),
                                labelText: "Nama Lengkap",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              autocorrect: false,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email harus diisi!'; // Validasi untuk Email
                                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Masukkan email yang valid!'; // Validasi format email
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.mail_outline,
                                  color: Color(0xff01b399),
                                ),
                                labelText: "Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              autocorrect: false,
                              textInputAction: TextInputAction.done,
                              obscureText: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password harus diisi!';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.key,
                                  color: Color(0xff01b399),
                                ),
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Sudah punya akun?",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 110, 110, 110)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Login Disini!",
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _authServices
                                        .createUserWithEmailAndPassword(
                                      context,
                                      _emailController.text,
                                      _passwordController.text,
                                      _nameController.text,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: const Color(0xff01b399),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: const Text(
                                  "Daftar",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
