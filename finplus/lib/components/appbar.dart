import 'package:flutter/material.dart';

// Definir la función buildAppBar
AppBar buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    leading: const Padding(padding: EdgeInsets.only(left: 8.0),
    child: CircleAvatar(
      backgroundImage: AssetImage('lib/assets/images/minilogo.png'),
      backgroundColor: Colors.transparent, // Fondo transparente
    ),
    ),
    title: const Text(
      'FinPlus',
      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.w800,

      ),
    ),
     actions: const[
Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: CircleAvatar(
      backgroundImage: AssetImage('lib/assets/images/foto perfil.png'),
      backgroundColor: Colors.transparent, // Fondo transparente
    ),
    ),
     ] 
  );
}
