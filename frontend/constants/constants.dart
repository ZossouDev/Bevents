extension StringCasingExtension on String {
  String toCapitalizedCase() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() =>
      replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalizedCase()).join(' ');
}

class Constants {}
