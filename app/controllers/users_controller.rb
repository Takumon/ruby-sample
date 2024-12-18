class UsersController < ApplicationController
  include Pagination
  before_action :wait # フロントエンドのローディング表示を確認するため

  def index
    req = RequestGetUsers.new(params)
    if not req.valid?
      render json: { error: req.errors.full_messages }, status: :bad_request and return
    end

    users = User.order(created_at: :desc).page(req.page).per(req.limit_value)
    render json: camelize_keys(resources_with_pagination(users))
  end

  def show
    user = get_user
    render json: camelize_keys(user)
  end

  def create
    p =user_params
    user = User.new(p)
    if !user.valid?
      render json: camelize_keys({ error: user.errors }), status: :bad_request
      return
    end

    if user.save
      render json: user, status: :created, location: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    user = get_user
    if user.update(user_params)
      render json: user
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user = get_user
    user.destroy!
  end

  private
    def get_user
      User.find(params[:id])
    end

    def user_params
      params.permit(
        :name,
        :email,
        :birthday,
        :gender,
        :bio,
        :amount_min,
        :amount_max,
        )
    end

    def wait
      sleep 1
    end
end
