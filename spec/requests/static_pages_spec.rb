require 'spec_helper'

describe "StaticPages" do
  
  let(:base_title) {"Ruby on Rails Tutorial Sample App"}

  describe "Home Page" do

    before :each do
      visit '/static_pages/home'
    end

    it "should have the h1 'Sample App'" do
      page.should have_selector('h1', :text => 'Sample App')
    end

    it "should have the base title" do
      page.should have_selector('title',
        :text => "#{base_title}")
    end

    it "should not have a custome page title" do
      page.should_not have_selector('title', :text => '| Home')
    end
  end

  describe "Help Page" do

    before :each do
      visit '/static_pages/help'
    end

    it "should have the h1 'Help'" do
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the title 'Help'" do
      page.should have_selector('title',
        :text => "#{base_title} | Help")
    end
  end

  describe "About Page" do

    before :each do
      visit '/static_pages/about'
    end

    it "should have the h1 'About Us'" do
      page.should have_selector('h1', :text => 'About Us')
    end

    it "should have the title 'About Us'" do
      page.should have_selector('title',
        :text => "#{base_title} | About Us")
    end
  end

  describe "Contact Page" do

    before :each do
      visit '/static_pages/contact'
    end

    it "should have the h1 'Contact'" do
      page.should have_selector('h1', :text => 'Contact')
    end

    it "should have the title 'Contact'" do
      page.should have_selector('title', :text => "#{base_title} | Contact")
    end
  end

end
