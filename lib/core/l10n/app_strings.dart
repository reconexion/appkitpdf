import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

enum AppLanguage { en, es }

class LocaleController extends ChangeNotifier {
  AppLanguage _language = AppLanguage.en;
  AppLanguage get language => _language;
  AppStrings get strings => _language == AppLanguage.en ? EnStrings() : EsStrings();

  void toggle() {
    _language = _language == AppLanguage.en ? AppLanguage.es : AppLanguage.en;
    notifyListeners();
  }

  void setLanguage(AppLanguage lang) {
    if (_language == lang) return;
    _language = lang;
    notifyListeners();
  }
}

extension AppLocalizationsX on BuildContext {
  AppStrings get t => Provider.of<LocaleController>(this).strings;
}

abstract class AppStrings {
  // ─── App ───────────────────────────────────────────────────
  String get appTitle;
  String get languageTooltip;

  String get organizationTitle;
  String get conversionTitle;
  String get editingTitle;
  String get securityTitle;
  String get extrasTitle;

  // ─── Navegación / Ajustes ───────────────────────────────────
  String get navHome;
  String get navRecent;
  String toolsCount(int n);
  String get settingsTitle;
  String get recentEmpty;
  String get removeFromList;
  String get todayLabel;
  String get privacyTitle;
  String get privacyNote;
  String get aboutVersion;

  // ─── Shared widgets (ResultCard / FileTile / page picker) ──
  String get processing;
  String get done;
  String errorMessage(String error);
  String get open;
  String get share;
  String get noFileSelected;
  String get select;
  String get selectFileCta;
  String get changeFile;
  String previewFailed(String error);
  String pagesCount(int n);
  String get selectAll;
  String get clearSelection;
  String pageLabel(int n);
  String get visualHint;

  // ─── Organization ───────────────────────────────────────────
  String get organizationPageTitle;
  String get mergeTitle;
  String get selectPdfsMultiple;
  String filesSelected(int n);
  String get mergeButton;

  String get splitTitle;
  String get splitButton;
  String get visualSplitHint;
  String partLabel(int n, String pages);
  String get addPartButton;
  String partResultLabel(int n, String filename);

  String get removeTitle;
  String get removeButton;

  String get extractTitle;
  String get extractButton;

  String get reorderTitle;
  String get reorderButton;
  String get reorderVisualHint;

  String get rotateTitle;
  String get rotateButton;

  String get renameTitle;
  String get newNameLabel;
  String get renameButton;

  // ─── Conversion ─────────────────────────────────────────────
  String get conversionPageTitle;
  String get pdfToImagesTitle;
  String get convertToImagesButton;
  String get imagesToPdfTitle;
  String get selectImagesMultiple;
  String imagesSelected(int n);
  String get createPdfButton;
  String get pdfToWordTitle;
  String get pdfToWordDesc;
  String get convertToWordButton;
  String get pdfToExcelTitle;
  String get pdfToExcelDesc;
  String get convertToExcelButton;
  String get pdfToPptTitle;
  String get pdfToPptDesc;
  String get convertToPptButton;
  String get htmlToPdfTitle;
  String get htmlToPdfHint;
  String get convertToPdfButton;

  // ─── Editing ────────────────────────────────────────────────
  String get editingPageTitle;
  String get pageNumbersTitle;
  String get positionBottomCenter;
  String get positionBottomRight;
  String get positionTopCenter;
  String get addPageNumbersButton;
  String get overlayTitle;
  String get overlayTextLabel;
  String get fontSizeLabel;
  String get opacityLabel;
  String get allPagesLabel;
  String get specificPageLabel;
  String get applyOverlayButton;

  // ─── Security ───────────────────────────────────────────────
  String get securityPageTitle;
  String get protectTitle;
  String get passwordLabel;
  String get protectButton;
  String get unprotectTitle;
  String get currentPasswordLabel;
  String get unprotectButton;
  String get compressTitle;
  String get compressDesc;
  String get compressButton;

  // ─── Extras ─────────────────────────────────────────────────
  String get extrasPageTitle;
  String get ocrTitle;
  String get ocrDesc;
  String get runOcrButton;
  String get compareTitle;
  String get compareDesc;
  String get pdf1Label;
  String get pdf2Label;
  String get compareButton;
  String get repairTitle;
  String get repairDesc;
  String get repairButton;
}

class EnStrings implements AppStrings {
  @override
  String get appTitle => 'KitPDF';
  @override
  String get languageTooltip => 'Language';

  @override
  String get organizationTitle => 'Organization';
  @override
  String get conversionTitle => 'Conversion';
  @override
  String get editingTitle => 'Editing';
  @override
  String get securityTitle => 'Security';
  @override
  String get extrasTitle => 'Extras';

