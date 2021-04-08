class Utils {
  static String getUserName(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitials = nameSplit[1][0];

    return firstNameInitial + lastNameInitials;
  }
}
