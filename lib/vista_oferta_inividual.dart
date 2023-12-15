import 'package:flutter/material.dart';
import 'package:market_list/database.dart';
import 'package:market_list/vista_producto.dart';

import 'entidades/entidad_producto.dart';

class VistaIndivudiales extends StatefulWidget {
  const VistaIndivudiales({Key? key}) : super(key: key);

  @override
  State<VistaIndivudiales> createState() => _VistaIndivudialesState();
}

class _VistaIndivudialesState extends State<VistaIndivudiales> {
  @override
  Widget build(BuildContext context) {
    void buscar(String nombre, List<Producto> productos) {
      // b = productos
      //     .where((element) =>
      //         element.nombre.toLowerCase().contains(nombre.toLowerCase()))
      //     .toList();
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xfffaf443),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 40.0),
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
                        // setState(() {
                        //   buscar(value, b);
                        // });
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
        body: FutureBuilder(
            future: DatabaseList.instance.getAllOfertas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay productos'));
              }

              return ListView.builder(
                  // physics: BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  itemBuilder: (context, index) {
                    final producto = snapshot.data![index];
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
                  itemCount: snapshot.data!.length);
            }));
  }
}
