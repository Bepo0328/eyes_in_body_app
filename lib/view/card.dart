import 'package:eyes_in_body_app/data/data.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({Key? key, required this.food}) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: AssetThumb(
                asset: Asset(food.image, 'food.png', 0, 0),
                width: 300,
                height: 300,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black38),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                ['아침', '점심', '저녁', '간식'][food.type!],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({Key? key, required this.workout}) : super(key: key);

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: AssetThumb(
                asset: Asset(workout.image, 'workout.png', 0, 0),
                width: 300,
                height: 300,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black38),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                workout.name!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EyeBodyCard extends StatelessWidget {
  const EyeBodyCard({Key? key, required this.eyeBody}) : super(key: key);

  final EyeBody eyeBody;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: AssetThumb(
                asset: Asset(eyeBody.image, 'eyeBody.png', 0, 0),
                width: 300,
                height: 300,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black38),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                '${eyeBody.weight}kg',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
