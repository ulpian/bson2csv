bson2csv
========

whenever those tricky .bson files need to go csv :)

Sometimes its you just want something to work without a lot of effort :), this was my case, I had .bson files of my mongodump and I had to send them over to a non-tech team member who needed it in csv.

So as I couldn't find anything, I present bson2csv, a quick coffee / js file that takes command-line arguments that turn those .bson files into csv.

Run the script and give to arguments, the name of your bson file path/name and the file path/name to your csv.

> $ coffee bson2csv.coffee --bf ~/file.bson --cf ~/file.csv

You can also see the json data on the terminal by writing setting the log at the end

> $ coffee bson2csv.coffee --bf ~/file.bson --cf ~/file.csv --log true