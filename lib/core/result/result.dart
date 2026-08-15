class Result<T> {
  final T? data;
  final String? error;

  const Result.success(this.data) : error = null;
  const Result.failure(this.error) : data = null;

  bool get isSuccess => error == null;
}

class OperationResult {
  final String? outputPath;
  final List<String>? outputPaths;
  final String? textOutput;
  final String? error;

  bool get isSuccess => error == null;

  const OperationResult.success({this.outputPath, this.outputPaths, this.textOutput})
      : error = null;
  const OperationResult.failure(this.error)
      : outputPath = null,
        outputPaths = null,
        textOutput = null;
}
