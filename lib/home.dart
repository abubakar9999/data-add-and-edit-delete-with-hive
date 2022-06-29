import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _updatecontroler = TextEditingController();
  Box? contactBox;
  @override
  void initState() {
    contactBox = Hive.box("contact-box");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  var userdata = _controller.text;
                  contactBox!.add(userdata);
                },
                child: Text("save")),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box("contact-box").listenable(),
                builder: (context, box, widget) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: contactBox!.keys.toList().length,
                      itemBuilder: (context, index) => Card(
                            child: ListTile(
                              title: Text(contactBox!.getAt(index).toString()),
                              trailing: Container(
                                width: 120,
                                child: Row(children: [
                                  IconButton(
                                      onPressed: () {
                                        _updatecontroler.text =
                                            contactBox!.getAt(index).toString();
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  actions: [
                                                    TextField(
                                                      controller:
                                                          _updatecontroler,
                                                    ),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          contactBox!.putAt(
                                                              index,
                                                              _updatecontroler
                                                                  .text);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Update"))
                                                  ],
                                                ));
                                      },
                                      icon: Icon(Icons.edit_outlined)),
                                  IconButton(
                                      onPressed: () {
                                        contactBox!.deleteAt(index);
                                      },
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.amber,
                                      )),
                                ]),
                              ),
                            ),
                          ));
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
