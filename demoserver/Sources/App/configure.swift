import Vapor
import QueuesRedisDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    try app.queues.use(.redis(url: "redis://127.0.0.1:6379"))

    // register routes
    try routes(app)
}
