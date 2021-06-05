import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/provider/category_provider.dart';
import 'package:todo_list/utils/colors.dart';
import 'package:todo_list/provider/add_category_provider.dart';

class AddCategoryButton extends StatelessWidget {
  Icon _icon = Icon(Icons.label_off_outlined);

  TextEditingController nameController = TextEditingController();
  final textKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: 70.0,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: Text('Add Category'),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        child: Column(
                          children: <Widget>[
                            Form(
                              key: textKey,
                              child: TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: ListTile(
                                onTap: () {
                                  _pickIcon(context);
                                },
                                leading:
                                    Provider.of<AddCategoryProvider>(context)
                                        .icon,
                                title: (_icon == null)
                                    ? Text('None Selected')
                                    : Text('Selected Icon'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          child: Text("Add"),
                          onPressed: () {
                            if (!textKey.currentState.validate()) return null;
                            Provider.of<CategoryProvider>(context,
                                    listen: false)
                                .addCategory(
                                    nameController.text,
                                    Provider.of<AddCategoryProvider>(context,
                                            listen: false)
                                        .icon,
                                    Colors.primaries[Random()
                                        .nextInt(Colors.primaries.length)]);
                            Navigator.of(context).pop();
                          })
                    ],
                  );
                });
          },
          backgroundColor: kBlueColor,
          child: Icon(
            Icons.add,
            size: 20,
          ),
          // elevation: 0.1,
        ),
      ),
    );
  }

  _pickIcon(BuildContext context) async {
    IconData icon = await FlutterIconPicker.showIconPicker(context,
        iconPackMode: IconPack.cupertino);

    _icon = Icon(icon,
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)]);

    Provider.of<AddCategoryProvider>(context, listen: false).setIcon(_icon);
  }
}
