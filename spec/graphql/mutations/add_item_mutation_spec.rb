require "rails_helper"

RSpec.describe Mutations::AddItemMutation do
  subject(:result) do
    MartianLibrarySchema
      .execute(mutation, variables: variables, context: context)
      .as_json
  end

  let(:user)    { create(:user) }
  let(:context) { { current_user: user } }
  let(:title)   { "Total Recall" }

  let(:variables) do
    { title: title, description: "A classic based on Philip K. Dick's story" }
  end

  let(:mutation) do
    %(
      mutation AddItem($title: String!, $description: String) {
        addItem(attributes: {title: $title, description: $description}) {
          item {
            title
            }
          }
        }
      )
  end

  let(:item) { result.dig("data", "addItem", "item") }

  it "creates a new item" do
    expect { result }.to change(user.items, :count).by(1)
  end

  it "returns created item info" do
    expect(item["title"]).to eq(title)
  end
end
