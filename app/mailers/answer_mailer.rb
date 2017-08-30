class AnswerMailer < ApplicationMailer
  def notify(subscription)
    @question = subscription.question

    mail to: subscription.user.email, subject: 'New answer'
  end
end
