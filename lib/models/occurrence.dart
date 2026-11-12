enum Severity { baixa, moderada, alta }
enum OccurrenceStatus { pendente, validada, rejeitada }
enum OccurrenceCategory { alagamento, enchente, bueiro, arvore, deslizamento, buraco, iluminacao, descarte, outro }

extension SeverityLabel on Severity {
  String get label => const ['Baixa', 'Moderada', 'Alta'][index];
  static Severity parse(String? value) => switch (value) {
    'Alta' => Severity.alta,
    'Moderada' || 'Média' => Severity.moderada,
    _ => Severity.baixa,
  };
}
extension StatusLabel on OccurrenceStatus {
  String get label => const ['Pendente', 'Validada', 'Rejeitada'][index];
  static OccurrenceStatus parse(String? value) => switch (value) {
    'Validada' => OccurrenceStatus.validada,
    'Rejeitada' => OccurrenceStatus.rejeitada,
    _ => OccurrenceStatus.pendente,
  };
}
extension CategoryLabel on OccurrenceCategory {
  String get label => const ['Alagamento','Enchente','Bueiro','Árvore','Deslizamento','Buraco','Iluminação','Descarte irregular','Outro'][index];
  static OccurrenceCategory parse(String? value) {
    for (final category in OccurrenceCategory.values) {
      if (category.label == value) return category;
    }
    return OccurrenceCategory.outro;
  }
}

class Occurrence {
  Occurrence({required this.id, required this.title, required this.description, required this.neighborhood, required this.address, required this.severity, required this.status, required this.createdAt, this.favorite = false, this.category = 'Outro'});
  final String id, title, description, neighborhood, address, severity, status;
  final DateTime createdAt;
  final bool favorite;
  final String category;

  Severity get severityType => SeverityLabel.parse(severity);
  OccurrenceStatus get statusType => StatusLabel.parse(status);
  OccurrenceCategory get categoryType => CategoryLabel.parse(category);

  Occurrence copyWith({String? title, String? description, String? neighborhood, String? address, String? severity, String? status, bool? favorite, String? category}) => Occurrence(
    id: id, title: title ?? this.title, description: description ?? this.description, neighborhood: neighborhood ?? this.neighborhood, address: address ?? this.address,
    severity: severity ?? this.severity, status: status ?? this.status, createdAt: createdAt, favorite: favorite ?? this.favorite, category: category ?? this.category,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description, 'neighborhood': neighborhood,
    'address': address, 'severity': severity, 'status': status,
    'createdAt': createdAt.toIso8601String(), 'favorite': favorite, 'category': category,
  };

  factory Occurrence.fromJson(Map<String, dynamic> j) => Occurrence(
    id: (j['id'] ?? '').toString(), title: (j['title'] ?? 'Sem título').toString(), description: (j['description'] ?? '').toString(), neighborhood: (j['neighborhood'] ?? 'Não informado').toString(),
    address: (j['address'] ?? '').toString(), severity: SeverityLabel.parse(j['severity']?.toString()).label, status: StatusLabel.parse(j['status']?.toString()).label,
    createdAt: DateTime.tryParse((j['createdAt'] ?? '').toString()) ?? DateTime.fromMillisecondsSinceEpoch(0), favorite: j['favorite'] == true, category: CategoryLabel.parse(j['category']?.toString()).label,
  );
}
