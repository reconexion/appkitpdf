import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/tool_list.dart';
import '../../domain/repositories/editing_repository.dart';
import '../viewmodels/editing_view_model.dart';

const _accent = AppColors.categoryEditing;

List<ToolItem> editingTools(BuildContext context) {
  final t = context.t;
  return [
    ToolItem(icon: Icons.format_list_numbered, title: t.pageNumbersTitle, page: const _PageNumbersPage()),
    ToolItem(icon: Icons.branding_watermark_outlined, title: t.overlayTitle, page: const _TextOverlayPage()),
  ];
}

class _PositionSelector extends StatelessWidget {
  final PageNumberPosition value;
  final ValueChanged<PageNumberPosition> onChanged;
  const _PositionSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final accent = AccentScope.of(context);
    final options = {
      PageNumberPosition.bottomCenter: t.positionBottomCenter,
      PageNumberPosition.bottomRight: t.positionBottomRight,
      PageNumberPosition.topCenter: t.positionTopCenter,
    };
    return Column(
      children: options.entries.map((e) {
        final selected = value == e.key;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onChanged(e.key),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: BoxDecoration(
                color: selected ? accent : AppColors.badge,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(e.value,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: selected ? AppColors.cardText : Colors.white70,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                        )),
                  ),
                  if (selected) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.check, color: AppColors.cardText, size: 18),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _PageNumbersPage extends StatefulWidget {
  const _PageNumbersPage();
  @override
  State<_PageNumbersPage> createState() => _PageNumbersPageState();
}

class _PageNumbersPageState extends State<_PageNumbersPage> {
  PageNumberPosition _position = PageNumberPosition.bottomCenter;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditingViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.pageNumbersTitle,
      accent: _accent,
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
        _PositionSelector(value: _position, onChanged: (v) => setState(() => _position = v)),
        ElevatedButton(
          onPressed: vm.pageNumberFile != null && !vm.isAddingPageNumbers
              ? () => vm.addPageNumbers(_position)
              : null,
          child: Text(t.addPageNumbersButton),
        ),
        ResultCard(result: vm.pageNumberResult, isLoading: vm.isAddingPageNumbers),
      ],
    );
  }
}

class _TextOverlayPage extends StatefulWidget {
  const _TextOverlayPage();
  @override
  State<_TextOverlayPage> createState() => _TextOverlayPageState();
}

class _TextOverlayPageState extends State<_TextOverlayPage> {
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
    return OperationScaffold(
      title: t.overlayTitle,
      accent: _accent,
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
          decoration: InputDecoration(labelText: t.overlayTextLabel),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(text: '${t.fontSizeLabel}: ${_fontSize.round()}'),
            Slider(
              value: _fontSize,
              min: 10,
              max: 72,
              divisions: 62,
              label: _fontSize.round().toString(),
              onChanged: (v) => setState(() => _fontSize = v),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FieldLabel(text: '${t.opacityLabel}: ${_opacity.toStringAsFixed(1)}'),
            Slider(
              value: _opacity,
              min: 0.1,
              max: 1.0,
              divisions: 9,
              label: _opacity.toStringAsFixed(1),
              onChanged: (v) => setState(() => _opacity = v),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(t.allPagesLabel, style: Theme.of(context).textTheme.bodyMedium),
                value: _allPages,
                onChanged: (v) => setState(() => _allPages = v),
              ),
              if (!_allPages)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                  child: TextField(
                    controller: _pageCtrl,
                    decoration: InputDecoration(labelText: t.specificPageLabel),
                    keyboardType: TextInputType.number,
                  ),
                ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: vm.overlayFile != null && !vm.isAddingOverlay
              ? () => vm.addTextOverlay(
                    _textCtrl.text,
                    _fontSize,
                    _opacity,
                    allPages: _allPages,
                    specificPage: _allPages ? null : int.tryParse(_pageCtrl.text),
                  )
              : null,
          child: Text(t.applyOverlayButton),
        ),
        ResultCard(result: vm.overlayResult, isLoading: vm.isAddingOverlay),
      ],
    );
  }
}
