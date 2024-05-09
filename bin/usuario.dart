import 'dart:io';
import 'app.dart';
import 'database.dart';

class Usuario {
  //propiedades
  int? idusuario;
  String? nombre;
  String? apellido;
  String? password;
  String? direccion;
  String? direccioncorreo;
  String? dinerogastado = '0';
  int? vecesidas = 0;

  String? tiendaperteneciente;
  int? admin = 0;

  //Constructores

  Usuario();
  Usuario.fromMap(map) {
    this.idusuario = map['idusuario'];
    this.nombre = map['nombre'];
    this.password = map['password'];
    this.direccion = map['direccion'];
    this.direccioncorreo = map['direccioncorreo'];
    this.dinerogastado = map['dinerogastado'];
    this.vecesidas = map['vecesidas'];
    this.tiendaperteneciente = map['tiendaperteneciente'];
    this.admin = map['admin'];
  }

  //Metodos

  loginUsuario() async {
    var conn = await Database().conexion();
    try {
      var resultado = await conn.query('SELECT * FROM usuarios WHERE nombre = ?', [
        this.nombre
      ]);
      Usuario usuario = Usuario.fromMap(resultado.first);
      if (this.password == usuario.password) {
        return usuario;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    } finally {
      await conn.close();
    }
  }

  all() async {
    var conn = await Database().conexion();
    try {
      var resultado = await conn.query('SELECT * FROM usuarios');
      List<Usuario> usuarios = resultado.map((row) => Usuario.fromMap(row)).toList();
      return usuarios;
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  insertarUsuario() async {
    var conn = await Database().conexion();
    try {
      await conn.query('INSERT INTO usuarios(nombre,apellido,password,direccion,direccioncorreo,vecesidas,dinerogastado,tiendaperteneciente,admin) VALUES (?,?,?,?,?,?,?,?,?)', [
        nombre,
        apellido,
        password,
        direccion,
        direccioncorreo,
        dinerogastado,
        vecesidas,
        tiendaperteneciente,
        admin
      ]);
      print('Usuario insertado correctamente');
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }
}
