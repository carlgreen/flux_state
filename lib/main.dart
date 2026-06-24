import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('flux_state'),
          ),
        ),
        body: const Center(child: FluxStateApp()),
      ),
    );
  }
}

class FluxStateApp extends StatelessWidget {
  const FluxStateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('Hello World!');
  }
}
