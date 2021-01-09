// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../widgets/third_party/adaptive_scaffold.dart';
import 'firstPage.dart';
import 'SecondPage.dart';
import '../utils/abstracts.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSignOut;

  HomePage({
    @required this.onSignOut,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: Text('생활치료센터'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            textColor: Colors.white,
            onPressed: () =>
                (_pageAtIndex(_pageIndex) as ISaveUtil).formClear(),
            child: Text('초기화'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            textColor: Colors.white,
            onPressed: () => (_pageAtIndex(_pageIndex) as ISaveUtil).save(),
            child: Text('저장하기'),
          ),
        ),
      ],
      currentIndex: _pageIndex,
      destinations: [
        AdaptiveScaffoldDestination(
            title: '입소정보', icon: CupertinoIcons.square_arrow_down),
        AdaptiveScaffoldDestination(
            title: '퇴소정보', icon: CupertinoIcons.square_arrow_up),
        // AdaptiveScaffoldDestination(title: 'Settings', icon: Icons.settings),
      ],
      // body: _pageAtIndex(_pageIndex),
      body: pageIndex(_pageIndex),
      onNavigationIndexChange: (newIndex) {
        setState(() {
          if (newIndex == 0) (_pageAtIndex(newIndex) as ISaveUtil).clearState();
          _pageIndex = newIndex;
        });
      },
      // floatingActionButton:
      //     _hasFloatingActionButton ? _buildFab(context) : null,
    );
  }

  Widget pageIndex(int index) {
    if (index == 0) (_pageAtIndex(index) as ISaveUtil).clearState();
    return _pageAtIndex(index);
  }

  static Widget _pageAtIndex(int index) {
    if (index == 0) {
      return FirstPage();
    }

    if (index == 1) {
      return SecondPage();
    }

    return Center(child: Text('null page'));
  }
}
