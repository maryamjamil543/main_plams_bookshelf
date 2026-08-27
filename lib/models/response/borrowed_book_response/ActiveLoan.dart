class ActiveLoan {
  int? id;
  String? issuedAt;
  String? dueAt;
  String? returnedAt;
  String? notes;

  ActiveLoan({
    this.id,
    this.issuedAt,
    this.dueAt,
    this.returnedAt,
    this.notes,
  });

  factory ActiveLoan.fromJson(Map<String, dynamic> json) {
    return ActiveLoan(
      id: json['id'],
      issuedAt: json['issued_at'],
      dueAt: json['due_at'],
      returnedAt: json['returned_at'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'issued_at': issuedAt,
    'due_at': dueAt,
    'returned_at': returnedAt,
    'notes': notes,
  };
}