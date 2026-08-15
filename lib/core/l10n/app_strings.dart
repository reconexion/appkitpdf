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
  // ─── App / Home ─────────────────────────────────────────────
  String get appTitle;
  String get languageTooltip;

  String get organizationTitle;
  String get organizationSubtitle;
  String get conversionTitle;
  String get conversionSubtitle;
  String get editingTitle;
  String get editingSubtitle;
  String get securityTitle;
  String get securitySubtitle;
  String get extrasTitle;
  String get extrasSubtitle;

  // ─── Shared widgets (ResultCard / FileTile / page picker) ──
  String get processing;
  String get done;
  String errorMessage(String error);
  String get open;
  String get share;
  String get noFileSelected;
  String get select;
  String previewFailed(String error);
  String pagesCount(int n);
  String get selectAll;
  String get clearSelection;
  String pageLabel(int n);
  String get modeText;
  String get modeVisual;
  String get visualHint;

  // ─── Organization ───────────────────────────────────────────
  String get organizationPageTitle;
  String get mergeTitle;
  String get selectPdfsMultiple;
  String filesSelected(int n);
  String get mergeButton;

  String get splitTitle;
  String get rangesLabel;
  String get splitButton;
  String get visualSplitHint;
  String partLabel(int n, String pages);
  String get addPartButton;
  String partResultLabel(int n, String filename);

  String get removeTitle;
  String get removePagesLabel;
  String get removeButton;

  String get extractTitle;
  String get extractPagesLabel;
  String get extractButton;

  String get reorderTitle;
  String get reorderLabel;
  String get reorderButton;
  String get reorderVisualHint;

  String get rotateTitle;
  String get rotatePagesLabel;
  String get rotateButton;

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
  String get appTitle => 'PDF Kit';
  @override
  String get languageTooltip => 'Language';

  @override
  String get organizationTitle => 'Organization';
  @override
  String get organizationSubtitle =>
      'Merge · Split · Remove · Extract · Reorder · Rotate';
  @override
  String get conversionTitle => 'Conversion';
  @override
  String get conversionSubtitle =>
      'PDF↔Word · PDF↔Excel · PDF↔PPT · PDF↔Images · HTML→PDF';
  @override
  String get editingTitle => 'Editing';
  @override
  String get editingSubtitle => 'Add page numbers · Text overlay / Watermark';
  @override
  String get securityTitle => 'Security';
  @override
  String get securitySubtitle => 'Password protect · Unprotect · Compress';
  @override
  String get extrasTitle => 'Extras';
  @override
  String get extrasSubtitle => 'OCR · Compare PDFs · Repair corrupted PDF';

  @override
  String get processing => 'Processing...';
  @override
  String get done => 'Done!';
  @override
  String errorMessage(String error) => 'Error: $error';
  @override
  String get open => 'Open';
  @override
  String get share => 'Share';
  @override
  String get noFileSelected => 'No file selected';
  @override
  String get select => 'Select';
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
  String get modeText => 'Text';
  @override
  String get modeVisual => 'Visual';
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
  String get mergeButton => 'Merge';

  @override
  String get splitTitle => 'Split PDF';
  @override
  String get rangesLabel => 'Page ranges (e.g. 1-3,4-6 or 1,2,3)';
  @override
  String get splitButton => 'Split';
  @override
  String get visualSplitHint => 'Tap the pages for the current part, then add it:';
  @override
  String partLabel(int n, String pages) => 'Part $n: $pages';
  @override
  String get addPartButton => 'Add as new part';
  @override
  String partResultLabel(int n, String filename) => 'Part $n: $filename';

  @override
  String get removeTitle => 'Remove Pages';
  @override
  String get removePagesLabel => 'Page numbers to remove (e.g. 2,4,7)';
  @override
  String get removeButton => 'Remove Pages';

  @override
  String get extractTitle => 'Extract Pages';
  @override
  String get extractPagesLabel => 'Pages to extract (e.g. 1,3,5)';
  @override
  String get extractButton => 'Extract Pages';

  @override
  String get reorderTitle => 'Reorder Pages';
  @override
  String get reorderLabel => 'New order (e.g. 3,1,2 moves page 3 first)';
  @override
  String get reorderButton => 'Reorder';
  @override
  String get reorderVisualHint => 'Long-press a page and drag to reorder:';

  @override
  String get rotateTitle => 'Rotate Pages';
  @override
  String get rotatePagesLabel => 'Pages to rotate (e.g. 1,2 or leave empty for all)';
  @override
  String get rotateButton => 'Rotate';

  @override
  String get conversionPageTitle => 'Conversion';
  @override
  String get pdfToImagesTitle => 'PDF → JPG/Images';
  @override
  String get convertToImagesButton => 'Convert to Images';
  @override
  String get imagesToPdfTitle => 'Images → PDF';
  @override
  String get selectImagesMultiple => 'Select Images (multiple)';
  @override
  String imagesSelected(int n) => '$n images selected';
  @override
  String get createPdfButton => 'Create PDF';
  @override
  String get pdfToWordTitle => 'PDF → Word (.docx)';
  @override
  String get pdfToWordDesc => 'Extracts text and creates a Word document.';
  @override
  String get convertToWordButton => 'Convert to Word';
  @override
  String get pdfToExcelTitle => 'PDF → Excel (.xlsx)';
  @override
  String get pdfToExcelDesc => 'Extracts text into spreadsheet rows.';
  @override
  String get convertToExcelButton => 'Convert to Excel';
  @override
  String get pdfToPptTitle => 'PDF → PowerPoint (.pptx)';
  @override
  String get pdfToPptDesc => 'Each text block becomes a slide.';
  @override
  String get convertToPptButton => 'Convert to PowerPoint';
  @override
  String get htmlToPdfTitle => 'HTML → PDF';
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
  String get fontSizeLabel => 'Font size:';
  @override
  String get opacityLabel => 'Opacity:';
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
  String get compressButton => 'Compress';

  @override
  String get extrasPageTitle => 'Extras';
  @override
  String get ocrTitle => 'OCR — Scanned PDF → Selectable Text';
  @override
  String get ocrDesc =>
      'Renders each page as image, then runs ML Kit text recognition.';
  @override
  String get runOcrButton => 'Run OCR';
  @override
  String get compareTitle => 'Compare PDFs';
  @override
  String get compareDesc => 'Extracts text from both PDFs and diffs line by line.';
  @override
  String get pdf1Label => 'PDF 1 — not selected';
  @override
  String get pdf2Label => 'PDF 2 — not selected';
  @override
  String get compareButton => 'Compare';
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
  String get appTitle => 'PDF Kit';
  @override
  String get languageTooltip => 'Idioma';

  @override
  String get organizationTitle => 'Organización';
  @override
  String get organizationSubtitle =>
      'Combinar · Dividir · Quitar · Extraer · Reordenar · Rotar';
  @override
  String get conversionTitle => 'Conversión';
  @override
  String get conversionSubtitle =>
      'PDF↔Word · PDF↔Excel · PDF↔PPT · PDF↔Imágenes · HTML→PDF';
  @override
  String get editingTitle => 'Edición';
  @override
  String get editingSubtitle =>
      'Agregar números de página · Texto superpuesto / Marca de agua';
  @override
  String get securityTitle => 'Seguridad';
  @override
  String get securitySubtitle => 'Proteger con contraseña · Desproteger · Comprimir';
  @override
  String get extrasTitle => 'Extras';
  @override
  String get extrasSubtitle => 'OCR · Comparar PDFs · Reparar PDF dañado';

  @override
  String get processing => 'Procesando...';
  @override
  String get done => '¡Listo!';
  @override
  String errorMessage(String error) => 'Error: $error';
  @override
  String get open => 'Abrir';
  @override
  String get share => 'Compartir';
  @override
  String get noFileSelected => 'Ningún archivo seleccionado';
  @override
  String get select => 'Elegir';
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
  String get modeText => 'Texto';
  @override
  String get modeVisual => 'Visual';
  @override
  String get visualHint => 'Selecciona un PDF para ver sus hojas';

  @override
  String get organizationPageTitle => 'Organización';
  @override
  String get mergeTitle => 'Combinar PDFs';
  @override
  String get selectPdfsMultiple => 'Seleccionar PDFs (varios)';
  @override
  String filesSelected(int n) => '$n archivos seleccionados';
  @override
  String get mergeButton => 'Combinar';

  @override
  String get splitTitle => 'Dividir PDF';
  @override
  String get rangesLabel => 'Rangos de páginas (ej. 1-3,4-6 o 1,2,3)';
  @override
  String get splitButton => 'Dividir';
  @override
  String get visualSplitHint =>
      'Toca las hojas de la parte actual y luego agrégala:';
  @override
  String partLabel(int n, String pages) => 'Parte $n: $pages';
  @override
  String get addPartButton => 'Agregar como nueva parte';
  @override
  String partResultLabel(int n, String filename) => 'Parte $n: $filename';

  @override
  String get removeTitle => 'Quitar Páginas';
  @override
  String get removePagesLabel => 'Números de página a quitar (ej. 2,4,7)';
  @override
  String get removeButton => 'Quitar Páginas';

  @override
  String get extractTitle => 'Extraer Páginas';
  @override
  String get extractPagesLabel => 'Páginas a extraer (ej. 1,3,5)';
  @override
  String get extractButton => 'Extraer Páginas';

  @override
  String get reorderTitle => 'Reordenar Páginas';
  @override
  String get reorderLabel =>
      'Nuevo orden (ej. 3,1,2 mueve la página 3 al inicio)';
  @override
  String get reorderButton => 'Reordenar';
  @override
  String get reorderVisualHint =>
      'Mantén presionada una hoja y arrástrala para reordenar:';

  @override
  String get rotateTitle => 'Rotar Páginas';
  @override
  String get rotatePagesLabel =>
      'Páginas a rotar (ej. 1,2 o déjalo vacío para todas)';
  @override
  String get rotateButton => 'Rotar';

  @override
  String get conversionPageTitle => 'Conversión';
  @override
  String get pdfToImagesTitle => 'PDF → JPG/Imágenes';
  @override
  String get convertToImagesButton => 'Convertir a Imágenes';
  @override
  String get imagesToPdfTitle => 'Imágenes → PDF';
  @override
  String get selectImagesMultiple => 'Seleccionar Imágenes (varias)';
  @override
  String imagesSelected(int n) => '$n imágenes seleccionadas';
  @override
  String get createPdfButton => 'Crear PDF';
  @override
  String get pdfToWordTitle => 'PDF → Word (.docx)';
  @override
  String get pdfToWordDesc => 'Extrae el texto y crea un documento de Word.';
  @override
  String get convertToWordButton => 'Convertir a Word';
  @override
  String get pdfToExcelTitle => 'PDF → Excel (.xlsx)';
  @override
  String get pdfToExcelDesc => 'Extrae el texto en filas de hoja de cálculo.';
  @override
  String get convertToExcelButton => 'Convertir a Excel';
  @override
  String get pdfToPptTitle => 'PDF → PowerPoint (.pptx)';
  @override
  String get pdfToPptDesc => 'Cada bloque de texto se convierte en una diapositiva.';
  @override
  String get convertToPptButton => 'Convertir a PowerPoint';
  @override
  String get htmlToPdfTitle => 'HTML → PDF';
  @override
  String get htmlToPdfHint => 'Pega aquí el contenido HTML';
  @override
  String get convertToPdfButton => 'Convertir a PDF';

  @override
  String get editingPageTitle => 'Edición';
  @override
  String get pageNumbersTitle => 'Agregar Números de Página';
  @override
  String get positionBottomCenter => 'Centro Inferior';
  @override
  String get positionBottomRight => 'Inferior Derecha';
  @override
  String get positionTopCenter => 'Centro Superior';
  @override
  String get addPageNumbersButton => 'Agregar Números de Página';
  @override
  String get overlayTitle => 'Agregar Texto / Marca de Agua';
  @override
  String get overlayTextLabel => 'Texto a superponer';
  @override
  String get fontSizeLabel => 'Tamaño de fuente:';
  @override
  String get opacityLabel => 'Opacidad:';
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
  String get compressButton => 'Comprimir';

  @override
  String get extrasPageTitle => 'Extras';
  @override
  String get ocrTitle => 'OCR — PDF Escaneado → Texto Seleccionable';
  @override
  String get ocrDesc =>
      'Convierte cada página en imagen y aplica reconocimiento de texto con ML Kit.';
  @override
  String get runOcrButton => 'Ejecutar OCR';
  @override
  String get compareTitle => 'Comparar PDFs';
  @override
  String get compareDesc =>
      'Extrae el texto de ambos PDFs y compara línea por línea.';
  @override
  String get pdf1Label => 'PDF 1 — no seleccionado';
  @override
  String get pdf2Label => 'PDF 2 — no seleccionado';
  @override
  String get compareButton => 'Comparar';
  @override
  String get repairTitle => 'Reparar PDF Dañado';
  @override
  String get repairDesc =>
      'Intenta cargar y volver a guardar el PDF, reconstruyendo su estructura.';
  @override
  String get repairButton => 'Reparar PDF';
}
