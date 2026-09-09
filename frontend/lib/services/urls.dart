class Urls {
  /// Override these values at build/run time, for example:
  /// --dart-define=BEVENT_API_HOST=api.example.com
  /// --dart-define=BEVENT_API_ROOT=bevent
  static const String urlServeur =
      String.fromEnvironment('BEVENT_API_HOST', defaultValue: 'localhost');
  static const String apiRoot =
      String.fromEnvironment('BEVENT_API_ROOT', defaultValue: 'api_test');
  static const String urlBase = "${apiRoot}/api/";
  static const String urlAdministrateur = "${urlBase}admin.php";
  static const String urlArtiste = "${urlBase}artiste.php";
  static const String urlCommentaire = "${urlBase}commentaire.php";
  static const String urlEspace = "${urlBase}espace.php";
  static const String urlEvenement = "${urlBase}evenement.php";
  static const String urlManageur= "${urlBase}manageur.php";
  static const String urlOrganisateur = "${urlBase}organisateur.php";
  static const String urlTicket = "${urlBase}ticket.php";
  static const String urlVisiteur = "${urlBase}visiteur.php";
  static const String url_register = "${urlBase}register.php";

  static Uri apiUri(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) {
    return Uri.http(urlServeur, "${urlBase}$endpoint", queryParameters);
  }

  static String assetUrl(String path) {
    final normalizedPath = path.replaceFirst(RegExp(r'^/+'), '');
    return Uri.http(urlServeur, "$apiRoot/$normalizedPath").toString();
  }
}


