class CustomerModel {
  int? id;
  String? customerType;
  String? salutation;
  String? firstName;
  String? lastName;

  CustomerModel({
    this.id,
    this.customerType,
    this.salutation,
    this.firstName,
    this.lastName,
  });

  // Convert a Customer object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerType': customerType,
      'salutation': salutation,
      'firstName': firstName,
      'lastName': lastName,
    };
  }

  // Create a Customer object from a Map
  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      customerType: map['customerType'],
      salutation: map['salutation'],
      firstName: map['firstName'],
      lastName: map['lastName'],
    );
  }
}