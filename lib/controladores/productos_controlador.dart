import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:market_list/database.dart';
import 'package:market_list/entidades/entidad_producto.dart';

final productosControllerProvider =
    StateNotifierProvider.autoDispose<ProductoController, ProductosState>(
        (ref) => ProductoController(DatabaseList.instance, ref));

class ProductosState {
  final List<Producto> productos;
  final bool isLoading;
  final String? errorMessage;
  const ProductosState({
    this.productos = const [],
    this.isLoading = false,
    this.errorMessage,
  });
  ProductosState get empty => const ProductosState();

  ProductosState copyWith({
    List<Producto>? productos,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductosState(
      productos: productos ?? this.productos,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProductoController extends StateNotifier<ProductosState> {
  final DatabaseList _database;
  final Ref ref;
  ProductoController(
    this._database,
    this.ref,
  ) : super(const ProductosState());
  Future<void> getAllOfertas() async {
    state = state.empty.copyWith(isLoading: true);
    final result = await _database.getAllOfertas();

    final productos = result;
    state = state.empty.copyWith(productos: productos, isLoading: false);
  }
}
