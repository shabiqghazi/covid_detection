import 'package:covid_detection/models/user_model.dart';
import 'package:covid_detection/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool edit = false;
  late UserModel user;
  User? userAccount = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final userServices = UserServices();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController birthDateController;
  String? selectedGender;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ModalRoute.of(context)!.settings.arguments as UserModel;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phone);
    addressController = TextEditingController(text: user.address);
    birthDateController = TextEditingController(text: user.birthDate);
    selectedGender = user.gender != '' ? user.gender : null;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    birthDateController.dispose();
    super.dispose();
  }

  Future<void> resetForm() async {
    setState(() {
      nameController.text = user.name as String;
      emailController.text = user.email as String;
      phoneController.text = user.phone as String;
      addressController.text = user.address as String;
      birthDateController.text = user.birthDate as String;
      selectedGender = user.gender != '' ? user.gender : null;
      _formKey.currentState!.reset();
      FocusScope.of(context).unfocus();
      edit = !edit;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: const Text('Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: TextButton(
              onPressed: () async {
                await resetForm();
              },
              style: TextButton.styleFrom(
                backgroundColor: edit ? Colors.red[600] : Colors.green[600],
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              child: edit ? const Text('Batal') : const Text('Edit'),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      readOnly: true,
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email :',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      readOnly: !edit,
                      autocorrect: false,
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama harus diisi!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.contact_emergency),
                        labelText: 'Nama Lengkap :',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      readOnly: !edit,
                      autocorrect: false,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Telepon harus diisi!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.phone),
                        labelText: 'Telepon :',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      readOnly: !edit,
                      autocorrect: false,
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Alamat harus diisi!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.pin_drop),
                        labelText: 'Alamat :',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      iconSize: 0,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.person_pin_circle_rounded),
                        labelText: 'Gender :',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      value: selectedGender,
                      items: ['Laki-laki', 'Perempuan'].map((String gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: edit
                          ? (String? newValue) {
                              setState(() {
                                selectedGender = newValue;
                              });
                            }
                          : null,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Silahkan pilih gender!';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      readOnly: !edit,
                      controller: birthDateController,
                      onTap: () async {
                        if (edit) {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );

                          if (selectedDate != null) {
                            String formattedDate =
                                DateFormat.yMMMEd().format(selectedDate);
                            setState(() {
                              birthDateController.text = formattedDate;
                            });
                            print(birthDateController.text);
                          }
                        }
                      },
                      keyboardType: TextInputType.none,
                      textInputAction: TextInputAction.done,
                      showCursor: false,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Tanggal lahir harus diisi!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.date_range),
                        labelText: 'Tanggal Lahir :',
                        labelStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        edit
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await userServices.updateUser(
                                        userAccount!.uid,
                                        emailController.text,
                                        nameController.text,
                                        phoneController.text,
                                        addressController.text,
                                        birthDateController.text,
                                        selectedGender,
                                        user.createdAt,
                                      );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    foregroundColor: Colors.white,
                                    textStyle: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  child: const Text('Simpan'),
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
