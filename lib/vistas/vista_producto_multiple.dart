import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entidades/entidad_producto.dart';
import '../controladores/lista_controlador.dart';
import '../controladores/productos_controlador.dart';

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

class VistaMultiple extends ConsumerStatefulWidget {
  const VistaMultiple({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VistaMultipleState();
}

class _VistaMultipleState extends ConsumerState<VistaMultiple> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // ref.read(listaProductosControllerProvider.notifier).getList(1);
      ref.read(productosControllerProvider.notifier).getAllOfertas();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productosState = ref.watch(productosControllerProvider);
    final productosFiltrados =
        ref.watch(_filterRequestsProvider(productosState.productos));
    final listaState = ref.watch(listaProductosControllerProvider);
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
                          if (!listaState.listaDeProductos.contains(producto)) {
                            ref
                                .read(listaProductosControllerProvider.notifier)
                                .addToList(producto);
                          }
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
