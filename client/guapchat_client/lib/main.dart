import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'core/http_client.dart';
import 'core/ws_client.dart';
import 'utils/storage.dart';
import 'utils/error_handler.dart';
import 'features/auth/auth_client.dart';
import 'features/auth/auth_repository.dart';
import 'features/chat/chat_client.dart';
import 'features/chat/chat_repository.dart';
import 'pages/login_page.dart';
import 'pages/registration_page.dart';
import 'scr/adapters/http_client_adapter.dart';
import 'dart:io' as io;


void main() {

  final ioClient = io.HttpClient(); 

  // Оборачиваем его в адаптер
  final httpClient = HttpClientAdapter(ioClient); 

  // Передаем адаптированный клиент в AuthClient/ChatClient
  final authClient = AuthClient(
    baseUrl: 'https://api.example.com', 
    httpClient: httpClient, // Теперь тип совместим
  );



  // Инициализация глобальных зависимостей
  final authRepository = AuthRepository(authClient: authClient);
  final chatClient = ChatClient(baseUrl: 'https://api.example.com', httpClient: httpClient);
  final chatRepository = ChatRepository(chatClient: chatClient);
  final errorHandler = ErrorHandler();

  runApp(
    // Оборачиваем приложение в MultiProvider для доступа к зависимостям
    MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => authRepository),
        Provider<ChatRepository>(create: (_) => chatRepository),
        Provider<ErrorHandler>(create: (_) => errorHandler),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuapChat',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
      routes: {
        '/registration': (context) => const RegistrationPage(),
      },
    );
  }
}