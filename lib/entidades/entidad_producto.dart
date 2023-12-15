import 'package:market_list/entidades/entidad_oferta.dart';

class Producto {
  final int id;
  final String nombre;
  final String imagenUrl;
  final List<Oferta> ofertas;

  Producto({
    required this.id,
    required this.nombre,
    required this.imagenUrl,
    this.ofertas = const [],
  });
}
