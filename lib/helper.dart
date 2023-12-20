import 'package:market_list/database.dart';
import 'package:market_list/entidades/super_grupo.dart';

import 'entidades/entidad_oferta.dart';
import 'entidades/entidad_producto.dart';

bool todosTienenLaMismaCantidad(List<SupermercadoAgrupado> listaSupermercados) {
  // Verificar si la lista está vacía o tiene un solo elemento
  if (listaSupermercados.isEmpty || listaSupermercados.length == 1) {
    return true;
  }

  // Obtener la cantidad de productos del primer SupermercadoAgrupado
  int cantidadProductosPrimero = listaSupermercados[0].productos.length;

  // Verificar si todos los demás SupermercadoAgrupado tienen la misma cantidad de productos
  for (int i = 1; i < listaSupermercados.length; i++) {
    if (listaSupermercados[i].productos.length != cantidadProductosPrimero) {
      return false; // No tienen la misma cantidad
    }
  }

  return true; // Todos tienen la misma cantidad
}

Future<List<SupermercadoAgrupado>> superGroup(
    List<Producto> listaSeleccionado) async {
  final supermercados = await DatabaseList.instance.getAllSuper();

  List<SupermercadoAgrupado> supermercadosagrupado = [];
  for (var supermercado in supermercados) {
    List<Producto> productos = [];
    List<Oferta> ofertas = [];
    double total = 0;
    for (var listprod in listaSeleccionado) {
      for (var oferta in listprod.ofertas) {
        if (oferta.supermercado.id == supermercado.id) {
          productos.add(listprod);
          ofertas.add(oferta);
          total = total + oferta.precio;
        }
      }
    }

    supermercadosagrupado.add(SupermercadoAgrupado(
        supermercado: supermercado,
        productos: productos,
        ofertas: ofertas,
        total: total));
  }

  if (!todosTienenLaMismaCantidad(supermercadosagrupado)) {
    final superconmayorcantp = supermercadosagrupado.reduce(
        (supermercadosagrupado1, supermercadosagrupado2) =>
            supermercadosagrupado1.productos.length >
                    supermercadosagrupado2.productos.length
                ? supermercadosagrupado1
                : supermercadosagrupado2);
    for (var element in supermercadosagrupado) {
      if (element.productos.isNotEmpty) {
        if (superconmayorcantp.supermercado.id == element.supermercado.id) {
          element.mayCantProductos = true;
        }
      }
    }
  } else {
    final superconmenortotal = supermercadosagrupado.reduce(
        (supermercadosagrupado1, supermercadosagrupado2) =>
            supermercadosagrupado1.total < supermercadosagrupado2.total
                ? supermercadosagrupado1
                : supermercadosagrupado2);
    for (var element in supermercadosagrupado) {
      if (element.productos.isNotEmpty) {
        if (superconmenortotal.supermercado.id == element.supermercado.id) {
          element.totalmenor = true;
        }
      }
    }
  }

  return supermercadosagrupado;
}
