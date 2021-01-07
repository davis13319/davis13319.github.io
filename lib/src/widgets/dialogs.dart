// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/api/api.dart';
import 'package:web_dashboard/src/widgets/category_forms.dart';

import '../app.dart';
import 'edit_entry.dart';

class NewCategoryDialog extends StatelessWidget {
  final Function(String zipcode, String addr, String bldgMgrNum) onChanged;

  NewCategoryDialog({@required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('주소찾기'),
      children: <Widget>[
        NewCategoryForm(onChanged: onChanged),
      ],
    );
  }
}

class EditCategoryDialog extends StatelessWidget {
  final Category category;
  final Function(String zipcode, String addr, String bldgMgrNum) onChanged;

  EditCategoryDialog({
    @required this.category,
    @required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    var api = Provider.of<AppState>(context).api;

    return SimpleDialog(
      title: Text('Edit Category'),
      children: [
        EditCategoryForm(
          category: category,
          onDone: (shouldUpdate) {
            if (shouldUpdate) {
              api.categories.update(category, category.id);
            }
            Navigator.of(context).pop();
          },
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class NewEntryDialog extends StatefulWidget {
  @override
  _NewEntryDialogState createState() => _NewEntryDialogState();
}

class _NewEntryDialogState extends State<NewEntryDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('New Entry'),
      children: [
        NewEntryForm(),
      ],
    );
  }
}

class EditEntryDialog extends StatelessWidget {
  final Category category;
  final Entry entry;

  EditEntryDialog({
    this.category,
    this.entry,
  });

  @override
  Widget build(BuildContext context) {
    var api = Provider.of<AppState>(context).api;

    return SimpleDialog(
      title: Text('Edit Entry'),
      children: [
        EditEntryForm(
          entry: entry,
          onDone: (shouldUpdate) {
            if (shouldUpdate) {
              api.entries.update(category.id, entry.id, entry);
            }
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
