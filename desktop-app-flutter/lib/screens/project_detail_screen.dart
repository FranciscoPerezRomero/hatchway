import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/project_api.dart';
import '../models/client_info.dart';
import '../models/feature.dart';
import '../models/payment_record.dart';
import '../models/project.dart';
import '../models/tech_category.dart';
import '../state/project_store.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/slug.dart';
import '../utils/validators.dart';
import '../widgets/project_form/chip_list_field.dart';
import '../widgets/project_form/feature_editor.dart';
import '../widgets/project_form/image_picker_field.dart';
import '../widgets/project_form/payments_table.dart';
import '../widgets/project_form/requirements_list.dart';
import '../widgets/project_form/tech_category_editor.dart';

/// Vista dedicada de creación/edición de proyecto — pantalla completa
/// (no modal), con tabs DETALLES / CLIENTE / PAGOS. Reemplaza el antiguo
/// panel lateral: llenar la info de un proyecto ahora vive en su propia
/// vista, separada de la galería, tal como se definió en los wireframes.
class ProjectDetailScreen extends StatefulWidget {
  final Project? initial;
  final VoidCallback onBack;

  const ProjectDetailScreen({super.key, this.initial, required this.onBack});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  // ── Controllers de texto (Detalles — igual contrato que el backend) ──
  late final _title = TextEditingController(text: widget.initial?.title ?? '');
  late final _slug = TextEditingController(text: widget.initial?.slug ?? '');
  late final _tagline = TextEditingController(text: widget.initial?.tagline ?? '');
  late final _ctaPrimaryLabel = TextEditingController(text: widget.initial?.ctaPrimaryLabel ?? '');
  late final _ctaPrimaryUrl = TextEditingController(text: widget.initial?.ctaPrimaryUrl ?? '');
  late final _ctaSecondaryLabel = TextEditingController(text: widget.initial?.ctaSecondaryLabel ?? '');
  late final _ctaSecondaryUrl = TextEditingController(text: widget.initial?.ctaSecondaryUrl ?? '');
  late final _repositoryUrl = TextEditingController(text: widget.initial?.repositoryUrl ?? '');
  late final _role = TextEditingController(text: widget.initial?.role ?? '');
  late final _client = TextEditingController(text: widget.initial?.client ?? '');
  late final _duration = TextEditingController(text: widget.initial?.duration ?? '');
  late final _teamSize = TextEditingController(text: widget.initial?.teamSize ?? '');
  late final _challenge1 = TextEditingController(text: widget.initial?.challengeParagraph1 ?? '');
  late final _challenge2 = TextEditingController(text: widget.initial?.challengeParagraph2 ?? '');
  late final _cardShortDescription = TextEditingController(text: widget.initial?.cardShortDescription ?? '');
  late final _seoTitle = TextEditingController(text: widget.initial?.seoTitle ?? '');
  late final _seoDescription = TextEditingController(text: widget.initial?.seoDescription ?? '');
  late final _order = TextEditingController(text: (widget.initial?.order ?? 0).toString());
  late final _year = TextEditingController(text: widget.initial?.year?.toString() ?? '');

  late String _projectType = widget.initial?.projectType ?? 'web_app';
  late String? _status = widget.initial?.status;
  late bool _isPublished = widget.initial?.isPublished ?? false;
  late bool _isFeatured = widget.initial?.isFeatured ?? false;
  late bool _slugLocked = (widget.initial?.slug ?? '').isNotEmpty;

  // Campos dinámicos/opcionales — se pueden dejar vacíos, llenar parcial
  // o agregar de uno en uno, igual que en la versión Electron.
  late List<String> _keyChallenges = [...?widget.initial?.keyChallenges];
  late List<String> _tags = [...?widget.initial?.tags];
  late List<String> _metrics = [...?widget.initial?.metrics];
  final List<String> _screenshots = [];
  late List<Feature> _features = widget.initial?.features
          .map((f) => Feature(title: f.title, description: f.description))
          .toList() ??
      [];
  late List<TechCategory> _techStack = widget.initial?.techStack
          .map((t) => TechCategory(category: t.category, technologies: [...t.technologies]))
          .toList() ??
      [];

  String? _heroImageUrl;
  String? _cardThumbnailUrl;
  String? _mainScreenshotUrl;
  String? _heroFilePath;
  String? _cardFilePath;
  String? _mainScreenshotFilePath;
  final List<String> _newScreenshotPaths = [];

