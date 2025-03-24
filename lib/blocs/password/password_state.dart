class PasswordState {
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  PasswordState({
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  PasswordState copyWith({bool? isPasswordVisible, bool? isConfirmPasswordVisible}) {
    return PasswordState(
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible: isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }
}