// Tapping on screen takes you to fake api class and extract current date and time with a delay.
// Then update both the title of the homepage and text of independent widget in this homepage and given they are not passing data to each other.

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

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
      home: ApiProvider(api: Api(), child: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueKey _textKey = const ValueKey<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ApiProvider.of(context).api.dateAndTime ?? ''),
      ),
      body: GestureDetector(
        onTap: () async {
          final api = ApiProvider.of(context).api;
          final dateAndTime = await api.getDateAndTime();
          // Now anything dependent on the value key will be rebuilt, so will the date and time widget as it is dependent on it.
          setState(() {
            _textKey = ValueKey(dateAndTime);
          });
        },
        child: SizedBox.expand(
          child: Container(
            color: Colors.white,
            child: DateTimeWidget(key: _textKey),
          ),
        ),
      ),
    );
  }
}

class DateTimeWidget extends StatelessWidget {
  // Here this key is the unique id to this widget to check whether am I the same widget or do I need to be redrawn?
  // Taking a value key here, compare it with the value of dateandtime, if changes it should update this particular widget accordingly.
  const DateTimeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = ApiProvider.of(context).api;
    return Text(api.dateAndTime ?? 'Tap on screen to fetch date and time');
  }
}

// Grabs current date and time but with a little delay
class Api {
  String? dateAndTime;
  Future<String> getDateAndTime() {
    return Future.delayed(
      Duration(seconds: 1),
      () => DateTime.now().toIso8601String(),
    ).then((value) {
      dateAndTime = value;
      return value;
    });
  }
}

// Provider Class
class ApiProvider extends InheritedWidget {
  final Api api;
  // Assigning inherited widget with a unique id.
  final String uuid;
  ApiProvider({Key? key, required this.api, required Widget child})
      : uuid = Uuid().v4(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    // old instance of api provider class gets compared with the new one.
    return uuid != oldWidget.uuid;
  }

  static ApiProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}
