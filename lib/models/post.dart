import 'dart:convert';

class Post {
  final String id;
  final String userId;
  final String status;
  final String reportStatus;
  final String content;
  final DateTime createDate;
  final DateTime editDate;
  final DateTime lastReactDate;
  Post({
    required this.id,
    required this.userId,
    required this.status,
    required this.reportStatus,
    required this.content,
    required this.createDate,
    required this.editDate,
    required this.lastReactDate,
  });

  Post copyWith({
    String? id,
    String? userId,
    String? status,
    String? reportStatus,
    String? content,
    DateTime? createDate,
    DateTime? editDate,
    DateTime? lastReactDate,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      reportStatus: reportStatus ?? this.reportStatus,
      content: content ?? this.content,
      createDate: createDate ?? this.createDate,
      editDate: editDate ?? this.editDate,
      lastReactDate: lastReactDate ?? this.lastReactDate,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'userId': userId});
    result.addAll({'status': status});
    result.addAll({'reportStatus': reportStatus});
    result.addAll({'content': content});
    result.addAll({'createDate': createDate.millisecondsSinceEpoch});
    result.addAll({'editDate': editDate.millisecondsSinceEpoch});
    result.addAll({'lastReactDate': lastReactDate.millisecondsSinceEpoch});

    return result;
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      status: map['status'] ?? '',
      reportStatus: map['reportStatus'] ?? '',
      content: map['content'] ?? '',
      createDate: DateTime.fromMillisecondsSinceEpoch(map['createDate']),
      editDate: DateTime.fromMillisecondsSinceEpoch(map['editDate']),
      lastReactDate: DateTime.fromMillisecondsSinceEpoch(map['lastReactDate']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, status: $status, reportStatus: $reportStatus, content: $content, createDate: $createDate, editDate: $editDate, lastReactDate: $lastReactDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.userId == userId &&
        other.status == status &&
        other.reportStatus == reportStatus &&
        other.content == content &&
        other.createDate == createDate &&
        other.editDate == editDate &&
        other.lastReactDate == lastReactDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        status.hashCode ^
        reportStatus.hashCode ^
        content.hashCode ^
        createDate.hashCode ^
        editDate.hashCode ^
        lastReactDate.hashCode;
  }
}
