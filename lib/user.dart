class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.campus_sigla,
    required this.campus_desc,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.admin,
    required this.carro,
    required this.hora,
  });

  final int id;
  final String email;
  final String campus_sigla;
  final String campus_desc;
  final String latitude;
  final String longitude;
  final String location;
  final bool admin;
  final bool carro;
  final DateTime hora;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] == null ? null : json['id'],
    email: json['email'] == null ? null : json['email'],
    campus_sigla: json['campus_sigla'] == null ? null : json['campus_sigla'],
    campus_desc: json['campus_desc'] == null ? null : json['campus_desc'],
    latitude: json['latitude'] == null ? "" : json['latitude'],
    longitude: json['longitude'] == null ? "" : json['longitude'],
    location: json['location'] == null ? "" : json['location'],
    admin: json['admin'],
    carro: json['carro'],
    hora: json['hora'] == null ? DateTime.now() : DateTime.parse(json['hora']),

  );
}