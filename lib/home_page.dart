import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController controller = Modular.get();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    controller.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        if (controller.listUsers.isEmpty) {
          return Container(
            child: Center(child: CircularProgressIndicator()),
            color: Colors.white,
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Movi-IFPI'),
            centerTitle: true,
          ),
          body: ListView.builder(
            itemCount: controller.listUsers.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(controller.listUsers[index].id.toString()),
                ),
                title: Text(controller.listUsers[index].email),
                subtitle: Text(controller.listUsers[index].campus_desc),
              );
            },
          ),
          //novo widget adicionado
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context1) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      title: Text("Adicionar Novo"),
                      content: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextFormField(
                                validator: (value) =>
                                value!.isEmpty ? 'Preencha o campo' : null,
                                decoration: InputDecoration(
                                    labelText: "Email"),
                                onChanged: controller.setEmail,
                              ),
                              TextFormField(
                                validator: (value) =>
                                value!.isEmpty ? 'Preencha o campo' : null,
                                decoration:
                                InputDecoration(labelText: "Campus"),
                                onChanged: controller.setCampus,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(3.0),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ))),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      controller.addUser();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    "Salvar",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ]),
                      ),
                    );
                  });
            },
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}