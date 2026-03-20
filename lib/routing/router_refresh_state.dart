class RouterRefreshState {
  const RouterRefreshState({
    required this.isLoggedIn,
    required this.isMaintenance,
  });

  final bool isLoggedIn;
  final bool isMaintenance;

  RouterRefreshState copyWith({
    bool? isLoggedIn,
    bool? isMaintenance,
  }) {
    return RouterRefreshState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isMaintenance: isMaintenance ?? this.isMaintenance,
    );
  }
}
