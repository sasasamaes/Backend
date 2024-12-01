function fn() {
  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 30000);

  // Configuración base
  const config = {
    baseUrl: 'http://localhost:8080/v1/graphql',
    adminSecret: karate.properties['HASURA_ADMIN_SECRET'] || '',
    firebaseApiKey: karate.properties['FIREBASE_API_KEY'] || '',
    
    // Headers por defecto para GraphQL
    headers: {
      'Content-Type': 'application/json',
      'X-Hasura-Admin-Secret': karate.properties['HASURA_ADMIN_SECRET'] || ''
    }
  };

  // Función de utilidad para leer archivos de consultas GraphQL
  const loadQuery = (filePath) => {
    const file = karate.read('classpath:' + filePath);
    return file.replace(/\s+/g, ' ').trim();
  };

  // Agregar función de utilidad al config
  config.loadQuery = loadQuery;

  // Función helper para autenticación
  config.auth = {
    getAuthHeader: function(token) {
      return { 'Authorization': 'Bearer ' + token };
    }
  };

  // Helper para manejar respuestas GraphQL
  config.handleResponse = function(response) {
    if (response.errors) {
      karate.log('GraphQL Error:', response.errors);
      return false;
    }
    return true;
  };

  // Helper para cargar schemas
  const schemas = karate.read('classpath:helpers/schemas.js');
  config.schemas = schemas;

  return config;
}