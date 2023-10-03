import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Assignment(),
    );
  }
}

class Assignment extends StatefulWidget {
  const Assignment({Key? key}) : super(key: key);

  @override
  State<Assignment> createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          double containerH = constraints.maxHeight / 8;
          double containerW = constraints.maxWidth / 1.1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card1(containerH, containerW),
              Card2(containerH, containerW),
            ],
          );
        }),
      ),
    );
  }
}

Widget Card1(double H, double W) {
  return Container(
    padding: EdgeInsets.all(8),
    height: H,
    width: W,
    color: Colors.redAccent,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: H / 3,
          width: 150,
          color: Colors.grey,
        ),
        Container(
          height: H / 3,
          width: W / 1.1,
          color: Colors.green,
        )
      ],
    ),
  );
}

Widget Card2(double H, double W) {
  return Container(
    height: H,
    width: W,
    child: Stack(children: [
      Align(
        alignment: AlignmentDirectional.bottomCenter,
        child: Container(
          padding: EdgeInsets.all(8),
          height: H / 1.2,
          width: W,
          color: Colors.redAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: H / 3,
                width: W / 1.1,
                color: Colors.green,
              )
            ],
          ),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.topCenter,
        child: Container(
          height: 35,
          width: 150,
          color: Colors.grey,
        ),
      ),
    ]),
  );
}
