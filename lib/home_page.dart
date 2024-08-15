import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Offset> _offsets = [];
  final List<Size> _containerSizes = [];
  final List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save offsets
    List<String> offsetsString =
        _offsets.map((o) => '${o.dx},${o.dy}').toList();
    await prefs.setStringList('offsets', offsetsString);

    // Save sizes
    List<String> sizesString =
        _containerSizes.map((s) => '${s.width},${s.height}').toList();
    await prefs.setStringList('sizes', sizesString);

    // Save image paths
    await prefs.setStringList('imagePaths', _imagePaths);
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load offsets
    List<String>? offsetsString = prefs.getStringList('offsets');
    if (offsetsString != null && offsetsString.isNotEmpty) {
      _offsets.clear();
      _offsets.addAll(offsetsString.map((s) {
        final parts = s.split(',');
        return Offset(double.parse(parts[0]), double.parse(parts[1]));
      }).toList());
    }

    // Load sizes
    List<String>? sizesString = prefs.getStringList('sizes');
    if (sizesString != null && sizesString.isNotEmpty) {
      _containerSizes.clear();
      _containerSizes.addAll(sizesString.map((s) {
        final parts = s.split(',');
        return Size(double.parse(parts[0]), double.parse(parts[1]));
      }).toList());
    }

    // Load image paths
    List<String>? imagePaths = prefs.getStringList('imagePaths');
    if (imagePaths != null && imagePaths.isNotEmpty) {
      setState(() {
        _imagePaths.clear();
        _imagePaths.addAll(imagePaths);
      });
    }
  }

  void _openImageSelectionDialog() {
    String? selectedImagePath;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Resim Seç'),
          content: SizedBox(
            width: 300, // Pop-up genişliği
            height: 300, // Pop-up yüksekliği
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      ListTile(
                        leading: Image.asset(
                          'assets/images/resim1.png',
                          width: 50,
                          height: 50,
                        ),
                        title: const Text('Resim 1'),
                        onTap: () {
                          setState(() {
                            selectedImagePath = 'assets/images/resim1.png';
                          });
                        },
                        selected:
                            selectedImagePath == 'assets/images/resim1.png',
                        selectedTileColor:
                            Colors.grey.shade300, // Seçilenin arka planı
                      ),
                      ListTile(
                        leading: Image.asset(
                          'assets/images/resim2.png',
                          width: 50,
                          height: 50,
                        ),
                        title: const Text('Resim 2'),
                        onTap: () {
                          setState(() {
                            selectedImagePath = 'assets/images/resim2.png';
                          });
                        },
                        selected:
                            selectedImagePath == 'assets/images/resim2.png',
                        selectedTileColor:
                            Colors.grey.shade300, // Seçilenin arka planı
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedImagePath != null) {
                      setState(() {
                        _offsets.add(const Offset(100, 100));
                        _containerSizes.add(const Size(100, 100));
                        _imagePaths
                            .add(selectedImagePath!); // Seçilen resmi ekle
                      });
                      _saveData(); // Verileri kaydet
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: const Text('Tamam'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openSizeDialog(int index) {
    TextEditingController heightController = TextEditingController();
    TextEditingController widthController = TextEditingController();

    heightController.text = _containerSizes[index].height.toString();
    widthController.text = _containerSizes[index].width.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Boyutları Düzenle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: heightController,
                decoration: const InputDecoration(labelText: 'Height'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: widthController,
                decoration: const InputDecoration(labelText: 'Width'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Tamam'),
              onPressed: () {
                setState(() {
                  _containerSizes[index] = Size(
                    double.parse(widthController.text),
                    double.parse(heightController.text),
                  );
                });
                _saveData(); // Verileri kaydet
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Delete'),
              onPressed: () {
                setState(() {
                  _offsets.removeAt(index);
                  _containerSizes.removeAt(index);
                  _imagePaths.removeAt(index);
                });
                _saveData(); // Verileri kaydet
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Stack(
        children: _imagePaths.asMap().entries.map((entry) {
          int index = entry.key;
          String imagePath = entry.value;
          return Positioned(
            left: _offsets[index].dx,
            top: _offsets[index].dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _offsets[index] = Offset(
                    _offsets[index].dx + details.delta.dx,
                    _offsets[index].dy + details.delta.dy,
                  );
                });
                _saveData(); // Her hareketten sonra veriyi kaydet
              },
              onTap: () {
                _openSizeDialog(index);
              },
              child: SizedBox(
                width: _containerSizes[index].width,
                height: _containerSizes[index].height,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _openImageSelectionDialog,
            child: const Icon(Icons.add),
            tooltip: 'Resim Ekle',
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _saveData,
            child: const Icon(Icons.save),
            tooltip: 'Kaydet',
          ),
        ],
      ),
    );
  }
}
