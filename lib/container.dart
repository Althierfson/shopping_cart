import 'package:carrinho_de_compra/datasource/assets_datasource.dart';
import 'package:carrinho_de_compra/datasource/database.dart';
import 'package:carrinho_de_compra/repositories/assets_repository.dart';
import 'package:carrinho_de_compra/repositories/data_repository.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setContainer() async {
  final db = Db();
  await db.initDatabase();
  // datasource
  sl.registerLazySingleton(() => db);
  sl.registerLazySingleton(() => AssetsDataSource());

  // repository
  sl.registerLazySingleton(() => DataRepository(db: sl()));
  sl.registerLazySingleton(() => AssetsRepository(dataSource: sl()));
}
