import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meu_estoque/page/splash/splash_screen_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/sync/sync_controller.dart';
import 'create_account_page.dart';
import 'reset_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool isLoading = false;
  final SyncController syncController = Get.put(SyncController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                const SizedBox(height: 32.0),
                const FlutterLogo(
                  size: 120,
                ),

                const SizedBox(height: 32.0),

                // E-mail field
                TextFormField(
                  controller: authController.emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Digite seu e-mail';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // Password field
                TextFormField(
                  controller: authController.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Digite sua senha';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // Error message
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),

                const SizedBox(height: 16.0),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: TextButton(
                      onPressed: () {
                        Get.to(ResetPassword());
                      },
                      child: const Text(
                        'Esqueci minha senha',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(CreateAccountPage());
                        },
                        child: const Text('Cadastrar'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              errorMessage = ''; // Limpar a mensagem de erro
                              isLoading =
                                  true; // Iniciar o indicador de carregamento
                            });

                            if (syncController.isConn == true) {
                              bool success = await authController.login(
                                authController.emailController.text,
                                authController.passwordController.text,
                              );

                              setState(() {
                                isLoading =
                                    false; // Parar o indicador de carregamento
                              });

                              if (!success) {
                                setState(() {
                                  errorMessage = 'E-mail ou senha incorretos';
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                Get.off(SplashScreenPage());
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Sem Conexão'),
                                  content: Text(
                                      'Você precisa se conectar à internet para entrar no app.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                        child: isLoading
                            ? Container(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ))
                            : const Text('Entrar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
