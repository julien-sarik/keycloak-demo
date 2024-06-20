# keycloak-demo
## configuration
### startup mode
When using the dev mode (i.e. `kc.sh start-dev` command) some security features are disabled.  
Prod mode (i.e. `kc.sh start` command) requires TLS and hostname configuration.  
https://www.keycloak.org/server/configuration#_starting_keycloak
### startup optimization
By default the `start` and `start-dev` commands implicitly run the `build` command. This build command performs a set of optimizations for the startup and runtime behavior. To avoid losing that time, run a build explicitly before starting up during the Docker build.  
Keycloak distinguishes between build options, that are usable when running the build command, and configuration options, that are usable when starting up the server. Build options are marked in [All configuration](https://www.keycloak.org/server/all-config) with a tool icon.  
To startup Keycloak without the `build` step, add the `--optimized` option to the `start` command. 
https://www.keycloak.org/server/configuration#_optimize_the_keycloak_startup
### access logs
Access log is not a feature provided by Keycloak itself but by Quarkus.  
In order to enable Quarkus access logs, configure a `quarkus.properties` file as documented in [Quarkus documentation](https://quarkus.io/guides/http-reference#configuring-http-access-logs).  
In order for Keycloak to take this file into account, it needs to be mounted into `/opt/keycloak/conf/quarkus.properties` as documented [here](https://www.keycloak.org/server/configuration#_format_for_raw_quarkus_properties).
### observability
If enabled, a `/metrics` endpoint is available on the management port at `https://localhost:9000/metrics`. When the TLS is set for the default Keycloak server, the management interface will be accessible through HTTPS as well. The management interface can run only either on HTTP or HTTPS.  
The response has the Prometheus (OpenMetrics) format.
### hostname
As documented [here](https://www.keycloak.org/server/hostname) when running on production mode Keycloak default behavior is to be requested through a staticly configured hostname provided by `KC_HOSTNAME` env var.
### HTTP
As documented [here](https://www.keycloak.org/server/hostname#_using_edge_tls_termination), even if by default in production mode Keycloak is expecting HTTPS only, it can be configured to accept HTTP traffic from a reverse-proxy responsible for the TLS termination. This is enabled through `KC_HTTP_ENABLED` env var.
## build
```
podman build -t keycloak:local .
```

## run
```
podman run --rm --name keycloak -p 8443:8443 -p 8080:8080 -p 9000:9000 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin -e KC_HOSTNAME=https://localhost:8443 -e KC_HTTP_ENABLED=true -v "$PWD"/config/quarkus.properties:/opt/keycloak/conf/quarkus.properties keycloak:local start --optimized
```
Then browse `https://localhost:8443`