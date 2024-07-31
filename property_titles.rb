require './properties'

properties = Properties.new

properties_list = properties.list

# Print titles to stdout
for property in properties_list["content"]
	puts property["title"]
end