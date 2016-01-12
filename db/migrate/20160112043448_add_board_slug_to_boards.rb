class AddBoardSlugToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :board_slug, :string
    
    Board.all.each do |board|
      board.update_attributes(:board_slug => board.name.downcase.gsub(" ", '-'))
    end
  end
end
