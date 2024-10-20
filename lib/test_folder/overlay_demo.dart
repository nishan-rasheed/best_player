import 'package:flutter/material.dart';

class OverLayDemoScreen extends StatefulWidget {
  const OverLayDemoScreen({super.key});

  @override
  State<OverLayDemoScreen> createState() => _OverLayDemoScreenState();
}

class _OverLayDemoScreenState extends State<OverLayDemoScreen> {
  OverlayEntry? _overlayEntry;

  void _insertOverlay(BuildContext context) {
    _overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        top: 0,
        left: 0,
        child: Material(
          color: const Color(0xFF0E3311).withOpacity(0.5),
          child: GestureDetector(
            onTap: () {
              print('OVERLAY ON');
              //on tap, remove or hide the overlay
              _overlayEntry?.remove();
            },
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
              ),
            ),
          ),
        ),
      );
    });
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('dd'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Flutter application',
            ),
            Text(
              '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            WidgetsBinding.instance!.addPostFrameCallback((_) => _insertOverlay(context)),
        child: const Icon(Icons.add),
      ),
    );
  }
}