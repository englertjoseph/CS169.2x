Given /^the following articles exist$/ do |table|
  # table is a Cucumber::Ast::Table
  Article.create(table.hashes)
end

Then /^the article "(.*?)" should have body "(.*?)"$/ do |arg1, arg2|
  Article.find_by_title(title).body.should eq body
end

Then /^I should not be able to merge$/ do
  assert_raise Capybara::ElementNotFound do
    click_button("Merge")
  end
end

Then /^the article "(.*?)"'s author should be "(.*?)" or "(.*?)"$/ do |arg1, arg2, arg3|
  assert Article.find_by_title(arg1).author =~ /#{arg2}|#{arg3}/
end

Then /^the article "(.*?)" should include comments from "(.*?)"$/ do |arg1, arg2|
  merged_article = Article.find_by_title(arg1)
  article = Article.find_by_title(arg2)
  assert (merged_article & article) == merged_article
end

Then /^the tile of "(.*?)" should be either "(.*?)" or "(.*?)"$/ do |arg1, arg2, arg3|
  assert Article.find_by_title(arg1).title =~ /#{arg2}|#{arg3}/
end
