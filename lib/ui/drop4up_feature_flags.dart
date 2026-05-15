enum Drop4UpSurfaceRenderer { skin, legacy }

class Drop4UpFeatureFlags {
  const Drop4UpFeatureFlags._();

  static const _surfaceRenderer = String.fromEnvironment(
    'DROP4UP_SURFACE_RENDERER',
    defaultValue: 'legacy',
  );

  static const surfaceRenderer = _surfaceRenderer == 'legacy'
      ? Drop4UpSurfaceRenderer.legacy
      : Drop4UpSurfaceRenderer.skin;

  static const useSurfaceSkins = surfaceRenderer == Drop4UpSurfaceRenderer.skin;
}
