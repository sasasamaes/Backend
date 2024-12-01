# API Testing with Karate Framework

## Description
This project contains automated tests for a GraphQL API using Karate Framework. The tests cover authentication functionalities:
- user management,
- wallets
- error validation.

## Prerequisites
- Java 11 or higher
- Docker and Docker Compose
- Firebase access
- GraphQL server access (Hasura)

## Project Structure
```
├── docker-compose.test.yml
├── Dockerfile.test
├── karate-config.js
├── README.md
└── karate/
    ├── features/
    │   ├── auth/
    │   │   ├── login.feature
    │   │   ├── firebase-validation.feature
    │   │   └── permissions.feature
    │   ├── users/
    │   │   ├── query.feature
    │   │   └── roles.feature
    │   ├── wallet/
    │   │   └── wallets.feature
    │   └── errors/
    │       ├── authentication-errors.feature
    │       └── wallet-errors.feature
    └── queries/
        └── *.graphql
```

## Configuration

### Environment Variables
Create a `.env` file in the project root with the following variables:
```env
HASURA_ADMIN_SECRET=your_admin_secret
FIREBASE_API_KEY=your_firebase_api_key
```

### Karate Configuration
The `karate-config.js` file contains global test configuration, including:
- Connection timeouts
- API base URL
- Authentication utility functions
- Headers management
- Firebase integration

## Running Tests

### Using Docker
```bash
# Build and run tests
docker-compose -f docker-compose.test.yml --env-file .env up --build

# View results
open karate-reports/karate-summary.html
```

### Locally
```bash
# Assuming you have Maven installed
mvn test
```

## Types of Tests

### Authentication
- Firebase login
- Token validation
- Permissions handling

### Users
- User queries
- Role management
- Profile updates

### Wallets
- Wallet creation
- CRUD operations
- Transaction validation

### Error Handling
- Authentication errors
- Wallet operation errors
- Input validation

## Reports
Test reports are automatically generated in HTML format and can be found at:
```
/results/karate-reports/karate-summary.html
```

## Troubleshooting

### Common Issues
1. **Connection Error**
   ```
   Connect to localhost:8080 failed: Connection refused
   ```
   - Verify GraphQL server is running
   - Check Docker Compose network configuration

2. **File Errors**
   ```
   FileNotFoundException: .../queries/login.graphql
   ```
   - Verify file paths
   - Ensure files are copied into the container

## Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact
- Project Name: API Testing with Karate
- Project Link: [https://github.com/your-username/your-repository](https://github.com/your-username/your-repository)

## Acknowledgments
- [Karate Framework](https://github.com/karatelabs/karate)
- [GraphQL](https://graphql.org/)
- [Firebase](https://firebase.google.com/)
- [Hasura](https://hasura.io/)

Would you like me to expand on any section or add additional information?