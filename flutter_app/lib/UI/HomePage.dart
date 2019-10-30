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

            title: Text("Contacts"),
            centerTitle: true,
            backgroundColor: Colors.red),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.red,
            child: Icon(Icons.add),
            onPressed: () {
              _showContactPage();
            }),
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
                                  ])))),
                  onTap: () {
                    _showEditOptions(context, index);
                  });
            },
            padding: EdgeInsets.all(10.0),
            itemCount: listOfContacts.length));
  }

  void _showContactPage({ModelOfContact contactEntity}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return ContactPage(contact: contactEntity);
    }));

    if (recContact != null) {
      if (contactEntity != null) {
        await helper.updateContact(recContact);
        //getAllContacts();
      } else {
        await helper.saveContact(recContact);
      }
      getAllContacts();
    }
  }

  void getAllContacts() {
    helper.getAllContacts().then((value) {
      setState(() {
        listOfContacts = value;
      });
    });
  }

  void _showEditOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Colors.white,
                    child: Text("Edit",
                        style: TextStyle(color: Colors.black, fontSize: 18.0)),
                    onPressed: () {
                      Navigator.pop(context);
                      _showContactPage(contactEntity: listOfContacts[index]);
                    }),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Colors.white,
                    child: Text("Remove",
                        style: TextStyle(color: Colors.black, fontSize: 18.0)),
                    onPressed: () {
                      helper.deleteContact(listOfContacts[index].id);

                      setState(() {
                        listOfContacts.removeAt(index);
                        Navigator.pop(context);
                      });
                    }),
                FlatButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: Colors.white,
                    child: Text("Close",
                        style: TextStyle(color: Colors.black, fontSize: 18.0)),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ]));
        });
  }
}
