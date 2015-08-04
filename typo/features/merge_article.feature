Feature: Merge articles
  As a blog administrator
  In order to avoid multiple similar articles

  Background:
    Given the blog is set up
    And I am logged into the admin panel
    And the following articles exist
    | id | title    | body           | author |
    | 2  | Foobar   | LoremIpsum     | alice  |
    | 3  | Foobar 2 | LoremIpsum  2  | bob    |
    Given I am on the article page for "Foobar"
    And I fill in "merge_with" with "3"
    And I press "Merge"

  Scenario: Non-admin cannot merge articles
    Given I am logged out
    And I am on the article page for "Foobar"
    Then I should not be able to merge

  Scenario: Merged article contains text of both articles
    Then the article "Foobar" should have body "LoremIpsum LoremIpsum  2"

  Scenario: Merged articles should have one author
    Then the article "Foobar"'s author should be "alice" or "bob"

  Scenario: Comments should carry over to the merged article
    Then the article "Foobar" should include comments from "Foobar 2"

  Scenario: Title of merged article should be either of the originals
    Then the tile of "Foobar" should be either "Foobar" or "Foobar 2"
