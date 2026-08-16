import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/terminal_widgets.dart';
import '../viewmodels/organization_view_model.dart';

class RenamePage extends StatefulWidget {
  const RenamePage({super.key});

  @override
  State<RenamePage> createState() => _RenamePageState();
}

class _RenamePageState extends State<RenamePage> {
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrganizationViewModel>();
    final t = context.t;
    return TerminalScaffold(
      tag: 'rename',
      title: t.renameTitle,
      accent: AppColors.accentRename,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          FileTile(
            path: vm.renameFile,
            onTap: () async {
              final r = await FilePicker.platform.pickFiles(
                  type: FileType.custom, allowedExtensions: ['pdf']);
              if (r != null) vm.renameFile = r.files.single.path;
            },
            onClear: () => vm.renameFile = null,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(labelText: t.newNameLabel),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: vm.renameFile != null &&
                _nameCtrl.text.trim().isNotEmpty &&
                !vm.isRenaming
                ? () => vm.rename(_nameCtrl.text)
                : null,
            child: Text(t.renameButton),
          ),
          ResultCard(result: vm.renameResult, isLoading: vm.isRenaming),
        ],
      ),
    );
  }
}
