import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    try services.register(FluentSQLiteProvider())

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Configure a SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)

    /// Register the configured SQLite database to the database config.
    var databases = DatabasesConfig()
    databases.add(database: sqlite, as: .sqlite)
    services.register(databases)

    /// Configure migrations
    let migrations = MigrationConfig()
    services.register(migrations)

    // Websockets
    
    // Create a new NIO websocket server
    let wss = NIOWebSocketServer.default()

    // Add WebSocket upgrade support to GET /echo
    wss.get("echo") { ws, req in
        // Add a new on text callback
        ws.onText { ws, text in
            // Simply echo any received text
            ws.send("TESTE AUGUSTO" + text)
        }
    }

    // Register our server
    services.register(wss, as: WebSocketServer.self)
}
