import 'package:flutter/material.dart';

import '../../Services/database/directory_data.dart';
import 'directories.dart';

class DirectoriesPage extends StatelessWidget {
  final List<DirectoryData> directories;

  DirectoriesPage({required this.directories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true, // Make the app bar sticky
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: AnimatedTitle(),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Directories(directories: directories),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedTitle extends StatefulWidget {
  @override
  _AnimatedTitleState createState() => _AnimatedTitleState();
}

class _AnimatedTitleState extends State<AnimatedTitle> {
  ScrollController _scrollController = ScrollController();
  double _fontSize = 24;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      _fontSize = _scrollController.offset > 100 ? 16 : 24;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.bold),
      child: Text('Directories'),
    );
  }
}