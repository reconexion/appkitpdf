import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/result_card.dart';
import '../viewmodels/security_view_model.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          _ProtectSection(),
          Divider(),
          _UnprotectSection(),
          Divider(),
          _CompressSection(),
        ],
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
    return _Section(
      title: 'Protect with Password',
      children: [
        FileTile(
          path: vm.protectFile,
          label: 'No file selected',
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
          decoration: InputDecoration(
            labelText: 'Password',
            isDense: true,
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
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
          child: const Text('Protect PDF'),
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
    return _Section(
      title: 'Remove Password',
      children: [
        FileTile(
          path: vm.unprotectFile,
          label: 'No file selected',
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
          decoration: const InputDecoration(
              labelText: 'Current password', isDense: true),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: vm.unprotectFile != null && !vm.isUnprotecting
              ? () => vm.unprotect(_pwdCtrl.text)
              : null,
          child: const Text('Remove Password'),
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
    return _Section(
      title: 'Compress PDF',
      children: [
        const Text('Reduces file size using maximum compression.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        FileTile(
          path: vm.compressFile,
          label: 'No file selected',
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
          child: const Text('Compress'),
        ),
        ResultCard(result: vm.compressResult, isLoading: vm.isCompressing),
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
