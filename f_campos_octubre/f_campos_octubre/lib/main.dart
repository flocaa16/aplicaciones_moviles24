import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Inicio'), actions: const [
          Icon(Icons.notifications_outlined),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.settings_outlined),
          )
        ]),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            //primera card
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Determina en qué lugar en ele eje alinean o comienzan los elementos 
                // start: extremo izq; end: extremo derecho; center: al centro; strecht: tratará de ocupar todo el ancho disponible
                children: [
                  Container(
                    height: 200,
                    color: const Color.fromARGB(255, 197, 197, 197),
                    width: double.infinity,
                  ),
                  const ListTile( // Para crear listas de items
                    title: Text('Título de la Card 1'),
                    subtitle: Text('Este es el subtitle'),

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
            //Espacio entre las cards
            const SizedBox(
              height: 16.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.only(left: 8.0, bottom: 16.0), // Margin permite determinar cuánto espacio externo tendrá un widget
                    // Utiliza EdgeInsets para definir el epacio por cada lado.
                    // margin: const EdgeInsets.formLTRB(Left, Top, Right, Bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 150,
                          color: const Color.fromARGB(255, 197, 197, 197),
                          width: double.infinity,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Titulo de la Card',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              //Acción cuando se presiona el botón
                            },
                            child: const Text('Ver más'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Segunda al lado
                Expanded(
                  child: Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 150,
                          color: const Color.fromARGB(255, 197, 197, 197),
                          width: double.infinity,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Titulo de la Card',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              //Acción cuando se presiona el botón
                            },
                            child: const Text('Ver más'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            Expanded(
                  child: Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.only(left: 8.0, bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 150,
                          color: const Color.fromARGB(255, 197, 197, 197),
                          width: double.infinity,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Titulo de la Card',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              //Acción cuando se presiona el botón
                            },
                            child: const Text('Ver más'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

