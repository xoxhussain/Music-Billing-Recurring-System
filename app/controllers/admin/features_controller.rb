class Admin::FeaturesController < Admin::BaseController
  before_action :set_feature, only: [ :show, :edit, :update, :destroy ]

  def index
    @features = Feature.all
  end

  def new
    @feature = Feature.new
  end

  def create
    @feature = Feature.new(feature_params)

    if @feature.save
      redirect_to admin_feature_path(@feature), notice: t("features.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @feature.update(feature_params)
      redirect_to admin_feature_path(@feature), notice: t("features.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @feature.destroy
      redirect_to admin_features_path, notice: t("features.destroy.success")
    else
      redirect_to admin_features_path, alert: @feature.errors.full_messages.to_sentence
    end
  end

  private

  def set_feature
    @feature = Feature.find(params[:id])
  end

  def feature_params
    params.require(:feature).permit(
      :name,
      :code,
      :unit_price,
      :max_unit_limit
    )
  end
end
