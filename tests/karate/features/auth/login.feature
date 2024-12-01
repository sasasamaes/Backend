Feature: Authentication Tests
    Test Firebase authentication and token management

Background:
    * url baseUrl
    * headers headers

@login
Scenario: Successful Firebase Login
    * def loginMutation = read('queries/login-with-firebase.graphql')
    * def validToken = 'valid-firebase-token'
    Given request { query: '#(loginMutation)', variables: { firebaseToken: '#(validToken)' } }
    When method POST
    Then status 200
    And match response.errors == '#notpresent'
    And match response.data.loginWithFirebase contains { accessToken: '#present', refreshToken: '#present' }
    * def authToken = response.data.loginWithFirebase.accessToken

Scenario: Refresh Token
    * def refreshTokenMutation = read('queries/refresh-token.graphql')
    * def refreshToken = 'valid-refresh-token'
    Given request { query: '#(refreshTokenMutation)', variables: { refreshToken: '#(refreshToken)' } }
    When method POST
    Then status 200
    And match response.data.refreshToken contains { accessToken: '#present', refreshToken: '#present' }

Scenario: Check Token Status
    * def checkTokenQuery = read('queries/check-token-status.graphql')
    Given request { query: '#(checkTokenQuery)' }
    When method POST
    Then status 200
    And match response.data.tokenStatus contains { isValid: '#boolean', expiresIn: '#number' }

Scenario: Verify Session
    * def sessionQuery = read('queries/verify-session.graphql')
    Given request { query: '#(sessionQuery)' }
    When method POST
    Then status 200
    And match response.data.currentSession contains { isValid: '#boolean', expiresAt: '#present' }