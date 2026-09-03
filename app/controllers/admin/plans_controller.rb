class Admin::PlansController < Admin::BaseController
  before_action :set_plan, only: [ :show, :edit, :update, :destroy ]

  def index
    @plans = Plan.all
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)

    if @plan.save
      redirect_to admin_plan_path(@plan), notice: t("plans.create.success")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def edit; end

  def update
    if @plan.update(plan_params)
      redirect_to admin_plan_path(@plan), notice: t("plans.update.success")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @plan.destroy
      redirect_to admin_plans_path, notice: t("plans.destroy.success")
    else
      redirect_to admin_plans_path, alert: @plan.errors.full_messages.to_sentence
    end
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:name, :monthly_fee)
  end
end
