json.extract! bookshelf, :id, :name, :creator, :created_at, :updated_at
json.url bookshelf_url(bookshelf, format: :json)
