Feature: View Categories
  As an blog administrator
  In order to organize blog entries
  I want to view and add categories to the blog

  Background:
    Given the blog is set up
    And I am logged into the admin panel
    And I am on the admin categories page

  Scenario: View categories
    Then I should see "Categories"
    Then I should not see "ActiveRecord::RecordNotFound"

  Scenario: Edit a category
    Given there only exists a category "General"
    And I am on the edit page for "General"
    When I change the name to "#General"
    When I press "Save"
    Then I should see "#General"
