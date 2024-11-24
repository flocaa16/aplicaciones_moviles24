import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FormularioScreen extends StatefulWidget {
  final DocumentSnapshot? inversion;

  const FormularioScreen({super.key, this.inversion});

  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _inversionMensualController = TextEditingController();
  final _inversionMensualController2 = TextEditingController();

  int? _inversionInicial;
  int? _inversionMen;
  String? _tiempoSeleccionado;

  final List<int> opcionesInversionInicial = [10000, 20000, 30000, 40000];
  final List<int> opcionesInversionMen = [10000, 20000, 30000, 40000];
  final List<String> opcionesTiempo = [
    'Menos de un año',
    '1-2 años',
    '3-5 años',
    'Más de 5 años'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.inversion != null) {
      final inversionData = widget.inversion!.data() as Map<String, dynamic>;
      _nombreController.text = inversionData['nombre'] ?? '';
      _inversionMensualController.text =
          (inversionData['inversionMensual'] ?? '').toString();
      _inversionMensualController2.text =
          (inversionData['inversionMensual'] ?? '').toString();
      _inversionInicial = inversionData['inversionInicial'];
      _inversionMen = inversionData['inversionMen'];
      _tiempoSeleccionado = inversionData['tiempo'];
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _inversionMensualController.dispose();
    _inversionMensualController2.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final inversionData = {
        'nombre': _nombreController.text,
        'inversionInicial': _inversionInicial,
        'inversionMen': _inversionMen,
        'inversionMensual': int.tryParse(_inversionMensualController.text) ?? 0,
        'inversionMensual2':
            int.tryParse(_inversionMensualController2.text) ?? 0,
        'tiempo': _tiempoSeleccionado,
      };

      try {
        if (widget.inversion == null) {
          await FirebaseFirestore.instance
              .collection('inversion')
              .add(inversionData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inversión creada correctamente')),
          );
        } else {
          await FirebaseFirestore.instance
              .collection('inversion')
              .doc(widget.inversion!.id)
              .update(inversionData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inversión actualizada correctamente')),
          );
        }
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar la inversión')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.inversion == null
            ? 'Crear inversión rápida'
            : 'Editar inversión'),
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
              const Text(
                'Nombre de la inversión',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: "Nombre de la inversión",
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Inversión Inicial',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _inversionMensualController,
                decoration: InputDecoration(
                  labelText: "ej. 80.000",
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
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
                  children: opcionesInversionInicial.map((amount) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text('\$$amount'),
                        selected: _inversionInicial == amount,
                        onSelected: (selected) {
                          setState(() {
                            _inversionInicial = selected ? amount : null;
                            _inversionMensualController.text =
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
                        backgroundColor: _inversionInicial == amount
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
              const Text(
                'Inversión Mensual',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _inversionMensualController2,
                decoration: InputDecoration(
                  labelText: "ej. 20.000",
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
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
                  children: opcionesInversionMen.map((amount) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text('\$$amount'),
                        selected: _inversionMen == amount,
                        onSelected: (selected) {
                          setState(() {
                            _inversionMen = selected ? amount : null;
                            _inversionMensualController2.text =
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
                        backgroundColor: _inversionMen == amount
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
              const Text(
                'Tiempo de Inversión',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _tiempoSeleccionado,
                decoration: InputDecoration(
                  labelText: 'Tiempo de inversión',
                  fillColor: Colors.white,
                  filled: true,
                  border: const OutlineInputBorder(),
                ),
                items: opcionesTiempo.map((tiempo) {
                  return DropdownMenuItem<String>(
                    value: tiempo,
                    child: Text(tiempo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _tiempoSeleccionado = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor seleccione el tiempo de inversión';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveUser,
                child: Text(widget.inversion == null
                    ? 'Agregar inversión'
                    : 'Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
