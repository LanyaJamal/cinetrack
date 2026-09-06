import 'package:flutter/widgets.dart';

class AppRadius {
  const AppRadius._();

  static const double small = 10;
  static const double medium = 16;
  static const double large = 24;
}

class AppShape {
  const AppShape._();

  static const RoundedSuperellipseBorder small = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.small)),
  );

  static const RoundedSuperellipseBorder medium = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.medium)),
  );

  static const RoundedSuperellipseBorder large = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.all(Radius.circular(AppRadius.large)),
  );

  static const BorderRadius smallRadius = BorderRadius.all(
    Radius.circular(AppRadius.small),
  );

  static const BorderRadius mediumRadius = BorderRadius.all(
    Radius.circular(AppRadius.medium),
  );

  static const BorderRadius largeRadius = BorderRadius.all(
    Radius.circular(AppRadius.large),
  );
}
