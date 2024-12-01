Feature: Firebase Authentication Tests
    Test Firebase authentication and token management

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
        query: '#(loginQuery)',
        variables: {
            firebaseToken: '#(testToken)'
        }
    }
    """
    When method POST
    Then status 200
    And match response.errors == '#notpresent'
    And match response.data.loginWithFirebase contains { accessToken: '#present', refreshToken: '#present' }
    * def authToken = response.data.loginWithFirebase.accessToken

Scenario: Expired Token Rejection
    Given request 
    """
    {
        query: '#(loginQuery)',
        variables: {
            firebaseToken: '#(expiredToken)'
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
        query: '#(loginQuery)',
        variables: {
            firebaseToken: '#(invalidToken)'
        }
    }
    """
    When method POST
    Then status 200
    And match response.errors[0].message contains 'invalid'