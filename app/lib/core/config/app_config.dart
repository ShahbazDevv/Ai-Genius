class AppConfig {
  /// Default production backend URL on FastAPI Cloud / Render
  static const String defaultBaseUrl = 'https://ai-genius-backend.fastapicloud.dev';

  /// Android emulator loopback to host machine
  static const String androidEmulatorBaseUrl = 'http://10.0.2.2:8000';

  /// Localhost URL for desktop / web testing
  static const String localhostBaseUrl = 'http://127.0.0.1:8000';

  /// Active base URL (default: defaultBaseUrl)
  static String _currentBaseUrl = defaultBaseUrl;

  /// Current base URL in use
  static String get baseUrl => _currentBaseUrl;

  /// Update the base URL dynamically (e.g., when testing with Android emulator)
  static void setBaseUrl(String url) {
    _currentBaseUrl = url.trim().replaceAll(RegExp(r'/+$'), '');
  }

  /// Switch to Android emulator local backend
  static void useEmulator() {
    _currentBaseUrl = androidEmulatorBaseUrl;
  }

  /// Switch back to default deployed cloud backend
  static void useProduction() {
    _currentBaseUrl = defaultBaseUrl;
  }

  /// Reset to default
  static void reset() {
    _currentBaseUrl = defaultBaseUrl;
  }

  /// Request timeout in seconds (accommodates free tier server cold start)
  static const int timeoutSeconds = 60;
  static const Duration timeoutDuration = Duration(seconds: timeoutSeconds);
}
