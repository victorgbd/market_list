import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_list/vistas/controlador.dart';
import '../vistas/vista_producto.dart';

import '../entidades/entidad_producto.dart';

final _searchRequestsProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final _filterRequestsProvider = Provider.family
    .autoDispose<List<Producto>, List<Producto>>((ref, productos) {
  final search = ref.watch(_searchRequestsProvider);
  return productos
      .where(
          (element) => element.nombre.toString().toLowerCase().contains(search))
      .toList();
});

class VistaIndivudiales extends ConsumerStatefulWidget {
  const VistaIndivudiales({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VistaIndivudialesState();
}

class _VistaIndivudialesState extends ConsumerState<VistaIndivudiales> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(productosControllerProvider.notifier).getAllOfertas();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productosState = ref.watch(productosControllerProvider);
    final productosFiltrados =
        ref.watch(_filterRequestsProvider(productosState.productos));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfffaf443),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 65.0),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                    ),
                    child: TextField(
                      cursorColor: Colors.yellow[700],
                      onChanged: (value) {
                        ref.read(_searchRequestsProvider.notifier).state =
                            value;
                      },
                      decoration: const InputDecoration(
                        hintText: "Buscar producto",
                        prefixIcon: Icon(Icons.search),
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
        body: productosState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : productosFiltrados.isEmpty
                ? const Center(
                    child: Text("Lista vacía"),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    itemBuilder: (context, index) {
                      final producto = productosFiltrados[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                VistaProducto(producto: producto),
                          ));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(producto.nombre,
                                style: const TextStyle(fontSize: 20.0)),
                          ),
                        ),
                      );
                    },
                    itemCount: productosFiltrados.length));
  }
}
