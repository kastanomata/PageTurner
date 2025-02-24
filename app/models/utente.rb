class Utente < ApplicationRecord
    validates :email, presence: true
    validates :nome, presence: true
end
