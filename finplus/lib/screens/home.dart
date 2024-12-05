import 'package:finplus/screens/detalles_invertir.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finplus/components/appbar.dart'; // Asegúrate de tener esta importación correctamente configurada.
import 'package:finplus/components/formulario.dart';
import 'package:finplus/components/formulario_segundo.dart';

class Mantenedor extends StatefulWidget {
  const Mantenedor({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MantenedorState createState() => _MantenedorState();
}

class _MantenedorState extends State<Mantenedor> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MovimientosScreen(),
    const BilleteraScreen(),
    const AprenderScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sync_alt),
            label: 'Movimientos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.credit_card),
            label: 'Billetera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Aprende',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showEditForm(BuildContext context, DocumentSnapshot doc) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FormularioScreen(inversion: doc),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteUser(BuildContext context, String id) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar inversión'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar esta inversión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('inversion')
            .doc(id)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inversión eliminada exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la inversión')),
        );
      }
    }
  }

  Widget _buildPrivadosTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('inversion').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No hay registros disponibles.'));
        }

        final inversiones = snapshot.data!.docs;

        return ListView.builder(
          itemCount: inversiones.length,
          itemBuilder: (context, index) {
            final inversionData =
                inversiones[index].data() as Map<String, dynamic>;
            final inversionId = inversiones[index].id;

            return Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${inversionData['nombre']}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inversión inicial: ${inversionData['inversionInicial']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Inversión Mensual: ${inversionData['inversionMen']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${inversionData['tiempo']}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showEditForm(context, inversiones[index]),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteUser(context, inversionId),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('inversion').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No hay registros disponibles.'));
            }

            final inversion = snapshot.data!.docs;

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 12.0),
                  const Text(
                    "Hola de nuevo, Florencia",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      Container(
                        height: 60.0,
                        width: 2.0,
                        color: Colors.purple,
                      ),
                      const SizedBox(width: 12.0),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total invertido",
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            "104.602",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      height: 90.0,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Rentabilidad",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "35%",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12.0),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.orange,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Mis Acciones",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    "+ 0,2%",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Container(
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.transparent, // Sin fondo para el contenedor
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetalleProfesoresScreen(),
                                ),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.tertiary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: const Text(
                              'Nueva Inversión',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                            width: 8.0), // Espaciado entre los botones
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              // Este botón no tiene funcionalidad.
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                            child: const Text(
                              'Crear Portafolio',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Mis portafolios",
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TabBar(
                          labelColor: Theme.of(context).primaryColor,
                          unselectedLabelColor: Colors.black,
                          indicatorColor: Theme.of(context).primaryColor,
                          tabs: const [
                            Tab(text: 'Privados'),
                            Tab(text: 'Grupales'),
                          ],
                        ),
                        SizedBox(
                          height: 500.0,
                          child: TabBarView(
                            children: [
                              _buildPrivadosTab(),
                              const Center(
                                  child: Text("Contenido de Grupales")),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class MovimientosScreen extends StatelessWidget {
  const MovimientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Disponible Balance
                const Text(
                  'Balance Disponible',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      '\$935.000',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        // Acción para agregar dinero
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Transacciones
                const Text(
                  'Transacciones',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ListView(
                  shrinkWrap: true,
                  children: [
                    // Transacción 1
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.trending_down,
                            color: Colors.white),
                      ),
                      title: const Text(
                        'Lider',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        '05-DIC-2024',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: const Text(
                        '-\$25.000',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Transacción 2
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.trending_down,
                            color: Colors.white),
                      ),
                      title: const Text(
                        'Transferencia Josefina Friedli',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        '04-DIC-2024',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: const Text(
                        '-\$2.500',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Transacción 3
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child:
                            const Icon(Icons.trending_up, color: Colors.white),
                      ),
                      title: const Text(
                        'Pago programado',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        '04-DIC-2024',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: const Text(
                        '-\$250.000',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Transacción 4
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.trending_down,
                            color: Colors.white),
                      ),
                      title: const Text(
                        'Clínica sonrisa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        '03-DIC-2024',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: const Text(
                        '-\$420.000',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Transacción 5
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child:
                            const Icon(Icons.trending_up, color: Colors.white),
                      ),
                      title: const Text(
                        'Transferencia de otros bancos',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        '02-DIC-2024',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: const Text(
                        '-\$5.000',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Transacción 6
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.trending_down,
                            color: Colors.white),
                      ),
                      title: const Text(
                        'Niu Sushi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: const Text(
                        '01-DIC-2024',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: const Text(
                        '-\$16.270',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class BilleteraScreen extends StatelessWidget {
  const BilleteraScreen({super.key});

void _showEditForm(BuildContext context, DocumentSnapshot doc, String type) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: type == 'inversion'
              ? FormularioScreen(inversion: doc) // Correcto para inversiones
              : FormulariodosScreen(retirar: doc), // Correcto para retiros
        ),
      ),
    ),
  );
}


  Future<void> _deleteUser(
      BuildContext context, String id, String collection) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar registro'),
          content:
              const Text('¿Estás seguro de que deseas eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(id)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro eliminado exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar el registro')),
        );
      }
    }
  }

Widget _buildInversionesTab() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('inversion').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No hay registros disponibles.'));
      }

      final inversiones = snapshot.data!.docs;

      return ListView.builder(
        itemCount: inversiones.length,
        itemBuilder: (context, index) {
          final inversionData =
              inversiones[index].data() as Map<String, dynamic>;
          final inversionId = inversiones[index].id;

          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${inversionData['nombre']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inversión inicial: ${inversionData['inversionInicial']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inversión Mensual: ${inversionData['inversionMen']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${inversionData['tiempo']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditForm(
                          context,
                          inversiones[index],
                          'inversion', // Pasamos el tipo como 'inversion'
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _deleteUser(context, inversionId, 'inversion'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}


Widget _buildRetirosTab() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('retirar').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text('No hay registros disponibles.'));
      }

      final retiros = snapshot.data!.docs;

      return ListView.builder(
        itemCount: retiros.length,
        itemBuilder: (context, index) {
          final retiroData = retiros[index].data() as Map<String, dynamic>;
          final retiroId = retiros[index].id;

          return Card(
            margin: const EdgeInsets.all(8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${retiroData['item']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Monto retirado: ${retiroData['retiroInicial']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${retiroData['ubicacion']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${retiroData['rut']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${retiroData['cuenta']}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditForm(
                          context,
                          retiros[index],
                          'retiro', // Pasamos el tipo como 'retiro'
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _deleteUser(context, retiroId, 'retirar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'Inversiones'),
                Tab(text: 'Retiros'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildInversionesTab(),
                  _buildRetirosTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AprenderScreen extends StatelessWidget {
  const AprenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: DefaultTabController(
        length: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              isScrollable: true,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'Finanzas'),
                Tab(text: 'Datos'),
                Tab(text: 'Tecnología'),
                Tab(text: 'Ciencia'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  //Finanzas
                  ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: const [
                      BookmarkCard(
                        imagePath: 'lib/assets/images/imgfinanzas1.png',
                        title: 'Mercados financieros en alza',
                        date: '03.07.2024',
                      ),
                      BookmarkCard(
                        imagePath: 'lib/assets/images/jose.png',
                        title: 'Friedli: La nueva millonaria chilena',
                        date: '02.06.2024',
                      ),
                      BookmarkCard(
                        imagePath: 'lib/assets/images/imgfinanzas2.png',
                        title: 'Inversiones marca chancho, lo más top',
                        date: '14.05.2024',
                      ),
                    ],
                  ),
                  //Datos
                  ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: const [
                      BookmarkCard(
                        imagePath: 'lib/assets/images/imgfinanzas1.png',
                        title: 'Mercados financieros en alza',
                        date: '03.07.2024',
                      ),
                      BookmarkCard(
                        imagePath: 'lib/assets/images/jose.png',
                        title: 'Friedli: La nueva millonaria chilena',
                        date: '02.06.2024',
                      ),
                      BookmarkCard(
                        imagePath: 'lib/assets/images/imgfinanzas2.png',
                        title: 'Inversiones marca chancho, lo más top',
                        date: '14.05.2024',
                      ),
                    ],
                  ),
                  //Tecnología
                  ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: const [
                      BookmarkCard(
                        imagePath: 'lib/assets/images/imgfinanzas1.png',
                        title: 'Mercados financieros en alza',
                        date: '03.07.2024',
                      ),
                      BookmarkCard(
                        imagePath: 'lib/assets/images/jose.png',
                        title: 'Friedli: La nueva millonaria chilena',
                        date: '02.06.2024',
                      ),
                      BookmarkCard(
                        imagePath: 'lib/assets/images/imgfinanzas2.png',
                        title: 'Inversiones marca chancho, lo más top',
                        date: '14.05.2024',
                      ),
                    ],
                  ),
                  //Ciencia
                  ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: const [
                      BookmarkCard(
                        imagePath: 'lib/assets/images/imgfinanzas1.png',
                        title: 'Mercados financieros en alza',
                        date: '03.07.2024',
                      ),
                      BookmarkCard(
                        imagePath: 'lib/assets/images/jose.png',
                        title: 'Friedli: La nueva millonaria chilena',
                        date: '02.06.2024',
                      ),
                      BookmarkCard(
                        imagePath: 'lib/assets/images/imgfinanzas2.png',
                        title: 'Inversiones marca chancho, lo más top',
                        date: '14.05.2024',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BookmarkCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String date;

  const BookmarkCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.date,
  });

  @override
  State<BookmarkCard> createState() => _BookmarkCardState();
}

class _BookmarkCardState extends State<BookmarkCard> {
  bool isBookmarked = false; // Estado del ícono

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Bordes cuadrados
      ),
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            height: 25.0,
            color: Colors.transparent,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.date,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isBookmarked = !isBookmarked; // Cambiar estado
                            });
                          },
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_outline_outlined,
                            color: isBookmarked
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
