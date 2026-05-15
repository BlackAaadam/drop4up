import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'drop4up_feature_flags.dart';
import 'drop4up_tokens.dart';

enum Drop4UpSurfaceSkinKind {
  softRaised,
  softProminent,
  softInset,
  softPressed,
  tactileRaised,
  tactilePrimaryRaised,
  tactileInset,
  tactilePressed,
}

class Drop4UpSkinnedSurface extends StatefulWidget {
  const Drop4UpSkinnedSurface({
    super.key,
    required this.kind,
    required this.color,
    required this.radius,
    required this.child,
    required this.legacyBuilder,
    this.padding,
    this.width,
    this.height,
  });

  final Drop4UpSurfaceSkinKind kind;
  final Color color;
  final double radius;
  final Widget child;
  final WidgetBuilder legacyBuilder;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  @override
  State<Drop4UpSkinnedSurface> createState() => _Drop4UpSkinnedSurfaceState();
}

class _Drop4UpSkinnedSurfaceState extends State<Drop4UpSkinnedSurface> {
  ui.Image? _image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveSkin();
  }

  @override
  void didUpdateWidget(Drop4UpSkinnedSurface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.kind != widget.kind ||
        oldWidget.color != widget.color ||
        oldWidget.radius != widget.radius) {
      _resolveSkin();
    }
  }

  void _resolveSkin() {
    if (!Drop4UpFeatureFlags.useSurfaceSkins) {
      return;
    }

    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cached = Drop4UpSurfaceSkinCache.instance.imageFor(
      kind: widget.kind,
      color: widget.color,
      radius: widget.radius,
      devicePixelRatio: dpr,
    );
    if (cached != null) {
      _image = cached;
      return;
    }

    _image = null;
    unawaited(
      Drop4UpSurfaceSkinCache.instance
          .ensureImage(
            kind: widget.kind,
            color: widget.color,
            radius: widget.radius,
            devicePixelRatio: dpr,
          )
          .then((image) {
            if (!mounted) {
              return;
            }
            setState(() => _image = image);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Drop4UpFeatureFlags.useSurfaceSkins || _image == null) {
      return widget.legacyBuilder(context);
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: CustomPaint(
        painter: _SurfaceSkinPainter(
          image: _image!,
          centerSlice: Drop4UpSurfaceSkinCache.instance.centerSliceFor(
            radius: widget.radius,
            devicePixelRatio: MediaQuery.devicePixelRatioOf(context),
          ),
          paintOutset: Drop4UpSurfaceSkinCache.paintOutset,
        ),
        child: Padding(
          padding: widget.padding ?? EdgeInsets.zero,
          child: widget.child,
        ),
      ),
    );
  }
}

class Drop4UpSurfaceSkinCache {
  Drop4UpSurfaceSkinCache._();

  static final Drop4UpSurfaceSkinCache instance = Drop4UpSurfaceSkinCache._();

  static const double paintOutset = 24;
  static const double _imageLogicalSize = 160;
  static const double _contentInset = paintOutset;
  static const double _contentSize = _imageLogicalSize - _contentInset * 2;
  static const double _maxSkinRadius = 36;

  final Map<_SurfaceSkinKey, ui.Image> _images = {};
  final Map<_SurfaceSkinKey, Future<ui.Image>> _pending = {};

  Future<void> warmUp() async {
    if (!Drop4UpFeatureFlags.useSurfaceSkins) {
      return;
    }

    final dpr = _currentDevicePixelRatio();
    await Future.wait([
      _warm(
        Drop4UpSurfaceSkinKind.softRaised,
        Drop4UpTokens.cardSurface,
        32,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.softRaised,
        Drop4UpTokens.primaryBlue,
        Drop4UpTokens.pillRadius,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.softProminent,
        Drop4UpTokens.cardSurface,
        28,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.softProminent,
        Drop4UpTokens.cardSurface,
        30,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.softProminent,
        Drop4UpTokens.cardSurface,
        32,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.softPressed,
        Drop4UpTokens.primaryBlue,
        Drop4UpTokens.pillRadius,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactileRaised,
        Drop4UpTokens.cardSurface,
        20,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactileRaised,
        Drop4UpTokens.cardSurface,
        26,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactileRaised,
        Drop4UpTokens.cardSurface,
        Drop4UpTokens.pillRadius,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactileInset,
        Drop4UpTokens.cardSurface,
        21,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactileInset,
        Drop4UpTokens.cardSurface,
        22,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactileInset,
        Drop4UpTokens.cardSurface,
        23,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactileInset,
        Drop4UpTokens.lightBlue.withValues(alpha: 0.28),
        26,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactileInset,
        Drop4UpTokens.lightBlue.withValues(alpha: 0.34),
        Drop4UpTokens.pillRadius,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactilePressed,
        Drop4UpTokens.cardSurface,
        26,
        dpr,
      ),
      _warm(
        Drop4UpSurfaceSkinKind.tactilePrimaryRaised,
        Drop4UpTokens.primaryBlue,
        Drop4UpTokens.pillRadius,
        dpr,
      ),
    ]);
  }

  ui.Image? imageFor({
    required Drop4UpSurfaceSkinKind kind,
    required Color color,
    required double radius,
    required double devicePixelRatio,
  }) {
    return _images[_SurfaceSkinKey(
      kind: kind,
      color: color,
      radius: radius,
      devicePixelRatio: devicePixelRatio,
    )];
  }

  Future<ui.Image> ensureImage({
    required Drop4UpSurfaceSkinKind kind,
    required Color color,
    required double radius,
    required double devicePixelRatio,
  }) {
    final key = _SurfaceSkinKey(
      kind: kind,
      color: color,
      radius: radius,
      devicePixelRatio: devicePixelRatio,
    );
    final image = _images[key];
    if (image != null) {
      return Future.value(image);
    }

    return _pending.putIfAbsent(key, () async {
      final generated = await _generateSkin(
        kind: kind,
        color: color,
        radius: _effectiveRadius(radius),
        devicePixelRatio: key.devicePixelRatio,
      );
      _images[key] = generated;
      _pending.remove(key);
      return generated;
    });
  }

  Rect centerSliceFor({
    required double radius,
    required double devicePixelRatio,
  }) {
    final edge = (_contentInset + _effectiveRadius(radius)) * devicePixelRatio;
    final size = _imageLogicalSize * devicePixelRatio;
    return Rect.fromLTRB(edge, edge, size - edge, size - edge);
  }

  Future<ui.Image> _warm(
    Drop4UpSurfaceSkinKind kind,
    Color color,
    double radius,
    double dpr,
  ) {
    return ensureImage(
      kind: kind,
      color: color,
      radius: radius,
      devicePixelRatio: dpr,
    );
  }

  Future<ui.Image> _generateSkin({
    required Drop4UpSurfaceSkinKind kind,
    required Color color,
    required double radius,
    required double devicePixelRatio,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.scale(devicePixelRatio);

    final contentRect = Rect.fromLTWH(
      _contentInset,
      _contentInset,
      _contentSize,
      _contentSize,
    );
    final rrect = RRect.fromRectAndRadius(contentRect, Radius.circular(radius));
    final spec = _specFor(kind, color);

    for (final shadow in spec.outerShadows) {
      _drawOuterShadow(canvas, rrect, shadow);
    }
    _drawFill(canvas, rrect, spec);
    for (final shadow in spec.innerShadows) {
      _drawInnerShadow(canvas, rrect, shadow);
    }

    final picture = recorder.endRecording();
    return picture.toImage(
      (_imageLogicalSize * devicePixelRatio).round(),
      (_imageLogicalSize * devicePixelRatio).round(),
    );
  }

  static double _currentDevicePixelRatio() {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) {
      return 1;
    }
    return views.first.devicePixelRatio;
  }

  static double _effectiveRadius(double radius) {
    return radius.clamp(0, _maxSkinRadius).toDouble();
  }
}

class _SurfaceSkinPainter extends CustomPainter {
  const _SurfaceSkinPainter({
    required this.image,
    required this.centerSlice,
    required this.paintOutset,
  });

  final ui.Image image;
  final Rect centerSlice;
  final double paintOutset;

  @override
  void paint(Canvas canvas, Size size) {
    final target = Rect.fromLTRB(
      -paintOutset,
      -paintOutset,
      size.width + paintOutset,
      size.height + paintOutset,
    );
    final paint = Paint()..filterQuality = FilterQuality.low;
    canvas.drawImageNine(image, centerSlice, target, paint);
  }

  @override
  bool shouldRepaint(_SurfaceSkinPainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.centerSlice != centerSlice ||
        oldDelegate.paintOutset != paintOutset;
  }
}

class _SurfaceSkinKey {
  const _SurfaceSkinKey({
    required this.kind,
    required this.color,
    required this.radius,
    required this.devicePixelRatio,
  });

  final Drop4UpSurfaceSkinKind kind;
  final Color color;
  final double radius;
  final double devicePixelRatio;

  @override
  bool operator ==(Object other) {
    return other is _SurfaceSkinKey &&
        other.kind == kind &&
        other.color.toARGB32() == color.toARGB32() &&
        other.radius == radius &&
        other.devicePixelRatio == devicePixelRatio;
  }

  @override
  int get hashCode =>
      Object.hash(kind, color.toARGB32(), radius, devicePixelRatio);
}

class _SurfaceSkinSpec {
  const _SurfaceSkinSpec({
    required this.gradient,
    required this.outerShadows,
    required this.innerShadows,
  });

  final Gradient gradient;
  final List<_SkinShadow> outerShadows;
  final List<_SkinShadow> innerShadows;
}

class _SkinShadow {
  const _SkinShadow({
    required this.color,
    required this.offset,
    required this.blur,
    this.spread = 0,
  });

  final Color color;
  final Offset offset;
  final double blur;
  final double spread;
}

void _drawOuterShadow(Canvas canvas, RRect rrect, _SkinShadow shadow) {
  final paint = Paint()
    ..color = shadow.color
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, _sigmaFor(shadow.blur));
  canvas.drawRRect(rrect.shift(shadow.offset).inflate(shadow.spread), paint);
}

