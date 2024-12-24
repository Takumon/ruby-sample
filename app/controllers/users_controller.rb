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
    user = User.new(user_params)
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
    if user.update(user_params_for_update)
      render json: user
    else
      render json: user.errors, status: :conflict
    end
  rescue ActiveRecord::StaleObjectError => e
    render json: { error: "更新中に他のユーザーがこのデータを更新しました。最新の情報でリトライしてください" }, status: :conflict
  rescue ActiveRecord::RecordNotFound
    render json: { error: "対象の情報が見つかりませんでした" }, status: :not_found
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

    def user_params_for_update
      params.permit(
        :name,
        :email,
        :birthday,
        :gender,
        :bio,
        :amount_min,
        :amount_max,
        :updated_at,
        :lock_version,
        )
    end

    def wait
      sleep 1
    end
end
