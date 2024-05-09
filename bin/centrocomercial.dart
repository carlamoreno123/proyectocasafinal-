import 'package:mysql1/mysql1.dart';
import 'Database.dart';
import 'app.dart';

main() async {
  await Database().instalacion();
  app().menuInicial();
}
