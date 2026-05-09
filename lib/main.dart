import 'package:flutter/material.dart';

import 'data/reflection_entry_repository.dart';
import 'screens/drop_screen.dart';
import 'screens/home_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/profile_screen.dart';
import 'state/reflection_entries_controller.dart';
import 'state/reflection_entries_scope.dart';
import 'ui/drop4up_scaffold.dart';
import 'ui/drop4up_tokens.dart';
import 'ui/primary_drop_button.dart';
import 'ui/soft_icon_button.dart';
import 'ui/soft_surface.dart';

void main() {
  runApp(const Drop4UpPreviewApp());
}

class Drop4UpPreviewApp extends StatefulWidget {
  const Drop4UpPreviewApp({
    super.key,
    this.repository,
    this.clock,
    this.idGenerator,
  });

  final ReflectionEntryRepository? repository;
  final ReflectionClock? clock;
  final ReflectionIdGenerator? idGenerator;

  @override
  State<Drop4UpPreviewApp> createState() => _Drop4UpPreviewAppState();
}

class _Drop4UpPreviewAppState extends State<Drop4UpPreviewApp> {
  late final ReflectionEntriesController _entriesController;

  @override
  void initState() {
    super.initState();
    _entriesController = ReflectionEntriesController(
      repository: widget.repository ?? ReflectionEntryRepository(),
      clock: widget.clock,
      idGenerator: widget.idGenerator,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _entriesController.load();
    });
  }

  @override
  void dispose() {
    _entriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Drop4UpTokens.textTheme();

    return ReflectionEntriesScope(
      controller: _entriesController,
      child: MaterialApp(
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
        home: const ShellPreviewScreen(),
      ),
    );
  }
}

class ShellPreviewScreen extends StatefulWidget {
  const ShellPreviewScreen({super.key});

  @override
  State<ShellPreviewScreen> createState() => _ShellPreviewScreenState();
}

class _ShellPreviewScreenState extends State<ShellPreviewScreen> {
  int _tabIndex = 0;
  String? _initialJournalFilter;

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
        ),
        1 => const DropScreen(),
        2 => JournalScreen(
          initialTaxonomyFilter: _initialJournalFilter,
          onInitialFilterConsumed: _clearInitialJournalFilter,
        ),
        3 => const ProfileScreen(),
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
