enum ReloadBloc { reload, notReload }

/// A utility class for working with enums by mapping them to boolean values and associated content.
class EnumFormMap<T extends Enum> {
  ///
  EnumFormMap() {
    enumValuesMap = {};
    _enumContentMap = {};
  }
  ReloadBloc valueChangeCount = ReloadBloc.notReload;

  ///
  late Map<T, bool?> enumValuesMap;
  late Map<T, Object> _enumContentMap;

  /// Checks if all enum values are set to `true`.
  bool areAllTrue(int count) {
    return enumValuesMap.values.length == count &&
        enumValuesMap.values.every((value) => value == true);
  }

  /// Sets the value of an enum and associates content with it.
  void setValue(T enumValue, Object content, {bool value = false}) {
    enumValuesMap[enumValue] = value;
    _enumContentMap[enumValue] = content;
  }

  /// Gets the value associated with an enum.
  bool getValue(T enumValue) {
    return enumValuesMap[enumValue] ?? false;
  }

  /// Gets the value associated with an enum.
  ReloadBloc isReload(T enumValue) {
    return enumValuesMap[enumValue] ?? false
        ? ReloadBloc.reload
        : ReloadBloc.notReload;
  }

  /// Gets the content associated with an enum.
  ContentValueType? getContentValue<ContentValueType>(T enumValue) {
    return _enumContentMap[enumValue] == null
        ? null
        : _enumContentMap[enumValue]! as ContentValueType;
  }

  /// Gets the content associated with an enum.
  ContentValueType getContentValueNotNull<ContentValueType>(T enumValue) {
    return _enumContentMap[enumValue]! as ContentValueType;
  }

  /// Checks if an error message should be visible for a specific enum value.
  bool isErrorMessageVisible(T enumValue) {
    return !enumValuesMap.containsKey(enumValue) ||
        enumValuesMap[enumValue] == true;
  }
}
