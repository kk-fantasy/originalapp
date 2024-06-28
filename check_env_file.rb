env_file_path = File.join(Dir.pwd, '.env')
if File.exist?(env_file_path)
  puts ".env file exists at #{env_file_path}."
else
  puts ".env file does not exist in the current directory."
end