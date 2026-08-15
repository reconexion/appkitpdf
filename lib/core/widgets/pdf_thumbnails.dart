import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart' as pdfx;

/// Loads every page of the PDF at [path] as a small JPEG thumbnail and hands
/// them to [builder]. Reused by every visual page-picker widget.
class PdfThumbnails extends StatefulWidget {
  final String path;
  final Widget Function(BuildContext context, List<Uint8List> pages) builder;

  const PdfThumbnails({super.key, required this.path, required this.builder});

  @override
  State<PdfThumbnails> createState() => _PdfThumbnailsState();
}

class _PdfThumbnailsState extends State<PdfThumbnails> {
  late Future<List<Uint8List>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load(widget.path);
  }

  @override
  void didUpdateWidget(covariant PdfThumbnails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path) {
      setState(() => _future = _load(widget.path));
    }
  }

  static Future<List<Uint8List>> _load(String path) async {
    final doc = await pdfx.PdfDocument.openFile(path);
    final thumbs = <Uint8List>[];
    for (int i = 1; i <= doc.pagesCount; i++) {
      final page = await doc.getPage(i);
      final image = await page.render(
        width: page.width,
        height: page.height,
        format: pdfx.PdfPageImageFormat.jpeg,
      );
      await page.close();
      if (image != null) thumbs.add(image.bytes);
    }
    await doc.close();
    return thumbs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Uint8List>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Text('No se pudo previsualizar el PDF: ${snapshot.error}',
                style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
          );
        }
        return widget.builder(context, snapshot.data!);
      },
    );
  }
}
