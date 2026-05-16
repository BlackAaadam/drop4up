import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:ui' as ui;

import 'data/drop4up_preferences_repository.dart';
import 'data/reflection_entry_repository.dart';
import 'data/profile_backup_file_service.dart';
import 'data/visual_card_share_service.dart';
import 'screens/drop_screen.dart';
import 'screens/home_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/profile_screen.dart';
import 'state/drop4up_preferences_controller.dart';
import 'state/drop4up_preferences_scope.dart';
import 'state/reflection_entries_controller.dart';
import 'state/reflection_entries_scope.dart';
import 'ui/drop4up_scaffold.dart';
import 'ui/drop4up_tokens.dart';
import 'ui/primary_drop_button.dart';
import 'ui/soft_icon_button.dart';
import 'ui/soft_surface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _installFrameTimingLogger();
  runApp(const Drop4UpPreviewApp());
}

void _installFrameTimingLogger() {
  const enabled = bool.fromEnvironment('DROP4UP_FRAME_LOG');
  if (!enabled) {
    return;
  }

  SchedulerBinding.instance.addTimingsCallback((timings) {
    for (final timing in timings) {
      final buildMs = timing.buildDuration.inMicroseconds / 1000;
      final rasterMs = timing.rasterDuration.inMicroseconds / 1000;
      final vsyncMs = timing.vsyncOverhead.inMicroseconds / 1000;
      final buildToRasterMs =
          (timing.timestampInMicroseconds(ui.FramePhase.rasterStart) -
              timing.timestampInMicroseconds(ui.FramePhase.buildFinish)) /
          1000;
      final totalMs = timing.totalSpan.inMicroseconds / 1000;
      if (buildMs < 8 && rasterMs < 8 && totalMs < 16) {
        continue;
      }
      debugPrint(
        'Drop4UpFrame '
        'vsyncMs=${vsyncMs.toStringAsFixed(1)} '
        'buildMs=${buildMs.toStringAsFixed(1)} '
        'buildToRasterMs=${buildToRasterMs.toStringAsFixed(1)} '
        'rasterMs=${rasterMs.toStringAsFixed(1)} '
        'totalMs=${totalMs.toStringAsFixed(1)} '
        'layerCache=${timing.layerCacheCount}/${timing.layerCacheMegabytes.toStringAsFixed(1)}MB '
        'pictureCache=${timing.pictureCacheCount}',
      );
    }
  });
}

class Drop4UpPreviewApp extends StatefulWidget {
  const Drop4UpPreviewApp({
    super.key,
    this.repository,
    this.preferencesRepository,
    this.profileBackupFileService,
    this.visualCardShareService,
    this.visualCardPngCapture,
    this.clock,
    this.idGenerator,
  });

  final ReflectionEntryRepository? repository;
  final Drop4UpPreferencesRepository? preferencesRepository;
  final ProfileBackupFileService? profileBackupFileService;
  final VisualCardShareService? visualCardShareService;
  final VisualCardPngCapture? visualCardPngCapture;
  final ReflectionClock? clock;
  final ReflectionIdGenerator? idGenerator;

  @override
  State<Drop4UpPreviewApp> createState() => _Drop4UpPreviewAppState();
}

class _Drop4UpPreviewAppState extends State<Drop4UpPreviewApp> {
  late final ReflectionEntriesController _entriesController;
  late final Drop4UpPreferencesController _preferencesController;

  @override
  void initState() {
    super.initState();
    _entriesController = ReflectionEntriesController(
      repository: widget.repository ?? ReflectionEntryRepository(),
      clock: widget.clock,
      idGenerator: widget.idGenerator,
    );
    _preferencesController = Drop4UpPreferencesController(
      repository:
          widget.preferencesRepository ?? Drop4UpPreferencesRepository(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entriesController.load();
      _preferencesController.load();
    });
  }

