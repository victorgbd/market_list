import 'package:market_list/entidades/entidad_super.dart';

import 'entidad_oferta.dart';
import 'entidad_producto.dart';

class SupermercadoAgrupado {
  final Supermercado supermercado;
  final List<Producto> productos;
  final List<Oferta> ofertas;
  final double total;
  bool totalmenor;
  bool mayCantProductos;

  SupermercadoAgrupado(
      {required this.supermercado,
      required this.productos,
      required this.ofertas,
      required this.total,
      this.totalmenor = false,
      this.mayCantProductos = false});
}
