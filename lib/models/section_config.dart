class PlaceDisplayConfig {
  final String? titleOverride;
  final String? subtitleOverride;
  final String? imageOverride;

  const PlaceDisplayConfig({
    this.titleOverride,
    this.subtitleOverride,
    this.imageOverride,
  });
}

class SectionConfig {
  final String id;
  final String title;
  final String subtitle;
  final List<String> placeIds;
  final Map<String, PlaceDisplayConfig> customConfigs;

  const SectionConfig({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.placeIds,
    this.customConfigs = const {},
  });
}