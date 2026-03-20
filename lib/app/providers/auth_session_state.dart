class AuthSessionState {
  const AuthSessionState({required this.isLoggedIn});

  final bool isLoggedIn;

  AuthSessionState copyWith({bool? isLoggedIn}) {
    return AuthSessionState(isLoggedIn: isLoggedIn ?? this.isLoggedIn);
  }
}
