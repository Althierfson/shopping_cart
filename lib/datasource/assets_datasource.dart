class AssetsDataSource {
  List<String> get userIcons =>
      List.generate(25, (index) => "assets/user_icons/${index + 1}.jpg");

  List<String> get cartIcons =>
      List.generate(15, (index) => "assets/cart_icons/$index.jpg");
}