  @override
  void dispose() {
    _entriesController.dispose();
    _preferencesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ReflectionEntriesScope(
      controller: _entriesController,
      child: Drop4UpPreferencesScope(
        controller: _preferencesController,
        child: AnimatedBuilder(
          animation: _preferencesController,
          builder: (context, _) {
            final textScale = _preferencesController.preferences.largeText
                ? 1.08
                : 1.0;
            final textTheme = Drop4UpTokens.textTheme(textScale: textScale);

            return MaterialApp(
              title: 'Drop4Up',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                useMaterial3: true,
                scaffoldBackgroundColor: Drop4UpTokens.background,
                textTheme: textTheme,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: Drop4UpTokens.primaryBlue,
                  surface: Drop4UpTokens.cardSurface,
                ),
              ),
              home: ShellPreviewScreen(
                profileBackupFileService: widget.profileBackupFileService,
                visualCardShareService: widget.visualCardShareService,
                visualCardPngCapture: widget.visualCardPngCapture,
              ),
            );
          },
        ),
      ),
    );
  }
}

class ShellPreviewScreen extends StatefulWidget {
  const ShellPreviewScreen({
    super.key,
    this.profileBackupFileService,
    this.visualCardShareService,
    this.visualCardPngCapture,
  });

  final ProfileBackupFileService? profileBackupFileService;
  final VisualCardShareService? visualCardShareService;
  final VisualCardPngCapture? visualCardPngCapture;

  @override
  State<ShellPreviewScreen> createState() => _ShellPreviewScreenState();
}

class _ShellPreviewScreenState extends State<ShellPreviewScreen> {
  int _tabIndex = 0;
  String? _initialJournalFilter;
  final DropDraftController _dropDraftController = DropDraftController();

  static const _tabs = [
    _ShellTab('Home', 'Visual reflection placeholder'),
    _ShellTab('Drop', 'Quick capture placeholder'),
    _ShellTab('Journal', 'Search and organize placeholder'),
    _ShellTab('Profile', 'Settings and data placeholder'),
  ];

  @override
  Widget build(BuildContext context) {
    final tab = _tabs[_tabIndex];

    return Drop4UpScaffold(
      currentIndex: _tabIndex,
      onTabChanged: (index) => setState(() => _tabIndex = index),
      body: switch (_tabIndex) {
        0 => HomeScreen(
          onOpenJournalAll: _openJournalAll,
          onOpenJournalTag: _openJournalTag,
          onOpenProfile: _openProfile,
        ),
        1 => DropScreen(
          draftController: _dropDraftController,
          onOpenProfile: _openProfile,
        ),
        2 => JournalScreen(
          initialTaxonomyFilter: _initialJournalFilter,
          onInitialFilterConsumed: _clearInitialJournalFilter,
          visualCardShareService: widget.visualCardShareService,
          visualCardPngCapture: widget.visualCardPngCapture,
        ),
        3 => ProfileScreen(backupFileService: widget.profileBackupFileService),
        _ => _ShellPlaceholder(tab: tab),
      },
    );
  }

  void _openJournalAll() {
    setState(() {
      _initialJournalFilter = null;
      _tabIndex = 2;
    });
  }

  void _openJournalTag(String tag) {
    setState(() {
      _initialJournalFilter = tag;
      _tabIndex = 2;
    });
  }

  void _openProfile() {
    setState(() => _tabIndex = 3);
  }

  void _clearInitialJournalFilter() {
    if (_initialJournalFilter == null) {
      return;
    }
    setState(() => _initialJournalFilter = null);
  }
}

class _ShellPlaceholder extends StatelessWidget {
  const _ShellPlaceholder({required this.tab});

  final _ShellTab tab;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            Text(
              'Drop4Up',
              style: textTheme.titleLarge?.copyWith(
                color: Drop4UpTokens.primaryBlue,
              ),
            ),
            const Spacer(),
            SoftIconButton(
              icon: Icons.tune_rounded,
              label: 'Tune preview',
              onTap: () {},
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text('${tab.label} shell preview', style: textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(
          '${tab.description}. This phase proves the reusable shell and custom 4-tab navigation only.',
          style: textTheme.bodyLarge?.copyWith(
            color: Drop4UpTokens.textPrimary.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(height: 34),
        SoftSurface(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Shell surface', style: textTheme.titleMedium),
              const SizedBox(height: 10),
              Text(
                'The body uses Drop4UpScaffold padding, background, safe area, and bottom nav placement.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Text('Placeholder content', style: textTheme.bodyMedium),
            ],
          ),
        ),
        const SizedBox(height: 26),
        PrimaryDropButton(label: 'Preview Drop Button', onTap: () {}),
      ],
    );
  }
}

class _ShellTab {
  const _ShellTab(this.label, this.description);

  final String label;
  final String description;
}
