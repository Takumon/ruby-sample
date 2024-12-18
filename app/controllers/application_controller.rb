class ApplicationController < ActionController::API
  before_action :snakeize_params

  protected

    # Snakeize JSON API request params
    def snakeize_params
      params.deep_snakeize!
    end

  private

    # 配列/ハッシュ/オブジェクトのキーをキャメルケースに変換する
    def camelize_keys(data)
      if data.is_a?(ActiveRecord::Relation)
        data.map { |item| camelize_keys(item) }
      elsif data.is_a?(Array)
        data.map { |item| camelize_keys(item) }
      elsif data.is_a?(Hash)
        data.each_with_object({}) do |(key, value), result|
          result[key.to_s.camelize(:lower)] = camelize_keys(value)
        end
      elsif data.respond_to?(:to_hash)
        data.to_hash.each_with_object({}) do |(key, value), result|
          result[key.to_s.camelize(:lower)] = camelize_keys(value)
        end
      elsif data.respond_to?(:attributes)
        data.attributes.each_with_object({}) do |(key, value), result|
          result[key.to_s.camelize(:lower)] = camelize_keys(value)
        end
      else
        data
      end
    end
end
