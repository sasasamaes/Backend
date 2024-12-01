Feature: Wallet Error Tests
    Test wallet-related error scenarios

Background:
    * url baseUrl
    * headers headers
    * call read('../auth/login.feature@login')
    * def authToken = response.data.loginWithFirebase.accessToken

Scenario: Invalid Wallet Address Test
    * def query = read('queries/test-wallet-errors.graphql')
    Given request { query: '#(query)', variables: { address: 'invalid-address', chainType: 'ETH' } }
    When method POST
    Then status 200
    And match response.errors[0].message contains 'invalid wallet address'

Scenario: Test Invalid Operations
    * def query = read('queries/test-invalid-operations.graphql')
    * def invalidInput = { operation: 'INVALID_OP' }
    Given request { query: '#(query)', variables: { input: '#(invalidInput)' } }
    When method POST
    Then status 200
    And match response.errors[0].message contains 'invalid operation'