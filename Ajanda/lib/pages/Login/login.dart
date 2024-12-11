import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:yonetici_paneli/pages/Login/forgat_pw_page.dart';
import 'package:yonetici_paneli/pages/Login/register.dart';
import 'package:yonetici_paneli/service/auth_service.dart';
import 'package:yonetici_paneli/style/database_color.dart';
import 'package:yonetici_paneli/style/style.dart';
import 'package:yonetici_paneli/widgets/login_button.dart';
import 'package:yonetici_paneli/widgets/login_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:appcolor,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
            child: Column(
              children: [
                Expanded(
                  flex: 12,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Text("Hoşgeldiniz", style: AppStyle.mainTitle),
                  ),
                ),
                Expanded(
                  flex: 12,
                  child: Text(
                    "Giriş Yapınız",
                    style: AppStyle.mainTitle,
                  ),
                ),
                Expanded(
                  flex: 76,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        loginTextField(_email, "Email", const Icon(Icons.email),
                            false, "Email"),
                        const SizedBox(
                          height: 20,
                        ),
                        loginTextField(_password, "Şifre",
                            const Icon(Icons.lock), true, "Şifre"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.size,
                                          alignment: Alignment.center,
                                          child: const ForgatPasswordPage()));
                                },
                                child: Text("Şifremi Unuttum",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Colors.blue)),
                              ),
                            ),
                          ],
                        ),
                        loginButton(
                          "Giriş Yap",
                          () async {
                            context.read<FlutterFireAuthService>().signIn(
                                _email.text.trim(),
                                _password.text.trim(),
                                context);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.size,
                                      alignment: Alignment.center,
                                      child: const Register()));
                            },
                            child: Text(
                              "Kayıt Ol",
                              style: AppStyle.mainContent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
