class ArchiveMailer < ActionMailer::Base
  default from: 'soshigal@example.com'

  def archive_completion(archive, user)
    @archive = archive
    @user = user
    mail(to: user.email, subject: "#{archive.archivable.display_name} Download")
  end
end
