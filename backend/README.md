# NovaSys backend

Spring Boot service foundation for the NovaSys school transport management system.

This is **foundation setup only**. The application starts, connects to an in-memory
development database and reports its health. There are no domain endpoints yet:
no authentication, no driver search, no payments, no tracking. The Flutter app in
this repository does not call this service.

## Requirements

- **Java 21** (JDK, not just a JRE). The build targets Java 21 bytecode and will
  not compile on an older JDK.
- **Maven 3.9+** (tested with 3.9.16).

Verify your toolchain before building:

```sh
java -version     # expect 21.x
mvn -version      # the reported "Java version" must also be 21.x
```

If Maven reports a different Java version than `java -version`, point `JAVA_HOME`
at your JDK 21 installation for the session, for example in PowerShell:

```powershell
$env:JAVA_HOME = "C:\Users\<you>\AppData\Local\Programs\Eclipse Adoptium\jdk-21.0.12.101-hotspot"
```

## Starting the backend

From the `backend/` directory:

```sh
mvn spring-boot:run
```

The service listens on <http://localhost:8080>.

To build and run a standalone jar instead:

```sh
mvn clean package
java -jar target/novasys-backend-0.0.1-SNAPSHOT.jar
```

To change the port without editing configuration:

```sh
mvn spring-boot:run -Dspring-boot.run.arguments=--server.port=9090
```

## Running tests

```sh
mvn test
```

Three tests cover the foundation:

| Test | Verifies |
| --- | --- |
| `NovasysBackendApplicationTests.contextLoads` | The Spring application context starts, which also proves the datasource and JPA configuration are valid |
| `NovasysBackendApplicationTests.dataSourceIsConfigured` | A `dataSource` bean is present |
| `HealthEndpointTests.healthEndpointReturnsUp` | `GET /actuator/health` returns 200 with `"status":"UP"` |

## Local database

Development uses an **H2 in-memory database**. Nothing is written to disk, and all
data is discarded when the process stops.

| Setting | Value |
| --- | --- |
| JDBC URL | `jdbc:h2:mem:novasysdb` |
| Username | `sa` |
| Password | *(empty)* |
| Schema generation | `create-drop` — the schema is rebuilt on every start |

Hibernate logs the SQL it runs (`spring.jpa.show-sql=true`), which is useful while
entities are being added and should be turned off before any production use.

A browser SQL console is enabled for development at <http://localhost:8080/h2-console>.
Enter the JDBC URL above and username `sa` to connect.

No production database is configured. Replacing H2 means adding a real datasource,
switching `spring.jpa.hibernate.ddl-auto` away from `create-drop`, and introducing
schema migrations.

## Health check

Spring Boot Actuator provides the health endpoint; there is no hand-written
controller.

```sh
curl http://localhost:8080/actuator/health
```

```json
{
  "status": "UP",
  "components": {
    "db":        { "status": "UP", "details": { "database": "H2" } },
    "diskSpace": { "status": "UP" },
    "ping":      { "status": "UP" },
    "ssl":       { "status": "UP" }
  }
}
```

Only `health` and `info` are exposed (`management.endpoints.web.exposure.include`).
`management.endpoint.health.show-details=always` returns the component breakdown
shown above, which is appropriate locally but should be restricted before this
service is reachable from outside a development machine.

Available endpoints are listed at <http://localhost:8080/actuator>.

## Project layout

```
backend/
├── pom.xml
└── src/
    ├── main/
    │   ├── java/com/novasys/backend/NovasysBackendApplication.java
    │   └── resources/application.properties
    └── test/
        └── java/com/novasys/backend/
            ├── NovasysBackendApplicationTests.java
            └── HealthEndpointTests.java
```

Base package: `com.novasys.backend`.

## Dependencies

Spring Web, Spring Data JPA, Validation, H2, Spring Boot Actuator, and Spring Boot
Test (Spring Boot 3.5.16).
