import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormulariodosScreen extends StatefulWidget {
  final DocumentSnapshot? retirar;

  const FormulariodosScreen({super.key, this.retirar});

  @override
  // ignore: library_private_types_in_public_api
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormulariodosScreen> {
  final _formKey = GlobalKey<FormState>();

  int? _retiroInicial;
  String? _ubiciacionSeleccionado;

  final List<int> opcionesretiroInicial = [100000, 200000, 500000, 1000000];
  final List<String> opcionesUbicacion = [
    'Otro Portafolio',
    'Mi cuenta Bancaria'
  ];

   final _itemController = TextEditingController();
  final _rutController = TextEditingController();
  // ignore: non_constant_identifier_names
  final _CuentaController = TextEditingController();
  // ignore: non_constant_identifier_names
  final _RetiroInicialController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.retirar != null) {
      final retirarData = widget.retirar!.data() as Map<String, dynamic>;
      _itemController.text = retirarData['item'];
      _retiroInicial = retirarData['retiroInicial'];
      _RetiroInicialController.text = (retirarData['retiro'] ?? '').toString();
      _ubiciacionSeleccionado = retirarData['ubicacion'];
      _rutController.text = retirarData['rut'] ?? '';
      _CuentaController.text = (retirarData['cuenta'] ?? '').toString();
    }
  }

  @override
  void dispose() {
    _rutController.dispose();
    _CuentaController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final retirarData = {
        'item': _itemController.text,
        'retiroInicial': _retiroInicial,
        'retiro': int.tryParse(_RetiroInicialController.text) ?? 0,
        'ubicacion': _ubiciacionSeleccionado,
        'rut': _rutController.text,
        'cuenta': _CuentaController.text,
      };

      try {
        if (widget.retirar == null) {
          await FirebaseFirestore.instance
              .collection('retirar')
              .add(retirarData);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Retiro creado correctamente')),
          );
        } else {
          await FirebaseFirestore.instance
              .collection('retirar')
              .doc(widget.retirar!.id)
              .update(retirarData);
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Retiro actualizado correctamente')),
          );
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar el retiro')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.retirar == null
            ? 'Retirar dinero'
            : 'Editar retiro'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              //nombre retiro
              const Text(
                'Nombre',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _itemController,
                decoration: const InputDecoration(
                  labelText: "Nombre del Retiro",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),const SizedBox(height: 12),
              const Divider(thickness: 1.0),
              const SizedBox(height: 10),
              //Monto a retirar
              const Text(
                'Monto a retirar',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _RetiroInicialController,
                decoration: const InputDecoration(
                  labelText: "ej. 20.000",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un monto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: opcionesretiroInicial.map((amount) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text('\$$amount'),
                        selected: _retiroInicial == amount,
                        onSelected: (selected) {
                          setState(() {
                            _retiroInicial = selected ? amount : null;
                            _RetiroInicialController.text =
                                selected ? '$amount' : '';
                          });
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        labelStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.8),
                        ),
                        backgroundColor: _retiroInicial == amount
                            ? Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.3)
                            : Colors.white,
                        selectedColor: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.3),
                        side: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.8),
                          width: 1.5,
                        ),
                        showCheckmark: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Divider(thickness: 1.0),
              const SizedBox(height: 12),
//¿A dónde te gustaría transferir tu dinero?
              const Text(
                '¿A dónde te gustaría transferir tu dinero?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: opcionesUbicacion.map((ubicacion) {
                  final isSelected = _ubiciacionSeleccionado == ubicacion;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _ubiciacionSeleccionado = ubicacion;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey.shade300,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.white,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              ubicacion,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const Divider(thickness: 1.0),
              const SizedBox(height: 12),

              //Rut
              const Text(
                'Rut',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _rutController,
                decoration: const InputDecoration(
                  labelText: "Ej: XXXXXXXX-X",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su rut';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              //Cuenta
              const Text(
                'Cuenta',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _CuentaController,
                decoration: const InputDecoration(
                  labelText: "Banco Itaú - 0021345678",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su cuenta';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 32),
              ElevatedButton(
  onPressed: _saveUser,
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.8), // Fondo con Primary 800
    padding: const EdgeInsets.symmetric(vertical: 12.0), // Ajustar el relleno
  ),
  child: Text(
    widget.retirar == null ? 'Confirmar retiro' : 'Actualizar',
    style: const TextStyle(
      fontSize: 14, // Tamaño de la fuente
      color: Colors.white, // Color del texto
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }
}
