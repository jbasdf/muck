require 'fileutils'

def ensure_dirs(file_name)
  FileUtils.mkdir_p(File.dirname(file_name))
end

Given /^cms lite file "(.+)" contains "(.+)"$/ do |file_name, file_text|
  ensure_dirs(file_name)
  File.open(file_name, "w") do |file|
    file.puts(file_text)
  end
end

Given /^protected cms lite file "(.+)" contains "(.+)"$/ do |file_name, file_text|
  ensure_dirs(file_name)
  File.open(file_name, "w") do |file|
    file.puts(file_text)
  end
end