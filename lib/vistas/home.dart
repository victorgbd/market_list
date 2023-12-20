import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_list/controladores/usuario_controlador.dart';
import 'package:market_list/vistas/login.dart';

import 'lista_de_compra.dart';
import 'vista_oferta_inividual.dart';
import 'vista_producto_multiple.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarioState = ref.watch(usuarioControllerProvider);
    return Scaffold(
      appBar: AppBar(),
      endDrawer: Drawer(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        usuarioState.usuario!.nombre,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      Text(usuarioState.usuario!.email,
                          style: const TextStyle(color: Colors.grey))
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const VistaLogin(),
              ));
            },
            title: const Text(
              "Cerrar sesión",
              style: TextStyle(color: Colors.red),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ListaDeCompra(),
          ));
        },
        child: const Icon(Icons.assignment),
      ),
      body: SafeArea(
        child: GridView(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VistaIndivudiales(),
                  ));
                },
                child: const Card(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sell_outlined, size: 100),
                        Text("Ver Ofertas Individuales")
                      ]),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const VistaMultiple(),
                  ));
                },
                child: const Card(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 100),
                        Text("Agregar artículos")
                      ]),
                ),
              ),
            ]),
      ),
    );
  }
}
