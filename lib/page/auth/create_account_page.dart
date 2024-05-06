import 'package:flutter/material.dart';

import '../../controller/auth_controller.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  AuthController authController = AuthController();
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  // Lists for dropdown options
  List<String> days = List.generate(31, (index) => (index + 1).toString());
  List<String> months = List.generate(12, (index) => (index + 1).toString());
  List<String> years = List.generate(
      DateTime.now().year - 1959, (index) => (1960 + index).toString());

  String selectedDay = '1';
  String selectedMonth = '1';
  String selectedYear = '1960';

  String getFormattedDateOfBirth() {
    // Formata a data de nascimento no formato "yyyy-mm-dd"
    return '$selectedYear-$selectedMonth-${selectedDay.padLeft(2, '0')}';
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
                const SizedBox(height: 32.0),
                const FlutterLogo(
                  size: 120,
                ),

                // Full Name field
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira seu nome de usuário';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // E-mail field
                TextFormField(
                  controller: _emailController,
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
                  controller: _passwordController,
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

                // CPF field
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Insira o CPF';
                    }
                    // Add validation logic for CPF here if needed
                    return null;
                  },
                ),

                const SizedBox(height: 16.0),

                // Date of Birth field
                Row(
                  children: [
                    // Day Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedDay,
                        onChanged: (newValue) {
                          setState(() {
                            selectedDay = newValue!;
                          });
                        },
                        items: days.map((day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Dia',
                        ),
                      ),
                    ),

                    const SizedBox(width: 16.0),

                    // Month Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedMonth,
                        onChanged: (newValue) {
                          setState(() {
                            selectedMonth = newValue!;
                            _dataNascimentoController.text = selectedMonth;
                          });
                        },
                        items: months.map((month) {
                          return DropdownMenuItem<String>(
                            value: month,
                            child: Text(month),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Mês',
                        ),
                      ),
                    ),

                    const SizedBox(width: 16.0),

                    // Year Dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedYear,
                        onChanged: (newValue) {
                          setState(() {
                            selectedYear = newValue!;
                          });
                        },
                        items: years.map((year) {
                          return DropdownMenuItem<String>(
                            value: year,
                            child: Text(year),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          labelText: 'Ano',
                        ),
                      ),
                    ),
                  ],
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
                            await authController.createAccount(
                              _fullNameController.text,
                              _emailController.text,
                              _passwordController.text,
                              _cpfController.text,
                              getFormattedDateOfBirth()
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
