class ExportMailer < ActionMailer::Base
  default :from => "noreply@bigfuel.com"

  def export_complete_email(export, user)
    @model_name = "photos"

    mail(:to => user.email, :subject => "Your Facelauncher Export Has Completed")
  end
end