Feature: User Queries

Background:
  * url HASURA_ENDPOINT
  * def getUserWalletsQuery = read('queries/get-user-wallets.graphql')
  * def testUserId = '123e4567-e89b-12d3-a456-426614174000'

Scenario: Query User Wallets Successfully
  Given path '/v1/graphql'
  And header Authorization = 'Bearer ' + firebase_token
  And header x-hasura-role = 'user'
  And request 
  """
  {
    "query": "#(getUserWalletsQuery)",
    "variables": {
      "userId": "#(testUserId)"
    }
  }
  """
  When method post
  Then status 200
  And match response.data.user_wallets[0] contains { is_primary: true }
  And match response.errors == '#notpresent'

Scenario: Query User Wallets with Invalid Token
  Given path '/v1/graphql'
  And header Authorization = 'Bearer invalid_token'
  And request 
  """
  {
    "query": "#(getUserWalletsQuery)",
    "variables": {
      "userId": "#(testUserId)"
    }
  }
  """
  When method post
  Then status 200
  And match response.errors[0].message contains 'invalid token'