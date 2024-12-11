import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:yonetici_paneli/pages/Home/setting/profil_image_picker.dart';
import 'package:yonetici_paneli/pages/Login/forgat_pw_page.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/login_button.dart';
import 'package:yonetici_paneli/widgets/setting_text_field.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _profileImageUrl;

 
  void fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('Kullanıcılar')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          usernameController.text = snapshot.data()?['Kullanıcı Adı'] ?? '';
          emailController.text = snapshot.data()?['email'] ?? '';
          
          _profileImageUrl = snapshot.data()?['profileImageUrl'] ?? '';
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> _selectProfileImage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileImagePickerPage()),
    );

    if (result != null && result is String) {
      setState(() {
        _profileImageUrl = result;
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('Kullanıcılar')
            .doc(user.uid)
            .update({
          'profileImageUrl': result,
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appcolor,
          centerTitle: true,
          title: Text("TaskFlow", style: AppStyle.mainTitle),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: SizedBox(
                height: 80,
                width: 80,
                child: Lottie.asset("assets/animations/logo.json"),
              ),
            )
          ],
          leading: IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu, color: textColor),
          ),
        ),
        backgroundColor: appcolor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _selectProfileImage,
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: enabledColor, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: enabledColor.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 5,
                            )
                          ],
                          image: _profileImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(_profileImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _profileImageUrl == null
                            ? const Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: 40,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Hoşgeldiniz",
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: enabledColor.withOpacity(0.3),
                            blurRadius: 10,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: appcolor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: enabledColor.withOpacity(0.3)),
                  boxShadow: [
                    BoxShadow(
                      color: enabledColor.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    settingTextfield(
                      usernameController,
                      const Icon(Icons.supervised_user_circle),
                      "Kullanıcı Adı",
                    ),
                    const SizedBox(height: 20),
                    settingTextfield(
                      emailController,
                      const Icon(Icons.email),
                      "Email",
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: enabledColor.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: loginButton("Şifreyi Sıfırla", () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.size,
                            alignment: Alignment.center,
                            child: const ForgatPasswordPage(),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
