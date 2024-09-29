class HistoryModel {
  final String status, createdAt, dimension, size, dispersi, url;
  String? userId, documentId;

  HistoryModel({
    this.documentId,
    required this.status,
    this.userId,
    required this.createdAt,
    required this.dimension,
    required this.size,
    required this.dispersi,
    required this.url,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'userId': userId,
      'createdAt': createdAt,
      'dimension': dimension,
      'size': size,
      'dispersi': dispersi,
      'url': url,
    };
  }

  factory HistoryModel.fromFirebaseJson(Map<String, dynamic> json) {
    return HistoryModel(
      status: json['status'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      dimension: json['dimension'],
      size: json['size'],
      dispersi: json['dispersi'],
      url: json['url'],
    );
  }

  factory HistoryModel.fromPythonJson(Map<String, dynamic> json, userId) {
    String status = json['status'].replaceAll('\n', '');
    return HistoryModel(
      status: status,
      userId: userId,
      createdAt: DateTime.now().toString(),
      dimension: json['dimension'],
      size: json['size'],
      dispersi: json['dispersi'],
      url: json['url'],
    );
  }
}
