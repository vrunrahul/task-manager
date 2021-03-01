class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def send_deadline_alerts(email, tasks)
    @tasks = tasks
    mail(to: email, subject: 'Welcome to My Awesome Site')
  end

end
