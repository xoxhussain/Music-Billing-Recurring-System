class Admin::PlanFeaturesController < ApplicationController
  include AdminAuthorization

  layout "admin"

  before_action :set_plan

  def create
    @plan_feature = @plan.plan_features.build(plan_feature_params)

    if @plan_feature.save
      redirect_to admin_plan_path(@plan), notice: "Feature added to plan."
    else
      redirect_to admin_plan_path(@plan),
                  alert: @plan_feature.errors.full_messages.to_sentence
    end
  end

  def destroy
    @plan_feature = @plan.plan_features.find(params[:id])
    @plan_feature.destroy

    redirect_to admin_plan_path(@plan), notice: "Feature removed from plan."
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def plan_feature_params
    params.require(:plan_feature).permit(:feature_id, :max_unit_price)
  end
end
