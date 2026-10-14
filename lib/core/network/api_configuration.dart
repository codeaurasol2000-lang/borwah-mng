class ApiConfiguration {
  const ApiConfiguration({
    required this.baseUrl,
    required this.useMockData,
  });

  static const String _configuredBaseUrl =
      String.fromEnvironment('API_BASE_URL');
  static const bool _isReleaseBuild = bool.fromEnvironment('dart.vm.product');

  factory ApiConfiguration.fromEnvironment() {
    return const ApiConfiguration(
      baseUrl: _configuredBaseUrl,
      useMockData: bool.fromEnvironment(
        'USE_MOCK_DATA',
        defaultValue: !_isReleaseBuild,
      ),
    );
  }

  final String baseUrl;
  final bool useMockData;

  void validate() {
    if (useMockData) return;

    final uri = Uri.tryParse(baseUrl.trim());
    if (uri == null ||
        !uri.hasAuthority ||
        uri.host.isEmpty ||
        (uri.scheme != 'https' && uri.scheme != 'http') ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment) {
      throw StateError(
        'Remote API mode requires a valid API_BASE_URL using HTTP or HTTPS.',
      );
    }
  }
}
