local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';
// local k = import "github.com/jsonnet-libs/k8s-libsonnet/1.30/main.libsonnet"

{

    local deployment = k.apps.v1.deployment,
    local container = k.core.v1.container,
    local port = k.core.v1.containerPort,
    local service = k.core.v1.service,
    local configMap = k.core.v1.configMap,
    local envFrom = k.core.v1.envFromSource,
    local ingress = k.networking.v1.ingress,
    local ingressRule = k.networking.v1.ingressRule,
    local httpIngressPath = k.networking.v1.httpIngressPath,

    // local configMapRef = k.core.v1.envFromSource.configMapRef,

    // myConfigData:: {
    //     "foo.yml": std.manifestYamlDoc({
    //     foo: "bar",
    //     list: [1,2,3],
    //     object: {
    //         "my key": "contains a space!",
    //     }
    //     }),
    // },

    myConfigData:: {
        DJANGO_ALLOWED_HOSTS: "*",
        STATIC_ENDPOINT_URL: "https://your_space_name.space_region.digitaloceanspaces.com",
        STATIC_BUCKET_NAME: "your_space_name",
        DJANGO_LOGLEVEL: "info",
        DEBUG: "True",
        DATABASE_ENGINE: "postgresql_psycopg2",
    },

    // object
    _config:: {
        polls_app: {
            port: 5000,
            name: "polls"
        }
    },

    polls_app: {
        configMap: configMap.new("polls-config") + configMap.withData($.myConfigData),

        deployment: deployment.new(
            name='polls',
            replicas=1,
            containers=[
            container.new($._config.polls_app.name, 'polls:latest')
            + container.withPorts([port.new('api', $._config.polls_app.port)])
            + container.withEnvFrom(envFrom.configMapRef.withName(self.configMap.metadata.name))
            ]
        ),

        service: k.util.serviceFor(self.deployment),

        ingress: ingress.new("polls-ingress") 
        + ingress.spec.withIngressClassName("nginx")
        + ingress.spec.withRules([
            ingressRule.withHost("hello.polls.com") + ingressRule.http.withPaths([
                httpIngressPath.withPath("/")
                + httpIngressPath.withPathType("Prefix")
                + httpIngressPath.backend.service.withName('polls')
                // + httpIngressPath.backend.service.port.withName("nginx")
                + httpIngressPath.backend.service.port.withNumber(5000)
            ]),
        ]),
    },
    

}
