function fn() {
  karate.configure('connectTimeout', 30000);
  karate.configure('readTimeout', 30000);

  // Configuración base
  const config = {
    baseUrl: 'http://localhost:8080/v1/graphql',
    adminSecret: karate.properties['HASURA_ADMIN_SECRET'] || '',
    firebaseApiKey: karate.properties['FIREBASE_API_KEY'] || '',
    firebaseAuthUrl: 'https://identitytoolkit.googleapis.com/v1/accounts',
    
    // Headers por defecto para GraphQL
    headers: {
      'Content-Type': 'application/json',
      'X-Hasura-Admin-Secret': karate.properties['HASURA_ADMIN_SECRET'] || ''
    }
  };

  // Función de utilidad para leer archivos de consultas GraphQL
  const loadQuery = (filePath) => {
    const file = karate.read(filePath);
    return file.replace(/\s+/g, ' ').trim();
  };

  // Agregar función de utilidad al config
  config.loadQuery = loadQuery;

  // Funciones de autenticación de Firebase
  config.auth = {
    // Obtener token con email/password
    signInWithEmailPassword: function(email, password) {
      const response = karate.http({
        url: config.firebaseAuthUrl + ':signInWithPassword?key=' + config.firebaseApiKey,
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        data: {
          email: email,
          password: password,
          returnSecureToken: true
        }
      });
      return response.json;
    },

    // Crear usuario con email/password
    signUp: function(email, password) {
      const response = karate.http({
        url: config.firebaseAuthUrl + ':signUp?key=' + config.firebaseApiKey,
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        data: {
          email: email,
          password: password,
          returnSecureToken: true
        }
      });
      return response.json;
    },

    // Obtener header de autorización
    getAuthHeader: function(token) {
      return { 'Authorization': 'Bearer ' + token };
    },

    // Obtener custom token
    getCustomToken: function(uid) {
      // Nota: Esto requiere configuración adicional con Firebase Admin SDK
      const response = karate.http({
        url: config.baseUrl + '/auth/custom-token',
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        data: { uid: uid }
      });
      return response.json.token;
    },

    // Verificar token ID
    verifyIdToken: function(idToken) {
      const response = karate.http({
        url: config.firebaseAuthUrl + ':lookup?key=' + config.firebaseApiKey,
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        data: { idToken: idToken }
      });
      return response.json;
    }
  };

  return config;
}