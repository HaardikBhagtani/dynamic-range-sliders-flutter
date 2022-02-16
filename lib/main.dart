import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dynamic Range Slider Demo',
      home: DynamicRangeSliderDemo(),
    );
  }
}

class DynamicRangeSliderDemo extends StatefulWidget {
  const DynamicRangeSliderDemo({Key? key}) : super(key: key);

  @override
  _DynamicRangeSliderDemoState createState() => _DynamicRangeSliderDemoState();
}

class _DynamicRangeSliderDemoState extends State<DynamicRangeSliderDemo> {
  double min = 100, max = 1000;
  int divisions = 18;
  int difference = 100;
  RangeValues rangeValues = const RangeValues(100, 1000);
  TextStyle kTextStyle = const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dynamic Range Slider Demo')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dynamic Range Slider',
                  style: kTextStyle,
                ),
                Text(
                  '${rangeValues.start.round().toString()} - ${rangeValues.end.round().toString()}',
                  style: kTextStyle,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            DynamicRangeSlider(
              currentRangeValues: rangeValues,
              min: min,
              max: max,
              onChanged: (RangeValues values) {
                setState(() {
                  rangeValues = values;
                });
              },
              onChangeEnd: (RangeValues values) {
                // When end value reaches max, then increase max value by 50%
                if (values.end == max) {
                  setState(() {
                    max = max + 1000;
                    divisions = (max - min) ~/ difference;
                    //difference = difference + 50;
                  });
                }
                // When end value is more than 100 and is less than 50% of the max,
                // then decrease max value by 50%
                else if (max > 1000 && values.end < max - 1000) {
                  setState(() {
                    max = max - 1000;
                    //difference = difference - 50;
                    divisions = (max - min) ~/ difference;
                  });
                }
              },
              divisions: divisions,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('min: $min', style: kTextStyle),
                Text('max: $max', style: kTextStyle),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DynamicRangeSlider extends StatelessWidget {
  final RangeValues currentRangeValues;
  final double min, max;
  final onChanged;
  final onChangeEnd;
  final int divisions;

  const DynamicRangeSlider({
    Key? key,
    required this.currentRangeValues,
    required this.min,
    required this.max,
    required this.onChanged,
    this.onChangeEnd,
    required this.divisions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: currentRangeValues,
      min: min,
      max: max,
      divisions: divisions,
      labels: RangeLabels(
        currentRangeValues.start.round().toString(),
        currentRangeValues.end.round().toString(),
      ),
      onChanged: onChanged, // callback when the range values change
      onChangeEnd: onChangeEnd ?? null, // callback when the user is done selecting new values
    );
  }
}
