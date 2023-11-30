import 'package:firebase_example/widgets/base_appbar.dart';
import 'package:flutter/material.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
        title: const Text('Post Screen'),
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
    );
  }
}
