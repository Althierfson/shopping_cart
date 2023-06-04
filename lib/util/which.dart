class Which<F, S> {
  S? _successValue;
  F? _failureValue;

  Which._({S? sucessValue, F? failureValue}) {
    _successValue = sucessValue;
    _failureValue = failureValue;
  }

  factory Which.sucesss(S value) => Which._(sucessValue: value);

  factory Which.failure(F value) => Which._(failureValue: value);

  F? get failure => _failureValue;

  S? get sucess => _successValue;

  void fold(Function(F failure) failure, Function(S success) success) {
    if (_failureValue != null) {
      failure(_failureValue as F);
      return;
    }
    if (_successValue != null) {
      success(_successValue as S);
      return;
    }
  }
}
