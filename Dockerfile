FROM quay.io/keycloak/keycloak:25.0.0 as builder

# persist build configuration to allow faster startup using `bin/kc.sh start --optimized` that avoid doing the Keycloak build process on startup
# https://www.keycloak.org/server/configuration#_optimize_the_keycloak_startup

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# for demonstration purposes only, please make sure to use proper certificates in production instead
WORKDIR /opt/keycloak
RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore


# build an optimized image with the expected configuration
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:25.0.0
# output of the build is copied to the final image
COPY --from=builder /opt/keycloak/ /opt/keycloak/