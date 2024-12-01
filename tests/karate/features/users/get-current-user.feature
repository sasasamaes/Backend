Feature: Current User

Background:
  * url HASURA_ENDPOINT
  * def getCurrentUserQuery = read('queries/get-current-user.graphql')
  * def authToken = 'your_auth_token'

Scenario: Get Current User Profile
  Given path '/v1/graphql'
  And header Authorization = 'Bearer ' + authToken
  And request 
  """
  {
    "query": "#(getCurrentUserQuery)",
    "variables": {
      "userId": "#(userId)"
    }
  }
  """
  When method post
  Then status 200
  And match response.data.users_by_pk != null
  And match response.data.users_by_pk contains { email: '#string' }