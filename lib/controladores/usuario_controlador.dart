import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:market_list/controladores/lista_controlador.dart';

import 'package:market_list/entidades/entidad_usuario.dart';

import '../database.dart';
import '../main.dart';
import '../vistas/home.dart';

final usuarioControllerProvider =
    StateNotifierProvider<ListaProductoController, UsuarioState>(
        (ref) => ListaProductoController(DatabaseList.instance, ref));

class UsuarioState {
  final Usuario? usuario;
  final bool isLoading;
  final String? errorMessage;
  const UsuarioState({
    this.usuario,
    this.isLoading = false,
    this.errorMessage,
  });
  UsuarioState get empty => const UsuarioState();

  UsuarioState copyWith(
      {bool? isLoading, String? errorMessage, Usuario? usuario}) {
    return UsuarioState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      usuario: usuario ?? this.usuario,
    );
  }
}

class ListaProductoController extends StateNotifier<UsuarioState> {
  final DatabaseList _database;
  final Ref ref;
  ListaProductoController(
    this._database,
    this.ref,
  ) : super(const UsuarioState());
  Future<void> getUsuario(
      String email, String contrasena, BuildContext context) async {
    state = state.empty.copyWith(isLoading: true);
    final resultUser = await _database.getUser(email, contrasena);
    if (resultUser == null) {
      state = state.empty.copyWith(errorMessage: null, isLoading: false);
      return;
    }

    state = state.empty.copyWith(usuario: resultUser, isLoading: false);
    ref.read(listaProductosControllerProvider.notifier).getList(resultUser.id);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(),
        ),
        (Route<dynamic> route) => false);
  }

  Future<void> registrarUsuario(String email, String contrasena, String nombre,
      BuildContext context) async {
    state = state.empty.copyWith(isLoading: true);
    final resultUser = await _database.getUserByEmail(email);
    if (resultUser == null) {
      await _database.registrarUsuario(email, contrasena, nombre);
      final resultRegis = await _database.getUserByEmail(email);
      if (resultRegis == null) {
        scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
            content: Text('Ha ocurrido un error al registrar este usuario')));
        state = state.empty.copyWith(isLoading: false);
        return;
      }
      state = state.empty.copyWith(usuario: resultRegis, isLoading: false);
      ref
          .read(listaProductosControllerProvider.notifier)
          .getList(resultRegis.id);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ),
          (Route<dynamic> route) => false);
    } else {
      scaffoldMessengerKey.currentState!.showSnackBar(
          const SnackBar(content: Text('Existe un usuario con este email')));
      state = state.empty.copyWith(isLoading: false);
    }
  }
}
