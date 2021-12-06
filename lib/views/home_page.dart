import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/main.dart';
import 'package:quick_actions/quick_actions.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final quickActions = const QuickActions();

  @override
  void initState() {
    super.initState();

    quickActions.setShortcutItems([
      const ShortcutItem(
        type: "write",
        localizedTitle: "Nouvelle note",
      ),
      const ShortcutItem(
        type: "scanne",
        localizedTitle: "Scanner un document",
      ),
      const ShortcutItem(
        type: "search",
        localizedTitle: "Rechercher",
      ),
    ]);

    quickActions.initialize((type) {
      if (type == "write") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MyApp(),
          ),
        );
      }

      if (type == "scanne") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MyApp(),
          ),
        );
      }

      if (type == "search") {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const MyApp(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OmgNote"),
      ),
      body: Container(),
    );
  }
}
