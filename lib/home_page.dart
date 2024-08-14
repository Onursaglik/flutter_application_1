// lib/home_page.dart
import 'package:flutter/material.dart';
import 'draggable_container.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Offset> _offsets = [
    const Offset(100, 100),
    const Offset(200, 200)
  ];
  final List<String> _imagePaths = [
    'assets/images/resim1.png',
    'assets/images/resim2.png'
  ];
  final List<Size> _imageSizes = [const Size(100, 100), const Size(100, 100)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Stack(
        children: _offsets.asMap().entries.map<Widget>((entry) {
          int index = entry.key;
          Offset offset = entry.value;
          return DraggableContainer(
            offset: offset,
            imagePath: _imagePaths[index],
            imageSize: _imageSizes[index],
            onDragEnd: (newOffset) {
              setState(() {
                _offsets[index] = newOffset;
              });
            },
            onTap: () {
              _showImageSizeDialog(context, index);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showImageSizeDialog(BuildContext context, int index) {
    TextEditingController heightController = TextEditingController();
    TextEditingController widthController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Image Size'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height'),
              ),
              TextField(
                controller: widthController,
                decoration: const InputDecoration(labelText: 'Width'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                setState(() {
                  _imageSizes[index] = Size(
                    double.parse(widthController.text),
                    double.parse(heightController.text),
                  );
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
