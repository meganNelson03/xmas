ListItem.destroy_all
List.destroy_all 
Account.destroy_all

account_values = [
  { first_name: 'Megan', last_name: 'McGee', email: 'd@dog.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe'},
  { first_name: 'Chandler', last_name: 'Kansas', email: 'c@test.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe' },
  { first_name: 'Marcia', last_name: 'Salad', email: 'm@rats.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe' },
  { first_name: 'Mister', last_name: 'Whiskers', email: 'j@test.com', password: 'qweqweqwe', password_confirmation: 'qweqweqwe' }
]

group = AccountGroup.create

account_values.each do |params|
  account = Account.new(params)
  account.account_group_id = group.id
  account.save!
  account.reload
end

account_ids = Account.pluck(:id)

account_ids.each do |id|
  list = List.new
  list.account_id = id
  list.save!
  list.reload
end

lists = List.all

lists.each do |list|
  rand(5..10).times do |n|
    list_item = ListItem.new 
    list_item.description = LoremIpsum.lorem_ipsum(words: rand(10..45))
    list_item.price = rand(10..123)
    list_item.list_id = list.id 
    list_item.priority = rand(0..2)
    list_item.claimed_by_id = [account_ids.select { |x| x != list.account_id }, nil, nil, nil].flatten.sample
    list_item.save!
  end
end
