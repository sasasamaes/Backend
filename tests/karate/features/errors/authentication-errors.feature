Feature: Authentication Error Tests
    Test authentication error scenarios

Background:
    * url baseUrl
    * headers headers

Scenario: Missing Authentication Test
    * def query = read('queries/test-missing-auth.graphql')
    Given request { query: '#(query)' }
    When method POST
    Then status 200
    And match response.errors[0].message contains 'authentication required'

Scenario: Invalid User ID Test
    * def query = read('queries/test-invalid-user.graphql')
    Given request { query: '#(query)', variables: { userId: 'invalid-id' } }
    When method POST
    Then status 200
    And match response.errors[0].message contains 'user not found'

Scenario: Unauthorized Access Test
    * def query = read('queries/test-unauthorized-access.graphql')
    Given request { query: '#(query)', variables: { resourceId: 'restricted-resource' } }
    When method POST
    Then status 200
    And match response.errors[0].message contains 'unauthorized'