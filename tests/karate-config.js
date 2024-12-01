function fn() {
  var env = karate.env || 'dev';
  var config = {
      env: env,
      HASURA_ENDPOINT: java.lang.System.getenv('HASURA_ENDPOINT'),
      HASURA_ADMIN_SECRET: java.lang.System.getenv('HASURA_ADMIN_SECRET'),
      FIREBASE_API_KEY: java.lang.System.getenv('FIREBASE_API_KEY')
  };
  
  if (env == 'dev') {
      config.tenant_token = 'test-tenant-token';
      config.landlord_token = 'test-landlord-token';
  }
  
  return config;
}