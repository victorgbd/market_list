import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_list/entidades/super_grupo.dart';
import 'package:market_list/helper.dart';
import 'package:market_list/controladores/lista_controlador.dart';

class ListaDeCompra extends ConsumerStatefulWidget {
  const ListaDeCompra({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ListaDeCompraState();
}

class _ListaDeCompraState extends ConsumerState<ListaDeCompra> {
  @override
  Widget build(BuildContext context) {
    final listaState = ref.watch(listaProductosControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recomendación de Supermercado",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          FutureBuilder(
              future: superGroup(listaState.listaDeProductos),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay supermercados'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final supermercadoAgrupado = snapshot.data![index];

                    if (supermercadoAgrupado.mayCantProductos) {
                      return SuperCard(
                        supermercadoAgrupado: supermercadoAgrupado,
                        color: Colors.green[100],
                      );
                    }
                    if (supermercadoAgrupado.totalmenor) {
                      return SuperCard(
                        supermercadoAgrupado: supermercadoAgrupado,
                        color: Colors.green[100],
                      );
                    }

                    return SuperCard(
                      supermercadoAgrupado: supermercadoAgrupado,
                      color: null,
                    );
                  },
                );
              }),
          const Center(
            child: Text(
              "Artículos sin existencia en los Supermercados",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              itemBuilder: (context, index) {
                // print(
                //     "${listaState.listaDeProductos[index].nombre} ${listaState.listaDeProductos[index].ofertas} ");
                if (listaState.listaDeProductos[index].ofertas.isEmpty) {
                  return Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(listaState.listaDeProductos[index].nombre),
                  ));
                } else {
                  return Container();
                }
              },
              itemCount: listaState.listaDeProductos.length),
        ],
      ),
    );
  }
}

class SuperCard extends StatelessWidget {
  const SuperCard({
    super.key,
    required this.supermercadoAgrupado,
    required this.color,
  });

  final SupermercadoAgrupado supermercadoAgrupado;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        children: [
          Text(
            supermercadoAgrupado.supermercado.nombre,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          ListView.separated(
            itemCount: supermercadoAgrupado.productos.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black,
              indent: 10.0,
              endIndent: 10.0,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(supermercadoAgrupado.productos[index].nombre),
                    Text(supermercadoAgrupado.ofertas[index].precio.toString())
                  ],
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "Total: ${supermercadoAgrupado.total}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
