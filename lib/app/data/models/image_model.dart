import 'dart:convert';

class ImageModel {
  final String sql = """
CREATE TABLE image (
    ids   STRING PRIMARY KEY,
    path  STRING,
    url  STRING,
    createdAt INTEGER,
    updatedAt INTEGER,
    deletedAt INTEGER
)
""";
  final String? ids;
  final String? path;
  final String? url;
  final int? createdAt;
  final int? updatedAt;
  final int? deletedAt;
  ImageModel({
    this.ids,
    this.path,
    this.url,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  ImageModel copyWith({
    String? ids,
    String? path,
    String? url,
    int? createdAt,
    int? updatedAt,
    int? deletedAt,
  }) {
    return ImageModel(
      ids: ids ?? this.ids,
      path: path ?? this.path,
      url: url ?? this.url,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (ids != null) {
      result.addAll({'ids': ids});
    }
    if (path != null) {
      result.addAll({'path': path});
    }
    if (url != null) {
      result.addAll({'url': url});
    }
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    if (updatedAt != null) {
      result.addAll({'updatedAt': updatedAt});
    }
    if (deletedAt != null) {
      result.addAll({'deletedAt': deletedAt});
    }

    return result;
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      ids: map['ids'],
      path: map['path'],
      url: map['url'],
      createdAt: map['createdAt']?.toInt(),
      updatedAt: map['updatedAt']?.toInt(),
      deletedAt: map['deletedAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageModel.fromJson(String source) =>
      ImageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ImageModel(ids: $ids, path: $path, url: $url, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageModel &&
        other.ids == ids &&
        other.path == path &&
        other.url == url &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.deletedAt == deletedAt;
  }

  @override
  int get hashCode {
    return ids.hashCode ^
        path.hashCode ^
        url.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        deletedAt.hashCode;
  }
}
