import 'package:chat_app/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController namecontroller = TextEditingController();
  final formkey = GlobalKey<FormState>();
  var uuid = const Uuid();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Please enter your name'),
              content: Form(
                key: formkey,
                child: TextFormField(
                  controller: namecontroller,
                  validator: (value) {
                    if (value == null) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                MaterialButton(
                  color: Colors.red,
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
                MaterialButton(
                  color: Colors.teal,
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      String name = namecontroller.text;
                      namecontroller.clear();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            name: name,
                            uid: uuid.v1(),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Enter',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          ),
          child: const Text('Enter Chat room'),
        ),
      ),
    );
  }
}
