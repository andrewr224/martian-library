require "rails_helper"

RSpec.describe Mutations::UpdateItemMutation do
  subject(:result) do
    MartianLibrarySchema
      .execute(mutation, variables: variables, context: context)
      .as_json
  end

  let(:user)    { create(:user) }
  let(:context) { { current_user: user } }
  let(:title)   { "Total Recall" }
  let(:item)    { create(:item, user: user) }

  let(:variables) do
    { id: item.id, title: title }
  end

  let(:mutation) do
    %(
      mutation UpdateItem($id: ID!, $title: String!, $description: String) {
        updateItem(id: $id, attributes: {title: $title, description: $description}) {
          item {
            title
            }
          }
        }
      )
  end

  let(:returned_item) { result.dig("data", "updateItem", "item") }

  it "updates the item" do
    expect { result; item.reload }.to change(item, :title).to(title)
  end

  it "returns update item info" do
    expect(returned_item["title"]).to eq(title)
  end
end
