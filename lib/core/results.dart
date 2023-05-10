//! Failures

abstract class Failure {}

class GeneralFailure extends Failure {}

class NoneFailure extends Failure {}

class NoPathFailure extends Failure {}

//! Successes

abstract class Success {}

class GeneralSuccess extends Success {}
