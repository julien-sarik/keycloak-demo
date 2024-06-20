# keycloak-demo
## configuration
### access logs
Access log is not a feature provided by Keycloak itself but by Quarkus.  
In order to enable Quarkus access logs, configure a `quarkus.properties` file as documented in [Quarkus documentation](https://quarkus.io/guides/http-reference#configuring-http-access-logs).  
In order for Keycloak to take this file into account, it needs to be mounted into `/opt/keycloak/conf/quarkus.properties` as documented [here](https://www.keycloak.org/server/configuration#_format_for_raw_quarkus_properties).
## run
```
podman run --rm --name keycloak -p 8080:8080 -e KEYCLOAK_ADMIN=admin -e KEYCLOAK_ADMIN_PASSWORD=admin -v "$PWD"/config/quarkus.properties:/opt/keycloak/conf/quarkus.properties quay.io/keycloak/keycloak:25.0.0 start-dev
```
Then browse `http://localhost:8080`