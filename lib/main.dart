import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Test',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: LoginForm(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //This class contains both the Page UI and the Form UI
  // variables where we'll save the details
  String login = "", passwd = "";
  late PolynomialFit pol1;

  final firestoreInstance = FirebaseFirestore.instance;

  // Form key
  final _formKey = GlobalKey<FormState>();

  //let's create the page and UI of the form in one
  // A better way would be to separate them
  // but this way we save up on a but of time

  void _onPressed() {
    setState(() {
      firestoreInstance.collection("users").add(
          {"login": login, "passwd": passwd, "derivative": pol1}).then((value) {
        print(value.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Form Test"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //This will contain the login form fields
              Text("Testing functionality"),
              SizedBox(
                height: 5,
              ),
              TextFormField(
                  decoration: InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: "Email/Username",
                      labelText: "Email/Username"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    login = value;
                    // return null;
                  }),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Password",
                    labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  passwd = value;
                  // return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: "Input a Polynomial",
                    labelText: "Polynomial Field"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a polynomial value';
                  }
                  pol1 = value as PolynomialFit;
                  // return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    //TODO: Calculate Polynomial and Save the three fields in Firestore
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    _onPressed();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
