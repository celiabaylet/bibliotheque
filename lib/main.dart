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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),//changer couleurs
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mon premier projet Flutter'),
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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++; //si à la place de ++ on met = _counter + 100 voir resultat
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary, //changer couleur du haut a la place de inversePrimary
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Vous avez appuyé sur le bouton :',
            ),
            Text(
              '$_counter', //affiche la variable _counter
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text(
              'fois.',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(   //bouton en bas a droite
        onPressed: _incrementCounter,               //qd bouton pressé j'incremente le compteur
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