void _drawInnerShadow(Canvas canvas, RRect rrect, _SkinShadow shadow) {
  canvas.save();
  canvas.clipRRect(rrect);
  final paint = Paint()
    ..color = shadow.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = shadow.blur * 2.4
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, _sigmaFor(shadow.blur));
  canvas.drawRRect(
    rrect.shift(shadow.offset).deflate(shadow.spread.abs() * 0.5),
    paint,
  );
  canvas.restore();
}

void _drawFill(Canvas canvas, RRect rrect, _SurfaceSkinSpec spec) {
  final paint = Paint()..shader = spec.gradient.createShader(rrect.outerRect);
  canvas.drawRRect(rrect, paint);
}

double _sigmaFor(double radius) => radius * 0.57735 + 0.5;

_SurfaceSkinSpec _specFor(Drop4UpSurfaceSkinKind kind, Color color) {
  return switch (kind) {
    Drop4UpSurfaceSkinKind.softRaised => _SurfaceSkinSpec(
      gradient: _raisedGradient(color),
      outerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.54),
          offset: const Offset(-2, -2),
          blur: 5,
          spread: -4,
        ),
        _SkinShadow(
          color: Drop4UpTokens.warmShadow.withValues(alpha: 0.40),
          offset: const Offset(0, 10),
          blur: 18,
          spread: -8,
        ),
        _SkinShadow(
          color: Drop4UpTokens.coolShadow.withValues(alpha: 0.14),
          offset: const Offset(3, 8),
          blur: 16,
          spread: -10,
        ),
      ],
      innerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.48),
          offset: const Offset(0, 1.6),
          blur: 3.2,
          spread: -2.8,
        ),
        _SkinShadow(
          color: Drop4UpTokens.coolShadow.withValues(alpha: 0.13),
          offset: const Offset(0, -1.8),
          blur: 3.6,
          spread: -2.6,
        ),
      ],
    ),
    Drop4UpSurfaceSkinKind.softProminent => _SurfaceSkinSpec(
      gradient: _raisedGradient(color),
      outerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.58),
          offset: const Offset(-2.2, -2.2),
          blur: 5.8,
          spread: -4,
        ),
        _SkinShadow(
          color: Drop4UpTokens.warmShadow.withValues(alpha: 0.58),
          offset: const Offset(0, 14),
          blur: 24,
          spread: -7,
        ),
        _SkinShadow(
          color: Drop4UpTokens.coolShadow.withValues(alpha: 0.26),
          offset: const Offset(5, 11),
          blur: 20,
          spread: -9,
        ),
      ],
      innerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.58),
          offset: const Offset(0.8, 2.1),
          blur: 3.8,
          spread: -2.6,
        ),
        _SkinShadow(
          color: Drop4UpTokens.coolShadow.withValues(alpha: 0.28),
          offset: const Offset(-1.4, -2.8),
          blur: 4.8,
          spread: -2.6,
        ),
      ],
    ),
    Drop4UpSurfaceSkinKind.softInset => _SurfaceSkinSpec(
      gradient: _insetGradient(color),
      outerShadows: const [],
      innerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.warmShadow.withValues(alpha: 0.46),
          offset: const Offset(3, 3),
          blur: 8,
          spread: -2.4,
        ),
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.82),
          offset: const Offset(-3, -3),
          blur: 8,
          spread: -3,
        ),
        _SkinShadow(
          color: Drop4UpTokens.primaryBlue.withValues(alpha: 0.08),
          offset: const Offset(0, -1.6),
          blur: 3.4,
          spread: -2.4,
        ),
      ],
    ),
    Drop4UpSurfaceSkinKind.softPressed => _SurfaceSkinSpec(
      gradient: _pressedGradient(color),
      outerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.warmShadow.withValues(alpha: 0.16),
          offset: const Offset(0, 6),
          blur: 12,
          spread: -9,
        ),
      ],
      innerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.warmShadow.withValues(alpha: 0.50),
          offset: const Offset(3, 3),
          blur: 9,
          spread: -2,
        ),
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.78),
          offset: const Offset(-3, -3),
          blur: 10,
          spread: -3,
        ),
        _SkinShadow(
          color: Drop4UpTokens.coolShadow.withValues(alpha: 0.10),
          offset: const Offset(0, -1.4),
          blur: 3.4,
          spread: -2.4,
        ),
      ],
    ),
    Drop4UpSurfaceSkinKind.tactileRaised => _SurfaceSkinSpec(
      gradient: LinearGradient(colors: [color, color]),
      outerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.textPrimary.withValues(alpha: 0.105),
          offset: const Offset(3.2, 5.4),
          blur: 10.5,
          spread: -5.5,
        ),
        _SkinShadow(
          color: Drop4UpTokens.textPrimary.withValues(alpha: 0.034),
          offset: const Offset(0, 8.5),
          blur: 16,
          spread: -14,
        ),
        _SkinShadow(
          color: Drop4UpTokens.primaryBlue.withValues(alpha: 0.044),
          offset: const Offset(3.8, 5.2),
          blur: 11,
          spread: -10,
        ),
      ],
      innerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.52),
          offset: const Offset(1, 2.4),
          blur: 3.4,
          spread: -2.8,
        ),
        _SkinShadow(
          color: Drop4UpTokens.textSecondary.withValues(alpha: 0.22),
          offset: const Offset(-1.6, -2.9),
          blur: 3.2,
          spread: -2.8,
        ),
      ],
    ),
    Drop4UpSurfaceSkinKind.tactilePrimaryRaised => _SurfaceSkinSpec(
      gradient: _primaryGradient(color),
      outerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.22),
          offset: const Offset(-0.8, -0.8),
          blur: 2,
          spread: -3,
        ),
        _SkinShadow(
          color: Drop4UpTokens.textPrimary.withValues(alpha: 0.20),
          offset: const Offset(3.4, 7.2),
          blur: 13,
          spread: -5,
        ),
        _SkinShadow(
          color: Drop4UpTokens.primaryBlue.withValues(alpha: 0.18),
          offset: const Offset(5.2, 6.6),
          blur: 13,
          spread: -8,
        ),
      ],
      innerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.28),
          offset: const Offset(1, 2.4),
          blur: 3.2,
          spread: -2.4,
        ),
        _SkinShadow(
          color: Drop4UpTokens.textPrimary.withValues(alpha: 0.20),
          offset: const Offset(-1.6, -3),
          blur: 4.6,
          spread: -2.8,
        ),
      ],
    ),
    Drop4UpSurfaceSkinKind.tactileInset => _SurfaceSkinSpec(
      gradient: LinearGradient(colors: [color, color]),
      outerShadows: const [],
      innerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.62),
          offset: const Offset(1.6, 1.8),
          blur: 4.2,
          spread: -3.4,
        ),
        _SkinShadow(
          color: Drop4UpTokens.textSecondary.withValues(alpha: 0.26),
          offset: const Offset(-2, -2.4),
          blur: 5,
          spread: -3.2,
        ),
        _SkinShadow(
          color: Drop4UpTokens.primaryBlue.withValues(alpha: 0.08),
          offset: const Offset(-1.4, -2),
          blur: 4,
          spread: -3,
        ),
      ],
    ),
    Drop4UpSurfaceSkinKind.tactilePressed => _SurfaceSkinSpec(
      gradient: LinearGradient(colors: [color, color]),
      outerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.textPrimary.withValues(alpha: 0.030),
          offset: const Offset(0, 5),
          blur: 10,
          spread: -8,
        ),
      ],
      innerShadows: [
        _SkinShadow(
          color: Drop4UpTokens.softWhite.withValues(alpha: 0.52),
          offset: const Offset(1.4, 1.7),
          blur: 4,
          spread: -3.2,
        ),
        _SkinShadow(
          color: Drop4UpTokens.textSecondary.withValues(alpha: 0.34),
          offset: const Offset(-2.2, -2.8),
          blur: 5.2,
          spread: -3,
        ),
        _SkinShadow(
          color: Drop4UpTokens.primaryBlue.withValues(alpha: 0.10),
          offset: const Offset(-1.4, -2),
          blur: 4.4,
          spread: -2.8,
        ),
      ],
    ),
  };
}

