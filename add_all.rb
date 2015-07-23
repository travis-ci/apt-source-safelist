#! /usr/bin/env ruby

require 'json'

sources = JSON.parse(File.read(File.join(File.dirname($0), 'ubuntu.json')))

successes = sources.select do |src|
  puts "-------------------\nAdding #{src.inspect}\n"
  if src['key_url']
    system("curl -sSL #{src['key_url'].untaint.inspect} | sudo -E apt-key add -") && system("sudo -E apt-add-repository -y #{src['sourceline'].untaint.inspect}")
  else
    system("sudo -E apt-add-repository -y #{src['sourceline'].untaint.inspect}")
  end
end

exit sources.length == successes.length
