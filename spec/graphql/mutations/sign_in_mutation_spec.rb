require "rails_helper"

RSpec.describe Mutations::SignInMutation do
  subject(:result) do
    MartianLibrarySchema.execute(mutation, variables: { email: user.email}).as_json
  end

  let(:user) { create(:user) }

  let(:mutation) do
    %(
      mutation SignMeIn($email: String!) {
        signIn(email: $email) {
          token
          user {
            id
            fullName
            }
          }
        }
      )
  end

  let(:sign_in) { result.dig("data", "signIn") }

  it "returns user info" do
    expect(sign_in.dig("user", "id")).to eq(user.id.to_s)
  end

  it "returns auth token" do
    expect(sign_in["token"]).not_to be_nil
  end
end
