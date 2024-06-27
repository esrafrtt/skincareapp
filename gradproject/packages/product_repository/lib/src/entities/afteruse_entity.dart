// ignore: camel_case_types
class afterUseEntity {
  List<String> afterUse;

  afterUseEntity({
    required this.afterUse,
  });

  factory afterUseEntity.fromJson(Map<String, dynamic> json) {
    return afterUseEntity(
      afterUse: List<String>.from(json['afterUse']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'afterUse': afterUse,
    };
  }

  static afterUseEntity fromDocument(Map<String, dynamic> doc) {
    return afterUseEntity(
      afterUse: List<String>.from(doc['afterUse'] as List<dynamic>),
    );
  }

  Map<String, Object?> toDocument() {
    return {
      'afterUse': afterUse,
    };
  }
}
