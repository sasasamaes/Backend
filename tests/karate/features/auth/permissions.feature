Feature: Permission Tests
    Test role-based permissions and access control

Background:
    * url baseUrl
    * headers headers
    * call read('login.feature@login')
    * def authToken = response.data.loginWithFirebase.accessToken

Scenario: Validate Firebase Token
    * def validateTokenMutation = read('queries/validate-firebase-token.graphql')
    Given request { query: '#(validateTokenMutation)', variables: { token: '#(authToken)' } }
    When method POST
    Then status 200
    And match response.data.verifyFirebaseToken contains { valid: true }

Scenario: Revoke Token
    * def revokeTokenMutation = read('queries/revoke-token.graphql')
    Given request { query: '#(revokeTokenMutation)', variables: { token: '#(authToken)' } }
    When method POST
    Then status 200
    And match response.data.revokeToken contains { success: true }