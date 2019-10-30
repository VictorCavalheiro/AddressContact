import 'package:flutter/material.dart';
import 'package:flutter_app/Helpers/ContactModel.dart';

class ContactPage extends StatefulWidget {
  final ModelOfContact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  ModelOfContact _editedContact;
  bool _userEdited = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.contact == null) {
      _editedContact = ModelOfContact();
    } else {
      _editedContact = ModelOfContact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name.toString();
      _emailController.text = _editedContact.email.toString();
      _phoneController.text = _editedContact.phone.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.red,
                title: Text(_editedContact.name ?? "New Contact"),
                centerTitle: true),
            floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.red,
                onPressed: () {
                  if (_editedContact.name != null &&
                      _editedContact.name.isNotEmpty)
                    Navigator.pop(context, _editedContact);
                  else
                    FocusScope.of(context).requestFocus(_nameFocus);
                },
                child: Icon(Icons.save)),
            body: SingleChildScrollView(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                          child: Container(
                              alignment: Alignment.center,
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage("images/user.png"))))),
                      TextField(
                          focusNode: _nameFocus,
                          controller: _nameController,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: "Name:"),
                          onChanged: (value) {
                            _userEdited = true;
                            setState(() {
                              _editedContact.name = value;
                            });
                          }),
                      Divider(
                        height: 10.0,
                      ),
                      TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: "Email:"),
                          onChanged: (value) {
                            _userEdited = true;
                            _editedContact.email = value;
                          }),
                      Divider(height: 10.0),
                      TextField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.black),
                              labelText: "Phone:"),
                          onChanged: (value) {
                            _userEdited = true;
                            _editedContact.phone = value;
                          })
                    ]))),
        onWillPop: _willPopCallback);
  }

  Future<bool> _willPopCallback() async {
    if (_userEdited == false) {
      return true;
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text("Desfazer operacoes?"),
                content: Text("Operacoes serao desfeitas!"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text("Sim")),
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancelar"))
                ]);
          });

      return false;
    }
  }
}
