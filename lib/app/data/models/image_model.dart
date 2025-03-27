import 'dart:convert';
import 'dart:typed_data';

class ImageModel {
  final String sql = """
CREATE TABLE image (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    data  BLOB,
    path  STRING,
    url  STRING
)
""";
  final int? id;
  final Uint8List? data;
  final String? path;
  final String? url;
  ImageModel({this.id, this.data, this.path, this.url});

  ImageModel copyWith({int? id, Uint8List? data, String? path, String? url}) {
    return ImageModel(
      id: id ?? this.id,
      data: data ?? this.data,
      path: path ?? this.path,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (data != null) {
      result.addAll({'data': data});
    }
    if (path != null) {
      result.addAll({'path': path});
    }
    if (url != null) {
      result.addAll({'url': url});
    }

    return result;
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id']?.toInt(),
      data: map['data'],
      path: map['path'],
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ImageModel.fromJson(String source) =>
      ImageModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ImageModel(id: $id, data: $data, path: $path, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImageModel &&
        other.id == id &&
        other.data == data &&
        other.path == path &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^ data.hashCode ^ path.hashCode ^ url.hashCode;
  }
}
