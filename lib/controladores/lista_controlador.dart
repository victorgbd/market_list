import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_list/controladores/usuario_controlador.dart';

import '../database.dart';
import '../entidades/entidad_producto.dart';

final listaProductosControllerProvider =
    StateNotifierProvider<ListaProductoController, ListaProductosState>(
        (ref) => ListaProductoController(DatabaseList.instance, ref));

class ListaProductosState {
  final List<Producto> listaDeProductos;
  final bool isLoading;
  final String? errorMessage;
  const ListaProductosState({
    this.listaDeProductos = const [],
    this.isLoading = false,
    this.errorMessage,
  });
  ListaProductosState get empty => const ListaProductosState();

  ListaProductosState copyWith(
      {List<Producto>? listaDeProductos,
      bool? isLoading,
      String? errorMessage}) {
    return ListaProductosState(
      listaDeProductos: listaDeProductos ?? this.listaDeProductos,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ListaProductoController extends StateNotifier<ListaProductosState> {
  final DatabaseList _database;
  final Ref ref;
  ListaProductoController(
    this._database,
    this.ref,
  ) : super(const ListaProductosState());
  // Future<void> getUsuario(
  //     String email, String contrasena, BuildContext context) async {
  //   state = state.empty.copyWith(isLoading: true);
  //   final resultUser = await _database.getUser(email, contrasena);
  //   if (resultUser == null) {
  //     state = state.empty.copyWith(errorMessage: null, isLoading: false);
  //     return;
  //   }
  //   final result = await _database.getList(resultUser.id);

  //   final productos = result;

  //   state = state.empty.copyWith(
  //        listaDeProductos: productos, isLoading: false);
  //   // ignore: use_build_context_synchronously
  //   Navigator.of(context).pushReplacement(MaterialPageRoute(
  //     builder: (context) => const MyHomePage(),
  //   ));
  // }

  Future<void> getList(int idUsuario) async {
    state = state.empty.copyWith(isLoading: true);
    final result = await _database.getList(idUsuario);

    final productos = result;
    state = state.empty.copyWith(listaDeProductos: productos, isLoading: false);
  }

  Future<void> addToList(Producto producto) async {
    final usuario = ref.watch(usuarioControllerProvider);
    state = state.empty.copyWith(isLoading: true);
    await _database.insertToList(producto.id, usuario.usuario!.id);
    final result = await _database.getList(usuario.usuario!.id);

    final productos = result;
    state = state.empty.copyWith(listaDeProductos: productos, isLoading: false);
  }
}
