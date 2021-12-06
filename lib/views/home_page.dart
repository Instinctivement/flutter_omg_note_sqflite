import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/main.dart';
import 'package:flutter_omg_note_sqflite/theme/style.dart';
import 'package:flutter_omg_note_sqflite/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import '../constants/constant.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final quickActions = const QuickActions();
  bool switchValue = false;
  ThemeProvider themeProvider = ThemeProvider();

  void getCurrentTheme() async {
    themeProvider.darkTheme = await themeProvider.preference.getTheme();
  }

  @override
  void initState() {
    getCurrentTheme();
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
    return ChangeNotifierProvider(
      create: (_) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: Style.themeData(themeProvider.darkTheme),
            home: Scaffold(
              appBar: AppBar(
                title: const Text('OmgApp'),
              ),
              body: Center(
                child: Switch(
                  inactiveTrackColor: primaryClr,
                  inactiveThumbColor: secondaryClr,
                  value: switchValue,
                  onChanged: (val) {
                    themeProvider.darkTheme = !themeProvider.darkTheme;
                    setState(() {
                      switchValue = val;
                    });
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
