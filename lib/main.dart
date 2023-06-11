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
  final String id;
  final String name;
  Contact({required this.name}): id= Uuid().v4();
}

class ContactBook extends ValueNotifier<List<Contact>>{
  //Creating a singleton, i.e. private constructor in dart- standard method
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook()=> _shared;

  int get length=> value.length;

  void add({required contact}){
    // final ValueNotifier notifier;
    // value.add(contact);
    // notifyListeners();

    final contacts = value;
    contacts.add(contact);
    // value = contacts;
    notifyListeners();
  }

  void remove({required contact}){
    final contacts = value;
    if(contacts.contains(contact)){
      contacts.remove(contact);
      // value = contacts; equality doesn't agree with setter here
      notifyListeners();
    }
  }

  Contact? contact({required int atIndex}) => value.length> atIndex ? value[atIndex]: null;
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
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) {
          final contacts = value as List<Contact>;
          return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index){
                final contact = contacts[index];
                return Dismissible(
                  onDismissed: (direction){
                    // contacts.remove(contact);
                    ContactBook().remove(contact: contact);
                  },
                  key: ValueKey(contact.id),
                  child: Material(
                    color: Colors.white,
                    elevation: 6,
                    child: ListTile(
                      title: Text(contact!.name),
                    ),
                  ),
                );
              },);
        },
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
  //When your higher up widget changes in the case of it not being a constant
  void didUpdateWidget(covariant NewContactView oldWidget){
    super.didUpdateWidget(oldWidget);
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

