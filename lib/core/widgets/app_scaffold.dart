import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Header compartido: botón atrás opcional + título, sin cromo de color
/// — la identidad de marca vive en los botones de acción (rojo) y en el
/// acento de categoría dentro del contenido, no en la barra superior.
class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  /// Color del título — el color de categoría en pantallas de herramienta,
  /// para que "los textos sean del color que corresponde su función".
  final Color? titleColor;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.titleColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      // Scaffold solo reserva espacio extra para el notch/status bar sobre
      // un appBar personalizado — no empuja su contenido hacia abajo por
      // sí solo (eso sí lo hace el AppBar de Material). Sin este SafeArea
      // el título queda debajo del reloj / batería del sistema.
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Row(
            children: [
              if (showBack)
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back, size: 22),
                  color: AppColors.textPrimary,
                )
              else
                const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: titleColor ?? AppColors.textPrimary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (actions != null) ...actions!,
              const SizedBox(width: 4),
            ],
          ),
        ),
      ),
    );
  }
}

/// Scaffold estándar para una pantalla de herramienta: el título del
/// header y el ícono del picker/slider/páginas seleccionadas heredan el
/// acento de categoría vía [AccentScope] — el fondo se mantiene azul
/// marino siempre, el acento nunca tiñe superficies, solo texto/contorno.
class OperationScaffold extends StatelessWidget {
  final String title;
  final Color accent;
  final List<Widget> children;

  const OperationScaffold({
    super.key,
    required this.title,
    required this.accent,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AccentScope(
      color: accent,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppHeader(title: title, titleColor: accent),
        body: SafeArea(
          top: false,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            itemCount: children.length,
            separatorBuilder: (_, _) => const SizedBox(height: 20),
            itemBuilder: (_, i) => children[i],
          ),
        ),
      ),
    );
  }
}

/// Etiqueta pequeña, mayúscula, en el color de categoría — encabezado de
/// una sección dentro de una pantalla de herramienta (p. ej. "Posición").
class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2),
      ),
    );
  }
}
