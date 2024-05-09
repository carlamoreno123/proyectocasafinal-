import 'dart:io';
import 'usuario.dart';
import 'valoraciontienda.dart';

class app {

//Metodos

//El menu inicial que sale cuando ejecutas el codigo, con tres opciones:
  menuInicial() async {
    int? opcion;
    do {
      stdout.writeln('''Elige una opción
      1 - Crear usuario
      2 - Registrarse como admin
      3 - Log in''');
      String respuesta = stdin.readLineSync() ?? 'e';
      opcion = int.tryParse(respuesta);
    } while (_menuinicialrespuestanovalida(opcion));
    switch (opcion) {
      case 1:
        await registrarusuario();
        break;
      case 2:
        await comprobarAdmin();
        break;
      case 3:
        await login();
        break;
    }
  }

//Cuando un uduario normal se loguea puede dejar una valoracion de la tienda que se
//desee y tambien se puede salir
  menuLogueado(usuario) async {
    int? opcion;
    do {
      stdout.writeln('''Hola, ${usuario.nombre}, elige una opción
      1 - dejar valoración
      2 - salir
      ''');
      opcion = parsearrespuesta();
    } while (_menulogueadorespuestanovalida(opcion));
    switch (opcion) {
      case 1:
        crearValoracion(usuario.idusuario);
        break;
      case 2:
        print('adios!');
        break;
    }
  }

//El admin podra ver las valoraciones de dicha tienda y de que usuario lo ha escrito 
//mediante su id, tambien podra salir
  menuAdmin(usuarioadmin) async {
    int? opcion;
    do {
      stdout.writeln('''Hola, ${usuarioadmin.nombre}, elige una opción
      1- ver valoraciones
      2-salir
      ''');
      opcion = parsearrespuesta();
    } while (_menulogueadorespuestanovalida(opcion));
    switch (opcion) {
      case 1:
        await listarValoraciones();
        break;
      case 2:
        print('adios!');
        break;
    }
  }

//Para poder registrarse como admin primero hay que comprobar si tienes la 
//contraseña 
  comprobarAdmin() async {
    stdout.writeln('escribe la contraseña');
    String? respuesta = stdin.readLineSync() ?? 'e';
    if (respuesta == '12345') {
      await registrarAdmin();
    } else {
      print('contraseña incorrecta');
    }
  }

//Registra un Admin. Este no tiene apellido, direccion o direccioncorreo
  registrarAdmin() async {
    Usuario usuarioadmin = Usuario();
    stdout.writeln('''Hola, bienvenido  tenemos que verificar tu entidad, por
        favor rellene estos datos:''');
    stdout.write('1-nombre admin:');
    usuarioadmin.nombre = stdin.readLineSync();
    stdout.write('2-password admin:');
    usuarioadmin.password = stdin.readLineSync();
    stdout.write('3-tienda perteneciente:');
    usuarioadmin.tiendaperteneciente = elegirTienda();
    usuarioadmin.admin = 1;
    await usuarioadmin.insertarUsuario();
    stdout.writeln('vale, eres tu ${usuarioadmin.nombre}');
  }

//Registra un usuario con todos sus datos, no incluye si es admin y la tienda perteneciente,
//ya que sera null(0)
  registrarusuario() async {
    Usuario usuario = Usuario();
    stdout.write('''Hola, bienvenido estas apunto de resgistrarte en este centro comercial, porfavor
      rellene estos datos:''');
    stdout.write('1- nombre:');
    usuario.nombre = stdin.readLineSync();
    stdout.write('2-apelido:');
    usuario.apellido = stdin.readLineSync();
    stdout.write('3-contraseña:');
    usuario.password = stdin.readLineSync();
    stdout.write('4-direccion:');
    usuario.direccion = stdin.readLineSync();
    stdout.write('5-direccioncorreo:');
    usuario.direccioncorreo = stdin.readLineSync();

    await usuario.insertarUsuario();
  }

//crea valoracion al elegir una tienda
  crearValoracion(int id) async {
    Valoraciontienda valoracion = Valoraciontienda();
    valoracion.idusuario = id;
    valoracion.tiendaperteneciente = elegirTienda();
    stdout.write('deja tu valoración:');
    valoracion.valoraciontienda = stdin.readLineSync();
    await valoracion.insertarValoracion();
  }

//Consiste en un map que contiene tiendas al elegir una tienda la devuelve y escribe 
//tu valoracion en esa tienda
  elegirTienda() {
    Map<int, String> tiendas = {
      1: 'Zara',
      2: 'Carrefour',
      3: 'Stradivarius',
      4: 'Pull and bear',
      5: 'Bershka'
    };
    int? opcion;
    do {
      stdout.writeln('''Elige una tienda:
      1 -> Zara
      2 -> Carrefour
      3 -> Stradivarius
      4 -> Pull and bear
      5 -> Bershka''');
      String respuesta = stdin.readLineSync() ?? 'e';
      opcion = int.tryParse(respuesta);
    } while (opcion == null || opcion != 1 && opcion != 2 && opcion != 3 && opcion != 4 && opcion != 5);
    return tiendas[opcion];
  }

//Se loguea un usuario normal, si es admin te manda a usuario admin, si no a menulogueado
  login() async {
    Usuario usuario = new Usuario();
    stdout.writeln('Introduce tu nombre de usuario');
    usuario.nombre = stdin.readLineSync();
    stdout.writeln('Introduce tu constraseña');
    usuario.password = stdin.readLineSync();
    var resultado = await usuario.loginUsuario();
    if (resultado == false) {
      stdout.writeln('Tu nombre de usuario o contraseña son incorrectos');
      menuInicial();
    } else {
      if (resultado.admin == 1) {
        await menuAdmin(resultado);
      } else {
        await menuLogueado(resultado);
      }
    }
  }

//Contiene una lista con todas las valoraciones, se elige una tienda y lista las valoraciones
//que contiene y el id del usuario que ha escrito esa valoracion
  listarValoraciones() async {
    String respuesta = elegirTienda();
    List valoraciones = await Valoraciontienda().allvaloracion(respuesta);

    for (var elemento in valoraciones) {
      print('el id: ${elemento.idusuario} ha dejado esta valoración: ${elemento.valoraciontienda}');
    }
  }

//Parsean opciones
  bool _menuinicialrespuestanovalida(var opcion) => opcion == null || opcion != 1 && opcion != 2 && opcion != 3;
  bool _menulogueadorespuestanovalida(var opcion) => opcion == null || opcion != 1 && opcion != 2 && opcion != 3 && opcion != 4;
  int? parsearrespuesta() => int.tryParse(stdin.readLineSync() ?? 'e');
}
