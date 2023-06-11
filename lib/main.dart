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
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Homepage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/new-contact': (context) => NewContactView(),
      },
    );
  }
}

class Contact{
  final String name;
  const Contact({required this.name});
}

class ContactBook{
  //Creating a singleton, i.e. private constructor in dart- standard method
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook()=> _shared;

  final List<Contact> _contacts =[];

  int get length=> _contacts.length;

  void add({required contact}){
    final ValueNotifier notifier;
    _contacts.add(contact);
  }

  void remove({required contact}){
    _contacts.remove(contact);
  }

  Contact? contact({required int atIndex}) => _contacts.length> atIndex ? _contacts[atIndex]: null;
}

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    //below code is a singleton and will not be initialized over and over again.
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: ListView.builder(
          itemCount: contactBook.length,
          itemBuilder: (context, index){
            final contact = contactBook.contact(atIndex: index);
            return ListTile(
              title: Text(contact!.name),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
            await Navigator.of(context).pushNamed('/new-contact');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({Key? key}) : super(key: key);

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {

  late final TextEditingController _controller;

  @override
  void initState(){
    _controller = TextEditingController();
    super.initState();
  }

  @override

  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new contact"),
      ),
      body: Column(
        children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter new contact name here....',
              ),
            ),
          TextButton(onPressed: (){
            final contact = Contact(name: _controller.text);
            ContactBook().add(contact: contact);
            Navigator.of(context).pop();
          }, child: Text("Add contact"))
        ],
      ),
    );
  }
}

