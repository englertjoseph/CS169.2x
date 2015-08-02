Feature: View Categories
  As an blog administrator
  In order to organize blog entries
  I want to view and add categories to the blog

  Background:
    Given the blog is set up
    And I am logged into the admin panel

  Scenario: View categories
    Given I am on the admin categories page
    Then I should see "Categories"
    Then I should not see "ActiveRecord::RecordNotFound"
