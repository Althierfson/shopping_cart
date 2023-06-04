import 'package:wishlist/datasource/database.dart';
import 'package:wishlist/datasource/db_sqlite_data_source_impl.dart';
import 'package:wishlist/repositories/data_repository.dart';
import 'package:wishlist/state_manege/home_store/home_store.dart';
import 'package:wishlist/state_manege/new_user_store/new_user_store.dart';
import 'package:wishlist/state_manege/new_wishlist_store/new_wishlist_store.dart';
import 'package:wishlist/state_manege/shopping_store/shopping_store.dart';
import 'package:wishlist/state_manege/wishlist_list_store/wishlist_list_store.dart';
import 'package:wishlist/validate_data/validate_data.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setContainer() async {
  final db = Db();
  await db.initDatabase();
  // datasource
  sl.registerLazySingleton(() => db);
  sl.registerLazySingleton(() => DBSqliteDataSource(database: sl()));

  // repository
  sl.registerLazySingleton(() => Repository(dataSource: sl()));

  // Validate data
  sl.registerLazySingleton(() => ValidateData());

  // store
  sl.registerLazySingleton(() => HomeStore(repository: sl()));
  sl.registerLazySingleton(() => WishlistListStore(repository: sl()));
  sl.registerLazySingleton(
      () => NewWishlistStore(repository: sl(), validateData: sl()));
  sl.registerLazySingleton(
      () => NewUserStore(repository: sl(), validateData: sl()));
  sl.registerLazySingleton(() => ShoppingStore(repository: sl()));
}
