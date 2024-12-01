Feature: Firebase Token Validation Tests

Background:
    * url baseUrl
    * headers headers
    * def testToken = 'validFirebaseToken'
    * def expiredToken = 'expiredFirebaseToken'
    * def invalidToken = 'invalidToken'

@auth
Scenario: Valid Firebase Token Authentication
    * def loginQuery = loadQuery('karate/features/auth/queries/login.graphql')
    Given request { query: '#(loginQuery)', variables: { token: '#(testToken)' } }
    When method POST
    Then status 200
    And match response.errors == '#notpresent'
    And match response.data.login contains { token: '#present', user: '#present' }

Scenario: Expired Token Rejection
    * def loginQuery = loadQuery('karate/features/auth/queries/login.graphql')
    Given request { query: '#(loginQuery)', variables: { token: '#(expiredToken)' } }
    When method POST
    Then status 200
    And match response.errors[0].message contains 'expired'

Scenario: Invalid Token Format
    * def loginQuery = loadQuery('karate/features/auth/queries/login.graphql')
    Given request { query: '#(loginQuery)', variables: { token: '#(invalidToken)' } }
    When method POST
    Then status 200
    And match response.errors[0].message contains 'invalid'