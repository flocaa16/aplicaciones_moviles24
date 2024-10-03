import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 230, 230, 230),
          foregroundColor: const Color.fromARGB(255, 14, 19, 23),
          elevation: 0,
        )),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.arrow_back),
          title: const Text('Kundenbewertungen'),
        ),
        body: ListView(
          children: [
            Container(
              height: 170.0,
              width: double.infinity,
              color: const Color.fromARGB(255, 162, 6, 6),
              //child: const Text(''),
            ),
            const SizedBox(
              height: 22.0,
            ),
            const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Nach Standard sortieren',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(
              height: 22.0,
            ),
            Container(
              height: 200.0,
              width: double.infinity,
              color: const Color.fromARGB(255, 162, 6, 6),
            ),
            const SizedBox(
              height: 12.0,
            ),
            ListTile(
              title: const Text(
                'Das Feedback wurde teilweise automatisch übersetzt.',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
              ),
              trailing: ElevatedButton(
                onPressed: () {},
                child: const Text(
                  'Original zeigen',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Container(
              height: 100.0,
              width: double.infinity,
              color: const Color.fromARGB(255, 162, 6, 6),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Container(
              height: 100.0,
              width: double.infinity,
              color: const Color.fromARGB(255, 162, 6, 6),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              height: 100.0,
              color: Colors.transparent,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12.0),
                      color: const Color.fromARGB(255, 184, 11, 97),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12.0),
                      color: const Color.fromARGB(255, 184, 11, 97),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12.0),
                      color: const Color.fromARGB(255, 184, 11, 97),
                    ),
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 12.0),
                      color: const Color.fromARGB(255, 184, 11, 97),
                    ),
                  ],
                ),
              ),
            ),
               const SizedBox(
              height: 12.0,
            ),
          ],
          //Children
        ),
      ),
    );
  }
}
