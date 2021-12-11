import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_omg_note_sqflite/controllers/task_controller.dart';
import 'package:flutter_omg_note_sqflite/main.dart';
import 'package:flutter_omg_note_sqflite/models/task.dart';
import 'package:flutter_omg_note_sqflite/theme/theme.dart';
import 'package:flutter_omg_note_sqflite/views/add_task_page.dart';
import 'package:flutter_omg_note_sqflite/views/widgets/components/button.dart';
import 'package:flutter_omg_note_sqflite/views/widgets/components/task_tile.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quick_actions/quick_actions.dart';
import '../constants/constant.dart';
import '../notification/notificationservice.dart';
import 'secondpage.dart';
import 'package:get/get.dart';
import '../theme/theme_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final quickActions = const QuickActions();
  bool switchValue = Get.isDarkMode;
  DateTime timeBackPressed = DateTime.now();
  final _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

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
      themeMode: ThemeService().theme,
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
              children: [
                _addTaskBar(),
                const SizedBox(height: 20),
                _addDateBar(),
                const SizedBox(height: 20),
                _showTasks(),
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

  Row _addTaskBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: subHeadingStyle,
            ),
            Text(
              "Aujourd'hui",
              style: headingStyle,
            ),
          ],
        ),
        MyButton(
            label: "+ Tache",
            onTap: () async {
              await Get.to(const AddTaskPage());
              _taskController.getTasks();
            }),
      ],
    );
  }

  SizedBox _addDateBar() {
    return SizedBox(
      child: DatePicker(
        DateTime.now(),
        height: 85,
        width: 65,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: grey,
          ),
        ),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              print(_taskController.taskList.length);
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                  child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showBottomSheet(
                                context, _taskController.taskList[index]);
                          },
                          child: TaskTile(_taskController.taskList[index]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isComplete == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.36,
        color: Get.isDarkMode ? darkGreyClr : white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            task.isComplete == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Task Complete",
                    onTap: () {
                      _taskController.markTaskComplete(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                    context: context,
                  ),
            const SizedBox(
              height: 1,
            ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.delete(task);

                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            const SizedBox(
              height: 10,
            ),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: primaryClr,
              isClose: true,
              context: context,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 45,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: white,
                  ),
          ),
        ),
      ),
    );
  }
}
