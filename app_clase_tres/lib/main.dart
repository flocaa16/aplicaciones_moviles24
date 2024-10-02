import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu), // Ícono de menú
          title: const Text('Diagramación'), // Título de la AppBar
          actions: const [
            Icon(Icons.more_vert), // Ícono de more_vert
          ],
        ),
        body: ListView(
          children: [
            const SizedBox(
              height: 12.0,
            ),

            //primera card
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    color: const Color.fromARGB(255, 197, 197, 197),
                    width: double.infinity,
                  ),
                  const ListTile(
                    title: Text('Título de la Card 1'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción cuando se presiona el botón
                      },
                      child: const Text('ver más'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 12.0), // Espacio de 12 píxeles entre los containers

            //segunda card
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200,
                    color: const Color.fromARGB(255, 197, 197, 197),
                    width: double.infinity,
                  ),
                  const ListTile(
                    title: Text('Título de la Card 2'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // Acción cuando se presiona el botón
                      },
                      child: const Text('ver más'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
                height: 12.0), // Espacio de 12 píxeles entre los containers

            //Scroll horizontal
            Container(
              height: 280.0, // Altura de 148 píxeles
              margin:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    8,
                    (index) => Card(
                      elevation: 4.0,
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            height: 180,
                            color: const Color.fromARGB(255, 197, 197, 197),
                            width: 180,
                          ),
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'Título de la Card ${index + 1}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 12.0), // Espacio de 12 píxeles entre los containers
          ],
        ),
      ),
    );
  }
}
