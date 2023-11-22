export 'string_extension.dart';

extension NullObject on Object? {
  bool get isNull => this == null;
  bool get isNotNull => this != null;
}
