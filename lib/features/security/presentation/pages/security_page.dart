import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/widgets/feature_grid.dart';
import '../../../../core/widgets/result_card.dart';
import '../../../../core/widgets/terminal_widgets.dart';
import '../viewmodels/security_view_model.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return TerminalScaffold(
      tag: 'secure',
      title: t.securityPageTitle,
      body: FeatureGrid(
        items: [
          FeatureGridItem(
            icon: Icons.lock_outline,
            title: t.protectTitle,
            subtitle: t.protectHint,
            page: const _OperationPage(
                tag: 'protect', child: _ProtectSection()),
          ),
          FeatureGridItem(
            icon: Icons.lock_open_outlined,
            title: t.unprotectTitle,
            subtitle: t.unprotectHint,
            page: const _OperationPage(
                tag: 'unprotect', child: _UnprotectSection()),
          ),
          FeatureGridItem(
            icon: Icons.compress,
            title: t.compressTitle,
            subtitle: t.compressHint,
            page: const _OperationPage(
                tag: 'compress', child: _CompressSection()),
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
      title: context.t.securityPageTitle,
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [child],
      ),
    );
  }
}

class _ProtectSection extends StatefulWidget {
  const _ProtectSection();
  @override
  State<_ProtectSection> createState() => _ProtectSectionState();
}

class _ProtectSectionState extends State<_ProtectSection> {
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
    return TerminalSection(
      title: t.protectTitle,
      initiallyExpanded: true,
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
        const SizedBox(height: 8),
        TextField(
          controller: _pwdCtrl,
          obscureText: _obscure,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: t.passwordLabel,
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off,
                  size: 18),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.protectFile != null &&
              _pwdCtrl.text.isNotEmpty &&
              !vm.isProtecting
              ? () => vm.protect(_pwdCtrl.text)
              : null,
          child: Text(t.protectButton),
        ),
        ResultCard(result: vm.protectResult, isLoading: vm.isProtecting),
      ],
    );
  }
}

class _UnprotectSection extends StatefulWidget {
  const _UnprotectSection();
  @override
  State<_UnprotectSection> createState() => _UnprotectSectionState();
}

class _UnprotectSectionState extends State<_UnprotectSection> {
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
    return TerminalSection(
      title: t.unprotectTitle,
      initiallyExpanded: true,
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
        const SizedBox(height: 8),
        TextField(
          controller: _pwdCtrl,
          obscureText: true,
          decoration: InputDecoration(labelText: t.currentPasswordLabel),
        ),
        const SizedBox(height: 8),
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

class _CompressSection extends StatelessWidget {
  const _CompressSection();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SecurityViewModel>();
    final t = context.t;
    return TerminalSection(
      title: t.compressTitle,
      initiallyExpanded: true,
      children: [
        Text(t.compressDesc, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 8),
        FileTile(
          path: vm.compressFile,
          onTap: () async {
            final r = await FilePicker.platform.pickFiles(
                type: FileType.custom, allowedExtensions: ['pdf']);
            if (r != null) vm.compressFile = r.files.single.path;
          },
          onClear: () => vm.compressFile = null,
        ),
        const SizedBox(height: 8),
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