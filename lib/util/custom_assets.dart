class CustomAssets {
  static List<String> get userIcons =>
      List.generate(25, (index) => "assets/user_icons/${index + 1}.jpg");

  static List<String> get cartIcons =>
      List.generate(15, (index) => "assets/wishlist_icons/$index.jpg");
}
