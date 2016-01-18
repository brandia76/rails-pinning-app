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
    username { email.split('@')[0] }
    
    factory :user_with_boards do
      after(:create) do |user|
        user.boards << FactoryGirl.create(:board)
        3.times do  
          user.pinnings.create(pin: FactoryGirl.create(:pin, user_id: user.id), board: user.boards.first)
        end
      end
      
      factory :user_with_boards_and_followers do  
        after(:create) do |user|
          3.times do  
            follower = FactoryGirl.create(:user)
            Follower.create(user: user, follower_id: follower.id)
          end
        end
      end   
    end
    
    factory :user_with_followees do 
      after(:create) do |user|  
        3.times do
          FactoryGirl.create(:user)
          Follower.create(user: FactoryGirl.create(:user), follower_id: user.id)
        end
      end
    end
  end
  
  factory :pinning do 
    pin
    user
    board
  end
  
  factory :board do 
    name "Factory Pins!"
    board_slug "factory_pins!"
  end
end 