{
  // +:: is important (we don't want to override the
  // _config object, just add to it)
  _config+:: {
    flask_demo: {
      port: 8000,
      name: 'flask-demo',
      config_name: 'flask-demo-config',
      config_map: {
        DJANGO_ALLOWED_HOSTS: '*',
        STATIC_ENDPOINT_URL: 'https://your_space_name.space_region.digitaloceanspaces.com',
        STATIC_BUCKET_NAME: 'your_space_name',
        DJANGO_LOGLEVEL: 'info',
        DEBUG: 'True',
        DATABASE_ENGINE: 'postgresql_psycopg2',
      },
    },
  },


  // again, make sure to use +::

  // default params is coming from test env
  _images+:: {
    apps: {
      flask_demo: '192.168.1.98/channel-test/flask-demo:latest',
    },
  },

  // myConfigData:: {
  //   DJANGO_ALLOWED_HOSTS: '*',
  //   STATIC_ENDPOINT_URL: 'https://your_space_name.space_region.digitaloceanspaces.com',
  //   STATIC_BUCKET_NAME: 'your_space_name',
  //   DJANGO_LOGLEVEL: 'info',
  //   DEBUG: 'True',
  //   DATABASE_ENGINE: 'postgresql_psycopg2',
  // },
}
