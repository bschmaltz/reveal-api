class PostsController < ApplicationController
  skip_before_filter  :verify_authenticity_token

  def create
    @user = authenticate_token
    @post = Post.new(post_params)
    @post.username = User.find(post_params[:user_id]).username
    if !@user.nil? and @user.id==post_params[:user_id] and @post.save
      @vote = Vote.new({user_id: @user.id, post_id: @post.id, up: true})
      @vote.save
      @result = true
    else
      @result = false
    end
  end

  def index_followed_posts
    @items = []
    followed_posts=nil
    followed_shares=nil
    @user = authenticate_token
    if !@user.nil?
      if params[:last_post_id].nil? and params[:last_share_id].nil?
        followed_posts = User.joins(:user_followed).joins(:posts).where('posts.revealed >= ?', true).order(created_at: :desc).limit(10).select('posts.id as id, posts.created_at as created_at')
        followed_shares = User.joins(:user_followed).joins(:shares).order(created_at: :desc).limit(10).select('shares.id as id, shares.post_id as post_id, shares.created_at as created_at, users.id as user_id, users.username as username')
      else
        if params[:last_post_id]
          last_post = Post.find(params[:last_post_id].to_i)
          followed_posts = User.joins(:user_followed).joins(:posts).where("posts.created_at >= ? AND posts.id != ? AND posts.revealed = ?", last_post.created_at, last_post.id, true).order(created_at: :desc).limit(10).select('posts.id as id, posts.created_at as created_at')
          followed_shares = User.joins(:user_followed).joins(:shares).where("shares.created_at >= ?", last_post.created_at).order(created_at: :desc).limit(10).select('shares.id as id, shares.post_id as post_id, shares.created_at as created_at, users.id as user_id, users.username as username')
        else
          last_share = Share.find(params[:last_share_id].to_i)
          followed_posts = User.joins(:user_followed).joins(:posts).where("posts.created_at >= ? AND posts.revealed = ?", last_share.created_at, true).order(created_at: :desc).limit(10).select('posts.id as id, posts.created_at as created_at')
          followed_shares = User.joins(:user_followed).joins(:shares).where("shares.created_at >= ? AND shares.id != ?", last_share.created_at, last_share.id).order(created_at: :desc).limit(10).select('shares.id as id, shares.post_id as post_id, shares.created_at as created_at, users.id as user_id, users.username as username')
        end
      end
    end
    setup_items(followed_posts, followed_shares)
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

  def index
    @posts = nil
    if params[:last_post_id].nil?
      @posts = Post.order(created_at: :desc).limit(10)
    else
      last_post = Post.find(params[:last_post_id].to_i)
      @posts = Post.where("created_at >= :last_post_date AND id != :last_post_id",{last_post_date: last_post.created_at, last_post_id: last_post.id}).order(created_at: :desc).limit(10)
    end

    @user = authenticate_token
    setup_posts(@posts, @user)
  end

  def show
    @user = authenticate_token
    @posts = Post.where('id = ?', params[:id])
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
  end

  def hide
    @user = authenticate_token
    @post = Post.find(params[:id])
    if !@user.nil? and !@post.nil? and @user.id==@post.user_id and @post.update_attribute(:revealed, false)
      @result = true
    else
      @result = false
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
          share = Share.find_by_user_id_and_post_id(user.id, post.id)
        end
        @posts_with_votes.push(OpenStruct.new(post.attributes.merge({current_user_vote: user_vote(vote), vote_stat: post.vote_stat, current_user_shared: user_shared(share), share_stat: post.share_stat})))
      end
    end
  end

  #need to refactor badly, but whatevs
  def setup_items(followed_posts, followed_shares)
    p = 0
    s = 0
    10.times do
      if !followed_posts.nil? and !followed_shares.nil? and (p<followed_posts.length or s<followed_shares.length)
        item = nil
        if followed_shares.nil? or s>=followed_shares.length
          post = Post.find(followed_posts[p].id)
          vote = Vote.find_by_user_id_and_post_id(@user.id, post.id)
          share = Share.find_by_user_id_and_post_id(@user.id, post.id)
          item = OpenStruct.new(post.attributes.merge({item_type: 'post', curent_user_vote: user_vote(vote), vote_stat: post.vote_stat, current_user_shared: user_shared(share), share_stat: post.share_stat}))
          p = p+1
        elsif followed_posts.nil? or p>=followed_posts.length
          post = Post.find(followed_shares[s].post_id)
          vote = Vote.find_by_user_id_and_post_id(@user.id, post.id)
          share = Share.find_by_user_id_and_post_id(@user.id, post.id)
          item = OpenStruct.new(post.attributes.merge({item_type: 'share', share_id: followed_shares[s].id, share_username: followed_shares[s].username, share_user_id: followed_shares[s].user_id, curent_user_vote: user_vote(vote), vote_stat: post.vote_stat, current_user_shared: user_shared(share), share_stat: post.share_stat}))
          s = s+1
        elsif followed_posts[p].created_at<followed_shares[s].created_at
          post = Post.find(followed_posts[p].id)
          vote = Vote.find_by_user_id_and_post_id(@user.id, post.id)
          share = Share.find_by_user_id_and_post_id(@user.id, post.id)
          item = OpenStruct.new(post.attributes.merge({item_type: 'post', curent_user_vote: user_vote(vote), vote_stat: post.vote_stat, current_user_shared: user_shared(share), share_stat: post.share_stat}))
          p = p+1
        else
          post = Post.find(followed_shares[s].post_id)
          vote = Vote.find_by_user_id_and_post_id(@user.id, post.id)
          share = Share.find_by_user_id_and_post_id(@user.id, post.id)
          item = OpenStruct.new(post.attributes.merge({item_type: 'share', share_id: followed_shares[s].id, share_username: followed_shares[s].username, share_user_id: followed_shares[s].user_id, curent_user_vote: user_vote(vote), vote_stat: post.vote_stat, current_user_shared: user_shared(share), share_stat: post.share_stat}))
          s = s+1
        end
        @items.push(item)
      else
        break
      end
    end
  end

  def user_vote(vote)
    if vote.nil?
      'no vote'
    elsif vote.up
      'up'
    else
      'down'
    end
  end

  def user_shared(share)
    !share.nil?
  end

end
