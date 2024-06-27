import '../entities/afteruse_entity.dart';

class AfterUse {
  List<String> afterUse;

  AfterUse({
    required this.afterUse,
  });

  afterUseEntity toEntity() {
    return afterUseEntity(
      afterUse: afterUse,
    );
  }

  static AfterUse fromEntity(afterUseEntity entity) {
    return AfterUse(
      afterUse: entity.afterUse,
    );
  }

  factory AfterUse.fromJson(Map<String, dynamic> json) {
    return AfterUse(
      afterUse: List<String>.from(json['afterUse']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'afterUse': afterUse,
    };
  }
}
