import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import '../constants/controllers.dart';
import '../controllers/UserController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;

  static const String titulo = "Bem Vindo";

  bool loadingGoogle = false;
  bool loadingFacebook = false;

  loginGoogle() async {
    setState(() => loadingGoogle = true);
    try {
      await userController.loginGoogle();
    } on AuthException catch (e) {
      setState(() => loadingGoogle = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  loginFacebook() async {
    setState(() => loadingFacebook = true);
    try {
      await userController.loginFacebook();
    } on AuthException catch (e) {
      setState(() => loadingFacebook = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.mensagem)));
    }
  }

  notTryingToLogin() {
    return !loadingGoogle && !loadingFacebook;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              const Text(
                titulo,
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -1.5),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: Column(
                            children: [
                              Visibility(
                                visible: (isLogin) ? true : false,
                                child: Column(
                                  children: (loadingGoogle)
                                      ? [
                                          const Padding(
                                            padding: EdgeInsets.all(16),
                                            child: SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          )
                                        ]
                                      : [
                                          Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: FractionallySizedBox(
                                              widthFactor: 0.8,
                                              child: SignInButton(
                                                Buttons.Google,
                                                text: "Conectar com Google",
                                                onPressed: () {
                                                  if (notTryingToLogin()) {
                                                    loginGoogle();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
