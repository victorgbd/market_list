import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:market_list/controladores/usuario_controlador.dart';

class VistaRegistro extends ConsumerStatefulWidget {
  const VistaRegistro({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VistaRegistroState();
}

class _VistaRegistroState extends ConsumerState<VistaRegistro> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    void signUp(BuildContext context) async {
      FocusManager.instance.primaryFocus?.unfocus();
      final result = _formKey.currentState?.saveAndValidate() ?? false;

      if (!result) return;
      final nombre = _formKey.currentState?.value['nombre'] as String;
      final email = _formKey.currentState?.value['email'] as String;
      final contrasena = _formKey.currentState?.value['password'] as String;

      await ref
          .read(usuarioControllerProvider.notifier)
          .registrarUsuario(email, contrasena, nombre, context);
    }

    return Scaffold(
      appBar: AppBar(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    "Nombre",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[200]
                            : const Color(0xff1c272b),
                        border:
                            Border.all(color: Colors.grey.shade400, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: FormBuilderTextField(
                        decoration: const InputDecoration(
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        name: 'nombre',
                        keyboardType: TextInputType.name,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    "Email",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[200]
                            : const Color(0xff1c272b),
                        border:
                            Border.all(color: Colors.grey.shade400, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: FormBuilderTextField(
                        decoration: const InputDecoration(
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        name: 'email',
                        keyboardType: TextInputType.emailAddress,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.email(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(left: 22.0),
                  child: Text(
                    "Contraseña",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[200]
                            : const Color(0xff1c272b),
                        border:
                            Border.all(color: Colors.grey.shade400, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: FormBuilderTextField(
                        decoration: InputDecoration(
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(hidePassword
                                ? Icons.visibility_off
                                : Icons.remove_red_eye),
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                          ),
                        ),
                        name: 'password',
                        keyboardType: TextInputType.text,
                        obscureText: hidePassword,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.minLength(4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(2),
                        minimumSize: MaterialStateProperty.all(
                            const Size(double.infinity, 50)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ))),
                    onPressed: () {
                      signUp(context);
                    },
                    child: const Text(
                      "Registrarse",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}