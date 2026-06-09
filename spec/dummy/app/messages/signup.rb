class Signup < Spina::Pro::Message
  inbox :signups, "Signups"
  
  field :first_name, :string
  field :last_name, :string
  field :body, :text
end