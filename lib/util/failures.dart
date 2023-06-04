abstract class Failure {}

class DeleteFailure extends Failure {
  @override
  String toString() => "Failure on delete data!";
}

class SaveFailure extends Failure {
  @override
  String toString() => "Failure on save data!";
}

class UpdateFailure extends Failure {
  @override
  String toString() => "Failure on update data!";
}

class FetchFailure extends Failure {
  @override
  String toString() => "Failure on search for data!";
}
