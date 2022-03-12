import 'dart:developer';

import 'package:mobx/mobx.dart';

import 'package:movii/user.dart';
import 'package:movii/user_repo.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  late UserRepository repository;
  _HomeControllerBase(this.repository);

  @observable
  List<UserModel> listUsers = <UserModel>[].asObservable();
  UserModel user = UserModel.fromJson({'id':1, 'email':'teste','campus_sigla':'cc', 'campus_desc':'cc', 'carro':false, 'admin':false});
  UserModel carro = UserModel.fromJson({'id':1, 'email':'teste','campus_sigla':'cc', 'campus_desc':'cc', 'carro':true, 'admin':false});

  @observable
  String email = '';
  @action
  setEmail(value) => email = value;
  @observable
  String campus_sigla = '';
  @action
  setCampus(value) => campus_sigla = value;
  @observable
  String campus_desc = '';
  @action
  setCampus_desc(value) => campus_desc = value;
  @action
  getUsers() async {
    listUsers = await repository.getUsers();
  }
  @action
  getUser(email) async {
    carro = await repository.getUser(email);
  }
  @action
  getCarro(campus_sigla) async {
    user = await repository.getCarro(campus_sigla);
  }
  @observable
  String latitude = '';
  @action
  setLatitude(value) => latitude = value;
  @observable
  String longitude = '';
  @action
  setLongitude(value) => longitude = value;


  //novo método adicionado
  @action
  addUser() {
    repository.addUser(email, campus_sigla, campus_desc);
  }

  @action
  savePosition() {
    repository.savePosition(email, latitude, longitude);
  }
}