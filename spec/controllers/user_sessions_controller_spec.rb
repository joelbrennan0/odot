require 'spec_helper'

describe UserSessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
  end

  it "renders the new template" do
    get 'new'
    expect(response).to render_template('new')
  end
end

  describe "POST 'create'" do
    context "with correct credientials" do
      let!(:user) {User.create(first_name: "Jason", last_name: "Seifer", email: "jason@teamtreehouse.com", password: "treehouse1", password_confirmation: "treehouse1")}
    
    it "redirects to the todo list path" do
      post :create, email: "jason@teamtreehouse.com", password: "treehouse1"
      expect(response).to be_redirect
      expect(response).to redirect_to(todo_lists_path)
    end

    it "finds the user" do
      expect(User).to receive(:find_by).with({email: "jason@teamtreehouse.com"}).and_return(user)
      post :create, email: "jason@teamtreehouse.com", passord: "treehouse1"
    end

    it "authenticates the user" do
      User.stub(:find_by).and_return(user)
      expect(user).to receive(:authenticate)
      post :create, email: "jason@teamtreehouse.com", password: "treehouse1"
    end

    it "sets the user_id in the session" do
      post :create, email: "jason@teamtreehouse.com", password: "treehouse1"
      expect(session[:user_id]).to eq(user.id)
    end

    it "sets the flash success message" do
      post :create, email: "jason@teamtreehouse.com", password: "treehouse1"
      expect(flash[:success]).to eq("You are now logged in!")
    end
  end

  shared_examples_for "denied login" do
    it "renders the new template" do
       post :create, email: email, password: password
        expect(response).to render_template('new')
      end

      it "sets the flash error message if login unsuccessful" do
        post :create, email: email, password: password
        expect(flash[:error]).to eq("Login failed!  Please check your details and try again.")
      end
  end

    context "with blank credentials" do
      let(:email) {""}
      let(:password) {""}
        it_behaves_like "denied login"
      end

    context "with incorrect password credentials" do
            let!(:user) {User.create(first_name: "Jason", last_name: "Seifer", email: "jason@teamtreehouse.com", password: "treehouse1", password_confirmation: "treehouse1")}
            let(:email) {user.email}
            let(:password) {"incorrect"}
          it_behaves_like "denied login"
          end

    context "with no email in existence" do
            let(:email) {"none@somewhere.com"}
            let(:password) {"incorrect"}
            it_behaves_like "denied login"
          end
    end

end
