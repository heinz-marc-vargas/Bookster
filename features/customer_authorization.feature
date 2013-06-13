Feature: Customer Authorization
  In Order customer authorization details
  As an customer
  I want to login as a customer

  @javascript
  Scenario: Login Customer
    Given I am on the "/customer_booking/login" auth page
    When I am logged in facebook with login and password
    Then I should see "Select a Service"