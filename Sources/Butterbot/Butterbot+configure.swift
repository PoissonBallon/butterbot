import FluentPostgreSQL
import Vapor
import Leaf


extension Butterbot {
  public func configure() throws {
    self.configureHttpRouter()
    self.configureLeaf()
    self.configurePostgreSQL()

    //    self.addGoogleAnalytics()
//    services.register(Butterbot.self)
  }
  
  private func configureHttpRouter() {
//    let webController = WebController()
//    let slackAuthController = SlackAuthController()
    let router = EngineRouter.default()
//      router.get("", use: webController.index)
//      router.group("slack") { (subRouter) in
//        subRouter.get("/oauth/authorize", use: slackAuthController.oauthAuthorize)
//        subRouter.post("/event", use: slackAuthController.event)
//      }
    self.services.register(router, as: Router.self)
  }
  
//  private static func addGoogleAnalytics() {
//    // Analytics
//    //  let config = GoogleAnalyticsConfig(trackingID: Environment.GoogleAnalyticsTrackingID)
//    //  services.register(config)
//    //  try services.register(GoogleAnalyticsProvider())
//    // Database
//  }
  
  private func configureLeaf() {
    self.services.register { container -> LeafRenderer in
      let directoryConfig = try container.make(DirectoryConfig.self)
      let viewsDirectory = directoryConfig.workDir + "Resources/Views"
      let config = LeafConfig(tags: LeafTagConfig.default(), viewsDir: viewsDirectory, shouldCache: true)
      return LeafRenderer(config: config, using: container)
    }
  }
  
  private func configurePostgreSQL() {
    let postgreConfig = PostgreSQLDatabaseConfig(url: Environment.postgreUri, transport: .unverifiedTLS)
    let database = PostgreSQLDatabase(config: postgreConfig!)
    var databasesConfig = DatabasesConfig()
    var migrationsConfig = MigrationConfig()
    
    try? services.register(FluentPostgreSQLProvider())
    databasesConfig.add(database: database, as: .psql)
    
    self.feature.forEach {
      $0.configurePostgreSQL(&migrationsConfig)
    }
    services.register(databasesConfig)
    services.register(migrationsConfig)
    services.register(DatabaseConnectionPoolConfig(maxConnections: 4))
    
  }

}
