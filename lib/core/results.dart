abstract class Result {}

//! Failures

abstract class Failure extends Result {}

class BadState extends Failure {}

//! Successes

abstract class Success extends Result {}

class GeneralSuccess extends Success {}

//! Result

abstract class General extends Result {}

class Nothing extends General {}

class NoPath extends General {}

class PathFound extends General {}
