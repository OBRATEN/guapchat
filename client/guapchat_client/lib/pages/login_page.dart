import 'package:flutter/material.dart';
import 'package:guapchat_client/pages/dialogues_page.dart';
import 'package:guapchat_client/pages/messenger_page.dart';
import 'package:guapchat_client/utils/http_client.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form key for managing form state
  final _formKey = GlobalKey<FormState>();
  HttpClient httpClient = HttpClient(baseUrl: "http://localhost:4444");

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variable to store error message
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Email Field
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Имя пользователя",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Пароль",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите пароль";
                  } else if (value.length < 6) {
                    return "Минимальная длина пароля - 6 символов";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Error Message
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),

              // Login Button
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(
                        'Имя пользователя: $_usernameController.text.trim()',
                      );
                      print('Пароль: $_passwordController.text.trim()');
                      final postData = {
                        "user": {
                          'username': _usernameController.text.trim(),
                          'password': _passwordController.text.trim(),
                        },
                      };
                      final headers = {'Content-Type': 'application/json'};
                      final postResponse = await httpClient.post(
                        'api/login/',
                        body: postData,
                        headers: headers,
                      );
                      print('POST response: $postResponse');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessengerPage(),
                        ),
                      );
                    }
                  } on Exception catch (e) {
                    print(e);
                  }
                },
                child: const Text("Вход"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegistrationPage()),
                  );
                },
                child: Text('Нет аккаунта? Регистрация'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
