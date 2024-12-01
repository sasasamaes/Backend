Feature: User Role Tests
    Test role management and verification

Background:
    * url baseUrl
    * headers headers
    * call read('../auth/login.feature@login')
    * def authToken = response.data.loginWithFirebase.accessToken

Scenario: Verify Tenant Role
    * def verifyTenantQuery = read('queries/verify-tenant-role.graphql')
    Given request { query: '#(verifyTenantQuery)' }
    When method POST
    Then status 200
    And match response.data.currentUser.roles contains 'tenant'

Scenario: Verify Landlord Role
    * def verifyLandlordQuery = read('queries/verify-landlord-role.graphql')
    Given request { query: '#(verifyLandlordQuery)' }
    When method POST
    Then status 200
    And match response.data.currentUser.roles contains 'landlord'

Scenario: Check Role Permissions
    * def checkPermissionsQuery = read('queries/check-role-permissions.graphql')
    Given request { query: '#(checkPermissionsQuery)', variables: { roleId: 'tenant', resource: 'properties' } }
    When method POST
    Then status 200
    And match response.data.checkRolePermissions contains { hasAccess: '#boolean' }

Scenario: Role Transition
    * def roleTransitionMutation = read('queries/role-transition.graphql')
    * def transitionInput = { fromRole: 'tenant', toRole: 'landlord' }
    Given request { query: '#(roleTransitionMutation)', variables: { input: '#(transitionInput)' } }
    When method POST
    Then status 200
    And match response.data.initiateRoleTransition contains { success: '#boolean', transitionId: '#present' }