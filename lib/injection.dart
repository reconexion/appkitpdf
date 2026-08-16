import 'features/conversion/data/datasources/conversion_data_source.dart';
import 'features/conversion/data/repositories/conversion_repository_impl.dart';
import 'features/conversion/domain/usecases/conversion_usecases.dart';
import 'features/conversion/presentation/viewmodels/conversion_view_model.dart';
import 'features/editing/data/datasources/editing_data_source.dart';
import 'features/editing/data/repositories/editing_repository_impl.dart';
import 'features/editing/domain/usecases/editing_usecases.dart';
import 'features/editing/presentation/viewmodels/editing_view_model.dart';
import 'features/extras/data/datasources/extras_data_source.dart';
import 'features/extras/data/repositories/extras_repository_impl.dart';
import 'features/extras/domain/usecases/extras_usecases.dart';
import 'features/extras/presentation/viewmodels/extras_view_model.dart';
import 'features/organization/data/datasources/organization_data_source.dart';
import 'features/organization/data/repositories/organization_repository_impl.dart';
import 'features/organization/domain/usecases/organization_usecases.dart';
import 'features/organization/presentation/viewmodels/organization_view_model.dart';
import 'features/security/data/datasources/security_data_source.dart';
import 'features/security/data/repositories/security_repository_impl.dart';
import 'features/security/domain/usecases/security_usecases.dart';
import 'features/security/presentation/viewmodels/security_view_model.dart';

class Injection {
  // ─── Organization ───────────────────────────────────────────
  static final _orgDs = OrganizationDataSourceImpl();
  static final _orgRepo = OrganizationRepositoryImpl(_orgDs);

  static final organizationViewModel = OrganizationViewModel(
    mergePdfs: MergePdfs(_orgRepo),
    splitPdf: SplitPdf(_orgRepo),
    removePages: RemovePages(_orgRepo),
    extractPages: ExtractPages(_orgRepo),
    reorderPages: ReorderPages(_orgRepo),
    rotatePages: RotatePages(_orgRepo),
    renamePdf: RenamePdf(_orgRepo),
  );

  // ─── Conversion ─────────────────────────────────────────────
  static final _convDs = ConversionDataSourceImpl();
  static final _convRepo = ConversionRepositoryImpl(_convDs);

  static final conversionViewModel = ConversionViewModel(
    pdfToImages: PdfToImages(_convRepo),
    imagesToPdf: ImagesToPdf(_convRepo),
    pdfToWord: PdfToWord(_convRepo),
    pdfToExcel: PdfToExcel(_convRepo),
    pdfToPpt: PdfToPpt(_convRepo),
    htmlToPdf: HtmlToPdf(_convRepo),
  );

  // ─── Editing ────────────────────────────────────────────────
  static final _editDs = EditingDataSourceImpl();
  static final _editRepo = EditingRepositoryImpl(_editDs);

  static final editingViewModel = EditingViewModel(
    addPageNumbers: AddPageNumbers(_editRepo),
    addTextOverlay: AddTextOverlay(_editRepo),
  );

  // ─── Security ───────────────────────────────────────────────
  static final _secDs = SecurityDataSourceImpl();
  static final _secRepo = SecurityRepositoryImpl(_secDs);

  static final securityViewModel = SecurityViewModel(
    protectPdf: ProtectPdf(_secRepo),
    unprotectPdf: UnprotectPdf(_secRepo),
    compressPdf: CompressPdf(_secRepo),
  );

  // ─── Extras ─────────────────────────────────────────────────
  static final _extDs = ExtrasDataSourceImpl();
  static final _extRepo = ExtrasRepositoryImpl(_extDs);

  static final extrasViewModel = ExtrasViewModel(
    ocrPdf: OcrPdf(_extRepo),
    comparePdfs: ComparePdfs(_extRepo),
    repairPdf: RepairPdf(_extRepo),
  );
}
