Feature: Firebase Token Validation Tests

Background:
    * url baseUrl
    * headers headers
    * def loginQuery = read('queries/login-with-firebase.graphql')
    * def testToken = 'valid-firebase-token'
    * def expiredToken = 'expired-firebase-token'
    * def invalidToken = 'invalid-token'

@auth
Scenario: Valid Firebase Token Authentication
    Given request 
    """
    {
      "query": "#(loginQuery)",
      "variables": { 
        "token": "#(testToken)" 
      }
    }
    """
    When method POST
    Then status 200
    And match response.errors == '#notpresent'
    And match response.data.loginWithFirebase contains { token: '#present', user: '#present' }

Scenario: Expired Token Rejection
    Given request 
    """
    {
      "query": "#(loginQuery)",
      "variables": { 
        "token": "#(expiredToken)" 
      }
    }
    """
    When method POST
    Then status 200
    And match response.errors[0].message contains 'expired'

Scenario: Invalid Token Format
    Given request 
    """
    {
      "query": "#(loginQuery)",
      "variables": { 
        "token": "#(invalidToken)" 
      }
    }
    """
    When method POST
    Then status 200
    And match response.errors[0].message contains 'invalid'