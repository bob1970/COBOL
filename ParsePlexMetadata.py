#!/usr/bin/python
import sys
import re

MetadataFile = open("MovieMetadata.txt","rb")
MovieFile = open("Movies.csv", "wb")

meta = MetadataFile.read()
meta = meta.replace("\n","")

pattern = '<Video.*?/Video>'
Videos = re.compile(pattern, re.DOTALL | re.MULTILINE).findall(meta)
#print matches
MaxLen = {}
MaxLen['Title'] = 0
MaxLen['Studio'] = 0
MaxLen['Director'] = 0
MaxLen['ContentRating'] = 0
MaxLen['Rating'] = 0
MaxLen['Summary'] = 0
MaxLen['Genre'] = 0
MaxLen['Actor'] = 0

MaxLen['Buffer'] = 0

for v in Videos:
	#print v

	#Title 

	Title = ''
	pattern = 'title=".*?"'
	search = re.compile(pattern, re.DOTALL | re.MULTILINE).search(v)
	if search is not None:
		Title = search.group().replace("title=",'').replace('"','')
	print Title
	if len(Title) > MaxLen['Title']:
		MaxLen['Title'] = len(Title)

	#Studio
	Studio = ''
	pattern = 'studio=".*?"'
	search = re.compile(pattern, re.DOTALL | re.MULTILINE).search(v)
	if search is not None:
		Studio = search.group().replace("studio=",'').replace('"','')
	print Studio
	if len(Studio) > MaxLen['Studio']:
		MaxLen['Studio'] = len(Studio)

	#Director
	Director = ''
	pattern = '<Director.*?/>'
	search = re.compile(pattern, re.DOTALL | re.MULTILINE).search(v)
	if search is not None:
		Director = search.group().replace('<Director tag=','').replace('"','').replace('/>','')
	print Director
	if len(Director) > MaxLen['Director']:
		MaxLen['Director'] = len(Director)

	#ContentRating
	ContentRating = ''
	pattern = 'contentRating=".*?"'
	search = re.compile(pattern, re.DOTALL | re.MULTILINE).search(v)
	if search is not None:
		ContentRating = search.group().replace('contentRating=','').replace('"','')
	print ContentRating
	if len(ContentRating) > MaxLen['ContentRating']:
		MaxLen['ContentRating'] = len(ContentRating)

	#Rating
	Rating = ''
	pattern = 'rating=".*?"'
	search = re.compile(pattern, re.DOTALL | re.MULTILINE).search(v)
	if search is not None:
		Rating = search.group().replace("rating=",'').replace('"','')
	print Rating
	if len(Rating) > MaxLen['Rating']:
		MaxLen['Rating'] = len(Rating)

	#Summary
	Summary = ''
	pattern = 'summary=".*?" rating='
	search = re.compile(pattern, re.DOTALL | re.MULTILINE).search(v)
	if search is not None:
		Summary = search.group().replace('summary=','').strip('"').strip('" rating=')
	if len(Summary) > MaxLen['Summary']:
		MaxLen['Summary'] = len(Summary)

	buffer = Title + "|" + Studio + "|" + Director + "|" 
	buffer += ContentRating + "|" + Rating + "|" + Summary

	print ''
	print 'Genres:'
	pattern = '<Genre.*?/>'
	Genres = re.compile(pattern, re.DOTALL | re.MULTILINE).findall(v)
	GenreCount = len(Genres)
	buffer += "|" + str(GenreCount)
        GenreString = ""
        Comma = ""
	for Genre in Genres:
		Genre = Genre.replace('<Genre tag=','').replace('"','').replace('/>','')
		GenreString += Comma + Genre
                Comma = ","
		print Genre 
		if len(Genre) > MaxLen['Genre']:
			MaxLen['Genre'] = len(Genre)
        buffer += "|" + GenreString

	print ''
	print 'Actors:'
	pattern = '<Role.*?/>'
	Actors = re.compile(pattern, re.DOTALL | re.MULTILINE).findall(v)
	ActorCount = len(Actors)
        ActorString = ""
        Comma = ""
	buffer += "|" + str(ActorCount)
	for Actor in Actors:
		Actor = Actor.replace('<Role tag=','').replace('"','').replace('/>','')
		ActorString += Comma + Actor
                Comma = ","
		print Actor
		if len(Actor) > MaxLen['Actor']:
			MaxLen['Actor'] = len(Actor)
        buffer += "|" + ActorString + "|"

	buffer = buffer.ljust(1500)
	MovieFile.write(buffer)
	
	if len(buffer) > MaxLen['Buffer']:
		MaxLen['Buffer'] = len(buffer)
	
	print ""
	print ""


print MaxLen
MetadataFile.close()
MovieFile.close()
