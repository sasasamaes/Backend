Feature: User Creation

Background:
  * url HASURA_ENDPOINT
  * def createUserQuery = read('queries/create-user.graphql')

Scenario: Create New User
  Given path '/v1/graphql'
  And header x-hasura-admin-secret = HASURA_ADMIN_SECRET
  And request 
  """
  {
    "query": "#(createUserQuery)",
    "variables": {
      "email": "test@example.com",
      "name": "Test User"
    }
  }
  """
  When method post
  Then status 200
  And match response.data.insert_users_one.email == 'test@example.com'
  And match response.errors == '#notpresent'