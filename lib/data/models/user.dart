class UserModel {
  final String id;
  final String name;
  final String username;
  final String email;
  final _Address address;
  final String phone;
  final String website;
  final _Company company;

  UserModel(
      {required this.id,
      required this.name,
      required this.username,
      required this.email,
      required this.address,
      required this.phone,
      required this.website,
      required this.company});
}

class _Address {
  final String street;
  final String suite;
  final String city;
  final String zipcode;
  final _Geo geo;

  _Address(
      {required this.street,
      required this.suite,
      required this.city,
      required this.zipcode,
      required this.geo});
}

class _Geo {
  final String lat;
  final String lng;

  _Geo({required this.lat, required this.lng});
}

class _Company {
  final String name;
  final String catchPhrase;
  final String bs;

  _Company({required this.name, required this.catchPhrase, required this.bs});
}
