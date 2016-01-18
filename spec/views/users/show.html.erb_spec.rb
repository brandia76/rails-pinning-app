require 'spec_helper'

RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = FactoryGirl.create(:user_with_boards)
    @pins = @user.pins
    @boards = Board.where(user_id: @user.id) + Board.joins(:board_pinners).where(board_pinners: {user_id: @user.id})

  end

  it "renders attributes in <p>" do
    render
    @boards.each do |board|
      expect(rendered).to match(board.name)
    end
  end
end
