Feature: User Query Tests
    Test user information retrieval and management

Background:
    * url baseUrl
    * headers headers
    * call read('../auth/login.feature@login')
    * def authToken = response.data.loginWithFirebase.accessToken

Scenario: Get Current User
    * def getCurrentUserQuery = read('queries/get-current-user.graphql')
    Given request { query: '#(getCurrentUserQuery)' }
    When method POST
    Then status 200
    And match response.data.currentUser contains { id: '#present', email: '#present' }

Scenario: List Users with Pagination
    * def listUsersQuery = read('queries/list-users.graphql')
    Given request { query: '#(listUsersQuery)', variables: { first: 10, after: null } }
    When method POST
    Then status 200
    And match response.data.users.edges == '#[_ > 0]'