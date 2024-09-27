protocol GeoLoggerProtocol: Sendable {
    /// Logs a message along with the source file, function, and line number where the log was generated.
    ///
    /// - Parameters:
    ///   - logType: The type of log which is outputted.
    ///   - message: The message which is logged.
    ///   - file: The name of the file where the log is called.
    ///   - function: The name of the function where the log is called.
    ///   - line: The line number in the file where the log is called.
    ///
    /// - Important: Do not to manually pass values for `file`, `function`, and `line`.
    /// These parameters have default values that automatically capture the context where the log is called,
    /// ensuring accurate logging information.
    ///
    /// ```swift
    /// //
    /// // Example.swift
    /// //
    /// //
    ///
    /// class Example {
    ///     func example() async {
    ///         await locationLog(logType: .debug, message: "An example log message.")
    ///     }
    /// }
    /// ```
    ///
    /// ```swift
    /// // Output to Xcode console
    /// // 2001-01-01 00:00:00.000 [ℹ️] [Example.swift]:8 example() -> An example log message.
    /// ```
    func geoLog(
        logType: LogType,
        message: String,
        file: String,
        function: String,
        line: Int
    )
}

extension GeoLoggerProtocol {
    func geoLog(
        logType: LogType,
        message: String,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        geoLog(
            logType: logType,
            message: message,
            file: file,
            function: function,
            line: line
        )
    }
}
