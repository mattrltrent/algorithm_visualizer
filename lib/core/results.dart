abstract class Result {}

//! Failures

abstract class Failure extends Result {}

class BadState extends Failure {}

class NoPathFailure extends Failure {}

//! Successes

abstract class Success extends Result {}

class GeneralSuccess extends Success {}

//! Result

abstract class General extends Result {}

class Nothing extends General {}
