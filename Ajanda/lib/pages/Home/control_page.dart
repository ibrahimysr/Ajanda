import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:yonetici_paneli/pages/Home/finish/finish_control_bar.dart';

import 'package:yonetici_paneli/pages/Home/home_page.dart';
import 'package:yonetici_paneli/pages/Home/setting/settings.dart';

import 'package:yonetici_paneli/service/auth_service.dart';
import 'package:yonetici_paneli/service/error_message_service.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';

import 'package:yonetici_paneli/widgets/bottomnavigator_button.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  final PageController _pageController = PageController();
  int index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [MenuHeader(), MenuItems()],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: PageView(
        controller: _pageController,
        onPageChanged: (int newIndex) {
          setState(() {
            index = newIndex;
          });
        },
        children: const [
           HomePage(),
           EndTimeController(),
           SettingPage(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: const Color(0xffF0F0FA),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                bottomNavigatorButton(() {
                  _pageController.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                }, index, 0, 'assets/images/write.png', "Ana Sayfa"),
                bottomNavigatorButton(() {
                  _pageController.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                }, index, 1, 'assets/images/menu-2.png', "Görev Durumu"),
                bottomNavigatorButton(() {
                  _pageController.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                }, index, 2, 'assets/images/setting.png', "Ayarlar"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MenuHeader extends StatelessWidget {
 
  const MenuHeader({super.key});

 Future<Map<String, dynamic>?> _getProfileImageAndUsername() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Kullanıcılar')
        .doc(user.uid)
        .get();

    if (userDoc.exists) {
      String? profileImageUrl = userDoc.get('profileImageUrl') as String?;
      String? username = userDoc.get('Kullanıcı Adı') as String?;
      
      if (profileImageUrl != null && username != null) {
        return {
          'profileImageUrl': profileImageUrl,
          'Kullanıcı Adı': username,
        };
      } else {
        debugPrint('Profile image URL or username is null');
        return null;
      }
    } else {
      debugPrint('User document does not exist');
      return null;
    }
  } catch (e) {
    debugPrint('Error fetching profile image URL and username: $e');
    return null;
  }
}

  @override
  Widget build(BuildContext context) { 

    return Container(
      color: enabledColor,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _getProfileImageAndUsername(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const CircleAvatar(
              backgroundImage: AssetImage("assets/icon.png"),
              radius: 40,
            );
          } else if (!snapshot.hasData) {
            return const CircleAvatar(
              backgroundImage: AssetImage("assets/icon.png"),
              radius: 40,
            );
          } else {
             String profileImageUrl = snapshot.data!["profileImageUrl"]!;
            String username = snapshot.data!["Kullanıcı Adı"]!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl),
                    radius: 40,
                  ),
                  const SizedBox(height: 12),
                   Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      username,
                      style:const TextStyle(color: Colors.white, fontSize: 19),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class MenuItems extends StatelessWidget {
  const MenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Wrap(
        runSpacing: 16,
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Hata Bildirimi"),
            onTap: () {
              showReportDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Çıkış Yap"),
            onTap: () {
              context.read<FlutterFireAuthService>().signOut(context);
            },
          ),
        ],
      ),
    );
  }
}

