FactoryGirl.define do
  factory :pin do
		sequence(:title) { |n| "Rails Cheatsheet#{n}" }
		url "http://rails-cheat.com"
		text "A great tool for beginning developers"
		category Category.find_by_name("rails")
    slug { title.downcase.gsub(" ", '-') }
	end

  factory :user do 
    sequence(:email) { |n| "coder#{n}@skillcrush.com" }
    first_name "Skillcrush"
    last_name "Coder"
    password "secret"
    
    after(:create) do |user|
      user.boards << FactoryGirl.create(:board)
      3.times do  
        user.pinnings.create(pin: FactoryGirl.create(:pin, user_id: user.id), board: user.boards.first)
      end
    end
  end
  
  factory :pinning do 
    pin
    user
    board
  end
  
  factory :board do 
    name "My Pins!"
  end
end 