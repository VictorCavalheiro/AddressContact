import 'package:flutter/material.dart';
import 'package:flutter_app/Helpers/ContactModel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Helper helper;
  List<ModelOfContact> listOfContacts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    helper = new Helper();
    listOfContacts = List();
    helper.getAllContacts().then((value) {
      setState(() {
        listOfContacts = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Contacts"),
            centerTitle: true,
            backgroundColor: Colors.red),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(Icons.add),
            onPressed: () {}),
        body: ListView.builder(
            itemBuilder: (context, index) {

            },
            padding: EdgeInsets.all(10.0),
            itemCount: listOfContacts.length));
  }


}
