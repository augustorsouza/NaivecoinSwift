import Vapor

var application: Application!

/// Called after your application has initialized.
public func boot(_ app: Application) throws {
    application = app
}
