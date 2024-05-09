import 'Database.dart';

class Valoraciontienda {
//propiedades
  int? idvaloracion;
  int? idusuario;
  String? tiendaperteneciente;
  String? valoraciontienda;

  Valoraciontienda();
  Valoraciontienda.fromMap(map) {
    this.idvaloracion = map['idvaloracion'];
    this.idusuario = map['idusuario'];
    this.tiendaperteneciente = map['tiendaperteneciente'];
    this.valoraciontienda = map['valoraciontienda'];
  }

//Lista de valoraciones donde devuelve una valoracion dependiendo de la tienda que se elija
  allvaloracion(String tienda) async {
    var conn = await Database().conexion();
    try {
      var resultado = await conn.query("SELECT * FROM valoraciones WHERE tiendaperteneciente = '$tienda'");
      List<Valoraciontienda> usuarios = resultado.map((row) => Valoraciontienda.fromMap(row)).toList();
      return usuarios;
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }

  insertarValoracion() async {
    var conn = await Database().conexion();
    try {
      print(tiendaperteneciente);
      await conn.query('INSERT INTO valoraciones(idusuario,tiendaperteneciente,valoraciontienda) VALUES (?,?,?)', [
        idusuario,
        tiendaperteneciente,
        valoraciontienda
      ]);
      print('Valoracion insertada correctamente');
    } catch (e) {
      print(e);
    } finally {
      await conn.close();
    }
  }
}
