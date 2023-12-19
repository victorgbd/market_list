import 'package:flutter/material.dart';
import 'package:market_list/entidades/super_grupo.dart';
import 'package:market_list/helper.dart';

class ListaDeCompra extends StatefulWidget {
  const ListaDeCompra({Key? key}) : super(key: key);

  @override
  State<ListaDeCompra> createState() => _ListaDeCompraState();
}

class _ListaDeCompraState extends State<ListaDeCompra> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recomendación de Supermercado",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
          future: superGroup(),
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
