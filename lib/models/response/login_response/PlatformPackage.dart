class PlatformPackage {
   int? id;
   String? name;
   String? price;
   String? durationType;
   int? durationValue;
   int? durationDays;
   int? maxLibraries;
   String? description;
   List<String>? features;

  PlatformPackage({
     this.id,
     this.name,
     this.price,
     this.durationType,
    this.durationValue,
    this.maxLibraries,
    this.description,
    this.features,
    this.durationDays
  });
   PlatformPackage.fromJson(Map<String, dynamic> json) {
     id = json['id'];
     durationDays = json['duration_days'];
     name = json['name'] ?? '';
     price =json['amount']?.toString() ?? '0';
     durationType = json['duration_type']?.toString() ?? '';
     durationValue =json['duration_value'] is int
         ? json['duration_value']
         : int.tryParse(json['duration_value']?.toString() ?? '');
     maxLibraries = json['max_libraries'] is int
         ? json['max_libraries']
         : int.tryParse(json['max_libraries']?.toString() ?? '');
     description = json['description']?.toString();
     features = json['features'] != null
         ? List<String>.from(json['features'])
         : [];
   }

   Map<String, dynamic> toJson() {
     return {
       'id': id,
       'duration_days': durationDays,
       'name': name,
       'amount': price,
       'duration_type': durationType,
       'duration_value': durationValue,
       'max_libraries': maxLibraries,
       'description': description,
       'features': features,
     };
   }
   PlatformPackage.fromDb({
     required int id,
      int? durationDays,
     String? name,
     String? price,
     String? durationType,
     int? durationValue,
     int? maxLibraries,
     String? description,
     List<String>? features,
   }) {
     this.id = id;
     this.durationDays = durationDays;
     this.name = name ?? '';
     this.price = price ?? '0';
     this.durationType = durationType ?? '';
     this.durationValue = durationValue;
     this.maxLibraries = maxLibraries;
     this.description = description ?? '';
     this.features = features ?? [];
   }

}
