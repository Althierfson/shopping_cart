class ValidateData {
  String? validateUserName(String userName) {
    if (userName.length < 3) return "Name can't be empty";
    return null;
  }

  String? validateWishlistName(String cartName) {
    if (cartName.length < 3) return "Name can't be empty";
    return null;
  }
}
