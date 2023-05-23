import 'package:carrinho_de_compra/datasource/assets_datasource.dart';

class AssetsRepository {
  AssetsDataSource dataSource;

  AssetsRepository({required this.dataSource});

  List<String> get userIcons => dataSource.userIcons;

  List<String> get cartIcons => dataSource.cartIcons;
}
