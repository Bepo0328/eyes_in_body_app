import 'package:eyes_in_body_app/data/data.dart';
import 'package:eyes_in_body_app/data/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class WorkoutAddPage extends StatefulWidget {
  const WorkoutAddPage({Key? key, required this.workout}) : super(key: key);

  final Workout workout;

  @override
  _WorkoutAddPageState createState() => _WorkoutAddPageState();
}

class _WorkoutAddPageState extends State<WorkoutAddPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  Workout get workout => widget.workout;

  @override
  void initState() {
    nameController.text = workout.name.toString();
    timeController.text = workout.time.toString();
    memoController.text = workout.memo.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              workout.memo = memoController.text;
              workout.name = nameController.text;
              workout.time = int.tryParse(timeController.text) ?? 0;

              final dbHelper = DatabaseHelper.instance;
              await dbHelper.insertWorkout(workout);
              Navigator.pop(context);
            },
            child: const Text(
              '저장',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (ctx, idx) {
            if (idx == 0) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '어떤 운동을 하셨나요?',
                      style: TextStyle(fontSize: 20.0),
                    ),
                    TextField(
                      controller: nameController,
                    ),
                  ],
                ),
              );
            } else if (idx == 1) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '운동시간',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Container(
                      width: 100.0,
                      child: TextField(
                        controller: timeController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              );
            } else if (idx == 2) {
              return Container(
                width: 300.0,
                height: 300.0,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      selectImage();
                    },
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: workout.image!.isEmpty
                          ? Image.asset('assets/img/workout.png')
                          : AssetThumb(
                              asset: Asset(workout.image, 'workout.png', 0, 0),
                              width: 300,
                              height: 300,
                            ),
                    ),
                  ),
                ),
              );
            } else if (idx == 3) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '메모',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      maxLines: 10,
                      minLines: 10,
                      keyboardType: TextInputType.multiline,
                      controller: memoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
          itemCount: 4,
        ),
      ),
    );
  }

  Future<void> selectImage() async {
    final __img = await MultiImagePicker.pickImages(
      maxImages: 1,
      enableCamera: true,
    );

    if (__img.isEmpty) {
      return;
    }

    setState(() {
      workout.image = __img.first.identifier;
    });
  }
}
