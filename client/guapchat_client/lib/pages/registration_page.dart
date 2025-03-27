import 'package:flutter/material.dart';
import 'package:guapchat_client/utils/http_client.dart';
import 'login_page.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _fio = '';
  String _password = '';
  HttpClient httpClient = HttpClient(baseUrl: "http://localhost:4444");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Регистрация')),
      body: Center(
        child: Container(
          width: 400, // Ограничиваем ширину для ПК
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Имя пользователя',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите имя пользователя';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value!;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Пароль',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // Скрываем пароль
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Фамилия и имя',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите Фамилию и имя';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _fio = value!;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Обрабатываем отправку данных
                      print('Имя пользователя: $_username');
                      print('Пароль: $_password');
                      print('ФИ: $_fio');
                      final postData = {
                        "user": {
                          'username': _username,
                          'password': _password,
                          'firstname': _fio.split(' ')[1],
                          'lastname': _fio.split(' ')[0],
                        },
                      };
                      final headers = {'Content-Type': 'application/json'};
                      final postResponse = await httpClient.post(
                        'api/register/',
                        body: postData,
                        headers: headers,
                      );
                      print('POST response: $postResponse');
                    }
                  },
                  child: Text('Зарегистрироваться'),
                ),
                SizedBox(
                  height: 10,
                ), // Добавляем немного места между кнопкой и текстом
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: Text('Уже зарегестрированы? Вход'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
