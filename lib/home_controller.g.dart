// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$HomeController on _HomeControllerBase, Store {
  final _$nameAtom = Atom(name: '_HomeControllerBase.name');

  @override
  String get email {
    _$nameAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$nameAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  final _$descriptionAtom = Atom(name: '_HomeControllerBase.description');

  @override
  String get campus_sigla {
    _$descriptionAtom.reportRead();
    return super.campus_sigla;
  }

  @override
  set campus_sigla(String value) {
    _$descriptionAtom.reportWrite(value, super.campus_sigla, () {
      super.campus_sigla = value;
    });
  }

  @override
  set listUsers(List<UserModel> value) {
    _$listUsersAtom.reportWrite(value, super.listUsers, () {
      super.listUsers = value;
    });
  }

  final _$getUsersAsyncAction = AsyncAction('_HomeControllerBase.getUsers');

  @override
  Future getUsers() {
    return _$getUsersAsyncAction.run(() => super.getUsers());
  }


  final _$listUsersAtom = Atom(name: '_HomeControllerBase.listUsers');

  @override
  List<UserModel> get listUsers {
    _$listUsersAtom.reportRead();
    return super.listUsers;
  }

  final _$getUserAsyncAction = AsyncAction('_HomeControllerBase.getUser');

  @override
  Future getUser(email) {
    return _$getUserAsyncAction.run(() => super.getUser(email));
  }

  final _$getCarroAsyncAction = AsyncAction('_HomeControllerBase.getCarro');

  @override
  Future getCarro(campus_sigla) {
    return _$getCarroAsyncAction.run(() => super.getCarro(campus_sigla));
  }

  final _$_HomeControllerBaseActionController =
  ActionController(name: '_HomeControllerBase');

  @override
  dynamic setEmail(dynamic value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setEmail');
    try {
      return super.setEmail(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic setCampus(dynamic value) {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.setCampus');
    try {
      return super.setCampus(value);
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addUser() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.addUser');
    try {
      return super.addUser();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic savePosition() {
    final _$actionInfo = _$_HomeControllerBaseActionController.startAction(
        name: '_HomeControllerBase.savePosition');
    try {
      return super.savePosition();
    } finally {
      _$_HomeControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
email: ${email},
campus_sigla: ${campus_sigla},
listUsers: ${listUsers}
    ''';
  }
}