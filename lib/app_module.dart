import 'package:hasura_connect/hasura_connect.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind(
          (i) => HasuraConnect("https://movi-i.herokuapp.com/v1/graphql"),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];
}