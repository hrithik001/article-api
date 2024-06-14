class Post < ApplicationRecord
    belongs_to :user
    has_many :comments, dependent: :destroy
    

    # tags
    has_many :posts_tags, dependent: :destroy
    has_many :tags, through: :posts_tags
    
    # rection 
    has_many :reactions, dependent: :destroy
    has_many :users, through: :reactions

    #reports
    has_many :reports, dependent: :destroy

    validates :post_title, presence: true
    validates :post_content, presence: true
    validate :can_user_create ,on: :create
    validate :can_user_edit ,on: :update
    validate :can_user_destory?

    # search 
    def self.search_posts(query: nil, tag_name: nil)
      posts = all
  
      if tag_name.present?
        tag = Tag.find_by(name: tag_name)
        posts = tag.posts if tag
      elsif query.present?
        query = "%#{query}%"
        posts = where('post_title LIKE ? OR post_content LIKE ?', query, query)
      end
  
      posts
    end



    # create post
    def self.create_with_tags(params, current_user)
      post = Post.new(
        post_title: params[:post_title],
        post_content: params[:post_content],
        user: current_user
      )
  
      if post.save
        params[:tag_names].each do |tag_name|
          tag = Tag.find_or_create_by(name: tag_name)
          post.tags << tag
        end
      end
  
      post
    end
    def can_user_destory?
      unless user == Current.user || Current.user.role == 'admin'
        errors.add(:base, 'You are not authorized to delete this post')
      end
  end
  # myposts
    def self.posts_by_user(user)
      where(user_id: user.id)
    end

  

    private
    def can_user_create?
        if Current.user.role == 'user'
            errors.add(:base, 'You are not authorized to create posts.')
          end
    end
    def can_user_edit?
      puts "current user =>#{Current.user.inspect}"
        if Current.user.role == 'user' 
            errors.add(:base, 'You are not authorized to edit posts.')
        end
    end 
   
   
        
end
