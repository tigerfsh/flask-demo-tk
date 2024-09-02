(import 'fdemo/fdemo.libsonnet') +
{
  // again, we only want to patch, not replace, thus +::
  _images+:: {
    apps: {
      flask_demo: '192.168.1.98/channel-test/flask-demo',
    },
  },
}
