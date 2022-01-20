import 'package:eyes_in_body_app/data/data.dart';
import 'package:eyes_in_body_app/data/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class FoodAddPage extends StatefulWidget {
  const FoodAddPage({Key? key, required this.food}) : super(key: key);

  final Food food;

  @override
  _FoodAddPageState createState() => _FoodAddPageState();
}

class _FoodAddPageState extends State<FoodAddPage> {
  TextEditingController kcalController = TextEditingController();
  TextEditingController memoController = TextEditingController();

  Food get food => widget.food;

  @override
  void initState() {
    kcalController.text = food.kcal.toString();
    memoController.text = food.memo.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A3A3C),
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              food.memo = memoController.text;
              food.kcal = int.tryParse(kcalController.text) ?? 0;

              final dbHelper = DatabaseHelper.instance;
              await dbHelper.insertFood(food);
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
                    horizontal: 16.0, vertical: 20.0),
                child: const Text(
                  '오늘 어떤 음식을 드셨나요?',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
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
                      '칼로리',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      width: 100.0,
                      child: TextField(
                        controller: kcalController,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
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
                      child: food.image!.isEmpty
                          ? Image.asset('assets/img/rice.png')
                          : AssetThumb(
                              asset: Asset(food.image, 'food.png', 0, 0),
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
                child: CupertinoSegmentedControl(
                  children: const {
                    0: Text('아침'),
                    1: Text('점심'),
                    2: Text('저녁'),
                    3: Text('간식'),
                  },
                  onValueChanged: (idx) {
                    setState(() {
                      food.type = idx as int?;
                    });
                  },
                  groupValue: food.type,
                ),
              );
            } else if (idx == 4) {
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
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    TextField(
                      maxLines: 10,
                      minLines: 10,
                      keyboardType: TextInputType.multiline,
                      controller: memoController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
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
          itemCount: 5,
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
      food.image = __img.first.identifier;
    });
  }
}
