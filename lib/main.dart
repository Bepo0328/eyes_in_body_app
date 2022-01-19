import 'package:eyes_in_body_app/data/data.dart';
import 'package:eyes_in_body_app/data/database.dart';
import 'package:eyes_in_body_app/utils.dart';
import 'package:eyes_in_body_app/view/body.dart';
import 'package:eyes_in_body_app/view/card.dart';
import 'package:eyes_in_body_app/view/food.dart';
import 'package:eyes_in_body_app/view/workout.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
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

  @override
  void initState() {
    getHistories();
    super.initState();
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
      floatingActionButton: FloatingActionButton(
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
          todayFood.isEmpty ? Container() : Container(
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
          todayWorkout.isEmpty ? Container() : Container(
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
          todayEyeBody.isEmpty ? Container() : Container(
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
    return Container();
  }

  Widget getGalleryPage() {
    return Container();
  }
}
