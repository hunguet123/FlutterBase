/// App-level intents emitted by any feature screen.
/// The app layer listens and handles the actual business logic.
sealed class AppEvent {
  const AppEvent();
}

/// User requested to log out from any screen.
class LogoutRequested extends AppEvent {
  const LogoutRequested();
}
