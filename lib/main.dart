import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator_app/view_model/translator_view_model.dart';
import 'package:translator_app/views/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TranslatorViewModel(),
      child: MaterialApp(
        title: 'Translate App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
