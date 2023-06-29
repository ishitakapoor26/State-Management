import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value;
  set value(double newValue) {
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

final sliderData = SliderData();

// Says I'm gonna rebuilt my child whenever this Listenable to whom I am listening, i.e. SliderData, calls notifyListeners().
class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  SliderInheritedNotifier(
      {Key? key, required SliderData sliderData, required Widget child})
      : super(
          key: key,
          notifier: sliderData,
          child: child,
        );

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: SliderInheritedNotifier(
        sliderData: sliderData,
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Slider(value: SliderInheritedNotifier.of(context), onChanged: (value) {
                  sliderData.value = value;
                }),
                Row(
                  children: [
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 200,
                        color: Colors.yellow,
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 200,
                        color: Colors.blue,
                      ),
                    )
                  ].expandEqually().toList(),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}

extension ExpandedEqually on Iterable<Widget> {
  Iterable<Widget> expandEqually() => map((w) => Expanded(child: w));
}
