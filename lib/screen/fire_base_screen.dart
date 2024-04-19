import 'package:flutter/material.dart';

class FirebaseScreen extends StatelessWidget {
  const FirebaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('firebase'),
          ),
          FilledButton(
            onPressed: () {},
            child: const Text('Add'),
          )
        ],
      ),
    );
  }
}
