import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yonetici_paneli/service/auth_service.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/login_button.dart';

class ForgatPasswordPage extends StatefulWidget {
  const ForgatPasswordPage({super.key});

  @override
  State<ForgatPasswordPage> createState() => _ForgatPasswordPageState();
}

class _ForgatPasswordPageState extends State<ForgatPasswordPage> {
  final TextEditingController _passwordResetcontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "E-posta adresinizi girin",
                style: AppStyle.mainContent,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: appcolor2,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      border: Border.all(color: textColor)),
                  child: TextField(
                    controller: _passwordResetcontroller,
                    style: const TextStyle(color: textColor),
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        iconColor: enabledColor,
                        border: InputBorder.none,
                        hintText: "E-posta",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
              loginButton(
                  "Şifreyi Sıfırla",
                  () => {
                        context
                            .read<FlutterFireAuthService>()
                            .passwordReset(_passwordResetcontroller.text.trim(),context)
                      })
            ],
          ),
        ),
      ),
    );
  }
}
