import 'dart:convert';

class SyncState {
  final String sql = """
CREATE TABLE sync_state (
    key TEXT PRIMARY KEY,
    value TEXT
)
""";

  final String? key;
  final String? value;
  SyncState({this.key, this.value});

  SyncState copyWith({String? key, String? value}) {
    return SyncState(key: key ?? this.key, value: value ?? this.value);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (key != null) {
      result.addAll({'key': key});
    }
    if (value != null) {
      result.addAll({'value': value});
    }

    return result;
  }

  factory SyncState.fromMap(Map<String, dynamic> map) {
    return SyncState(key: map['key'], value: map['value']);
  }

  String toJson() => json.encode(toMap());

  factory SyncState.fromJson(String source) =>
      SyncState.fromMap(json.decode(source));

  @override
  String toString() => 'SyncState(key: $key, value: $value)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SyncState && other.key == key && other.value == value;
  }

  @override
  int get hashCode => key.hashCode ^ value.hashCode;
}
