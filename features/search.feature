# features/search.feature
Feature: Search
  As a User
  I want to search for content
  In order to find content easily over paginating

  Background:
   Given I am on the home page

  Scenario: Find users by name
    Given the following users:
      | name             |
      | Jack Brown |
      | Emily Schauer          |
    When I search for "Jack"
    Then I should be on the search page
    And I should see the user named "Jack Brown" in the user list
    But I should not see the user named "Emily Schauer" in the post list

  Scenario: No users found
    When I search for "Armor Wars"
    Then I should be on the search page
    And I should see a message indicating no users were found

