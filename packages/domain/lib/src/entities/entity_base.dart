///The base entity
class EntityBase {
  ///The base entity constructor
  const EntityBase({
    required this.id,
    required this.createdBy,
    required this.createdDate,
    required this.lastModifiedBy,
    required this.lastModifiedDate,
  });

  /// The unique identifier of the client.
  final int? id;

  /// The username of the user who created the client.
  final String? createdBy;

  /// The date and time when the client was created.
  final DateTime? createdDate;

  /// The username of the user who last modified the client.
  final String? lastModifiedBy;

  /// The date and time when the client was last modified.
  final DateTime? lastModifiedDate;
}
