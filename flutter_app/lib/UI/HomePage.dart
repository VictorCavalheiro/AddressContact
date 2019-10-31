import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Helpers/ContactModel.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ContactPage.dart';

enum OrderOptions {orderaz,orderza}

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
        _orderList(OrderOptions.orderaz);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          actions: <Widget>[
            PopupMenuButton<OrderOptions>(itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(child: Text("Order A-Z"),value: OrderOptions.orderaz),
              const PopupMenuItem<OrderOptions>(child: Text("Order Z-A"),value: OrderOptions.orderza)
    ],onSelected: _orderList)
          ],
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
                                              image: listOfContacts[index]
                                                  .img != "" ? FileImage(File(
                                                  listOfContacts[index]
                                                      .img)) : AssetImage(
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

  void _orderList(OrderOptions value){
    switch(value){
      case OrderOptions.orderaz:
        listOfContacts.sort(  (a,b){  return a.name.toLowerCase().compareTo(b.name.toLowerCase());   });
        break;
      case OrderOptions.orderza:
        listOfContacts.sort(  (a,b){  return b.name.toLowerCase().compareTo(a.name.toLowerCase());   });
        break;

      default:

    }
    setState(() {

    });
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
        _orderList(OrderOptions.orderaz);
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
                            style: TextStyle(
                                color: Colors.black, fontSize: 18.0)),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(
                              contactEntity: listOfContacts[index]);
                        }),
                    FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: Colors.white,
                        child: Text("Remove",
                            style: TextStyle(
                                color: Colors.black, fontSize: 18.0)),
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
                        child: Text("Call",
                            style: TextStyle(
                                color: Colors.black, fontSize: 18.0)),
                        onPressed: () {
                          launch("tel://${listOfContacts[index].phone}");
                        })
                  ]));
        });
  }
}