  @override
  String get navHome => 'Home';
  @override
  String get navRecent => 'Recent';
  @override
  String toolsCount(int n) => n == 1 ? '1 tool' : '$n tools';
  @override
  String get settingsTitle => 'Settings';
  @override
  String get recentEmpty => 'Files you process will show up here';
  @override
  String get removeFromList => 'Remove';
  @override
  String get todayLabel => 'Today';
  @override
  String get privacyTitle => 'Privacy';
  @override
  String get privacyNote =>
      'Everything runs on your device. Your files are never uploaded anywhere.';
  @override
  String get aboutVersion => 'Version 1.0.0';

  @override
  String get processing => 'Processing on your device…';
  @override
  String get done => 'Done';
  @override
  String errorMessage(String error) => 'Something went wrong: $error';
  @override
  String get open => 'Open';
  @override
  String get share => 'Share';
  @override
  String get noFileSelected => 'No file selected yet';
  @override
  String get select => 'Select';
  @override
  String get selectFileCta => 'Select a PDF';
  @override
  String get changeFile => 'Change';
  @override
  String previewFailed(String error) => 'Could not preview PDF: $error';
  @override
  String pagesCount(int n) => '$n pages';
  @override
  String get selectAll => 'All';
  @override
  String get clearSelection => 'None';
  @override
  String pageLabel(int n) => 'Page $n';
  @override
  String get visualHint => 'Select a PDF to see its pages';

  @override
  String get organizationPageTitle => 'Organization';
  @override
  String get mergeTitle => 'Merge PDFs';
  @override
  String get selectPdfsMultiple => 'Select PDFs (multiple)';
  @override
  String filesSelected(int n) => '$n files selected';
  @override
  String get mergeButton => 'Merge PDFs';

  @override
  String get splitTitle => 'Split PDF';
  @override
  String get splitButton => 'Split PDF';
  @override
  String get visualSplitHint => 'Tap the pages for this part, then add it:';
  @override
  String partLabel(int n, String pages) => 'Part $n: $pages';
  @override
  String get addPartButton => 'Add as new part';
  @override
  String partResultLabel(int n, String filename) => 'Part $n: $filename';

  @override
  String get removeTitle => 'Remove Pages';
  @override
  String get removeButton => 'Remove Pages';

  @override
  String get extractTitle => 'Extract Pages';
  @override
  String get extractButton => 'Extract Pages';

  @override
  String get reorderTitle => 'Reorder Pages';
  @override
  String get reorderButton => 'Save Order';
  @override
  String get reorderVisualHint => 'Long-press a page and drag to reorder:';

  @override
  String get rotateTitle => 'Rotate Pages';
  @override
  String get rotateButton => 'Rotate Pages';

  @override
  String get renameTitle => 'Rename PDF';
  @override
  String get newNameLabel => 'New file name';
  @override
  String get renameButton => 'Rename PDF';

  @override
  String get conversionPageTitle => 'Conversion';
  @override
  String get pdfToImagesTitle => 'PDF to Images';
  @override
  String get convertToImagesButton => 'Convert to Images';
  @override
  String get imagesToPdfTitle => 'Images to PDF';
  @override
  String get selectImagesMultiple => 'Select Images (multiple)';
  @override
  String imagesSelected(int n) => '$n images selected';
  @override
  String get createPdfButton => 'Create PDF';
  @override
  String get pdfToWordTitle => 'PDF to Word';
  @override
  String get pdfToWordDesc => 'Extracts the text and creates a Word document.';
  @override
  String get convertToWordButton => 'Convert to Word';
  @override
  String get pdfToExcelTitle => 'PDF to Excel';
  @override
  String get pdfToExcelDesc => 'Extracts the text into spreadsheet rows.';
  @override
  String get convertToExcelButton => 'Convert to Excel';
  @override
  String get pdfToPptTitle => 'PDF to PowerPoint';
  @override
  String get pdfToPptDesc => 'Each text block becomes a slide.';
  @override
  String get convertToPptButton => 'Convert to PowerPoint';
  @override
  String get htmlToPdfTitle => 'HTML to PDF';
  @override
  String get htmlToPdfHint => 'Paste HTML content here';
  @override
  String get convertToPdfButton => 'Convert to PDF';

  @override
  String get editingPageTitle => 'Editing';
  @override
  String get pageNumbersTitle => 'Add Page Numbers';
  @override
  String get positionBottomCenter => 'Bottom Center';
  @override
  String get positionBottomRight => 'Bottom Right';
  @override
  String get positionTopCenter => 'Top Center';
  @override
  String get addPageNumbersButton => 'Add Page Numbers';
  @override
  String get overlayTitle => 'Add Text / Watermark';
  @override
  String get overlayTextLabel => 'Text to overlay';
  @override
  String get fontSizeLabel => 'Font size';
  @override
  String get opacityLabel => 'Opacity';
  @override
  String get allPagesLabel => 'All pages';
  @override
  String get specificPageLabel => 'Specific page number';
  @override
  String get applyOverlayButton => 'Apply Overlay';

