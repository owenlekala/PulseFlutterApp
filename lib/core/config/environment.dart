enum Environment {
  dev('dev'),
  staging('staging'),
  production('production');

  const Environment(this.value);
  final String value;

  static Environment fromString(String value) {
    return Environment.values.firstWhere(
      (env) => env.value == value,
      orElse: () => Environment.dev,
    );
  }

  static Environment get current {
    return fromString(
      const String.fromEnvironment('APP_ENV', defaultValue: 'dev'),
    );
  }

  bool get isDev => this == Environment.dev;
  bool get isStaging => this == Environment.staging;
  bool get isProduction => this == Environment.production;
}

