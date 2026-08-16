import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/feature_grid.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/terminal_widgets.dart';
import '../../domain/repositories/editing_repository.dart';
import '../viewmodels/editing_view_model.dart';

class EditingPage extends StatelessWidget {
  const EditingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return TerminalScaffold(
      tag: 'edit',
      title: t.editingPageTitle,
      body: FeatureGrid(
        items: [
          FeatureGridItem(
            icon: Icons.format_list_numbered,
            title: t.pageNumbersTitle,
            subtitle: t.pageNumbersHint,
            page: const _OperationPage(
                tag: 'pagenum', child: _PageNumbersSection()),
          ),
          FeatureGridItem(
            icon: Icons.text_fields,
            title: t.overlayTitle,
            subtitle: t.overlayHint,
            page: const _OperationPage(
                tag: 'overlay', child: _TextOverlaySection()),
          ),
        ],
      ),
    );
  }
}

/// Wraps a single operation section in its own page, reached from the
/// operation grid above.
class _OperationPage extends StatelessWidget {
  final String tag;
  final Widget child;
  const _OperationPage({required this.tag, required this.child});

  @override
  Widget build(BuildContext context) {
    return TerminalScaffold(
      tag: tag,
      title: context.t.editingPageTitle,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [child],
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
    return TerminalSection(
      title: t.pageNumbersTitle,
      initiallyExpanded: true,
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
        const SizedBox(height: 8),
        DropdownButton<PageNumberPosition>(
          value: _position,
          isExpanded: true,
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
    return TerminalSection(
      title: t.overlayTitle,
      initiallyExpanded: true,
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
        const SizedBox(height: 8),
        TextField(
          controller: _textCtrl,
          decoration: InputDecoration(labelText: t.overlayTextLabel),
        ),
        Row(
          children: [
            Text(t.fontSizeLabel, style: Theme.of(context).textTheme.bodySmall),
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
            Text(_fontSize.round().toString(),
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Row(
          children: [
            Text(t.opacityLabel, style: Theme.of(context).textTheme.bodySmall),
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
            Text(_opacity.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        SwitchListTile(
          title: Text(t.allPagesLabel, style: Theme.of(context).textTheme.bodyMedium),
          value: _allPages,
          onChanged: (v) => setState(() => _allPages = v),
          dense: true,
          contentPadding: EdgeInsets.zero,
        ),
        if (!_allPages)
          TextField(
            controller: _pageCtrl,
            decoration: InputDecoration(labelText: t.specificPageLabel),
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