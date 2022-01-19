import 'package:eyes_in_body_app/data/data.dart';
import 'package:eyes_in_body_app/data/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class EyeBodyAddPage extends StatefulWidget {
  const EyeBodyAddPage({Key? key, required this.eyeBody}) : super(key: key);

  final EyeBody eyeBody;

  @override
  _EyeBodyAddPageState createState() => _EyeBodyAddPageState();
}

class _EyeBodyAddPageState extends State<EyeBodyAddPage> {
  TextEditingController weightController = TextEditingController();

  EyeBody get eyeBody => widget.eyeBody;

  @override
  void initState() {
    weightController.text = eyeBody.weight.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () async {
              eyeBody.weight = int.tryParse(weightController.text) ?? 0;

              final dbHelper = DatabaseHelper.instance;
              await dbHelper.insertEyeBody(eyeBody);
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
                  '오늘의 눈바디를 기록해주세요',
                  style: TextStyle(fontSize: 20.0),
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
                      '몸무게',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Container(
                      width: 100.0,
                      child: TextField(
                        controller: weightController,
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
                      child: eyeBody.image!.isEmpty
                          ? Image.asset('assets/img/eyeBody.png')
                          : AssetThumb(
                              asset: Asset(eyeBody.image, 'eyeBody.png', 0, 0),
                              width: 300,
                              height: 300,
                            ),
                    ),
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
          itemCount: 3,
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
      eyeBody.image = __img.first.identifier;
    });
  }
}
