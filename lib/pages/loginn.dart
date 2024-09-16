import 'package:flutter/material.dart';
import 'package:covid_detection/services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class Loginn extends StatefulWidget {
  const Loginn({super.key});

  @override
  State<Loginn> createState() => _LoginnState();
}

class _LoginnState extends State<Loginn> {
  final AuthServices _authServices = AuthServices();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
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
            child: SizedBox(
              height: screenHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Cough Detection",
                      style: GoogleFonts.signika(
                        textStyle: const TextStyle(
                          color: Color(0xff01b399),
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  // Image.asset('images/login.jpg'),
                  Container(
                    width: screenWidth * 0.8,
                    height: screenWidth * 0.8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "Login terlebih dahulu!",
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
                              autofocus: false,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
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
                                  "Belum punya akun?",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 110, 110, 110)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed('/daftar');
                                  },
                                  child: Text(
                                    "Daftar Disini!",
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
                                        .signInWithEmailAndPassword(
                                      context,
                                      _emailController.text,
                                      _passwordController.text,
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
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  User? user =
                                      await _authServices.signInWithGoogle();
                                  if (user != null) {
                                    // Navigate to the next screen
                                    Navigator.of(context)
                                        .pushReplacementNamed('/home');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  backgroundColor: Colors.blue[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: const Text(
                                  "Login dengan akun Google",
                                  style: TextStyle(
                                    fontSize: 15,
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
