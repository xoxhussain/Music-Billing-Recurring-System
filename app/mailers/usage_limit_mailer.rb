class UsageLimitMailer < ApplicationMailer
  def usage_exceeded
    @subscription = params[:subscription]
    @plan_feature = params[:plan_feature]

    @user = @subscription.user
    @feature = @plan_feature.feature
    @current_usage = @subscription.usage_for(@plan_feature)
    @max_limit = @feature.max_unit_limit

    mail(
      to: @user.email,
      subject: "Usage limit exceeded for #{@feature.name}"
    )
  end
end