  // ── Cliente / Pagos — concepto local, no viaja al backend ──
  final ClientInfo _clientInfo = ClientInfo();
  late final _clientName = TextEditingController();
  late final _clientCompany = TextEditingController();
  late final _clientEmail = TextEditingController();
  late final _clientPhone = TextEditingController();
  final PaymentInfo _paymentInfo = PaymentInfo();
  late final _totalCost = TextEditingController();
  late final _monthlyPayment = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _screenshots.addAll(widget.initial?.screenshots ?? []);
    _heroImageUrl = widget.initial?.heroImageUrl;
    _cardThumbnailUrl = widget.initial?.cardThumbnailUrl;
    _mainScreenshotUrl = widget.initial?.mainScreenshotUrl;
    _title.addListener(_onTitleChanged);
  }

  void _onTitleChanged() {
    if (!_slugLocked) _slug.text = generateSlug(_title.text);
  }

  @override
  void dispose() {
    _title.removeListener(_onTitleChanged);
    for (final c in [
      _title, _slug, _tagline, _ctaPrimaryLabel, _ctaPrimaryUrl, _ctaSecondaryLabel,
      _ctaSecondaryUrl, _repositoryUrl, _role, _client, _duration, _teamSize,
      _challenge1, _challenge2, _cardShortDescription, _seoTitle, _seoDescription,
      _order, _year, _clientName, _clientCompany, _clientEmail, _clientPhone,
      _totalCost, _monthlyPayment,
    ]) {
      c.dispose();
    }
    _tabController.dispose();
    super.dispose();
  }

  static String? _emptyToNull(String v) => v.trim().isEmpty ? null : v.trim();

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final store = context.read<ProjectStore>();
    final api = context.read<ProjectApi>();

    var payload = Project(
      id: widget.initial?.id,
      slug: _slug.text.trim(),
      order: int.tryParse(_order.text) ?? 0,
      projectType: _projectType,
      isPublished: _isPublished,
      isFeatured: _isFeatured,
      title: _title.text.trim(),
      tagline: _emptyToNull(_tagline.text),
      heroImageUrl: _heroImageUrl,
      ctaPrimaryLabel: _emptyToNull(_ctaPrimaryLabel.text),
      ctaPrimaryUrl: _emptyToNull(_ctaPrimaryUrl.text),
      ctaSecondaryLabel: _emptyToNull(_ctaSecondaryLabel.text),
      ctaSecondaryUrl: _emptyToNull(_ctaSecondaryUrl.text),
      repositoryUrl: _emptyToNull(_repositoryUrl.text),
      role: _emptyToNull(_role.text),
      year: int.tryParse(_year.text),
      status: _status,
      client: _emptyToNull(_client.text),
      duration: _emptyToNull(_duration.text),
      teamSize: _emptyToNull(_teamSize.text),
      challengeParagraph1: _emptyToNull(_challenge1.text),
      challengeParagraph2: _emptyToNull(_challenge2.text),
      keyChallenges: _keyChallenges,
      techStack: _techStack,
      features: _features,
      metrics: _metrics,
      mainScreenshotUrl: _mainScreenshotUrl,
      screenshots: _screenshots,
      cardThumbnailUrl: _cardThumbnailUrl,
      cardShortDescription: _emptyToNull(_cardShortDescription.text),
      tags: _tags,
      seoTitle: _emptyToNull(_seoTitle.text),
      seoDescription: _emptyToNull(_seoDescription.text),
    ).toCreateJson();

    // Path B (genérico, ANTES de crear/actualizar): main screenshot + nuevas screenshots.
    if (_mainScreenshotFilePath != null) {
      try {
        payload['main_screenshot_url'] = await api.uploadGeneric(_mainScreenshotFilePath!);
      } catch (_) {
        _toast('No se pudo subir la imagen principal de galería.');
      }
    }
    if (_newScreenshotPaths.isNotEmpty) {
      final urls = <String>[];
      for (final path in _newScreenshotPaths) {
        try {
          urls.add(await api.uploadGeneric(path));
        } catch (_) {
          _toast('Una de las screenshots no se pudo subir.');
        }
      }
      payload['screenshots'] = [...(payload['screenshots'] as List? ?? []), ...urls];
    }

    Project? saved;
    if (widget.initial?.id == null) {
      saved = await store.createProject(payload);
    } else {
      await store.updateProject(widget.initial!.id!, payload);
      saved = store.projects.firstWhere((p) => p.id == widget.initial!.id, orElse: () => Project());
    }

    if (saved == null || saved.id == null) {
      setState(() => _saving = false);
      return;
    }
    final id = saved.id!;

    // Path A (hero/card, DESPUÉS de crear/actualizar), independientes entre sí.
    if (_heroFilePath != null) {
      try {
        final url = await api.uploadProjectImage(id, _heroFilePath!, 'hero');
        store.setImage(id, 'hero_image_url', url);
      } catch (_) {
        _toast('Proyecto guardado, pero la imagen hero no se pudo subir.');
      }
    }
    if (_cardFilePath != null) {
      try {
        final url = await api.uploadProjectImage(id, _cardFilePath!, 'card');
        store.setImage(id, 'card_thumbnail_url', url);
      } catch (_) {
        _toast('Proyecto guardado, pero el thumbnail no se pudo subir.');
      }
    }

    if (!mounted) return;
    setState(() => _saving = false);
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTopBar(),
        _buildTabBar(),
        Expanded(
          child: Form(
            key: _formKey,
            child: TabBarView(
              controller: _tabController,
              children: [
                _scrollPad(_buildDetallesTab()),
                _scrollPad(_buildClienteTab()),
                _scrollPad(_buildPagosTab()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _scrollPad(Widget child) => SingleChildScrollView(padding: const EdgeInsets.all(AppSpacing.xxxl), child: child);

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl, vertical: AppSpacing.xl),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderDim, width: 1.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: widget.onBack,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: const BoxDecoration(border: Border.fromBorderSide(BorderSide(color: AppColors.borderDim, width: 1.5))),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_back, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.xs),
                      Text('VOLVER', style: AppTypography.mono(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _title.text.trim().isEmpty ? (widget.initial == null ? 'NUEVO PROYECTO' : widget.initial!.title.toUpperCase()) : _title.text.toUpperCase(),
                    style: AppTypography.display(fontSize: 26),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _badge(_projectType.toUpperCase().replaceAll('_', ' '), AppColors.borderDim, AppColors.textSecondary),
                      const SizedBox(width: AppSpacing.xs),
                      _badge(_isPublished ? 'PUBLICADO' : 'BORRADOR', _isPublished ? AppColors.neonGreen : AppColors.borderDim, _isPublished ? AppColors.neonGreen : AppColors.textMuted),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(boxShadow: AppColors.hardShadow(offset: 4)),
            child: ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: Text(_saving ? 'GUARDANDO…' : '▸ GUARDAR PROYECTO'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color borderColor, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(border: Border.all(color: borderColor, width: 1)),
      child: Text(text, style: AppTypography.mono(fontSize: 10, color: fg)),
    );
  }

  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxl),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderDim, width: 1.5))),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: const [Tab(text: 'DETALLES'), Tab(text: 'CLIENTE'), Tab(text: 'PAGOS')],
      ),
    );
  }

  Widget _conceptNotice(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xl),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: AppColors.neonRed.withValues(alpha: 0.06), border: Border.all(color: AppColors.neonRed, width: 1)),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 14, color: AppColors.neonRed),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(text, style: AppTypography.mono(fontSize: 11, color: AppColors.neonRed))),
        ],
      ),
    );
  }

  // ── Tab: Detalles (dos columnas, igual contrato de datos que hoy) ──
  Widget _buildDetallesTab() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _section('GENERAL', _generalFields()),
              _section('HERO', _heroFields()),
              _section('METADATA', _metadataFields()),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xxl),
        Expanded(
          child: Column(
            children: [
              _section('CONTENIDO', _contenidoFields()),
              _section('TECH STACK', _buildTechStackSection()),
              _section('GALERÍA & CARD', _galleryCardFields()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _section(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xxl),
      decoration: BoxDecoration(color: AppColors.surfaceBlock.withValues(alpha: 0.4), border: Border.all(color: AppColors.borderDim, width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.borderDim, width: 1.5), left: BorderSide(color: AppColors.neonRed, width: 3))),
            child: Text(title, style: AppTypography.sectionTitle()),
          ),
          Padding(padding: const EdgeInsets.all(AppSpacing.lg), child: child),
        ],
      ),
    );
  }

  Widget _generalFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field('Título *  — nombre del proyecto tal como aparece en el portafolio', TextFormField(controller: _title, style: AppTypography.sans(fontSize: 13), validator: (v) => requiredField(v, 'El título es requerido'), onChanged: (_) => setState(() {})), ),
        _field(
          _slugLocked ? 'Slug *  — URL del proyecto (/proyectos/tu-slug)' : 'Slug *  //auto — se genera del título hasta que lo edites a mano',
          TextFormField(
            controller: _slug,
            style: AppTypography.sans(fontSize: 13),
            validator: (v) => requiredField(v, 'El slug es requerido'),
            onChanged: (v) => setState(() => _slugLocked = v.isNotEmpty && v != generateSlug(_title.text)),
          ),
        ),
        Row(
          children: [
            Expanded(child: _field('Orden — posición en la grilla del portafolio (0 = primero)', TextFormField(controller: _order, keyboardType: TextInputType.number, style: AppTypography.sans(fontSize: 13)))),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _field('Tipo de proyecto', DropdownButtonFormField<String>(
                value: _projectType,
                items: kProjectTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                onChanged: (v) => setState(() => _projectType = v ?? 'web_app'),
                style: AppTypography.sans(fontSize: 13, color: AppColors.textPrimary),
                dropdownColor: AppColors.surfaceBlockAlt,
              )),
            ),
          ],
        ),
        Row(
          children: [
            _checkbox('Publicado — visible en el portafolio público', _isPublished, (v) => setState(() => _isPublished = v)),
            const SizedBox(width: AppSpacing.xxl),
            _checkbox('Destacado — aparece primero/resaltado', _isFeatured, (v) => setState(() => _isFeatured = v)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('// SEO (opcional)', style: AppTypography.sectionTitle()),
        const SizedBox(height: AppSpacing.sm),
        _field('Título SEO — vacío usa el título de arriba', TextFormField(controller: _seoTitle, style: AppTypography.sans(fontSize: 13))),
        _field('Descripción SEO — vacío usa el tagline', TextFormField(controller: _seoDescription, maxLines: 2, style: AppTypography.sans(fontSize: 13))),
      ],
    );
  }

  Widget _heroFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _field('Tagline — 1-2 líneas cortas para el hero', TextFormField(controller: _tagline, maxLines: 2, style: AppTypography.sans(fontSize: 13))),
        ImagePickerField(
          labelText: 'Imagen hero — banner grande a la derecha del título',
          localFilePath: _heroFilePath,
          existingUrl: _heroImageUrl,
          onFilePicked: (path) => setState(() => _heroFilePath = path),
          onCleared: () => setState(() {
            _heroFilePath = null;
            _heroImageUrl = null;
          }),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('// CTAs (opcionales)', style: AppTypography.sectionTitle()),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(child: _field('Texto CTA primario', TextFormField(controller: _ctaPrimaryLabel, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: 'live_demo() →')))),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _field('URL CTA primario', TextFormField(controller: _ctaPrimaryUrl, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: 'https://...')))),
          ],
        ),
        Row(
          children: [
            Expanded(child: _field('Texto CTA secundario', TextFormField(controller: _ctaSecondaryLabel, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: 'source_code() →')))),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _field('URL CTA secundario', TextFormField(controller: _ctaSecondaryUrl, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: 'https://...')))),
          ],
        ),
        _field('Repositorio — link a GitHub, opcional', TextFormField(controller: _repositoryUrl, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: 'https://github.com/...'))),
      ],
    );
  }

  Widget _metadataFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _field('Rol desempeñado', TextFormField(controller: _role, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: 'Full-Stack Developer')))),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _field('Año', TextFormField(controller: _year, keyboardType: TextInputType.number, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: '2025')))),
          ],
        ),
        _field('Estado — pill cosmética visible en la card (no afecta si está publicado)', DropdownButtonFormField<String?>(
          value: _status,
          items: [
            const DropdownMenuItem(value: null, child: Text('— Sin especificar —')),
            ...kProjectStatuses.map((s) => DropdownMenuItem(value: s, child: Text(s))),
          ],
          onChanged: (v) => setState(() => _status = v),
          style: AppTypography.sans(fontSize: 13, color: AppColors.textPrimary),
          dropdownColor: AppColors.surfaceBlockAlt,
        )),
        Row(
          children: [
            Expanded(child: _field('Cliente / Contexto — texto libre para la card', TextFormField(controller: _client, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: 'Personal Project')))),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: _field('Duración', TextFormField(controller: _duration, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: '3 Months')))),
          ],
        ),
        _field('Tamaño del equipo', TextFormField(controller: _teamSize, style: AppTypography.sans(fontSize: 13), decoration: const InputDecoration(hintText: 'Solo / 2 developers'))),
      ],
    );
  }

  Widget _contenidoFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// THE CHALLENGE (opcional)', style: AppTypography.sectionTitle()),
        const SizedBox(height: AppSpacing.sm),
        _field('Párrafo 1 — contexto del reto', TextFormField(controller: _challenge1, maxLines: 3, style: AppTypography.sans(fontSize: 13))),
        _field('Párrafo 2 — solución adoptada', TextFormField(controller: _challenge2, maxLines: 3, style: AppTypography.sans(fontSize: 13))),
        const SizedBox(height: AppSpacing.sm),
        Text('// KEY CHALLENGES — máx 4, se puede dejar vacío', style: AppTypography.sectionTitle()),
        const SizedBox(height: AppSpacing.sm),
        ChipListField(items: _keyChallenges, maxItems: 4, hintText: 'Reto clave — Enter para agregar', onChanged: (v) => setState(() => _keyChallenges = v)),
        const SizedBox(height: AppSpacing.lg),
        Text('// KEY FEATURES — máx 3, agrega solo las que apliquen', style: AppTypography.sectionTitle()),
        const SizedBox(height: AppSpacing.sm),
        FeatureEditor(features: _features, onChanged: (v) => setState(() => _features = v)),
      ],
    );
  }

  Widget _buildTechStackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Opcional — puedes dejarlo vacío, agregar una sola categoría con una sola tecnología, o varias.', style: AppTypography.sans(fontSize: 11, color: AppColors.textMuted)),
        const SizedBox(height: AppSpacing.md),
        TechCategoryEditor(categories: _techStack, onChanged: (v) => setState(() => _techStack = v)),
      ],
    );
  }

  Widget _galleryCardFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('// GALERÍA (opcional)', style: AppTypography.sectionTitle()),
        const SizedBox(height: AppSpacing.sm),
        ImagePickerField(
          labelText: 'Screenshot principal — imagen grande en la página del proyecto',
          localFilePath: _mainScreenshotFilePath,
          existingUrl: _mainScreenshotUrl,
          onFilePicked: (path) => setState(() => _mainScreenshotFilePath = path),
          onCleared: () => setState(() {
            _mainScreenshotFilePath = null;
            _mainScreenshotUrl = null;
          }),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Screenshots secundarias — cualquier cantidad', style: AppTypography.label()),
        const SizedBox(height: AppSpacing.sm),
        if (_screenshots.isNotEmpty || _newScreenshotPaths.isNotEmpty) _screenshotsGrid(),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () async {
            final path = await pickImageFile(context);
            if (path != null) setState(() => _newScreenshotPaths.add(path));
          },
          icon: const Icon(Icons.add_photo_alternate_outlined, size: 16),
          label: Text('Agregar screenshot', style: AppTypography.mono(fontSize: 12)),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Métricas de impacto — máx 4, opcional', style: AppTypography.label()),
        const SizedBox(height: AppSpacing.sm),
        ChipListField(items: _metrics, maxItems: 4, hintText: 'Ej: 50k usuarios activos', onChanged: (v) => setState(() => _metrics = v)),
        const SizedBox(height: AppSpacing.lg),
        Text('// CARD DEL LISTADO', style: AppTypography.sectionTitle()),
        const SizedBox(height: AppSpacing.sm),
        ImagePickerField(
          labelText: 'Thumbnail de la card — distinto a la imagen hero',
          localFilePath: _cardFilePath,
          existingUrl: _cardThumbnailUrl,
          onFilePicked: (path) => setState(() => _cardFilePath = path),
          onCleared: () => setState(() {
            _cardFilePath = null;
            _cardThumbnailUrl = null;
          }),
        ),
        _field('Descripción corta — máx ~120 caracteres', TextFormField(controller: _cardShortDescription, maxLength: 120, style: AppTypography.sans(fontSize: 13))),
        Text('Tags visibles en la card — opcional', style: AppTypography.label()),
        const SizedBox(height: AppSpacing.sm),
        ChipListField(items: _tags, hintText: 'Tag — Enter para agregar', onChanged: (v) => setState(() => _tags = v)),
      ],
    );
  }

  Widget _screenshotsGrid() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final url in _screenshots) _thumb(url: url, isLocal: false, onRemove: () => setState(() => _screenshots.remove(url))),
        for (final path in _newScreenshotPaths) _thumb(url: path, isLocal: true, isNew: true, onRemove: () => setState(() => _newScreenshotPaths.remove(path))),
      ],
    );
  }

  Widget _thumb({required String url, required bool isLocal, bool isNew = false, required VoidCallback onRemove}) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: AppColors.borderDim, width: 1)),
          child: SizedBox(height: 80, width: 110, child: isLocal ? Image.file(File(url), fit: BoxFit.cover) : Image.network(url, fit: BoxFit.cover)),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.8), border: Border.all(color: AppColors.borderDim, width: 1)),
              child: const Icon(Icons.close, size: 11, color: Colors.white),
            ),
          ),
        ),
        if (isNew)
          Positioned(
            bottom: 4,
            left: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(color: AppColors.neonRed.withValues(alpha: 0.9)),
              child: Text('nuevo', style: AppTypography.mono(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
      ],
    );
  }

  // ── Tab: Cliente (concepto local) ──
  Widget _buildClienteTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _conceptNotice('CONCEPTO — esta información se guarda solo mientras el proyecto está abierto. Aún no hay tabla de clientes en el servidor.'),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _section('DATOS DEL CLIENTE', Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _field('Nombre', TextFormField(controller: _clientName, style: AppTypography.sans(fontSize: 13), onChanged: (v) => _clientInfo.name = v)),
                  _field('Empresa', TextFormField(controller: _clientCompany, style: AppTypography.sans(fontSize: 13), onChanged: (v) => _clientInfo.company = v)),
                  Row(
                    children: [
                      Expanded(child: _field('Email', TextFormField(controller: _clientEmail, style: AppTypography.sans(fontSize: 13), onChanged: (v) => _clientInfo.email = v))),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _field('Teléfono', TextFormField(controller: _clientPhone, style: AppTypography.sans(fontSize: 13), onChanged: (v) => _clientInfo.phone = v))),
                    ],
                  ),
                ],
              )),
            ),
            const SizedBox(width: AppSpacing.xxl),
            Expanded(
              child: _section('LISTA DE REQUERIMIENTOS', RequirementsList(
                items: _clientInfo.requirements,
                onChanged: (v) => setState(() => _clientInfo.requirements = v),
              )),
            ),
          ],
        ),
      ],
    );
  }

  // ── Tab: Pagos (concepto local) ──
  Widget _buildPagosTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _conceptNotice('CONCEPTO — vista previa de cómo se vería el control de pagos. Aún no se guarda en el servidor.'),
        Row(
          children: [
            Expanded(child: _metricCard('COSTO TOTAL', _totalCost.text.isEmpty ? '—' : _totalCost.text, AppColors.neonRed)),
            const SizedBox(width: AppSpacing.lg),
            Expanded(child: _metricCard('PAGADO', _paymentInfo.paidTotal == 0 ? '—' : '\$${_paymentInfo.paidTotal.toStringAsFixed(0)}', AppColors.neonGreen)),
            const SizedBox(width: AppSpacing.lg),
            Expanded(child: _metricCard('RESTANTE', _paymentInfo.remaining == 0 ? '—' : '\$${_paymentInfo.remaining.toStringAsFixed(0)}', AppColors.neonAmber)),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        Row(
          children: [
            Expanded(
              child: _field('Costo total del proyecto', TextFormField(
                controller: _totalCost,
                style: AppTypography.sans(fontSize: 13),
                decoration: const InputDecoration(hintText: r'$0.00'),
                onChanged: (v) => setState(() => _paymentInfo.totalCost = v),
              )),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _field('Pago mensual', TextFormField(
                controller: _monthlyPayment,
                style: AppTypography.sans(fontSize: 13),
                decoration: const InputDecoration(hintText: r'$0.00'),
                onChanged: (v) => _paymentInfo.monthlyPayment = v,
              )),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        _section('REGISTRO DE PAGOS', PaymentsTable(
          entries: _paymentInfo.entries,
          onChanged: (v) => setState(() => _paymentInfo.entries = v),
        )),
      ],
    );
  }

  Widget _metricCard(String label, String value, Color accent) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(color: AppColors.surfaceBlock.withValues(alpha: 0.4), border: Border(left: BorderSide(color: accent, width: 3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.mono(fontSize: 10, color: AppColors.textSecondary, letterSpacing: 1)),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: AppTypography.display(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _field(String label, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTypography.label()),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }

  Widget _checkbox(String label, bool value, ValueChanged<bool> onChanged) {
    return Expanded(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Row(
          children: [
            Checkbox(value: value, onChanged: (v) => onChanged(v ?? false), activeColor: AppColors.neonRed),
            Expanded(child: Text(label, style: AppTypography.sans(fontSize: 12, color: AppColors.textPrimary))),
          ],
        ),
      ),
    );
  }
}
