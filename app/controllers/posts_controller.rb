class PostsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    @user = authenticate_token
    @post = Post.new(post_params)
    if !@user.nil? and @user.id==post_params[:user_id] and @post.save
      @result = true
    else
      @result = false
    end
  end

  def index_followed_posts
    @items = []
    followed_posts=nil
    followed_watches=nil
    @user = authenticate_token
    if !@user.nil?
      if params[:last_post_id].nil? and params[:last_vote_id].nil?
        followed_posts = @user.user_followed.joins("LEFT JOIN posts ON posts.user_id=followers.followed_user_id").where('posts.revealed = ?', true).order('posts.created_at DESC').select('posts.id as id, posts.created_at as created_at').limit(10)
        followed_watches = @user.user_followed.joins("LEFT JOIN votes ON votes.user_id=followers.followed_user_id").where('votes.action = ?', 'watch').order('votes.updated_at DESC').select('votes.id as id, votes.updated_at as updated_at, followers.followed_user_id as user_id, votes.post_id as post_id').order(updated_at: :desc).limit(10)
      else
        if params[:last_post_id]
          last_post = Post.find(params[:last_post_id].to_i)
          followed_posts = @user.user_followed.joins("LEFT JOIN posts ON posts.user_id=followers.followed_user_id").where('posts.revealed = ?', true).order('posts.created_at DESC').where("followers.user_id = ? AND posts.created_at <= ? AND posts.id != ? AND posts.revealed = ?", @user.id, last_post.created_at, last_post.id, true).select('posts.id as id, posts.created_at as created_at').limit(10)
          followed_watches = @user.user_followed.joins("LEFT JOIN votes ON votes.user_id=followers.followed_user_id").where("followers.user_id = ? AND votes.action = ? AND votes.updated_at <= ?", @user.id, 'watch', last_post.created_at).order('votes.updated_at DESC').select('votes.id as id, votes.updated_at as updated_at, followers.followed_user_id as user_id, votes.post_id as post_id').limit(10)
        else
          last_vote = Vote.find(params[:last_vote_id].to_i)
          followed_posts = @user.user_followed.joins("LEFT JOIN posts ON posts.user_id=followers.followed_user_id").where('posts.revealed = ?', true).order('posts.created_at DESC').where("followers.user_id = ? AND posts.created_at <= ? AND posts.revealed = ?", @user.id, last_vote.created_at, true).select('posts.id as id, posts.created_at as created_at').limit(10)
          followed_watches = @user.user_followed.joins("LEFT JOIN votes ON votes.user_id=followers.followed_user_id").where("followers.user_id = ? AND votes.action = ? AND votes.updated_at <= ? AND votes.id != ?", @user.id, 'watch', last_vote.updated_at, last_vote.id).order('votes.updated_at DESC').select('votes.id as id, votes.updated_at as updated_at, followers.followed_user_id as user_id, votes.post_id as post_id').limit(10)
        end
      end
    end
    setup_items(followed_posts, followed_watches)
  end

  def index_for_user
    @posts = nil
    @user = authenticate_token
    if @user.nil? or @user.id != params[:user_id].to_i
      @posts = Post.where('user_id = ? AND revealed = ?', params[:user_id], true).order(created_at: :desc)
    else
      @posts = Post.where('user_id = ?', params[:user_id]).order(created_at: :desc)
    end

    setup_posts(@posts, @user)
    render 'index'
  end

  def index_by_location
    @posts = nil
    radius = (params[:radius].nil?) ? 10 : params[:radius]

    if !params[:latitude].nil? and !params[:longitude].nil?
      origin = [params[:latitude], params[:longitude]]
      if params[:last_post_id].nil?
        @posts = Post.where("longitude != ? and latitude != ?", 0, 0).within(radius, :origin => origin).order(created_at: :desc).limit(10)
      else
        last_post = Post.find(params[:last_post_id].to_i)
        @posts = Post.where("longitude != ? and latitude != ?", 0, 0).where("created_at <= ? AND id != ?", last_post.created_at, last_post.id).within(radius, :origin => origin).order(created_at: :desc).limit(10)
      end
    end

    @user = authenticate_token
    setup_posts(@posts, @user)
    render 'index'
  end

  def index
    @posts = nil
    if params[:last_post_id].nil?
      @posts = Post.order(created_at: :desc).limit(10)
    else
      last_post = Post.find(params[:last_post_id].to_i)
      @posts = Post.where("created_at <= :last_post_date AND id != :last_post_id",{last_post_date: last_post.created_at, last_post_id: last_post.id}).order(created_at: :desc).limit(10)
    end

    @user = authenticate_token
    setup_posts(@posts, @user)
  end

  def index_popular
    @orig_request_time = (params[:orig_request_time].nil?) ? DateTime.now() : DateTime.parse(params[:orig_request_time])
    @posts = nil
    if params[:orig_request_time].nil?
      @posts = Post.where("created_at >= ?", 31.days.ago).sort_by {|post| post.rating(@orig_request_time) }.reverse[0..9]
    elsif !params[:page].nil? and !params[:orig_request_time].nil?
      first_post_num = params[:page].to_i*10
      @posts = Post.where("created_at >= ?", 31.days.ago).sort_by {|post| post.rating(@orig_request_time) }.reverse[first_post_num..first_post_num+9]
    end

    @user = authenticate_token
    setup_posts(@posts, @user)
  end

  def show
    @user = authenticate_token
    @posts = Post.where("id = ?", params[:id])
    setup_posts(@posts, @user)
    @post = @posts_with_votes.nil? ? nil : @posts_with_votes[0]
  end

  def update
    @user = authenticate_token
    @post = Post.find(params[:id])
    if !@user.nil? and !@post.nil? and @user.id==post_params[:user_id] and @user.id==@post.user_id and @post.update_attributes(post_params)
      @result = true
    else
      @result = false
    end
  end

  def destroy
    @user = authenticate_token
    @post = Post.find(params[:id])
    if !@user.nil? and !@post.nil? and @user.id==@post.user_id and @post.destroy
      @result = true
    else
      @result = false
    end
  end

  def reveal
    @user = authenticate_token
    @post = Post.find(params[:id])
    if !@user.nil? and !@post.nil? and @user.id==@post.user_id and @post.update_attribute(:revealed, true)
      @result = true
    else
      @result = false
    end
    render 'reveal'

    if @result
      watches = Vote.where('post_id = ? and action = ?', params[:id], 'watch')
      watches.each do |watch|
        RevealNotification.new({user_id: watch.user_id, post_id: params[:id], viewed: false}).save
      end
    end
  end

  def hide
    @user = authenticate_token
    @post = Post.find(params[:id])
    if !@user.nil? and !@post.nil? and @user.id==@post.user_id and @post.update_attribute(:revealed, false)
      @result = true
    else
      @result = false
    end
    render 'hide'
    
    if @result
      RevealNotification.where('post_id = ?', params[:id]).destroy_all
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :content, :revealed, :latitude, :longitude)
  end

  #this needs to be refactored
  def setup_posts(posts, user)
    @posts_with_votes = []
    #\33t h6x
    if !posts.nil?
      posts.each do |post|
        vote = nil
        share = nil
        if !user.nil?
          vote = Vote.find_by_user_id_and_post_id(user.id, post.id)
        end
        @posts_with_votes.push(OpenStruct.new(post.attributes.merge({current_user_vote: parse_vote(vote), watch_stat: post.watch_stat, ignore_stat: post.ignore_stat, user: post.user})))
      end
    end
  end

  #need to refactor badly, but whatevs
  def setup_items(followed_posts, followed_watches)
    p = 0
    w = 0
    10.times do
      if !followed_posts.nil? and !followed_watches.nil? and (p<followed_posts.length or w<followed_watches.length)
        item = nil
        if followed_watches.nil? or w>=followed_watches.length
          post = Post.find(followed_posts[p].id)
          vote = Vote.find_by_user_id_and_post_id(@user.id, followed_posts[p].id)
          item = OpenStruct.new(post.attributes.merge({item_type: 'post', current_user_vote: parse_vote(vote), watch_stat: post.watch_stat, ignore_stat: post.ignore_stat, user: post.user}))
          p = p+1
        elsif followed_posts.nil? or p>=followed_posts.length
          post = Post.find(followed_watches[w].post_id)
          vote = Vote.find_by_user_id_and_post_id(@user.id, post.id)
          followed_user = User.find(followed_watches[w].user_id)
          item = OpenStruct.new(post.attributes.merge({item_type: 'watch', vote_id: followed_watches[w].id, followed_username: followed_user.username, followed_user_id: followed_user.id, current_user_vote: parse_vote(vote), watch_stat: post.watch_stat, ignore_stat: post.ignore_stat, user: post.user}))
          w = w+1
        elsif followed_posts[p].created_at>=followed_watches[w].updated_at
          post = Post.find(followed_posts[p].id)
          vote = Vote.find_by_user_id_and_post_id(@user.id, followed_posts[p].id)
          item = OpenStruct.new(post.attributes.merge({item_type: 'post', current_user_vote: parse_vote(vote), watch_stat: post.watch_stat, ignore_stat: post.ignore_stat, user: post.user}))
          p = p+1
        else
          post = Post.find(followed_watches[w].post_id)
          vote = Vote.find_by_user_id_and_post_id(@user.id, post.id)
          followed_user = User.find(followed_watches[w].user_id)
          item = OpenStruct.new(post.attributes.merge({item_type: 'watch', vote_id: followed_watches[w].id, followed_username: followed_user.username, followed_user_id: followed_user.id, current_user_vote: parse_vote(vote), watch_stat: post.watch_stat, ignore_stat: post.ignore_stat, user: post.user}))
          w = w+1
        end
        @items.push(item)
      else
        break
      end
    end
  end

  def parse_vote(vote)
    if vote.nil?
      return ""
    else
      vote.action
    end
  end

  def user_shared(share)
    !share.nil?
  end

end
