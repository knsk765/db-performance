FactoryBot.define do
  factory :user do
    last_name      {Faker::Name.last_name}
    first_name     {Faker::Name.first_name}
    date_of_birth  {Faker::Date.between(from: '1900-01-01', to: '2022-09-01')}
    strength       {Faker::Number.number(digits: 4)}
    defence        {Faker::Number.number(digits: 4)}
    agility        {Faker::Number.number(digits: 4)}
    intelligence   {Faker::Number.number(digits: 4)}
    luck           {Faker::Number.number(digits: 4)}
    memo01         {Faker::Lorem.paragraph(sentence_count: 2)}
    memo02         {Faker::Lorem.paragraph(sentence_count: 3)}
    memo03         {Faker::Lorem.paragraph(sentence_count: 4)}
    memo04         {Faker::Lorem.paragraph(sentence_count: 5)}
    memo05         {Faker::Lorem.paragraph(sentence_count: 6)}
    memo06         {Faker::Lorem.paragraph(sentence_count: 7)}
    memo07         {Faker::Lorem.paragraph(sentence_count: 8)}
    memo08         {Faker::Lorem.paragraph(sentence_count: 9)}
    memo09         {Faker::Lorem.paragraph(sentence_count: 10)}
    memo10         {Faker::Lorem.paragraph(sentence_count: 11)}
    deleted_at     {nil}
    end
end
