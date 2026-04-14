enum FlavorType {
  user,
  provider;

  T variant<T>({required T parent, required T driver}) {
    return this == FlavorType.user ? parent : driver;
  }

  String get endpoint {
    switch (this) {
      case FlavorType.user:
        return "users";
      case FlavorType.provider:
        return "providers";
    }
  }

  String get displayName {
    switch (this) {
      case FlavorType.user:
        return "Diyafatukum User";
      case FlavorType.provider:
        return "Diyafatukum Provider";
    }
  }
}
