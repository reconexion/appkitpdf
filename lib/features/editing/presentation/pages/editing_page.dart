import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/result_card.dart';
import '../../domain/repositories/editing_repository.dart';
import '../viewmodels/editing_view_model.dart';

class EditingPage extends StatelessWidget {
  const EditingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.t.editingPageTitle)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _PageNumbersSection(),
          Divider(),
          _TextOverlaySection(),
        ],
      ),
    );
  }
}

class _PageNumbersSection extends StatefulWidget {
  const _PageNumbersSection();
  @override
  State<_PageNumbersSection> createState() => _PageNumbersSectionState();
}

class _PageNumbersSectionState extends State<_PageNumbersSection> {
  PageNumberPosition _position = PageNumberPosition.bottomCenter;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditingViewModel>();
    final t = context.t;
    return _Section(
      title: t.pageNumbersTitle,
      children: [
        FileTile(
          path: vm.pageNumberFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.pageNumberFile = r.files.single.path;
          },
          onClear: () => vm.pageNumberFile = null,
        ),
        DropdownButton<PageNumberPosition>(
          value: _position,
          items: [
            DropdownMenuItem(
                value: PageNumberPosition.bottomCenter,
                child: Text(t.positionBottomCenter)),
            DropdownMenuItem(
                value: PageNumberPosition.bottomRight,
                child: Text(t.positionBottomRight)),
            DropdownMenuItem(
                value: PageNumberPosition.topCenter,
                child: Text(t.positionTopCenter)),
          ],
          onChanged: (v) => setState(() => _position = v!),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.pageNumberFile != null && !vm.isAddingPageNumbers
              ? () => vm.addPageNumbers(_position)
              : null,
          child: Text(t.addPageNumbersButton),
        ),
        ResultCard(
            result: vm.pageNumberResult, isLoading: vm.isAddingPageNumbers),
      ],
    );
  }
}

class _TextOverlaySection extends StatefulWidget {
  const _TextOverlaySection();
  @override
  State<_TextOverlaySection> createState() => _TextOverlaySectionState();
}

class _TextOverlaySectionState extends State<_TextOverlaySection> {
  final _textCtrl = TextEditingController(text: 'CONFIDENTIAL');
  double _fontSize = 36;
  double _opacity = 0.3;
  bool _allPages = true;
  final _pageCtrl = TextEditingController(text: '1');

  @override
  void dispose() {
    _textCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditingViewModel>();
    final t = context.t;
    return _Section(
      title: t.overlayTitle,
      children: [
        FileTile(
          path: vm.overlayFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.overlayFile = r.files.single.path;
          },
          onClear: () => vm.overlayFile = null,
        ),
        TextField(
          controller: _textCtrl,
          decoration: InputDecoration(
              labelText: t.overlayTextLabel, isDense: true),
        ),
        Row(
          children: [
            Text(t.fontSizeLabel),
            Expanded(
              child: Slider(
                value: _fontSize,
                min: 10,
                max: 72,
                divisions: 62,
                label: _fontSize.round().toString(),
                onChanged: (v) => setState(() => _fontSize = v),
              ),
            ),
            Text(_fontSize.round().toString()),
          ],
        ),
        Row(
          children: [
            Text(t.opacityLabel),
            Expanded(
              child: Slider(
                value: _opacity,
                min: 0.1,
                max: 1.0,
                divisions: 9,
                label: _opacity.toStringAsFixed(1),
                onChanged: (v) => setState(() => _opacity = v),
              ),
            ),
            Text(_opacity.toStringAsFixed(1)),
          ],
        ),
        SwitchListTile(
          title: Text(t.allPagesLabel),
          value: _allPages,
          onChanged: (v) => setState(() => _allPages = v),
          dense: true,
        ),
        if (!_allPages)
          TextField(
            controller: _pageCtrl,
            decoration: InputDecoration(
                labelText: t.specificPageLabel, isDense: true),
            keyboardType: TextInputType.number,
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.overlayFile != null && !vm.isAddingOverlay
              ? () => vm.addTextOverlay(
                    _textCtrl.text,
                    _fontSize,
                    _opacity,
                    allPages: _allPages,
                    specificPage: _allPages
                        ? null
                        : int.tryParse(_pageCtrl.text),
                  )
              : null,
          child: Text(t.applyOverlayButton),
        ),
        ResultCard(result: vm.overlayResult, isLoading: vm.isAddingOverlay),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      initiallyExpanded: true,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: children,
    );
  }
}
