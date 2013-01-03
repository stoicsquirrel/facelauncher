class ExportMailer < ActionMailer::Base
  default :from => "noreply@bigfuel.com"

  def export_complete_email(export, user)
    @model_name = "photos"

    mail(:to => "amelman5@gmail.com", :subject => "Your Facelauncher Export Has Completed")
  end
end