  @override
  String get securityPageTitle => 'Security';
  @override
  String get protectTitle => 'Protect with Password';
  @override
  String get passwordLabel => 'Password';
  @override
  String get protectButton => 'Protect PDF';
  @override
  String get unprotectTitle => 'Remove Password';
  @override
  String get currentPasswordLabel => 'Current password';
  @override
  String get unprotectButton => 'Remove Password';
  @override
  String get compressTitle => 'Compress PDF';
  @override
  String get compressDesc => 'Reduces file size using maximum compression.';
  @override
  String get compressButton => 'Compress PDF';

  @override
  String get extrasPageTitle => 'Extras';
  @override
  String get ocrTitle => 'Recognize Text (OCR)';
  @override
  String get ocrDesc =>
      'Renders each page as an image, then runs on-device text recognition.';
  @override
  String get runOcrButton => 'Run OCR';
  @override
  String get compareTitle => 'Compare PDFs';
  @override
  String get compareDesc => 'Extracts text from both PDFs and diffs them line by line.';
  @override
  String get pdf1Label => 'PDF 1 — not selected';
  @override
  String get pdf2Label => 'PDF 2 — not selected';
  @override
  String get compareButton => 'Compare PDFs';
  @override
  String get repairTitle => 'Repair Corrupted PDF';
  @override
  String get repairDesc =>
      'Attempts to load and re-save the PDF, rebuilding its structure.';
  @override
  String get repairButton => 'Repair PDF';
}

class EsStrings implements AppStrings {
  @override
  String get appTitle => 'KitPDF';
  @override
  String get languageTooltip => 'Idioma';

  @override
  String get organizationTitle => 'Organización';
  @override
  String get conversionTitle => 'Conversión';
  @override
  String get editingTitle => 'Edición';
  @override
  String get securityTitle => 'Seguridad';
  @override
  String get extrasTitle => 'Extras';

  @override
  String get navHome => 'Inicio';
  @override
  String get navRecent => 'Recientes';
  @override
  String toolsCount(int n) => n == 1 ? '1 herramienta' : '$n herramientas';
  @override
  String get settingsTitle => 'Ajustes';
  @override
  String get recentEmpty => 'Aquí verás los archivos que proceses';
  @override
  String get removeFromList => 'Eliminar';
  @override
  String get todayLabel => 'Hoy';
  @override
  String get privacyTitle => 'Privacidad';
  @override
  String get privacyNote =>
      'Todo se procesa en tu dispositivo. Tus archivos nunca se suben a internet.';
  @override
  String get aboutVersion => 'Versión 1.0.0';

  @override
  String get processing => 'Procesando en tu dispositivo…';
  @override
  String get done => 'Listo';
  @override
  String errorMessage(String error) => 'Algo salió mal: $error';
  @override
  String get open => 'Abrir';
  @override
  String get share => 'Compartir';
  @override
  String get noFileSelected => 'Aún no seleccionas un archivo';
  @override
  String get select => 'Elegir';
  @override
  String get selectFileCta => 'Seleccionar PDF';
  @override
  String get changeFile => 'Cambiar';
  @override
  String previewFailed(String error) => 'No se pudo previsualizar el PDF: $error';
  @override
  String pagesCount(int n) => '$n páginas';
  @override
  String get selectAll => 'Todo';
  @override
  String get clearSelection => 'Ninguno';
  @override
  String pageLabel(int n) => 'Página $n';
  @override
  String get visualHint => 'Selecciona un PDF para ver sus hojas';

  @override
  String get organizationPageTitle => 'Organización';
  @override
  String get mergeTitle => 'Unir PDFs';
  @override
  String get selectPdfsMultiple => 'Seleccionar PDFs (varios)';
  @override
  String filesSelected(int n) => '$n archivos seleccionados';
  @override
  String get mergeButton => 'Unir PDFs';

  @override
  String get splitTitle => 'Dividir PDF';
  @override
  String get splitButton => 'Dividir PDF';
  @override
  String get visualSplitHint => 'Toca las hojas de esta parte y luego agrégala:';
  @override
  String partLabel(int n, String pages) => 'Parte $n: $pages';
  @override
  String get addPartButton => 'Agregar como nueva parte';
  @override
  String partResultLabel(int n, String filename) => 'Parte $n: $filename';

  @override
  String get removeTitle => 'Eliminar Páginas';
  @override
  String get removeButton => 'Eliminar Páginas';

