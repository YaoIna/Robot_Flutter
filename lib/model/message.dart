class Message {
  final String message;
  final Role role;

  const Message(this.message, this.role);

  get isFromUser => role == Role.user;
}

enum Role { user, robot }
