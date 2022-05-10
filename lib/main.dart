import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences logindata;
  late bool newuser;

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  void autoLogin() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata.getBool('login') ?? true);
    if (newuser == false) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Welcome(title: "Welcome"),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Login',
              ),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(label: Text("username")),
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(label: Text("password")),
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  String name = nameController.text;
                  String password = passwordController.text;
                  if (name != '' && password != '') {
                    print('Successfull');
                    logindata.setBool('login', false);
                    logindata.setString('username', name);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Welcome(
                                  title: 'Welcome',
                                )));
                  }
                },
                child: Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Welcome extends StatefulWidget {
  Welcome({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late SharedPreferences logindata;
  String username = '';

  @override
  void initState() {
    super.initState();
    initial();
  }

  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                username,
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  logindata.setBool('login', true);
                  Navigator.pushReplacement(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => MyHomePage(
                                title: 'login',
                              )));
                },
                child: Text("Logout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
