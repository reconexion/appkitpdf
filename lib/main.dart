import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/l10n/app_strings.dart';
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
      ],
      child: MaterialApp(
        title: 'PDF Kit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
