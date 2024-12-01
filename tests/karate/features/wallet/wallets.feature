Feature: Wallet Management Tests
    Test wallet operations and validations

Background:
    * url baseUrl
    * headers headers
    * call read('../auth/login.feature@login')
    * def authToken = response.data.loginWithFirebase.accessToken

Scenario: Get Wallet Information
    * def query = read('queries/get-wallet-info.graphql')
    Given request { query: '#(query)', variables: { walletId: 'test-wallet-id' } }
    When method POST
    Then status 200
    And match response.data.wallet contains { id: '#present', address: '#present' }

Scenario: Verify Primary Wallet
    * def query = read('queries/get-primary-wallet.graphql')
    Given request { query: '#(query)' }
    When method POST
    Then status 200
    And match response.data.primaryWallet contains { isPrimary: true }

Scenario: Create New Wallet
    * def mutation = read('queries/create-wallet.graphql')
    * def walletInput = { address: '0x123...', chainType: 'ETH' }
    Given request { query: '#(mutation)', variables: { input: '#(walletInput)' } }
    When method POST
    Then status 200
    And match response.data.createWallet contains { success: true }

Scenario: Validate Chain Type
    * def query = read('queries/validate-chain-type.graphql')
    Given request { query: '#(query)', variables: { chainType: 'ETH' } }
    When method POST
    Then status 200
    And match response.data.validateChainType contains { isValid: '#boolean' }

Scenario: Check Wallet Uniqueness
    * def query = read('queries/check-wallet-uniqueness.graphql')
    Given request { query: '#(query)', variables: { address: '0x123...', chainType: 'ETH' } }
    When method POST
    Then status 200
    And match response.data.checkWalletUniqueness contains { isUnique: '#boolean' }