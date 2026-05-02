class RegisterRequest {
  final String nama;
  final String email;
  final String password;

  RegisterRequest({
    required this.nama,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {'nama': nama, 'email': email, 'password': password};
  }
}
