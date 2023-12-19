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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Producto && other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombre.hashCode ^
        imagenUrl.hashCode ^
        ofertas.hashCode;
  }
}
