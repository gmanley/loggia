class ArchiveMailer < ActionMailer::Base
  default from: 'soshigal@example.com'

  def archive_completion(archive, user_id)
    @archive = archive
    @user = User.find(user_id)
    mail(to: @user.email, subject: "#{@archive.archivable.display_name} Download")
  end
end
