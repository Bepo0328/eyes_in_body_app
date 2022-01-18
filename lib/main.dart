import 'package:eyes_in_body_app/data/body.dart';
import 'package:eyes_in_body_app/data/data.dart';
import 'package:eyes_in_body_app/utils.dart';
import 'package:eyes_in_body_app/view/food.dart';
import 'package:eyes_in_body_app/view/workout.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => FoodAddPage(
                                food: Food(
                                  date: Utils.getFormTime(DateTime.now()),
                                  type: 0,
                                  kcal: 0,
                                  image: '',
                                  memo: '',
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text('식단'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => WorkoutAddPage(
                                workout: Workout(
                                  date: Utils.getFormTime(DateTime.now()),
                                  time: 0,
                                  image: '',
                                  name: '',
                                  memo: '',
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text('운동'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => EyeBodyAddPage(
                                eyeBody: EyeBody(
                                  date: Utils.getFormTime(DateTime.now()),
                                  weight: 0,
                                  image: '',
                                ),
                              ),
                            ),
                          );
                        },
                        child: const Text('인바디'),
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
}
