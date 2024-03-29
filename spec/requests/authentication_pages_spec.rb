require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_header('Sign in') }
		it { should have_title('Sign in') }
	end

	describe "signin" do
		before { visit signin_path }

		describe "with invalid information" do
			before { click_button "Sign in" }

			it { should have_title('Sign in') }
			it { should have_error_message 'Invalid' }

			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_error_message }
			end
		end

		describe "with valid information" do
			let(:user) { FactoryGirl.create(:user) }
			before { fake_sign_in(user) }

			it { should have_title(user.name) }
			
			it { should have_link('Users', href: users_path) }
			it { should have_link('Profile', href: user_path(user)) }
			it { should have_link('Settings', href: edit_user_path(user)) }
			it { should have_link('Sign out', href: signout_path) }
			
			it { should_not have_link('Sign in', href: signin_path) }

			describe "followed by signout" do
				before { click_link "Sign out" }
				it { should have_link("Sign in") }
			end
		end

		describe "not signed in" do
			let(:user) { FactoryGirl.create(:user) }
			
			it { should_not have_link('Profile', href: user_path(user)) }
			it { should_not have_link('Settings', href: edit_user_path(user)) }
		end
	end

	describe "authorization" do

		describe "for non-signed-in users" do
			let(:user) { FactoryGirl.create(:user) }

			describe "in the Users controller" do

				describe "visiting the edit page" do
					before { visit edit_user_path(user) }
					it { should have_title('Sign in') }
				end

				describe "submitting to the update action" do
					before { put user_path(user) }
					specify { response.should redirect_to(signin_path) }
				end

				describe "when attempting to visit a protected page" do
					before do
						visit edit_user_path(user)
						fill_in "Email",		with: user.email
						fill_in "Password",	with: user.password
						click_button "Sign in"
					end

					describe "after signing in" do

						it "should render the desired protected page" do
							page.should have_title('Edit user')
						end

						describe "when signing in again" do
							before do
								visit signin_path
								fill_in "Email", with: user.email
								fill_in "Password", with: user.password
								click_button "Sign in"
							end

							it "should render the default (profile) page" do
								page.should have_title(user.name)
							end
						end
					end
				end

				describe "in the microposts controller" do

					describe "submitting to the create action" do
						before { post microposts_path }
						specify { response.should redirect_to(signin_path) }
					end

					describe "submitting to the destroy action" do
						before do
							micropost = FactoryGirl.create(:micropost)
							delete micropost_path(micropost)
						end
						specify { response.should redirect_to(signin_path) }
					end
				end

				describe "in the Relationships controller" do
					describe "submitting to the create action" do
						before { post relationships_path }
						specify { response.should redirect_to(signin_path) }
					end

					describe "submitting to the destroy action" do
						before { delete relationship_path(1) }
						specify { response.should redirect_to(signin_path) }
					end
				end

				describe "visiting the user index" do
					before { visit users_path }
					it { should have_title('Sign in') }
				end

				describe "visiting the following page" do
					before { visit following_user_path(user) }
					it { should have_title("Sign in") }
				end

				describe "visiting the followers page" do
					before { visit followers_user_path(user) }
					it { should have_title("Sign in") }
				end
			end
		end

		describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			
			before do 
				visit signin_path
				fake_sign_in user
			end

			describe "visiting Users#edit page" do
				before do
					visit edit_user_path(wrong_user)
				end
				it { should_not have_title(full_title('Edit user')) }
			end

			describe "submitting a PUT request to the Users#update action" do
				before do
					put user_path(wrong_user)
				end
				specify { response.should redirect_to(root_path) }
			end
		end

		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before do
				visit signin_path
				fake_sign_in non_admin
			end

			describe "submitting a DELETE request to the User#destroy action" do
				before { delete user_path(user) }
				specify { response.should redirect_to(root_path) }
			end
		end
	end
end
