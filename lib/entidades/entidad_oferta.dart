import 'package:market_list/entidades/entidad_super.dart';

class Oferta {
  final int id;
  final double precio;
  final int cantidad;
  final Supermercado supermercado;

  Oferta(
      {required this.id,
      required this.precio,
      required this.cantidad,
      required this.supermercado});
}
