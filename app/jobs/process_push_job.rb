class ProcessPushJob < ApplicationJob
  queue_as :default

  def perform(username)
    begin
      FileUtils.rm_rf Rails.application.secrets.tmp_directory + '/zerda-java-basics'
      output = `cd #{Rails.application.secrets.tmp_directory} && git clone git@github.com:#{username}/zerda-java-basics.git`
      FileUtils.rm_rf Rails.application.secrets.source_directory + '/com'
      FileUtils.cp_r(Rails.application.secrets.tmp_directory + '/zerda-java-basics/src/com', Rails.application.secrets.source_directory)
      output += `cd #{Rails.application.secrets.run_directory} && ./gradlew test`
    rescue
      output += 'something was wrong in your project setup (fork / clone / src folder / package name)'
    end
    messages = ''
    failures = ''
    test_count = 0
    fail_count = 0
    begin
      a=Hash.from_xml(File.open(Rails.application.secrets.test_directory + '/TEST-com.greenfox.exams.java.BlackJackTest.xml'))
      test_count += a['testsuite']['tests'].to_i
      fail_count += a['testsuite']['failures'].to_i
      a['testsuite']['testcase'].each do |t|
        m = t['classname'] + ' > ' + t['name']
        if t['failure']
          failures += m + '<br>'
          failures += t['failure'] + '<br>'
        else
          messages += m + ' ' + '...OK<br>'
        end
      end
      a=Hash.from_xml(File.open(Rails.application.secrets.test_directory + '/TEST-com.greenfox.exams.java.CardTest.xml'))
      test_count += a['testsuite']['tests'].to_i
      fail_count += a['testsuite']['failures'].to_i
      a['testsuite']['testcase'].each do |t|
        m = t['classname'] + ' > ' + t['name']
        if t['failure']
          failures += m + '<br>'
          failures += t['failure'] + '<br>'
        else
          messages += m + ' ' + '...OK<br>'
        end
      end
      a=Hash.from_xml(File.open(Rails.application.secrets.test_directory + '/TEST-com.greenfox.exams.java.DeckTest.xml'))
      test_count += a['testsuite']['tests'].to_i
      fail_count += a['testsuite']['failures'].to_i
      a['testsuite']['testcase'].each do |t|
        m = t['classname'] + ' > ' + t['name']
        if t['failure']
          failures += m + '<br>'
          failures += t['failure'] + '<br>'
          messages += m + ' ' + '...FAIL<br>'
        else
          messages += m + ' ' + '...OK<br>'
        end
      end
      a=Hash.from_xml(File.open(Rails.application.secrets.test_directory + '/TEST-com.greenfox.exams.java.PlayerTest.xml'))
      test_count += a['testsuite']['tests'].to_i
      fail_count += a['testsuite']['failures'].to_i
      a['testsuite']['testcase'].each do |t|
        m = t['classname'] + ' > ' + t['name']
        if t['failure']
          failures += m + '<br>'
          failures += t['failure'] + '<br>'
        else
          messages += m + ' ' + '...OK<br>'
        end
      end
      FileUtils.rm Rails.application.secrets.test_directory + '/TEST-com.greenfox.exams.java.BlackJackTest.xml'
      FileUtils.rm Rails.application.secrets.test_directory + '/TEST-com.greenfox.exams.java.CardTest.xml'
      FileUtils.rm Rails.application.secrets.test_directory + '/TEST-com.greenfox.exams.java.DeckTest.xml'
      FileUtils.rm Rails.application.secrets.test_directory + '/TEST-com.greenfox.exams.java.PlayerTest.xml'
    rescue
      failures += output
    end
    Suite.create(owner: username, rate: (test_count == 0 ? 0 : (100 - (fail_count*100/test_count))), messages: messages, failures: failures)
  end
end
