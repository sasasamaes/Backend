Feature: Wallet Management Tests

Background:
  * url HASURA_ENDPOINT
  * def walletSchema = read('../helpers/schemas.js').walletSchema
  * def userId = '123e4567-e89b-12d3-a456-426614174000'

Scenario: Create Primary Wallet
  Given path '/v1/graphql'
  And header x-hasura-admin-secret = HASURA_ADMIN_SECRET
  And request {
    query: `
      mutation CreateWallet($userId: uuid!, $address: String!) {
        insert_wallets_one(object: {
          user_id: $userId,
          address: $address,
          is_primary: true,
          chain_type: "ETH"
        }) {
          id
          address
          is_primary
          chain_type
          created_at
        }
      }
    `,
    variables: {
      userId: userId,
      address: "0x742d35Cc6634C0532925a3b844Bc454e4438f44e"
    }
  }
  When method post
  Then status 200
  And match response.data.insert_wallets_one contains walletSchema
  And match response.data.insert_wallets_one.is_primary == true

Scenario: Verify Wallet Address Format
  Given path '/v1/graphql'
  And header x-hasura-admin-secret = HASURA_ADMIN_SECRET
  And request {
    query: `
      mutation CreateWallet($userId: uuid!, $address: String!) {
        insert_wallets_one(object: {
          user_id: $userId,
          address: $address,
          chain_type: "ETH"
        }) {
          id
        }
      }
    `,
    variables: {
      userId: userId,
      address: "invalid-address"
    }
  }
  When method post
  Then status 200
  And match response.errors[0].message contains 'invalid wallet address'