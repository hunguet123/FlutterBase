class AuthState {
  const AuthState({
    required this.username,
    required this.password,
    required this.isLoading,
    required this.isLoggedIn,
  });

  final String username;
  final String password;
  final bool isLoading;
  final bool isLoggedIn;

  factory AuthState.initial({required bool isLoggedIn}) {
    return AuthState(
      username: '',
      password: '',
      isLoading: false,
      isLoggedIn: isLoggedIn,
    );
  }

  AuthState copyWith({
    String? username,
    String? password,
    bool? isLoading,
    bool? isLoggedIn,
  }) {
    return AuthState(
      username: username ?? this.username,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
