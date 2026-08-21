import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/controllers/recent_files_controller.dart';
import 'core/l10n/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/conversion/presentation/viewmodels/conversion_view_model.dart';
import 'features/editing/presentation/viewmodels/editing_view_model.dart';
import 'features/extras/presentation/viewmodels/extras_view_model.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/organization/presentation/viewmodels/organization_view_model.dart';
import 'features/security/presentation/viewmodels/security_view_model.dart';
import 'injection.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PdfKitApp());
}

class PdfKitApp extends StatelessWidget {
  const PdfKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleController>(
            create: (_) => LocaleController()),
        ChangeNotifierProvider<OrganizationViewModel>(
            create: (_) => Injection.organizationViewModel),
        ChangeNotifierProvider<ConversionViewModel>(
            create: (_) => Injection.conversionViewModel),
        ChangeNotifierProvider<EditingViewModel>(
            create: (_) => Injection.editingViewModel),
        ChangeNotifierProvider<SecurityViewModel>(
            create: (_) => Injection.securityViewModel),
        ChangeNotifierProvider<ExtrasViewModel>(
            create: (_) => Injection.extrasViewModel),
        ChangeNotifierProvider<RecentFilesController>(
            create: (_) => Injection.recentFilesController),
      ],
      child: MaterialApp(
        title: 'KitPDF',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const HomePage(),
      ),
    );
  }
}