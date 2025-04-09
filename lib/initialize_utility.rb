include LoggingUtility
module InitializeUtility
  def initialize_user(user)
    # Create default bookshelves for the user
    read_bookshelf  = user.create_bookshelf(name: "#{user.nickname}'s Read Books", special: :true)
    liked_bookshelf = user.create_bookshelf(name: "#{user.nickname}'s Liked Books", special: :true)

    # FIXME Populate the special bookshelves with books from the user's posts
    Post.where(creator: user.email_address).each do |post|
      # read_bookshelf.add_book(post.book)
      # liked_bookshelf.add_book(post.book) if rand < 1.0 / 3
    end
    # Create relationships and memberships
    random_follows = User.ids.sample(3)
    random_follows.each do |id|
      Relationship.create!(follower_id: user.id, followed_id: id)
    end
    random_memberships = Club.ids.sample(1)
    random_memberships.each do |id|
      Membership.create!(follower_id: user.id, club_id: id)
    end
  end

  def initialize_bookclub(bookclub)
    # FIXME initialize_bookclub does not work after database refactoring
    # Create special bookshelves for each bookclub
    # Bookshelf.create!(name: "#{bookclub.name}'s Read Books", creator: bookclub.curator, special: true)
    # Populate the special bookshelves with books from the bookclub's posts
    # Post.where(creator: bookclub.curator).each do |post|
    #     BookshelfContain.create!(name: "#{bookclub.name}'s Read Books", creator: bookclub.curator, book: post.book)
    # end
  end


  def initialize_tables
    # User initialization
    User.find_each { |user| initialize_user(user) }

    # Club initialization
    Club.find_each { |bookclub| initialize_bookclub(bookclub) }
  end
end
