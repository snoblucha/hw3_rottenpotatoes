# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
  
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  ratings = rating_list.split(",")
  ratings.each do |rating|    
    rating.strip!
    if(uncheck == nil)
      check("ratings_#{rating}")
    else
      uncheck("ratings_#{rating}")      
    end
  end
end

When /^I submit the ratings form$/ do
  click_button('ratings_submit')
end

Then /I should (not )?see movies with ratings:(.*)/ do |not_see, ratings| 
  ratings = ratings.split(',')  
  ratings.each do |rating|  
    if (not_see == nil) 
      page.should have_css('#movies td', :text => Regexp.new("^#{rating.strip}$"))
    else
      page.should_not have_css('#movies td', :text => Regexp.new("^#{rating.strip}$"))
    end
  end

end

When /^I (un)?check all ratings$/ do |uncheck|
  debugger
  all("#ratings_form input[type=checkbox]").each do |checkbox|
    if(uncheck == nil) 
      check(checkbox[:id])
    else
      uncheck(checkbox[:id])
    end
  end
end

Then /^I should not see any movie$/ do 
  rows = all("#movies tbody tr").size()  
  rows.should == 0 

  
end

Then /^I shoud see all movies$/ do
  rows = all("#movies tbody tr").size()  
  rows.should == Movie.count    
end

