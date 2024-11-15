import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../entidades/entidad_producto.dart';

class VistaProducto extends StatefulWidget {
  final Producto producto;
  const VistaProducto({
    Key? key,
    required this.producto,
  }) : super(key: key);

  @override
  State<VistaProducto> createState() => _VistaProductoState();
}

class _VistaProductoState extends State<VistaProducto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.producto.nombre)),
      body: SingleChildScrollView(
        child: Column(children: [
          CachedNetworkImage(
            height: 300,
            width: 300,
            imageUrl: widget.producto.imagenUrl,
            imageBuilder: (context, imageProvider) =>
                Card(elevation: 2, child: Image(image: imageProvider)),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
              ),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const Text("Oferta"),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.producto.ofertas[index].precio.toString()),
                        Text(
                            widget.producto.ofertas[index].supermercado.nombre),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: widget.producto.ofertas.length,
          )
        ]),
      ),
    );
  }
}
