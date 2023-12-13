import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> a = ['ramon', 'pedro', 'juan', 'victor'];
  late List<String> b;

  @override
  void initState() {
    b = a;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void buscar(String nombre) {
      b = a.where((element) => element.contains(nombre)).toList();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffaf443),
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 40.0),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5.0,
                  ),
                  child: TextField(
                    cursorColor: Colors.yellow[700],
                    onChanged: (value) {
                      setState(() {
                        buscar(value);
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: "Buscar producto",
                      prefixIcon: Icon(Icons.search),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
      body: ListView.builder(
          // physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(b[index], style: TextStyle(fontSize: 20.0)),
              ),
            );
          },
          itemCount: b.length),
    );
  }
}
