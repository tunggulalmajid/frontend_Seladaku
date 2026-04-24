import 'package:flutter/material.dart';

class KebunPage extends StatefulWidget {
  const KebunPage({super.key});

  @override
  State<KebunPage> createState() => _KebunPageState();
}

class _KebunPageState extends State<KebunPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [Center(child: Text("Manajemen Kebun"))]);
  }
}
