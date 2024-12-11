import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yonetici_paneli/service/auth_service.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/login_button.dart';
import 'package:yonetici_paneli/widgets/login_textfield.dart';

enum UserRole { employee, manager }

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _username = TextEditingController();

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Hata"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Tamam"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appcolor,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 16),
                  child: Text("Hoşgeldiniz", style: AppStyle.mainTitle),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                  ),
                  child: Text("Kayıt Olunuz", style: AppStyle.mainTitle),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        loginTextField(_email, "Email", const Icon(Icons.email),
                            false, "Email"),
                        const SizedBox(height: 20),
                        loginTextField(_password, "Şifre",
                            const Icon(Icons.lock), true, "Şifre"),
                        const SizedBox(height: 20),
                        loginTextField(
                            _username,
                            "Kullanıcı Adı",
                            const Icon(Icons.supervised_user_circle_rounded),
                            false,
                            "Kullanıcı Adı"),
                        const SizedBox(height: 20),
                        loginButton(
                          "Kayıt Ol",
                          () {
                            String email = _email.text.trim();
                            String password = _password.text.trim();
                            String username = _username.text.trim();

                            if (email.isEmpty ||
                                password.isEmpty ||
                                username.isEmpty) {
                              showErrorDialog(
                                  context, "Lütfen tüm alanları doldurun.");
                            } else if (password.length < 6) {
                              showErrorDialog(
                                  context, "Şifre en az 6 karakter olmalıdır.");
                            } else if (!email.endsWith("@gmail.com")) {
                              showErrorDialog(context,
                                  "Email '@gmail.com' ile bitmelidir.");
                            } else {
                              context.read<FlutterFireAuthService>().signUp(
                                    email,
                                    password,
                                    username,
                                    context,
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
