import 'dart:developer';

import 'package:hasura_connect/hasura_connect.dart';
import 'package:movii/user.dart';

class UserRepository {
  final HasuraConnect _hasuraConnect;

  UserRepository(this._hasuraConnect);

  Future<List<UserModel>> getUsers() async {
    List<UserModel> listUsers = [];
    UserModel userModel;
    var query = '''
      query getUsers {
        usuario {
          id
          email
          campus_sigla
          campus_desc
          latitude
          longitude
          location
          admin
          carro
        }
      }
    ''';

    var snapshot = await _hasuraConnect.query(query);
    for (var json in (snapshot['data']['usuario']) as List) {
      userModel = UserModel.fromJson(json);
      listUsers.add(userModel);
    }
    return listUsers;
  }

  Future<UserModel> getUser(email) async {
    UserModel userModel;
    var query = '''
      query getUser(\$email:String!) {
        usuario(where: {email: {_eq: \$email}}){
          id
          email
          campus_sigla
          campus_desc
          latitude
          longitude
          location
          admin
          carro
        }
      }
    ''';
    var data = await _hasuraConnect.query(query, variables: {
      "email": email,
    });
    for (var json in (data['data']['usuario']) as List) {
      userModel = UserModel.fromJson(json);
      return userModel;
    }
    return UserModel.fromJson({'id':1, 'email':'XXX','campus_sigla':'cc', 'campus_desc':'cc', 'carro':false, 'admin':false});
  }

  Future<UserModel> getCarro(campus_sigla) async {
    UserModel userModel;
    var query = '''
      query getCarro(\$campus_sigla:String!) {
        usuario(where: {campus_sigla: {_eq: \$campus_sigla}, carro: {_eq: true}}){
          id
          email
          campus_sigla
          campus_desc
          latitude
          longitude
          location
          admin
          carro
        }
      }
    ''';
    var data = await _hasuraConnect.query(query, variables: {
      "campus_sigla": campus_sigla,
    });
    for (var json in (data['data']['usuario']) as List) {
      userModel = UserModel.fromJson(json);
      return userModel;
    }
    return UserModel.fromJson({});
  }

  // novo método adicionado
  Future<String> addUser(String email, String campus_sigla, String campus_desc) async {
    var query = """
      mutation addUser(\$email:String!, \$campus_sigla:String!, \$campus_desc:String!){
      insert_usuario(objects: {email: \$email, campus_sigla: \$campus_sigla, campus_desc: \$campus_desc}) {
        returning {
          email
        }
      }
    }
    """;
    var data = await _hasuraConnect.mutation(query, variables: {
      "email": email,
      "campus_sigla": campus_sigla,
      "campus_desc": campus_desc,
    });
    return data["data"]['insert_users']['returning'][0]['email'];
  }

  // novo método adicionado
  Future<String> savePosition(String email, String latitude, String longitude) async {
    var query = """
      mutation savePosition(\$email:String!, \$latitude:String!, \$longitude:String!) {
      update_usuario(where: {email: {_eq: \$email}}, _set: {latitude: \$latitude, longitude: \$longitude}) {
        affected_rows
        returning {
          email
        }
      }
    }
    """;
    var data = await _hasuraConnect.mutation(query, variables: {
      "email": email,
      "latitude": latitude,
      "longitude": longitude,
    });
    return data["data"]['update_usuario'];
  }
}