  @override
  String get extractTitle => 'Extraer Páginas';
  @override
  String get extractButton => 'Extraer Páginas';

  @override
  String get reorderTitle => 'Reordenar Páginas';
  @override
  String get reorderButton => 'Guardar Orden';
  @override
  String get reorderVisualHint =>
      'Mantén presionada una hoja y arrástrala para reordenar:';

  @override
  String get rotateTitle => 'Rotar Páginas';
  @override
  String get rotateButton => 'Rotar Páginas';

  @override
  String get renameTitle => 'Renombrar PDF';
  @override
  String get newNameLabel => 'Nuevo nombre de archivo';
  @override
  String get renameButton => 'Renombrar PDF';

  @override
  String get conversionPageTitle => 'Conversión';
  @override
  String get pdfToImagesTitle => 'PDF a Imágenes';
  @override
  String get convertToImagesButton => 'Convertir a Imágenes';
  @override
  String get imagesToPdfTitle => 'Imágenes a PDF';
  @override
  String get selectImagesMultiple => 'Seleccionar Imágenes (varias)';
  @override
  String imagesSelected(int n) => '$n imágenes seleccionadas';
  @override
  String get createPdfButton => 'Crear PDF';
  @override
  String get pdfToWordTitle => 'PDF a Word';
  @override
  String get pdfToWordDesc => 'Extrae el texto y crea un documento de Word.';
  @override
  String get convertToWordButton => 'Convertir a Word';
  @override
  String get pdfToExcelTitle => 'PDF a Excel';
  @override
  String get pdfToExcelDesc => 'Extrae el texto en filas de hoja de cálculo.';
  @override
  String get convertToExcelButton => 'Convertir a Excel';
  @override
  String get pdfToPptTitle => 'PDF a PowerPoint';
  @override
  String get pdfToPptDesc => 'Cada bloque de texto se convierte en una diapositiva.';
  @override
  String get convertToPptButton => 'Convertir a PowerPoint';
  @override
  String get htmlToPdfTitle => 'HTML a PDF';
  @override
  String get htmlToPdfHint => 'Pega aquí el contenido HTML';
  @override
  String get convertToPdfButton => 'Convertir a PDF';

  @override
  String get editingPageTitle => 'Edición';
  @override
  String get pageNumbersTitle => 'Añadir Números de Página';
  @override
  String get positionBottomCenter => 'Centro Inferior';
  @override
  String get positionBottomRight => 'Inferior Derecha';
  @override
  String get positionTopCenter => 'Centro Superior';
  @override
  String get addPageNumbersButton => 'Añadir Números de Página';
  @override
  String get overlayTitle => 'Añadir Texto / Marca de Agua';
  @override
  String get overlayTextLabel => 'Texto a superponer';
  @override
  String get fontSizeLabel => 'Tamaño de fuente';
  @override
  String get opacityLabel => 'Opacidad';
  @override
  String get allPagesLabel => 'Todas las páginas';
  @override
  String get specificPageLabel => 'Número de página específica';
  @override
  String get applyOverlayButton => 'Aplicar Superposición';

  @override
  String get securityPageTitle => 'Seguridad';
  @override
  String get protectTitle => 'Proteger con Contraseña';
  @override
  String get passwordLabel => 'Contraseña';
  @override
  String get protectButton => 'Proteger PDF';
  @override
  String get unprotectTitle => 'Quitar Contraseña';
  @override
  String get currentPasswordLabel => 'Contraseña actual';
  @override
  String get unprotectButton => 'Quitar Contraseña';
  @override
  String get compressTitle => 'Comprimir PDF';
  @override
  String get compressDesc => 'Reduce el tamaño del archivo con compresión máxima.';
  @override
  String get compressButton => 'Comprimir PDF';

  @override
  String get extrasPageTitle => 'Extras';
  @override
  String get ocrTitle => 'Reconocer Texto (OCR)';
  @override
  String get ocrDesc =>
      'Convierte cada página en imagen y reconoce el texto en tu dispositivo.';
  @override
  String get runOcrButton => 'Ejecutar OCR';
  @override
  String get compareTitle => 'Comparar PDFs';
  @override
  String get compareDesc =>
      'Extrae el texto de ambos PDFs y lo compara línea por línea.';
  @override
  String get pdf1Label => 'PDF 1 — no seleccionado';
  @override
  String get pdf2Label => 'PDF 2 — no seleccionado';
  @override
  String get compareButton => 'Comparar PDFs';
  @override
  String get repairTitle => 'Reparar PDF Dañado';
  @override
  String get repairDesc =>
      'Intenta cargar y volver a guardar el PDF, reconstruyendo su estructura.';
  @override
  String get repairButton => 'Reparar PDF';
}
