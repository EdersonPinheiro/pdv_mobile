import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final authController = AuthController();
  final _formKey = GlobalKey<FormState>();

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

                TextFormField(
                  controller: authController.fullnameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira seu nome de Usuario';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // E-mail field
                TextFormField(
                  controller: authController.emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira o e-mail';
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
                      return 'Insira a senha';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Voltar'),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            print(authController.emailController.text);
                            print(authController.passwordController.text);
                            await authController.createAccount(
                              authController.fullnameController.text,
                              authController.emailController.text,
                              authController.passwordController.text,
                            );
                          }
                        },
                        child: const Text('Criar Conta'),
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