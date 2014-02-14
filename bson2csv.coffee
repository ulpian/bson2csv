require 'coffee-script'
# child procees exec for bsondump
exec = require('child_process').exec
# file reading capab
fs = require 'fs'
# BSON library from mongo
mongo = require 'mongodb'
BSON = new mongo.BSON()
# json to csv
jsoncsv = require 'json2csv'

# first arg for current bson file path
if process.argv[2] is '--bf'
	# then take the file path
	bson_file_path = process.argv[3]
	csv_file_path = process.argv[5]

	buffer = null
	# need high scoped variable
	@jobj = []

	# read bson file
	bson_file = fs.readFileSync bson_file_path

	# deserialize bson file contents to json
	bchild = exec('bsondump '+ bson_file_path, (err, stdout, stderr) =>
			# check for errors
			if err
				console.log 'Error: ' + err

			# get output
			object = stdout
			# replace ObjectId( and ) for parsing
			object = object.replace /ObjectId\(/g, ''
			# replace the nd ")
			object = object.replace /\ \)/g, ''
			# date clean
			object = object.replace /Date\( /g, ''

			object = object.replace /\}\n\{/g, '},{'
			object = object.replace /\n/g, ''
			# 
			object = object.replace /\'\{/g, '{'
			object = object.replace /\}\'/g, '}'

			# :D sorry everyone, spent time and this is the only way i can 
			# see to force this string to parse as a json array
			object = '[' + object + ']'
			# :( :( :(

			@jobj = JSON.parse object

			# field names taken from the first sample
			fields = Object.keys @jobj[0]

			# need to get field names
			# turn to csv and write to a csv file
			jsoncsv({ data: @jobj , fields: fields}, (err, csv) =>
				# error logging
				if err then console.log err
				fs.writeFile csv_file_path, csv, (err) =>
					# check error
					if err then console.log err
			)
			# log the json to confirm if option is selected
			if process.argv[6] is '--log'
				# and if set to true
				if process.argv[7] is 'true'
					# log the json
					console.log @jobj
		)
else
	# log error
	console.log 'Error: You must define -bf (the bson file path)'