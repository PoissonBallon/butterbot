import FluentPostgreSQL
import Vapor
import Leaf

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
  
  //////////////////////////////////
  /////// ROUTER
  //////////////////////////////////
  
  let router = EngineRouter.default()
  try routes(router)
  services.register(router, as: Router.self)
  
  //////////////////////////////////
  /////// DATABASE
  //////////////////////////////////
  
  
  /// Register providers first
  var databasesConfig = DatabasesConfig()
  var migrationsConfig = MigrationConfig()
  let postgreConfig = try PostgreSQLDatabaseConfig(url: Environment.postgreUri, transport: .unverifiedTLS)
  let database = PostgreSQLDatabase(config: postgreConfig)

  try services.register(FluentPostgreSQLProvider())
  
  databasesConfig.add(database: database, as: .psql)

  migrationsConfig.add(model: BotRegistration.self, database: .psql)
  migrationsConfig.add(model: KarmaPoint.self, database: .psql)

  services.register(databasesConfig)
  services.register(migrationsConfig)
  services.register(DatabaseConnectionPoolConfig(maxConnections: 8))

  //////////////////////////////////
  /////// MIDDLEWARE
  //////////////////////////////////
  
  var middlewares = MiddlewareConfig()
  middlewares.use(ErrorMiddleware.self)
  services.register(middlewares)
  
  //////////////////////////////////
  /////// LEAF
  //////////////////////////////////
  
  services.register { container -> LeafRenderer in
    let directoryConfig = try container.make(DirectoryConfig.self)
    let viewsDirectory = directoryConfig.workDir + "Resources/Views"
    let config = LeafConfig(tags: LeafTagConfig.default(), viewsDir: viewsDirectory, shouldCache: true)
    return LeafRenderer(config: config, using: container)
  }
  
  //////////////////////////////////
  /////// Butterbot
  //////////////////////////////////

  services.register(Butterbot.self)
}
