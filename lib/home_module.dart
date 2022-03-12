import 'package:flutter/material.dart';
import 'package:movii/home_controller.dart';
import 'package:movii/main.dart';
import 'package:movii/map.dart';
import 'package:movii/user_repo.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:movii/home_page.dart';

class HomeModule extends  Module {
  @override
  final List<Bind> binds = [
    Bind((i) => HomeController(i())),
    Bind((i) => UserRepository(i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child:(_, args) =>
        //HomePage()
        //MyMap()
        MaterialApp(title: 'Login Institucional - IFPI', home: SignInDemo(), )
    ),
  ];
}