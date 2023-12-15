import 'package:market_list/entidades/entidad_oferta.dart';
import 'package:market_list/entidades/entidad_producto.dart';
import 'package:market_list/entidades/entidad_super.dart';
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
    id_oferta INTEGER,
    FOREIGN KEY (id_oferta) REFERENCES ofertas(id) ON DELETE CASCADE
    )
    ''');
  }

  Future<void> insertToList(int idOferta) async {
    final db = await instance.database;
    await db.insert('lista', {'id_oferta': idOferta},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Producto>> getAllOfertas() async {
    final db = await instance.database;
//     await db.rawInsert(
//         '''INSERT INTO producto (nombre,image_url) VALUES ('Producto A','https://frajosfood.com/55145-medium_default/22206-supra-cloro-bleach-64-fl-oz-case-of-8-box-8-units.jpg'),
//         ('Producto B','https://walmarthn.vtexassets.com/arquivos/ids/302982/Jam-n-De-Pavo-Marca-Toledo-230gr-1-7809.jpg?v=638251727403800000'),
//         ('Producto C','https://super100rd.com/wp-content/uploads/2022/10/119761-1.png'),
//         ('Producto D','https://green.com.do/wp-content/uploads/2017/03/Platano-barahonero-1.jpg'),
//         ('Producto E','https://supermercadosnacional.com/media/catalog/product/cache/fde49a4ea9a339628caa0bc56aea00ff/2/2/2204866-1.jpg');''');
//     await db.rawInsert('''INSERT INTO supermercado (nombre,direccion) VALUES
//         ('Supermercado la yali','frende donde cuca'),
//         ('Supermercado Era','al lado de marino');''');
//     await db.rawInsert(
//         '''INSERT INTO ofertas (id_producto, id_supermercado, precio, cantidad)
// VALUES
// 	(1, 2, 5.99, 50),
//     (1, 1, 5.75, 30),
//     (3, 2, 8.50, 20);''');

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
}
