require 'spec_helper'

describe "StaticPages" do
  
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_header(heading) }
    it { should have_title(full_title(page_title)) }
  end

  describe "Home Page" do
    before { go_home }
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user)
        visit signin_path
        fake_sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(user)) }
        it { should have_link("1 follower", href: followers_user_path(user)) }
      end

      describe "should not have delete link for other users posts" do
        before do
          FactoryGirl.create(:micropost, user: other_user)
          visit user_path(other_user)
        end
        it { should_not have_link("delete") }
      end

      describe "with one micropost" do
        it { should have_selector("span", text: "micropost") }
        it { should_not have_selector("span", text: "microposts") }
        it "should have one list item" do
          page.all(".microposts li").count.should == 1
        end
      end

      describe "with two microposts" do
        before do
          FactoryGirl.create(:micropost, user: user)
          visit root_path
        end

        it { should have_selector("span", text: "micropost") }
        it "should have two list items" do
          page.all(".microposts li").count.should == 2
        end
      end

      describe "paginate" do
        before(:all) { 60.times { FactoryGirl.create(:micropost, user: user) } }

        let(:first_page) { Micropost.paginate(page: 1) }
        let(:second_page) { Micropost.paginate(page: 2) }

        it { should have_link('Next') }
        its(:html) { should match('>2</a>') }

        it "should list the first page of users" do
          first_page.each do |micropost|
            page.should have_selector("li", text: micropost.content)
          end
        end

        it "should not list the second page of users" do
          second_page.each do |micropost|
            page.should_not have_selector("li", text: micropost.content)
          end
        end
      end
    end
  end

  describe "Help Page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About Page" do
    before { visit about_path }
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact Page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    go_home
    click_link "About"
    page.should have_title full_title('About Us')
    click_link "Help"
    page.should have_title full_title('Help')
    click_link "Contact"
    page.should have_title full_title('Contact')
    click_link "Home"
    page.should have_title full_title('')
    click_link "Sign up now!"
    page.should have_title full_title('Sign up')
  end
end
