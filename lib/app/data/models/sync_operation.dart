import 'dart:convert';

class SyncOperation {
  final String sql = """
CREATE TABLE sync_operations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tableName TEXT NOT NULL,
    rowId TEXT NOT NULL,
    operation TEXT NOT NULL, 
    data TEXT,               
    lastError TEXT,               
    createdAt INTEGER NOT NULL,
    syncedAt INTEGER,
    synced INTEGER DEFAULT 0
)
""";
  final int? id;
  final String? tableName;
  final String? rowId;
  final String? operation;
  final String? data;
  final String? lastError;
  final int? synced;
  final int? createdAt;
  final int? synchedAt;
  SyncOperation({
    this.id,
    this.tableName,
    this.rowId,
    this.operation,
    this.data,
    this.lastError,
    this.synced,
    this.createdAt,
    this.synchedAt,
  });

  SyncOperation copyWith({
    int? id,
    String? tableName,
    String? rowId,
    String? operation,
    String? data,
    String? lastError,
    int? synced,
    int? createdAt,
    int? synchedAt,
  }) {
    return SyncOperation(
      id: id ?? this.id,
      tableName: tableName ?? this.tableName,
      rowId: rowId ?? this.rowId,
      operation: operation ?? this.operation,
      data: data ?? this.data,
      lastError: lastError ?? this.lastError,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
      synchedAt: synchedAt ?? this.synchedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (tableName != null) {
      result.addAll({'tableName': tableName});
    }
    if (rowId != null) {
      result.addAll({'rowId': rowId});
    }
    if (operation != null) {
      result.addAll({'operation': operation});
    }
    if (data != null) {
      result.addAll({'data': data});
    }
    if (lastError != null) {
      result.addAll({'lastError': lastError});
    }
    if (synced != null) {
      result.addAll({'synced': synced});
    }
    if (createdAt != null) {
      result.addAll({'createdAt': createdAt});
    }
    if (synchedAt != null) {
      result.addAll({'synchedAt': synchedAt});
    }

    return result;
  }

  factory SyncOperation.fromMap(Map<String, dynamic> map) {
    return SyncOperation(
      id: map['id']?.toInt(),
      tableName: map['tableName'],
      rowId: map['rowId'],
      operation: map['operation'],
      data: map['data'],
      lastError: map['lastError'],
      synced: map['synced']?.toInt(),
      createdAt: map['createdAt']?.toInt(),
      synchedAt: map['synchedAt']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SyncOperation.fromJson(String source) =>
      SyncOperation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SyncOperation(id: $id, tableName: $tableName, rowId: $rowId, operation: $operation, data: $data, lastError: $lastError, synced: $synced, createdAt: $createdAt, synchedAt: $synchedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SyncOperation &&
        other.id == id &&
        other.tableName == tableName &&
        other.rowId == rowId &&
        other.operation == operation &&
        other.data == data &&
        other.lastError == lastError &&
        other.synced == synced &&
        other.createdAt == createdAt &&
        other.synchedAt == synchedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        tableName.hashCode ^
        rowId.hashCode ^
        operation.hashCode ^
        data.hashCode ^
        lastError.hashCode ^
        synced.hashCode ^
        createdAt.hashCode ^
        synchedAt.hashCode;
  }
}
