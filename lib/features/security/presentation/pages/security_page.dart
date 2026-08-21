import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/tool_list.dart';
import '../viewmodels/security_view_model.dart';

const _accent = AppColors.categorySecurity;

List<ToolItem> securityTools(BuildContext context) {
  final t = context.t;
  return [
    ToolItem(icon: Icons.lock_outline, title: t.protectTitle, page: const _ProtectPage()),
    ToolItem(icon: Icons.lock_open_outlined, title: t.unprotectTitle, page: const _UnprotectPage()),
    ToolItem(icon: Icons.compress, title: t.compressTitle, page: const _CompressPage()),
  ];
}

class _ProtectPage extends StatefulWidget {
  const _ProtectPage();
  @override
  State<_ProtectPage> createState() => _ProtectPageState();
}

class _ProtectPageState extends State<_ProtectPage> {
  final _pwdCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SecurityViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.protectTitle,
      accent: _accent,
      children: [
        FileTile(
          path: vm.protectFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.protectFile = r.files.single.path;
          },
          onClear: () => vm.protectFile = null,
        ),
        TextField(
          controller: _pwdCtrl,
          obscureText: _obscure,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: t.passwordLabel,
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 20),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: vm.protectFile != null && _pwdCtrl.text.isNotEmpty && !vm.isProtecting
              ? () => vm.protect(_pwdCtrl.text)
              : null,
          child: Text(t.protectButton),
        ),
        ResultCard(result: vm.protectResult, isLoading: vm.isProtecting),
      ],
    );
  }
}

class _UnprotectPage extends StatefulWidget {
  const _UnprotectPage();
  @override
  State<_UnprotectPage> createState() => _UnprotectPageState();
}

class _UnprotectPageState extends State<_UnprotectPage> {
  final _pwdCtrl = TextEditingController();

  @override
  void dispose() {
    _pwdCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SecurityViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.unprotectTitle,
      accent: _accent,
      children: [
        FileTile(
          path: vm.unprotectFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.unprotectFile = r.files.single.path;
          },
          onClear: () => vm.unprotectFile = null,
        ),
        TextField(
          controller: _pwdCtrl,
          obscureText: true,
          decoration: InputDecoration(labelText: t.currentPasswordLabel),
        ),
        ElevatedButton(
          onPressed: vm.unprotectFile != null && !vm.isUnprotecting
              ? () => vm.unprotect(_pwdCtrl.text)
              : null,
          child: Text(t.unprotectButton),
        ),
        ResultCard(result: vm.unprotectResult, isLoading: vm.isUnprotecting),
      ],
    );
  }
}

class _CompressPage extends StatelessWidget {
  const _CompressPage();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SecurityViewModel>();
    final t = context.t;
    return OperationScaffold(
      title: t.compressTitle,
      accent: _accent,
      children: [
        Text(t.compressDesc, style: Theme.of(context).textTheme.bodySmall),
        FileTile(
          path: vm.compressFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.compressFile = r.files.single.path;
          },
          onClear: () => vm.compressFile = null,
        ),
        ElevatedButton(
          onPressed: vm.compressFile != null && !vm.isCompressing
              ? () => vm.compress()
              : null,
          child: Text(t.compressButton),
        ),
        ResultCard(result: vm.compressResult, isLoading: vm.isCompressing),
      ],
    );
  }
}
