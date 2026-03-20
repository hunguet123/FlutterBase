class LoginState {
  const LoginState({
    required this.username,
    required this.password,
    required this.isLoading,
  });

  final String username;
  final String password;
  final bool isLoading;

  factory LoginState.initial() {
    return const LoginState(username: '', password: '', isLoading: false);
  }

  LoginState copyWith({String? username, String? password, bool? isLoading}) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
