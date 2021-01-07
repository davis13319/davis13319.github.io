// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../app.dart';
import '../widgets/category_chart.dart';

class DashboardPage extends StatelessWidget {
  final Function(String zipcode, String addr, String bldgMgrNum) onChanged;

  DashboardPage({@required this.onChanged});
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return FutureBuilder<List<Category>>(
      future: appState.api.categories.list(),
      builder: (context, futureSnapshot) {
        if (!futureSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<List<Category>>(
          initialData: futureSnapshot.data,
          stream: appState.api.categories.subscribe(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Dashboard(
              snapshot.data,
              onChanged,
            );
          },
        );
      },
    );
  }
}

class Dashboard extends StatelessWidget {
  final List<Category> categories;
  final Function(String zipcode, String addr, String bldgMgrNum) onChanged;

  Dashboard(this.categories, this.onChanged);

  @override
  Widget build(BuildContext context) {
    var api = Provider.of<AppState>(context).api;
    return Scrollbar(
      child: GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 2,
          maxCrossAxisExtent: 500,
        ),
        children: [
          ...categories.map(
            (category) => Card(
              child: CategoryChart(
                category: category,
                api: api,
                onChanged: onChanged,
              ),
            ),
          )
        ],
      ),
    );
  }
}
