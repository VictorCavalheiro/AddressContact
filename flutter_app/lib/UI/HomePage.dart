import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Helpers/ContactModel.dart';

import 'ContactPage.dart';

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
            actions: <Widget>[Padding(padding: EdgeInsets.only(right: 10.0),child:Icon(Icons.share))],
            title: Text("Contacts"),
            centerTitle: true,
            backgroundColor: Colors.red),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(Icons.add),
            onPressed: () {_showContactPage();}),
        body: ListView.builder(
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: Container(
                      child: Card(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 80.0,
                                        height: 80.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  "images/user.png")),
                                        )),
                                    Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(listOfContacts[index].name,
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(listOfContacts[index].email,
                                                  style: TextStyle(
                                                      fontSize: 15.0)),
                                              Text(listOfContacts[index].phone,
                                                  style:
                                                      TextStyle(fontSize: 15.0))
                                            ]))
                                  ])))),onTap: (){
                    _showContactPage(contactEntity: listOfContacts[index]);
              });
            },
            padding: EdgeInsets.all(10.0),
            itemCount: listOfContacts.length));
  }

  void _showContactPage({ModelOfContact contactEntity}){
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return ContactPage(contact: contactEntity);
    }));
  }
}
