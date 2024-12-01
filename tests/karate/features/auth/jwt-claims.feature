Feature: JWT Claims Verification

Background:
    * url baseUrl
    * headers headers
    * def loginResult = call read('firebase-validation.feature@auth')
    * def authToken = loginResult.response.data.login.token

Scenario: Verify JWT Claims Structure
    * def jwtPayload = decodeJwt(authToken)
    And match jwtPayload contains { sub: '#present', role: '#present', exp: '#present' }
    And match jwtPayload.role == '#regex (tenant|landlord)'