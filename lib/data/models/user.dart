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

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'].toString(),
        name: json['name'],
        username: json['username'],
        email: json['email'],
        address: _Address.fromJson(json['address']),
        phone: json['phone'],
        website: json['website'],
        company: _Company.fromJson(json['company']));
  }
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

  static _Address fromJson(Map<String, dynamic> json) {
    return _Address(
        street: json['street'],
        suite: json['suite'],
        city: json['city'],
        zipcode: json['zipcode'],
        geo: _Geo.fromJson(json['geo']));
  }
}

class _Geo {
  final String lat;
  final String lng;

  _Geo({required this.lat, required this.lng});

  static _Geo fromJson(Map<String, dynamic> json) {
    return _Geo(lat: json['lat'], lng: json['lng']);
  }
}

class _Company {
  final String name;
  final String catchPhrase;
  final String bs;

  _Company({required this.name, required this.catchPhrase, required this.bs});

  static _Company fromJson(Map<String, dynamic> json) {
    return _Company(
        name: json['name'], catchPhrase: json['catchPhrase'], bs: json['bs']);
  }
}
