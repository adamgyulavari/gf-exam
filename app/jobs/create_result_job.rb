class CreateResultJob < ApplicationJob
  queue_as :default

  def perform(user)
    FileUtils.cp(user.solution_file.path, Rails.application.secrets.solution_directory + '/WordToolbox.java')
    FileUtils.cp(user.test_file.path, Rails.application.secrets.test_directory + '/' + user.test_file.name)
    system("cd #{Rails.application.secrets.run_directory} && ./gradlew test")
    FileUtils.rm_rf Rails.application.root.to_s + '/public/reports/' + user.uid
    FileUtils.cp_r(Rails.application.secrets.report_directory, Rails.application.root.to_s + '/public/reports/' + user.uid)
    t = File.open(Rails.application.secrets.report_directory + '/index.html').read
    user.update(last_runned: Time.now, running_tests: t.match(">(.*?)%</")[1].to_i)
  end
end
