import 'package:market_list/entidades/entidad_oferta.dart';
import 'package:market_list/entidades/entidad_producto.dart';
import 'package:market_list/entidades/entidad_super.dart';
import 'package:market_list/entidades/entidad_usuario.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseList {
  static final DatabaseList instance = DatabaseList._init();
  static Database? _database;

  DatabaseList._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _inidb('mylist.db');
    return _database!;
  }

  Future<Database> _inidb(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE producto(
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    image_url TEXT
    )
    ''');
    await db.execute('''
    CREATE TABLE usuario(
    id INTEGER PRIMARY KEY,
    email TEXT,
    contrasena TEXT,
    nombre TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE supermercado(
    id INTEGER PRIMARY KEY,
    nombre TEXT,
    direccion TEXT
    )
    ''');
    await db.execute('''
    CREATE TABLE ofertas (
    id INTEGER PRIMARY KEY,
    id_producto INTEGER,
    id_supermercado INTEGER,
    precio REAL,
    cantidad INTEGER,
    FOREIGN KEY (id_producto) REFERENCES productos(id) ON DELETE CASCADE
    FOREIGN KEY (id_supermercado) REFERENCES supermercado(id) ON DELETE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE lista(
    id INTEGER PRIMARY KEY,
    id_producto INTEGER,
	  id_usuario INTEGER,

    FOREIGN KEY (id_producto) REFERENCES producto(id) ON DELETE CASCADE,
	  FOREIGN KEY (id_usuario) REFERENCES usuario(id) ON DELETE CASCADE
    )
    ''');
  }

  Future<void> insertToList(int idProducto, int idUsuario) async {
    final db = await instance.database;
    await db.insert(
        'lista', {'id_producto': idProducto, 'id_usuario': idUsuario},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Producto>> getAllOfertas() async {
    final db = await instance.database;

    final resultProductos = await db.rawQuery('''
      SELECT * from producto;
''');
    List<Producto> productos = [];
    for (var producto in resultProductos) {
      final ofertas = await db.rawQuery('''
      SELECT ofertas.id as id_oferta,
      producto.id as id_producto,
      supermercado.id as id_supermercado,
        producto.nombre AS nombre_producto, 
        supermercado.nombre AS nombre_supermercado,
        supermercado.direccion as dir_supermercado,
        ofertas.precio, 
        ofertas.cantidad
      FROM ofertas
      INNER JOIN producto ON ofertas.id_producto = producto.id
      INNER JOIN supermercado ON ofertas.id_supermercado = supermercado.id
      WHERE producto.id =  ${producto['id']}  
      ORDER BY ofertas.precio ASC
      ;
''');
      productos.add(Producto(
          id: producto['id'] as int,
          nombre: producto['nombre'] as String,
          imagenUrl: producto['image_url'] as String,
          ofertas: List.generate(
              ofertas.length,
              (i) => Oferta(
                  id: ofertas[i]['id_oferta'] as int,
                  precio: ofertas[i]['precio'] as double,
                  cantidad: ofertas[i]['cantidad'] as int,
                  supermercado: Supermercado(
                      id: ofertas[i]['id_supermercado'] as int,
                      nombre: ofertas[i]['nombre_supermercado'] as String,
                      direccion: ofertas[i]['dir_supermercado'] as String)))));
    }

    return productos;
  }

  Future<List<Supermercado>> getAllSuper() async {
    final db = await instance.database;

    final resultSupermercados = await db.rawQuery('''
      SELECT * from supermercado;
''');
    List<Supermercado> supermercados = [];
    for (var elemento in resultSupermercados) {
      supermercados.add(Supermercado(
          id: elemento['id'] as int,
          nombre: elemento['nombre'] as String,
          direccion: elemento['direccion'] as String));
    }

    return supermercados;
  }

  Future<List<Producto>> getList(int idUsuario) async {
    final db = await instance.database;

    final resultProductos = await db.rawQuery('''
      SELECT lista.id_producto,producto.nombre,producto.image_url from lista 
      INNER JOIN producto on producto.id=lista.id_producto 
      WHERE lista.id_usuario=$idUsuario;
''');
    List<Producto> productos = [];
    for (var producto in resultProductos) {
      final ofertas = await db.rawQuery('''
      SELECT ofertas.id as id_oferta,
      producto.id as id_producto,
      supermercado.id as id_supermercado,
        producto.nombre AS nombre_producto, 
        supermercado.nombre AS nombre_supermercado,
        supermercado.direccion as dir_supermercado,
        ofertas.precio, 
        ofertas.cantidad
      FROM ofertas
      INNER JOIN producto ON ofertas.id_producto = producto.id
      INNER JOIN supermercado ON ofertas.id_supermercado = supermercado.id
      WHERE producto.id =  ${producto['id_producto']}  
      ORDER BY ofertas.precio ASC
      ;
''');
      productos.add(Producto(
          id: producto['id_producto'] as int,
          nombre: producto['nombre'] as String,
          imagenUrl: producto['image_url'] as String,
          ofertas: List.generate(
              ofertas.length,
              (i) => Oferta(
                  id: ofertas[i]['id_oferta'] as int,
                  precio: ofertas[i]['precio'] as double,
                  cantidad: ofertas[i]['cantidad'] as int,
                  supermercado: Supermercado(
                      id: ofertas[i]['id_supermercado'] as int,
                      nombre: ofertas[i]['nombre_supermercado'] as String,
                      direccion: ofertas[i]['dir_supermercado'] as String)))));
    }

    return productos;
  }

  Future<Usuario?> getUser(String email, String contrasena) async {
    final db = await instance.database;

    final resultUsuario = await db.rawQuery('''
      SELECT usuario.email, usuario.id, usuario.nombre from usuario 
      WHERE usuario.email='$email' and usuario.contrasena='$contrasena';
''');
    if (resultUsuario.isNotEmpty) {
      return Usuario(
          id: resultUsuario[0]['id'] as int,
          nombre: resultUsuario[0]['nombre'] as String,
          email: resultUsuario[0]['email'] as String);
    } else {
      return null;
    }
  }

  Future<Usuario?> getUserByEmail(String email) async {
    final db = await instance.database;

    final resultUsuario = await db.rawQuery('''
      SELECT usuario.email, usuario.id, usuario.nombre from usuario 
      WHERE usuario.email='$email';
''');
    if (resultUsuario.isNotEmpty) {
      return Usuario(
          id: resultUsuario[0]['id'] as int,
          nombre: resultUsuario[0]['nombre'] as String,
          email: resultUsuario[0]['email'] as String);
    } else {
      return null;
    }
  }

  Future<void> registrarUsuario(
      String email, String contrasena, String nombre) async {
    final db = await instance.database;
    await db.insert(
        'usuario', {'nombre': nombre, 'email': email, 'contrasena': contrasena},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> initInsert() async {
    final db = await instance.database;

    await db.rawInsert('''INSERT INTO producto (nombre,image_url)
        VALUES
        ('Cloro','https://frajosfood.com/55145-medium_default/22206-supra-cloro-bleach-64-fl-oz-case-of-8-box-8-units.jpg'),
        ('Jamón','https://walmarthn.vtexassets.com/arquivos/ids/302982/Jam-n-De-Pavo-Marca-Toledo-230gr-1-7809.jpg?v=638251727403800000'),
        ('Huevos','https://super100rd.com/wp-content/uploads/2022/10/119761-1.png'),
        ('Plátano','https://green.com.do/wp-content/uploads/2017/03/Platano-barahonero-1.jpg'),
        ('Salami','https://supermercadosnacional.com/media/catalog/product/cache/fde49a4ea9a339628caa0bc56aea00ff/2/2/2204866-1.jpg');''');
    await db.rawInsert('''INSERT INTO supermercado (nombre,direccion)
        VALUES
        ('Supermercado la yali','frende donde cuca'),
        ('Supermercado Era','al lado de marino');''');
    await db.rawInsert(
        '''INSERT INTO ofertas (id_producto, id_supermercado, precio, cantidad)
           VALUES
           (1, 2, 5.99, 50),
           (1, 1, 5.75, 30),
           (3, 2, 8.50, 20);''');
    await db.rawInsert('''INSERT INTO usuario (nombre,email,contrasena)
        VALUES
        ('pedro','pedro@gmail.com','1234'),
        ('juan','juan@gmail.com','1234');''');
    await db.rawInsert('''INSERT INTO lista (id_producto,id_usuario)
    VALUES
    (1, 1),
    (3, 1),
    (1, 2);''');
  }
}
