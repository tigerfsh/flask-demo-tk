local k = import 'github.com/grafana/jsonnet-libs/ksonnet-util/kausal.libsonnet';

(import './config.libsonnet') +
{

  local deployment = k.apps.v1.deployment,
  local container = k.core.v1.container,
  local port = k.core.v1.containerPort,
//   local service = k.core.v1.service,
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

  polls_app: {
    configMap: configMap.new($._config.flask_demo.config_name) + configMap.withData($._config.flask_demo.config_map),

    deployment: deployment.new(
      name=$._config.flask_demo.name,
      replicas=1,
      containers=[
        container.new($._config.flask_demo.name, $._images.apps.flask_demo)
        + container.withPorts([port.new('api', $._config.flask_demo.port)])
        + container.withEnvFrom(envFrom.configMapRef.withName(self.configMap.metadata.name)),
      ]
    ),

    service: k.util.serviceFor(self.deployment),

    ingress: ingress.new('polls-ingress')
             + ingress.spec.withIngressClassName('nginx')
             + ingress.spec.withRules([
               ingressRule.withHost('hello.polls.com') + ingressRule.http.withPaths([
                 httpIngressPath.withPath('/')
                 + httpIngressPath.withPathType('Prefix')
                 + httpIngressPath.backend.service.withName($._config.flask_demo.name)
                 // + httpIngressPath.backend.service.port.withName("nginx")
                 + httpIngressPath.backend.service.port.withNumber(5000),
               ]),
             ]),
  },


}
