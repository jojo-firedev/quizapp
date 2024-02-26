import 'package:flutter/material.dart';

class EinstellungPage extends StatefulWidget {
  const EinstellungPage({super.key});

  @override
  State<EinstellungPage> createState() => _EinstellungPageState();
}

class _EinstellungPageState extends State<EinstellungPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: const Center(
        child: Text("Einstellungen"),
      ),
    );
  }
}
