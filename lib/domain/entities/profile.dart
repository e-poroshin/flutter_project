class Profile {
  final String firstName;
  final String lastName;
  final String email;

  Profile({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
