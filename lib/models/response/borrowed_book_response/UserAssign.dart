class UserAssign {
   int? id;
   int? bookId;
   int? borrowerId;
   String? bookName;
   String? borrowerName;
   String? coverImage;
   String? libraryName;
   String? assignedDate;
   String? dueDate;
   String? status;

  UserAssign({
     this.id,
     this.bookId,
     this.bookName,
     this.borrowerName,
     this.libraryName,
     this.assignedDate,
     this.dueDate,
     this.status,
    this.borrowerId,
    this.coverImage
  });

  factory UserAssign.fromJson(Map<String, dynamic> json) {
    return UserAssign(
      id: json['id'],
      borrowerId: int.tryParse(json['borrower_id'].toString()),
      bookId: int.tryParse(json['book_id'].toString()),
      bookName: json['book_name'] ?? '',
      coverImage: json['cover_image'] ?? '',
      borrowerName: json['borrower_name'] ?? '',
      libraryName: json['library_name'] ?? '',
      assignedDate: json['assigned_date'] ?? '',
      dueDate: json['due_date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}