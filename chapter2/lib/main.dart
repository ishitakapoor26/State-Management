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
      home: ApiProvider(
          api: Api(),
          child: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String title ="Tap the Screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: GestureDetector(
        onTap: (){
          setState(() {
            title= DateTime.now().toIso8601String();
          });
        },
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}

class Api{
  String? dateAndTime;
  Future<String> getDateAndTime(){
    return Future.delayed(
      Duration(seconds: 1),
        ()=> DateTime.now().toIso8601String(),
    ).then((value) {
      dateAndTime =value;
      return value;
    });
  }
}

class ApiProvider extends InheritedWidget{
  final Api api;
  final String uuid;
  ApiProvider({Key? key, required this.api, required Widget child}): uuid = Uuid().v4(), super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant ApiProvider oldWidget) {
    return uuid !=oldWidget.uuid;
  }
  static ApiProvider of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<ApiProvider>()!;
  }
}