LinearGradient _raisedGradient(Color base) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: const [0, 0.14, 0.48, 0.82, 1],
    colors: [
      Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.64), base),
      Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.22), base),
      base,
      Color.alphaBlend(Drop4UpTokens.warmShadow.withValues(alpha: 0.06), base),
      Color.alphaBlend(Drop4UpTokens.coolShadow.withValues(alpha: 0.08), base),
    ],
  );
}

LinearGradient _insetGradient(Color base) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.alphaBlend(Drop4UpTokens.coolShadow.withValues(alpha: 0.08), base),
      base,
      Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.24), base),
    ],
  );
}

LinearGradient _pressedGradient(Color base) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.alphaBlend(Drop4UpTokens.warmShadow.withValues(alpha: 0.12), base),
      base,
      Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.36), base),
    ],
  );
}

LinearGradient _primaryGradient(Color base) {
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0, 0.32, 0.70, 1],
    colors: [
      Color.alphaBlend(
        Drop4UpTokens.softWhite.withValues(alpha: 0.26),
        Drop4UpTokens.accentBlue,
      ),
      Color.alphaBlend(Drop4UpTokens.softWhite.withValues(alpha: 0.14), base),
      Color.alphaBlend(Drop4UpTokens.accentBlue.withValues(alpha: 0.22), base),
      Color.alphaBlend(Drop4UpTokens.textPrimary.withValues(alpha: 0.08), base),
    ],
  );
}
