class LoginState {
  const LoginState({required this.isLoading});

  final bool isLoading;

  factory LoginState.initial() => const LoginState(isLoading: false);

  LoginState copyWith({bool? isLoading}) {
    return LoginState(isLoading: isLoading ?? this.isLoading);
  }
}
