import 'package:flutter/material.dart';
import 'package:movii/app_module.dart';
import 'package:movii/app_widget.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'dart:async';
import 'dart:convert' show json;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:movii/home_controller.dart';
import 'package:movii/map.dart';
import 'package:movii/user.dart';
import 'dart:developer';

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  //clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

void main() {
  runApp(
    ModularApp(
      module: AppModule(),
      child: AppWidget(),
      
    ),
  );
}

class SignInDemo extends StatefulWidget {
  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  HomeController controller_user = Modular.get();
  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'lendo informações sobre o contato';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'A API deu uma resposta ${response.statusCode} '
            '. Verifique os logs para obter detalhes.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'Você é... $namedContact!';
      } else {
        _contactText = 'Nada para exibir.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Widget _buildBody() {
    final GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      controller_user.getUser(user.email);
      if (controller_user.email == '') {
        controller_user.setEmail(user.email);
        controller_user.setCampus('cacor');
        controller_user.setCampus_desc('Corrente');
        controller_user.addUser();
      }
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ListTile(
            leading: GoogleUserCircleAvatar(
              identity: user,
            ),
            title: Text(user.displayName ?? ''),
            subtitle: Text(user.email),
          ),
          const Text('Login Aceito.'),
          Text(_contactText),
          ElevatedButton(
            child: const Text('SAIR'),
            onPressed: _handleSignOut,
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
          ),
          ElevatedButton(
            child: const Text('ATUALIZAR'),
            onPressed: () => _handleGetContact(user),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
          ),
          ElevatedButton(
            child: const Text('MAPA'),
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
            ),
            onPressed: () {
              final Future future =
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyMap(user: controller_user.user);
              }));
              future.then((user) {
                //teste
              });
            },
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: 200.0,
            height: 200.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                alignment: Alignment.center,
                image: AssetImage('assets/ico_bus.png'),
              ), //AssetImage("assets/Serenity.png"),
            ),
          ),
          const Text('Você não está logado.'),
          SizedBox(
            width: 180,
            height: 60,
            child: FloatingActionButton.extended(
              onPressed: _handleSignIn,
              label: const Text("ENTRAR"),
              backgroundColor: Colors.green,
              icon: Icon(Icons.mail),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login Institucional - IFPI'),
          backgroundColor: Colors.green,
        ),
        body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _buildBody(),
        ));
  }
}
