import 'package:mysql1/mysql1.dart';

class Database {
  // Propiedades
  final String _host = 'localhost';
  final int _port = 3306;
  final String _user = 'root';

  // Métodos
  instalacion() async {
    var settings = ConnectionSettings(
      host: this._host,
      port: this._port,
      user: this._user,
    );
    var conn = await MySqlConnection.connect(settings);
    try {
      await _crearDB(conn);
      await _crearTablaUsuarios(conn);
      await _crearTablavaloraciones(conn);
      await conn.close();
    } catch (e) {
      print(e);
      await conn.close();
    }
  }

  Future<MySqlConnection> conexion() async {
    var settings = ConnectionSettings(host: this._host, port: this._port, user: this._user, db: 'centrocomercialdb');

    return await MySqlConnection.connect(settings);
  }
//crea la base de datos del centro comercial
  _crearDB(conn) async {
    await conn.query('CREATE DATABASE IF NOT EXISTS centrocomercialdb');
    await conn.query('USE centrocomercialdb');
    print('Conectado a centrocomercialdb');
  }
//crea la tabla usuarios del centro comercial(esta no separa usuarios y usuarios admin
//si no que admin es bool(0 o 1)y la tienda a la que pertenece ese admin)
  _crearTablaUsuarios(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS usuarios(
        idusuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(50) NOT NULL UNIQUE,
        apellido VARCHAR(50),
        password VARCHAR(50) NOT NULL,
        direccion VARCHAR(200),
        direccioncorreo VARCHAR(50),
        dinerogastado VARCHAR(20) NOT NULL,
        vecesidas INT NOT NULL,
        tiendaperteneciente VARCHAR(20),
        admin INT
      )''');
    print('Tabla usuarios creada');
  }
//crea la tabla valoraciones
  _crearTablavaloraciones(conn) async {
    await conn.query('''CREATE TABLE IF NOT EXISTS valoraciones(
        idvaloracion INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
        idusuario INT NOT NULL,
        tiendaperteneciente VARCHAR(50) NOT NULL,
        valoraciontienda VARCHAR(200) NOT NULL
        )''');
    print('Tabla valoraciones creada');
  }
}
