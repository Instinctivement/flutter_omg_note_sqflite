import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/main.dart';
import 'package:flutter_omg_note_sqflite/theme/theme.dart';
import 'package:flutter_omg_note_sqflite/views/widgets/components/button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quick_actions/quick_actions.dart';
import '../constants/constant.dart';
import '../notification/notificationservice.dart';
import 'secondpage.dart';
import 'package:get/get.dart';
import '../theme/theme_service.dart';
import 'widgets/header_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final quickActions = const QuickActions();
  bool switchValue = false;
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();

    NotificationService.initNotification(initScheduled: true);
    listeNotification();

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

  void listeNotification() =>
      NotificationService.onNotifications.stream.listen(onClickNotification);

  void onClickNotification(String? payload) =>
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SecondPage(payload: payload),
      ));

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OmgNote',
      theme: Themes.lightMode,
      darkTheme: Themes.darktMode,
      home: WillPopScope(
        onWillPop: () async {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExistwarning = difference >= const Duration(seconds: 2);

          timeBackPressed = DateTime.now();

          if (isExistwarning) {
            const message = "Appuyer de nouveau pour sortir";
            Fluttertoast.showToast(
              msg: message,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: primaryClr,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            return false;
          } else {
            Fluttertoast.cancel();
            return true;
          }
        },
        child: Scaffold(
          appBar: _appBar(),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: const [
                HeaderPage(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      leading: Switch(
        value: switchValue,
        onChanged: (val) {
          ThemeService().switchTheme();
          NotificationService().showSimpleNotification(
            id: 2,
            title: 'Changement de thème',
            body: Get.isDarkMode
                ? "Le mode clair a été activé"
                : "Le mode sombre a été activé",
            payload: "OMGBA.Abs",
          );
          setState(() {
            switchValue = val;
          });
        },
      ),
      title: const Text('OmgApp'),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/user2.png"),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
