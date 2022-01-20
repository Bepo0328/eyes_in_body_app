import 'package:eyes_in_body_app/data/data.dart';
import 'package:eyes_in_body_app/data/database.dart';
import 'package:eyes_in_body_app/utils.dart';
import 'package:eyes_in_body_app/view/body.dart';
import 'package:eyes_in_body_app/view/card.dart';
import 'package:eyes_in_body_app/view/food.dart';
import 'package:eyes_in_body_app/view/workout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

void main() async {
  runApp(const MyApp());
  tz.initializeTimeZones();

  const AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel('bepo', 'eyebody',
          description: 'eyebody notification');
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin!
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(androidNotificationChannel);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eyes InBody App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;

  List<Food> todayFood = [];
  List<Workout> todayWorkout = [];
  List<EyeBody> todayEyeBody = [];

  final dbHelper = DatabaseHelper.instance;
  DateTime time = DateTime.now();

  void getHistories() async {
    int day = Utils.getFormTime(time);

    todayFood = await dbHelper.queryFoodByDate(day);
    todayWorkout = await dbHelper.queryWorkoutByDate(day);
    todayEyeBody = await dbHelper.queryEyeBodyByDate(day);
    setState(() {});
  }

  void getAllHistories() async {
    todayFood = await dbHelper.queryAllFood();
    todayWorkout = await dbHelper.queryAllWorkout();
    todayEyeBody = await dbHelper.queryAllEyeBody();
    setState(() {});
  }

  Future<bool> initNotification() async {
    flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();

    var initSettingAndroid = const AndroidInitializationSettings('app_icon');
    var initiOS = const IOSInitializationSettings();

    var initSetting = InitializationSettings(
      android: initSettingAndroid,
      iOS: initiOS,
    );

    await flutterLocalNotificationsPlugin!
        .initialize(initSetting, onSelectNotification: (payload) async {});
    setScheduling();

    return true;
  }

  @override
  void initState() {
    getHistories();
    initNotification();
    super.initState();
  }

  void setScheduling() async {
    var android = const AndroidNotificationDetails('bepo', 'eyebody',
        channelDescription: 'eyebody notification',
        importance: Importance.max,
        priority: Priority.max);
    var iOS = const IOSNotificationDetails();

    NotificationDetails detail = NotificationDetails(
      android: android,
      iOS: iOS,
    );

    flutterLocalNotificationsPlugin!.zonedSchedule(
      0,
      '오늘 다이어트를 기록해주세요!',
      '앱에서 기록을 알려주세요!',
      tz.TZDateTime.from(
          DateTime.now().add(const Duration(seconds: 10)), tz.local),
      detail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      payload: 'eyebody',
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: getPage(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (idx) {
          setState(() {
            currentIndex = idx;
            if (currentIndex == 0 || currentIndex == 1) {
              time = DateTime.now();
              getHistories();
            } else if (currentIndex == 2 || currentIndex == 3) {
              getAllHistories();
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '오늘',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '기록',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '통계',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_album_outlined),
            label: '갤러리',
          ),
        ],
        currentIndex: currentIndex,
      ),
      floatingActionButton: [2, 3].contains(currentIndex)
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    builder: (ctx) {
                      return SizedBox(
                        height: 200.0,
                        child: Column(
                          children: [
                            TextButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => FoodAddPage(
                                      food: Food(
                                        date: Utils.getFormTime(time),
                                        type: 0,
                                        kcal: 0,
                                        image: '',
                                        memo: '',
                                      ),
                                    ),
                                  ),
                                );
                                getHistories();
                              },
                              child: const Text('식단'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => WorkoutAddPage(
                                      workout: Workout(
                                        date: Utils.getFormTime(time),
                                        time: 0,
                                        image: '',
                                        name: '',
                                        memo: '',
                                      ),
                                    ),
                                  ),
                                );
                                getHistories();
                              },
                              child: const Text('운동'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => EyeBodyAddPage(
                                      eyeBody: EyeBody(
                                        date: Utils.getFormTime(time),
                                        weight: 0,
                                        image: '',
                                      ),
                                    ),
                                  ),
                                );
                                getHistories();
                              },
                              child: const Text('눈바디'),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget getPage() {
    if (currentIndex == 0) {
      return getMainPage();
    } else if (currentIndex == 1) {
      return getHistoryPage();
    } else if (currentIndex == 2) {
      return getChartPage();
    } else if (currentIndex == 3) {
      return getGalleryPage();
    } else {
      return Container();
    }
  }

  Widget getMainPage() {
    return Container(
      child: Column(
        children: [
          todayFood.isEmpty
              ? Container()
              : Container(
                  height: 140.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(todayFood.length, (idx) {
                      return InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => FoodAddPage(
                                food: todayFood[idx],
                              ),
                            ),
                          );
                          getHistories();
                        },
                        child: Container(
                          width: 140.0,
                          child: FoodCard(food: todayFood[idx]),
                        ),
                      );
                    }),
                  ),
                ),
          todayWorkout.isEmpty
              ? Container()
              : Container(
                  height: 140.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(todayWorkout.length, (idx) {
                      return InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => WorkoutAddPage(
                                workout: todayWorkout[idx],
                              ),
                            ),
                          );
                          getHistories();
                        },
                        child: Container(
                          width: 140.0,
                          child: WorkoutCard(workout: todayWorkout[idx]),
                        ),
                      );
                    }),
                  ),
                ),
          todayEyeBody.isEmpty
              ? Container()
              : Container(
                  height: 140.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(todayEyeBody.length, (idx) {
                      return InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => EyeBodyAddPage(
                                eyeBody: todayEyeBody[idx],
                              ),
                            ),
                          );
                          getHistories();
                        },
                        child: Container(
                          width: 140.0,
                          child: EyeBodyCard(eyeBody: todayEyeBody[idx]),
                        ),
                      );
                    }),
                  ),
                ),
        ],
      ),
    );
  }

  Widget getHistoryPage() {
    return Container(
      child: ListView(
        children: [
          TableCalendar(
            focusedDay: time,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            onDaySelected: (selectedDay, focusedDay) {
              time = selectedDay;
              getHistories();
            },
            selectedDayPredicate: (day) {
              return isSameDay(time, day);
            },
          ),
          getMainPage(),
        ],
      ),
    );
  }

  Widget getChartPage() {
    return Container(
      child: Column(
        children: [
          getMainPage(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('총 기록 식단 수 : \n${todayFood.length}'),
              Text('총 기록 운동 수 : \n${todayWorkout.length}'),
              Text('총 기록 눈바디 수 : \n${todayEyeBody.length}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget getGalleryPage() {
    return Container(
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1,
        children: List.generate(todayEyeBody.length, (idx) {
          return EyeBodyCard(eyeBody: todayEyeBody[idx]);
        }),
      ),
    );
  }
}
